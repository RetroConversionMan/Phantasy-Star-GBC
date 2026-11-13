#!/usr/bin/env python3
"""Real CGB vehicle sprites, bank restoration, entry geometry and ice drawing."""
import hashlib,json,subprocess
from pyboy import PyBoy
from verify_rom import load_symbols,cartridge_header
from verify_vehicles import source_use
from verify_world_logic import source_group
from extract_vehicle_graphics import ROOT,SHA,convert_frames
MAIN=r'''
#include <gb/gb.h>
#include <gb/cgb.h>
#include "world.h"
#include "vehicle_art.h"
#include "scene.h"
#include "font.h"
#include "assets.h"
uint16_t scene_shared_colors[32];uint8_t scene_shared_bytes[40];
uint8_t ready,command,map,vehicle_mode,facing,requested,interaction,result,bank_error,ice;
uint8_t palette_capture[64],sprite_x=80,sprite_y=80;
uint16_t x,y;
void main(void){
 DISPLAY_OFF;cpu_fast();HIDE_WIN;HIDE_SPRITES;
 VBK_REG=1;set_bkg_data(0,64,ui_font);
 SWITCH_ROM_MBC5(3);set_sprite_data(0,ALIS_TILE_COUNT,alis_tiles);set_sprite_palette(0,8,alis_palettes);
 SWITCH_ROM_MBC5(1);VBK_REG=0;ready=1;SHOW_BKG;DISPLAY_ON;
 while(1){vsync();if(command){uint8_t i;DISPLAY_OFF;
  if(command==1){world_select(map);world_load_graphics();world_vehicle_footprint(x,y,vehicle_mode);result=1;}
  else if(command==2)result=world_step_allowed(x,y,facing,vehicle_mode);
  else if(command==3)result=world_vehicle_use(&x,&y,facing,interaction,requested,&vehicle_mode);
  else if(command==4){world_terrain_sync(x,y);result=1;}
  else if(command==5){result=vehicle_sprite_load(vehicle_mode,facing);vehicle_sprite_draw(sprite_x,sprite_y);}
  else if(command==6){scene_actor_hide();result=1;}
  ice=world_ice_changed;
  if(command<5)world_draw((x+2048u-80u)&2047u,(y+1536u-80u)%1536u,1);
  for(i=0;i<64u;++i){OCPS_REG=i;palette_capture[i]=OCPD_REG;}
  if(CURRENT_BANK!=1)bank_error=1;
  DISPLAY_ON;command=0;
 }}
}
'''
def main():
 out=ROOT/'build/verification/vehicles-native';out.mkdir(parents=True,exist_ok=True);(out/'main.c').write_text(MAIN)
 original=(ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes();assert hashlib.sha256(original).hexdigest()==SHA
 groups=[source_group(original,g)for g in range(11)];mapping=original[0xdc1:0xdd9]
 sources=[out/'main.c']+[ROOT/'src'/s for s in ('world.c','world_assets.c','vehicle_art.c','scene_actor.c','scene_actor_data.c','bank_io.c','font.c','assets_sprites.c')]
 sources+=sorted((ROOT/'src').glob('world_assets_*_*.c'))+sorted((ROOT/'src').glob('scene_actor_bank_*.c'))
 rom=out/'vehicles.gbc'
 subprocess.run(['.tools/gbdk/bin/lcc','-msm83:gb','-Wm-yC','-Wm-yt0x1b','-Wm-yo128','-Wm-ya1','-Wl-m','-Wl-j','-Isrc','-o',str(rom.relative_to(ROOT)),*[str(p.relative_to(ROOT))for p in sources]],cwd=ROOT,check=True)
 sym=load_symbols(rom.with_suffix('.noi'));e=PyBoy(str(rom),window='null',cgb=True,sound_emulated=False,log_level='ERROR');e.set_emulation_speed(0)
 counts={'vehicle_frames':0,'native_sprite_pattern_bytes':0,'oam_entries':0,'protected_bytes':0,'geometry_cases':0,'ice_cases':0,'tile_attribute_pairs':0};timings=[]
 def put(name,value):
  e.memory[sym[name]]=value&255
  if name in ('x','y'):e.memory[sym[name]+1]=value>>8
 def get(name):return e.memory[sym[name]]+(e.memory[sym[name]+1]*256 if name in ('x','y')else 0)
 def palette():return bytes(e.memory[sym['palette_capture']:sym['palette_capture']+64])
 def protected():return bytes(e.memory[1,0x9000:0x9400])+bytes(e.memory[1,0x8000:0x8540])
 def command(number):
  put('command',number)
  for t in range(1200):
   e.tick(1)
   if not get('command'):break
  else:raise AssertionError(('native command timeout',number))
  timings.append(t+1);assert not get('bank_error');e.tick(2);return get('result')
 def load(mapid,x,y,mode=0):
  for k,v in [('map',mapid),('x',x),('y',y),('vehicle_mode',mode)]:put(k,v)
  assert command(1)==1
 def check_map(group,grid):
  x=(get('x')+2048-80)%2048;y=(get('y')+1536-80)%1536
  metas=(ROOT/f'assets/world/world_g{group:02d}.metatiles').read_bytes()
  for ty in range(y//8,y//8+19):
   for tx in range(x//8,x//8+21):
    sx,sy=tx%256,ty%192;m=grid[(sy//2)*128+sx//2]
    off=m*8+(sy&1)*4+(sx&1)*2;address=0x9800+(ty%32)*32+tx%32
    assert(e.memory[0,address],e.memory[1,address])==tuple(metas[off:off+2]),(group,tx,ty,m)
    counts['tile_attribute_pairs']+=1
 try:
  e.tick(180);assert get('ready');keep=protected();load(0,8,16);normal_palette=palette()
  for frame,(data,source,native,errors)in enumerate(convert_frames(original)):
   mode=(frame//4+1)*4;facing=(1,3,0,2)[frame%4]
   put('vehicle_mode',mode);put('facing',facing);assert command(5)==1
   assert not get('scene_actor_active')
   assert bytes(e.memory[1,0x8540:0x8640])==data[:256];counts['native_sprite_pattern_bytes']+=256
   assert palette()==data[-64:]
   for n in range(16):
    x,y,tile,attribute=data[256+n*4:260+n*4]
    assert bytes(e.memory[0xfe00+n*4:0xfe04+n*4])==bytes((y,x,84+tile,attribute));counts['oam_entries']+=1
   assert protected()==keep;counts['protected_bytes']+=len(keep);counts['vehicle_frames']+=1
   e.screen.image.save(out/f'{frame:02x}.png')
   command(6);assert palette()==normal_palette
  for mapid in (0,1,2,3,4):
   group=mapping[mapid];grid,flags,_=groups[group]
   for x,y in ((8,16),(2040,0),(520,784)):
    for current,requested in ((0,4),(0,8),(0,12),(8,8),(4,4)):
     load(mapid,x,y,current);put('facing',3);put('interaction',1);put('requested',requested)
     want=source_use(original,grid,flags,group,x,y,3,1,requested,current)
     got=(command(3),get('x'),get('y'),get('vehicle_mode'));assert got==want,(mapid,x,y,current,requested,got,want)
     counts['geometry_cases']+=1
  grid,flags,_=groups[2];icecells=[n for n,c in enumerate(grid)if 0xd8<=c<0xe0]
  for index in icecells[::max(1,len(icecells)//24)][:24]:
   mx,my=index%128,index//128;x=mx*16+8;y=(my*16+16)%1536
   load(2,x,y,12);expected=bytearray(grid)
   for dx,dy in ((-1,-1),(0,-1),(-1,0),(0,0)):
    q=((my+dy)%96)*128+(mx+dx)%128
    if 0xd8<=expected[q]<0xe0:expected[q]=0xd7
   assert get('ice');check_map(2,expected)
   put('x',(x+256)%2048);command(4);check_map(2,grid)
   # Reload, then clear the two cells immediately ahead without initial footprint clearing.
   load(2,x,(y+16)%1536,0);put('vehicle_mode',12);put('facing',1)
   target_y=(my-1)%96;expected=bytearray(grid)
   for xx in ((mx-1)%128,mx):
    q=target_y*128+xx
    if 0xd8<=expected[q]<0xe0:expected[q]=0xd7
   want=int(not any(flags[expected[target_y*128+xx]]&1 for xx in((mx-1)%128,mx)))
   assert command(2)==want;check_map(2,expected);counts['ice_cases']+=1
  assert protected()==keep
  report={'passed':True,'header':cartridge_header(rom),**counts,'command_frames':{'min':min(timings),'max':max(timings)},
   'limits':['Standalone CGB vehicle graphics/geometry probe; complete input-driven vehicle travel is separate',
             'Original directional poses and temporary terrain rules are verified; vehicle audio/movement cadence belong to main integration']}
  (out/'report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
 finally:e.stop(False)
if __name__=='__main__':main()
