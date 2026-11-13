#!/usr/bin/env python3
"""CGB execution of fourteen complete routes, source-state and VRAM checks."""
import ctypes as C,hashlib,json,struct,subprocess
from pyboy import PyBoy
from verify_travel import State
from verify_rom import load_symbols,cartridge_header
from extract_travel_graphics import ROOT
MAIN=r'''
#include <gb/gb.h>
#include <gb/cgb.h>
#include "travel.h"
#include "font.h"
#include "assets.h"
uint16_t scene_shared_colors[32];uint8_t scene_shared_bytes[40];
TravelState state;
uint8_t ready,command,tag,skip,flags,bank_error;
uint8_t bg_palette[64],obj_palette[64];
void main(void){
 DISPLAY_OFF;cpu_fast();HIDE_WIN;HIDE_SPRITES;
 VBK_REG=1;set_bkg_data(0,64,ui_font);
 SWITCH_ROM_MBC5(3);set_sprite_data(0,ALIS_TILE_COUNT,alis_tiles);set_sprite_palette(0,8,alis_palettes);
 SWITCH_ROM_MBC5(1);VBK_REG=0;ready=1;SHOW_BKG;DISPLAY_ON;
 while(1){vsync();if(command){uint8_t i;
  if(command>=3){flags=0;if(command==3)travel_fade_current();else if(command==4)scene_fade_begin(skip);else scene_fade_step(tag,skip);}
  else {flags=command==1?travel_begin(&state,tag):travel_step(&state,skip);if(flags)travel_present(&state,flags);}
  if(CURRENT_BANK!=1)bank_error=1;
  for(i=0;i<64u;++i){BCPS_REG=i;bg_palette[i]=BCPD_REG;OCPS_REG=i;obj_palette[i]=OCPD_REG;}
  command=0;
 }}
}
'''
def main():
 out=ROOT/'build/verification/travel-native';out.mkdir(parents=True,exist_ok=True);(out/'main.c').write_text(MAIN)
 sources=[out/'main.c']+[ROOT/'src'/p for p in('palette_commit.c','travel.c','travel_render.c','travel_art.c','world.c','world_assets.c','scene_actor.c','scene_actor_data.c','bank_io.c','font.c','assets.c','assets_sprites.c')]
 sources+=sorted((ROOT/'src').glob('world_assets_*_*.c'))+sorted((ROOT/'src').glob('scene_actor_bank_*.c'))
 rom=out/'travel.gbc'
 subprocess.run(['.tools/gbdk/bin/lcc','-msm83:gb','-Wm-yC','-Wm-yt0x1b','-Wm-yo128','-Wm-ya1','-Wl-m','-Wl-j','-Isrc','-o',str(rom.relative_to(ROOT)),*[str(p.relative_to(ROOT))for p in sources]],cwd=ROOT,check=True)
 lib=C.CDLL(str(ROOT/'build/verification/travel/travel.dylib'))
 lib.travel_begin.argtypes=[C.POINTER(State),C.c_uint8];lib.travel_begin.restype=C.c_uint8
 lib.travel_step.argtypes=[C.POINTER(State),C.c_uint8];lib.travel_step.restype=C.c_uint8
 lib.travel_space_row.argtypes=[C.POINTER(State),C.c_uint8,C.POINTER(C.c_uint8)];lib.travel_space_row.restype=C.c_uint8
 lib.travel_fade_color.argtypes=[C.c_uint8]*3;lib.travel_fade_color.restype=C.c_uint8
 sym=load_symbols(rom.with_suffix('.noi'));e=PyBoy(str(rom),window='null',cgb=True,sound_emulated=False,log_level='ERROR');e.set_emulation_speed(0)
 counts={'routes':0,'native_steps':0,'state_bytes':0,'viewports':0,'tile_attribute_pairs':0,'palette_bytes':0,'protected_bytes':0,'current_palette_fade_bytes':0};timings={};screens=[]
 mapping=(ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes()[0xdc1:0xdd9]
 grids=[(ROOT/f'assets/world/world_g{g:02d}.map').read_bytes()for g in range(11)]
 metas=[(ROOT/f'assets/world/world_g{g:02d}.metatiles').read_bytes()for g in range(11)]
 planets=[(ROOT/f'assets/travel-art/planet{p}.bin').read_bytes()for p in range(3)]
 source_world_palettes=[]
 for g in range(11):
  # Extraction manifest records converted palette values directly.
  src=(ROOT/f'src/world_assets_{g:02d}_tiles.c').read_text()
  import re
  match=re.search(r'const uint16_t world_g\d+_palettes\[28\]\s*=\s*\{([^}]+)',src)
  assert match,src[:200]
  source_world_palettes.append([int(v,0)for v in re.findall(r'0x[0-9a-fA-F]+|\d+',match[1])])
 def protected():return bytes(e.memory[1,0x9000:0x9400])+bytes(e.memory[1,0x8000:0x8540])
 def issue(command):
  e.memory[sym['command']]=command
  for ticks in range(1200):
   e.tick(1)
   if not e.memory[sym['command']]:break
  else:raise AssertionError('Travel native command timed out')
  assert not e.memory[sym['bank_error']];return ticks+1
 def state_bytes(s):return struct.pack('<4H2I18B',*[getattr(s,name)for name,_ in State._fields_])
 def check_view(s):
  if s.space_visible:
   head=(s.scroll+32)//8;data=planets[s.planet]
   for dy in range(19):
    row=C.c_uint8();kind=lib.travel_space_row(C.byref(s),(head+dy)%28,C.byref(row))
    for dx in range(20):
     off=1624+kind*768+row.value*32+7+dx;want=(data[off],data[off+384]);address=0x9800+((head+dy)%32)*32+dx
     assert(e.memory[0,address],e.memory[1,address])==want,(s.tag,s.phase_frames,'space',head,dy,dx)
     counts['tile_attribute_pairs']+=1
  else:
   group=mapping[s.map];grid=grids[group];meta=metas[group];x=(s.x-80)%2048;y=(s.y-80)%1536
   for dy in range(19):
    for dx in range(21):
     tx=x//8+dx;ty=y//8+dy;mx=tx%256;my=ty%192;m=grid[my//2*128+mx//2]
     off=m*8+(my&1)*4+(mx&1)*2;address=0x9800+(ty%32)*32+tx%32
     assert(e.memory[0,address],e.memory[1,address])==tuple(meta[off:off+2]),(s.tag,s.stage,s.phase_frames,'world',tx,ty)
     counts['tile_attribute_pairs']+=1
  counts['viewports']+=1
 def check_palette(s):
  colors=struct.unpack_from('<28H',planets[s.planet],1568)if s.space_visible else source_world_palettes[mapping[s.map]]
  expected=[]
  for color in colors:
   levels=[(((color>>shift)&31)*3+15)//31 for shift in(0,5,10)]
   sms=lib.travel_fade_color(sum(v<<(i*2)for i,v in enumerate(levels)),s.fade_step,s.fade_in)
   converted=[((sms>>i)&3)for i in(0,2,4)]
   expected.append(sum((v*10+(v>=2))<<(i*5)for i,v in enumerate(converted)))
  assert bytes(e.memory[sym['bg_palette']:sym['bg_palette']+56])==struct.pack('<28H',*expected),(s.tag,s.stage,s.phase_frames,'palette')
  counts['palette_bytes']+=56
 try:
  e.tick(180);assert e.memory[sym['ready']];keep=protected()
  for tag in list(range(1,7))+list(range(0x81,0x89)):
   s=State();e.memory[sym['tag']]=tag;want=lib.travel_begin(C.byref(s),tag);issue(1)
   assert e.memory[sym['flags']]==want
   check_view(s);check_palette(s)
   for step in range(2500):
    old=s.stage;want=lib.travel_step(C.byref(s),0);ticks=issue(2)
    key='load'if want&3 else 'space'if s.space_visible else'world'
    timings.setdefault(key,[]).append(ticks)
    assert e.memory[sym['flags']]==want,(tag,step,'flags')
    expected=state_bytes(s);actual=bytes(e.memory[sym['state']:sym['state']+34]);assert actual==expected,(tag,step,'state',actual.hex(),expected.hex())
    counts['native_steps']+=1;counts['state_bytes']+=34
    if want&4:check_palette(s)
    if want&3 or old!=s.stage or s.phase_frames%28==0:check_view(s)
    if old!=s.stage or s.space_visible and s.phase_frames in(112,672,673,784):
     e.tick(2);name=f'{tag:02x}-{step:04d}-{s.stage}.png';e.screen.image.save(out/name);screens.append(name)
    if s.stage==8:break
   else:raise AssertionError(('route did not finish',tag,s.stage))
   assert protected()==keep;counts['protected_bytes']+=len(keep);counts['routes']+=1
  base=bytes(e.memory[sym['bg_palette']:sym['bg_palette']+56])+bytes(e.memory[sym['obj_palette']:sym['obj_palette']+64])
  ui=bytes(e.memory[sym['bg_palette']+56:sym['bg_palette']+64])
  def expected_fade(step,inward):
   values=[]
   for color in struct.unpack('<60H',base):
    sms=sum(((((color>>shift)&31)*3+15)//31)<<(i*2)for i,shift in enumerate((0,5,10)))
    result=lib.travel_fade_color(sms,step,inward)
    values.append(sum((((result>>shift)&3)*10+(((result>>shift)&3)>=2))<<(i*5)for i,shift in enumerate((0,2,4))))
   return struct.pack('<60H',*values)
  def check_fade(step,inward):
   actual=bytes(e.memory[sym['bg_palette']:sym['bg_palette']+56])+bytes(e.memory[sym['obj_palette']:sym['obj_palette']+64])
   assert actual==expected_fade(step,inward),(step,inward,'current fade')
   assert bytes(e.memory[sym['bg_palette']+56:sym['bg_palette']+64])==ui
   counts['current_palette_fade_bytes']+=120
  e.memory[sym['skip']]=1;issue(4);check_fade(0,1)
  for step in range(1,11):e.memory[sym['tag']]=step;issue(5);check_fade(step,1)
  e.memory[sym['skip']]=0;issue(4)
  for step in range(10):e.memory[sym['tag']]=step;issue(5);check_fade(step,0)
  e.memory[sym['tag']]=0;issue(5)
  for step in range(1,10):issue(3);check_fade(step,0)
  report={'passed':True,'header':cartridge_header(rom),**counts,'probe_roundtrip_emulator_frames':{k:{'min':min(v),'max':max(v),'mean':round(sum(v)/len(v),2)}for k,v in timings.items()},'screenshots':screens,
   'limits':['Standalone native presenter/route probe, not main input-driven story integration','Round-trip timings include probe vsync and palette readback, not just renderer cost','Original initial transition fade-out and party follower sprites remain caller work']}
  (out/'report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps({k:v for k,v in report.items()if k!='screenshots'},indent=2))
 finally:e.stop(False)
if __name__=='__main__':main()
