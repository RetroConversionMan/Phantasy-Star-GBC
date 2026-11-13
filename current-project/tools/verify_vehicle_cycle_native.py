#!/usr/bin/env python3
"""Native vehicle layers, cycle palettes, facing reload and state persistence."""
from pathlib import Path
import hashlib,json,struct,subprocess,sys
import numpy as np
ROOT=next(p for p in Path(__file__).resolve().parents if(p/'upstream/ps1disasm/ps1original.sms').exists());WORK=Path(__file__).resolve().parents[1];sys.path.insert(0,str(ROOT/'tools'))
from pyboy import PyBoy
from verify_rom import load_symbols,read_word
MAIN=r'''
#include <gb/gb.h>
#include <gb/cgb.h>
#include "vehicle_art.h"
#include "vehicle_cycle.h"
#include "audio.h"
uint16_t scene_shared_colors[32];uint8_t scene_shared_bytes[40];
uint8_t ready,command,probe_mode,facing,remaining,bank_error,palette[64];
static const uint8_t blank[16]={0};
static const uint16_t background[4]={RGB(3,5,7),RGB(3,5,7),RGB(3,5,7),RGB(3,5,7)};
void main(void){
 uint8_t i;DISPLAY_OFF;cpu_fast();HIDE_WIN;SPRITES_8x8;audio_install();
 set_bkg_data(200,1,blank);fill_bkg_rect(0,0,32,32,200);set_bkg_palette(0,1,background);
 for(i=0;i<64u;++i)((volatile uint8_t*)0xdbc0)[i]=0xa5;
 ready=1;SHOW_BKG;DISPLAY_ON;
 while(1){vsync();if(command){
  if(command==1||command==3){DISPLAY_OFF;if(command==1)vehicle_palette_reset();vehicle_sprite_load(probe_mode,facing);vehicle_sprite_draw(80,80);DISPLAY_ON;}
  else {vehicle_cycle_world_tick(probe_mode,remaining);if(!remaining)audio_command(0xd6);vehicle_sprite_draw(80,80);}
  for(i=0;i<64u;++i){while(STAT_REG&2u);OCPS_REG=i;palette[i]=OCPD_REG;}
  if(CURRENT_BANK!=1)bank_error=1;command=0;
 }}
}
'''
def main():
 out=WORK/'evidence/native';out.mkdir(parents=True,exist_ok=True);(out/'main.c').write_text(MAIN)
 names=['vehicle_art','vehicle_cycle','audio_irq','audio','audio_data','audio_tables','audio_low_62','audio_low_63','scene_actor','scene_actor_data','assets_sprites','bank_io']
 objs=[f'build/obj/{n}.o'for n in names]+[str(p.relative_to(WORK))for p in sorted((WORK/'build/obj').glob('scene_actor_bank_*.o'))]
 subprocess.run(['../../../.tools/gbdk/bin/lcc','-msm83:gb','-Wm-yC','-Wm-yt0x1b','-Wm-yo128','-Wm-ya1','-Wl-m','-Wl-j','-Isrc','-o','evidence/native/vehicles.gbc','evidence/native/main.c',*objs],cwd=WORK,check=True)
 path=out/'vehicles.gbc';s=load_symbols(path.with_suffix('.noi'));e=PyBoy(str(path),window='null',cgb=True,sound_emulated=True,log_level='ERROR');e.set_emulation_speed(0)
 uploads=[]
 def upload(_):
  if e.memory[s['command']]==2 and e.memory[0xff40]&128:uploads.append(e.memory[0xff44])
 addr=s['vehicle_palette_cycle'];e.hook_register(addr>>16,addr&65535,upload,None)
 source=(ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes();manifest=json.loads((WORK/'assets/vehicle-cycles/manifest.json').read_text());record=manifest['records'];counts=dict(commands=0,palette_bytes=0,OAM_bytes=0,pattern_bytes=0,PPU_RGB_pixels=0,guards=0);screens=[]
 def issue(cmd):
  e.memory[s['command']]=cmd
  for _ in range(120):
   e.tick(1)
   if not e.memory[s['command']]:break
  else:raise AssertionError('native vehicle timeout')
  assert not e.memory[s['bank_error']];e.tick(2);counts['commands']+=1
  assert bytes(e.memory[0xdbc0:0xdc00])==b'\xa5'*64;counts['guards']+=1
 def check(mode,face,display,description,shot=False):
  f=mode-4+(2,0,3,1)[face];row=record[f];n=row['tiles'];data=(WORK/f'assets/vehicle-cycles/{f:02x}.bin').read_bytes();expected=bytearray(data[-64:])
  if display>=0:
   start=(0x7c73 if mode==8 else 0x7c6d)+display
   values=[sum(round(((v>>sh)&3)*31/3)<<shift for sh,shift in((0,0),(2,5),(4,10)))for v in source[start:start+3]]
   expected[58:64]=struct.pack('<3H',*values)
  assert bytes(e.memory[s['palette']:s['palette']+64])==expected,(description,'palette')
  assert bytes(e.memory[1,0x8540:0x8540+n*16])==data[:n*16],(description,'patterns')
  oam=bytes(e.memory[0xfe00:0xfea0]);meta=data[n*16:n*20]
  for i in range(n):
   x,y,tile,prop=meta[i*4:i*4+4];assert oam[i*4:i*4+4]==bytes((y,x,84+tile,prop)),(description,'OAM',i)
  for i in range(n,40):assert oam[i*4:i*4+2]==b'\0\0',(description,'stale OAM',i)
  counts['palette_bytes']+=64;counts['OAM_bytes']+=160;counts['pattern_bytes']+=n*16
  if shot:
   image=np.asarray(e.screen.image);rgb=np.full((144,160,3),image[0,0,:3],np.uint8);pal=np.array([[(v>>shift&31)<<3 for shift in(0,5,10)]for v in struct.unpack('<32H',expected)],np.uint8);painted=np.zeros((144,160),bool)
   for i in range(n):
    y,x,tile,prop=oam[i*4:i*4+4];raw=data[(tile-84)*16:(tile-83)*16]
    for yy in range(8):
     for xx in range(8):
      code=((raw[yy*2]>>(7-xx))&1)|(((raw[yy*2+1]>>(7-xx))&1)<<1);py=y-16+yy;px=x-8+xx
      if code and not painted[py,px]:rgb[py,px]=pal[(prop&7)*4+code];painted[py,px]=True
   assert np.array_equal(image[:,:,:3],rgb),(description,'PPU pixels');counts['PPU_RGB_pixels']+=144*160
   e.screen.image.save(out/(description+'.png'));screens.append(description+'.png')
 try:
  e.tick(180);assert e.memory[s['ready']]
  for mode in(4,8,12):
   for face in range(4):
    e.memory[s['probe_mode']]=mode;e.memory[s['facing']]=face;e.memory[s['vehicle_cycle']]=0;e.memory[s['vehicle_cycle']+1]=0;phase=clock=0;display=-1
    issue(1);check(mode,face,display,f'mode{mode}-face{face}-base',True)
    for tick in range(64):
     remaining=7-(tick%8)if tick<32 else 0;e.memory[s['remaining']]=remaining
     if mode==8 or remaining:
      clock=(clock-1)&255
      if clock&128:clock=3;phase=(phase+1)%3;display=phase
     issue(2);assert bytes(e.memory[s['vehicle_cycle']:s['vehicle_cycle']+2])==bytes((phase,clock))
     check(mode,face,display,f'mode{mode}-face{face}-tick{tick}',tick in(0,4,8,31,32,63))
    # A facing upload preserves the latest active palette. A full source map
    # reload restores base colors while keeping both persistent cycle bytes.
    face=(face+1)&3;e.memory[s['facing']]=face;keep=bytes(e.memory[s['vehicle_cycle']:s['vehicle_cycle']+2]);issue(3);check(mode,face,display,f'mode{mode}-turn{face}',True)
    issue(1);check(mode,face,-1,f'mode{mode}-reload{face}',True);assert bytes(e.memory[s['vehicle_cycle']:s['vehicle_cycle']+2])==keep
  assert uploads and all(144<=ly<=151 for ly in uploads),('cycle upload outside VBlank',uploads)
  report=dict(passed=True,cycle_palette_uploads=len(uploads),cycle_upload_LY_range=[min(uploads),max(uploads)],probe_sha256=hashlib.sha256(path.read_bytes()).hexdigest(),production_sha256=hashlib.sha256((WORK/'build/phantasy-star-gbc-world.gbc').read_bytes()).hexdigest(),object_sha256={p:hashlib.sha256((WORK/p).read_bytes()).hexdigest()for p in objs},counts=counts,screenshots=screens,scope='Unchanged production objects; all3 vehicle modes/4 facings, moving→idle, exact native palettes/patterns/OAM/PPU, facing and fullmap palette reload persistence, actual installed audioIRQ active.')
  (out/'report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps({k:v for k,v in report.items()if k not in('object_sha256','screenshots')},indent=2))
 finally:e.stop(save=False)
if __name__=='__main__':main()
