#!/usr/bin/env python3
"""Native party object execution, source SAT/alpha, VRAM and PPU regression."""
from pathlib import Path
import hashlib,json,sys,subprocess,struct
import numpy as np
from PIL import Image
ROOT=Path(__file__).resolve().parents[4];WORK=Path(__file__).resolve().parents[1]
sys.path[:0]=[str(ROOT/'tools'),str(WORK/'tools')]
from pyboy import PyBoy
from verify_rom import load_symbols
from verify_party_source import original,call
from extract_assets import ROM_SHA256
MAIN=r'''
#include <gb/gb.h>
#include <gb/cgb.h>
#include "party_world.h"
RPGState game_rpg;
uint8_t ready,command,road,accepted,remaining,held,bank_error,observed_palette[64];
static const uint8_t blank[16]={0};
static const uint16_t background[4]={RGB(3,5,7),RGB(3,5,7),RGB(3,5,7),RGB(3,5,7)};
void main(void) {
 uint8_t i;DISPLAY_OFF;cpu_fast();HIDE_WIN;SPRITES_8x8;
 set_bkg_data(200,1,blank);fill_bkg_rect(0,0,32,32,200);set_bkg_palette(0,1,background);
 for(i=0;i<64u;++i)((volatile uint8_t *)0xdbc0)[i]=0xa5u;
 ready=1;SHOW_BKG;DISPLAY_ON;
 while(1){vsync();if(command){
  if(command==1){DISPLAY_OFF;party_world_reset(road);party_world_draw();DISPLAY_ON;}
  else {party_world_tick(accepted,remaining,held);party_world_draw();}
  if(CURRENT_BANK!=1)bank_error=1;
  for(i=0;i<64u;++i){while(STAT_REG&2u);OCPS_REG=i;observed_palette[i]=OCPD_REG;}
  command=0;
 }}
}
'''
def main():
 out=WORK/'evidence/native';out.mkdir(parents=True,exist_ok=True);(out/'main.c').write_text(MAIN)
 # Link the exact object files used by the isolated full production cartridge.
 args=['../../../.tools/gbdk/bin/lcc','-msm83:gb','-Wm-yC','-Wm-yt0x1b','-Wm-yo32','-Wm-ya1','-Wl-m','-Wl-j','-Isrc','-o','evidence/native/party.gbc','evidence/native/main.c','build/obj/party_world.o','build/obj/party_world_data.o']
 subprocess.run(args,cwd=WORK,check=True)
 rompath=out/'party.gbc';sym=load_symbols(rompath.with_suffix('.noi'))
 original_rom=(ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes();assert hashlib.sha256(original_rom).hexdigest()==ROM_SHA256
 native_rom=rompath.read_bytes();full=(WORK/'build/phantasy-star-gbc-world.gbc').read_bytes()
 # This harness links the production objects unchanged. WRAM/global and
 # fixed-bank call relocations differ from the full cartridge.
 object_hashes={name:hashlib.sha256((WORK/'build/obj'/name).read_bytes()).hexdigest()for name in ('party_world.o','party_world_data.o')}
 emu=PyBoy(str(rompath),window='null',cgb=True,sound_emulated=False,log_level='ERROR');emu.set_emulation_speed(0)
 def issue(cmd):
  emu.memory[sym['command']]=cmd
  for i in range(20):
   emu.tick(1)
   if not emu.memory[sym['command']]:break
  else:raise AssertionError('command timeout')
  assert not emu.memory[sym['bank_error']]
  emu.tick(2)
  assert bytes(emu.memory[0xdbc0:0xdc00])==b'\xa5'*64
 def native_tile(tile):
  raw=bytes(emu.memory[1,0x8000+tile*16:0x8010+tile*16])
  return np.array([((raw[y*2]>>(7-x))&1)|(((raw[y*2+1]>>(7-x))&1)<<1)for y in range(8)for x in range(8)],np.uint8).reshape(8,8)
 def source_tile(actor,frame,q):
  addr=(0x8000,0x8a80,0x9440,0x9ec0)[actor];width=4 if actor==3 else 6
  off=28*16384+addr-0x8000+(frame*width+q)*32;raw=original_rom[off:off+32]
  return np.array([sum(((raw[y*4+p]>>(7-x))&1)<<p for p in range(4))for y in range(8)for x in range(8)],np.uint8).reshape(8,8)
 counts=dict(reset_cases=0,steps=0,OAM_bytes=0,alpha_pixels=0,PPU_frames=0,guard_checks=0,palette_bytes=0,PPU_RGB_pixels=0);screens=[]
 full_symbols=load_symbols((WORK/'build/phantasy-star-gbc-world.noi'))
 def data(name,size):
  addr=full_symbols[name];off=(addr>>16)*16384+(addr&65535)-16384;return full[off:off+size]
 palettes=data('party_world_palettes',64);attributes=data('party_world_attrs',310)
 colors=np.array([[(v>>shift&31)<<3 for shift in(0,5,10)]for v in struct.unpack('<32H',palettes)],np.uint8)
 def check(c,description,ppu=False):
  count=int.from_bytes(c.memory[0xc217:0xc219],'little')-0xc900
  oam=bytes(emu.memory[0xfe00:0xfea0]);expected=[]
  assert bytes(emu.memory[sym['observed_palette']:sym['observed_palette']+64])==palettes,(description,'OBJ palette')
  counts['palette_bytes']+=64
  pixels=np.asarray(emu.screen.image)if ppu else None
  rgb=np.full((144,160,3),pixels[0,0,:3],np.uint8)if ppu else None
  painted=np.zeros((144,160),bool)if ppu else None
  source_alpha=np.zeros((144,160),bool);native_alpha=np.zeros_like(source_alpha)
  for i in range(count):
   sy=c.memory[0xc900+i];sx=c.memory[0xc980+i*2];pattern=c.memory[0xc981+i*2]
   actor=0 if pattern<176 else 1 if pattern<182 else 2 if pattern<188 else 3
   q=pattern-(170,176,182,188)[actor]
   # Identity is unique among living actors; find its current source frame.
   slot=next(j for j in range(4)if c.memory[0xc801+j*32]==actor+1)
   frame=c.memory[0xc810+slot*32];tile=frame*6+q if actor==0 else (84,90,96)[actor-1]+q
   y=(sy-15)&255;x=(sx-48)&255
   assert tuple(oam[i*4:i*4+3])==(y,x,tile),(description,i,tuple(oam[i*4:i*4+3]),(y,x,tile))
   assert oam[i*4+3]&0xf8==8,(description,'prop',i,oam[i*4+3])
   attr=attributes[(0,84,162,246)[actor]+frame*(4 if actor==3 else 6)+q]
   assert oam[i*4+3]==8|attr,(description,'palette index',actor,frame,q)
   a=source_tile(actor,frame,q)!=0;codes=native_tile(tile);b=codes!=0
   assert np.array_equal(a,b),(description,'tile alpha',actor,frame,q)
   for yy in range(8):
    for xx in range(8):
     py=y-16+yy;px=x-8+xx
     if 0<=py<144 and 0<=px<160:
      source_alpha[py,px]|=bool(a[yy,xx]);native_alpha[py,px]|=bool(b[yy,xx])
      if ppu and codes[yy,xx]and not painted[py,px]:
       rgb[py,px]=colors[attr*4+codes[yy,xx]];painted[py,px]=True
   counts['alpha_pixels']+=64
  for i in range(count,40):assert oam[i*4:i*4+2]==b'\0\0',(description,'stale sprite',i)
  assert np.array_equal(source_alpha,native_alpha)
  if ppu:
   pixels=np.asarray(emu.screen.image);background=pixels[0,0,:3]
   actual=np.any(pixels[:,:,:3]!=background,axis=2)
   assert np.array_equal(actual,source_alpha),(description,'PPU alpha',int(np.count_nonzero(actual!=source_alpha)))
   assert np.array_equal(pixels[:,:,:3],rgb),(description,'PPU RGB',int(np.count_nonzero(pixels[:,:,:3]!=rgb)))
   counts['PPU_RGB_pixels']+=144*160
   name=f'{description}.png';emu.screen.image.save(out/name);screens.append(name);counts['PPU_frames']+=1
  counts['OAM_bytes']+=160;counts['guard_checks']+=1
 try:
  emu.tick(180);assert emu.memory[sym['ready']]
  for living in range(16):
   for road in(0,1,2,4,8):
    for i in range(4):emu.memory[sym['game_rpg']+i*16]=1 if living>>i&1 else 0
    emu.memory[sym['road']]=road;issue(1);c=original(original_rom,living,road)
    check(c,f'mask{living:02x}-road{road}-initial',living in(1,14,15));counts['reset_cases']+=1
    trace=[]
    for direction in(2,8,1,4):
     for _ in range(3):trace.extend((direction,15-i,direction)for i in range(16))
     trace.extend(((0,0,0),(0,0,15),(0,0,4)))
    for n,(accepted,remaining,held)in enumerate(trace):
     for name,value in(('accepted',accepted),('remaining',remaining),('held',held)):emu.memory[sym[name]]=value
     c.memory[0xc264]=accepted;c.memory[0xc265]=remaining;c.memory[0xc204]=held;call(c,0x576a);issue(2)
     check(c,f'mask{living:02x}-road{road}-step{n}',living==15 and n in(15,31,47,63,79,95,111,127,143,159,175,191));counts['steps']+=1
  report=dict(passed=True,ROM_sha256=hashlib.sha256(native_rom).hexdigest(),production_ROM_sha256=hashlib.sha256(full).hexdigest(),production_object_sha256=object_hashes,counts=counts,screenshots=screens,limits=['Dedicated command harness links unchanged production objects; main movement and travel integration checked separately.','Original accepted movement traces are supplied; no campaign state is used.','CGB per-tile palette reduction is measured separately; exact transparency/position/OAM ordering are checked here.'])
  (out/'report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps({k:v for k,v in report.items()if k!='screenshots'},indent=2))
 finally:emu.stop(save=False)
if __name__=='__main__':main()
