#!/usr/bin/env python3
"""Probe every source NPC/prepared-enemy native OBJ overlay and restoration."""
from pathlib import Path
import hashlib,json,subprocess
from pyboy import PyBoy
from verify_rom import load_symbols,cartridge_header
ROOT=Path(__file__).resolve().parents[1]
MAIN=r'''
#include <gb/gb.h>
#include <gb/cgb.h>
#include "scene.h"
#include "font.h"
#include "assets.h"
uint8_t probe_ready,probe_command,probe_kind,probe_id,probe_floor_palette,probe_result;
uint8_t probe_palette[64];
uint16_t scene_shared_colors[32];uint8_t scene_shared_bytes[40];
static const uint8_t checker[16]={0xaa,0x55,0x55,0xaa,0xaa,0x55,0x55,0xaa,0xaa,0x55,0x55,0xaa,0xaa,0x55,0x55,0xaa};
static const uint16_t background[4]={0,0x2108,0x4210,0x7fff};
static void capture_palette(void){uint8_t i;for(i=0;i<64u;++i){OCPS_REG=i;probe_palette[i]=OCPD_REG;}}
void main(void){
 DISPLAY_OFF;cpu_fast();HIDE_WIN;HIDE_SPRITES;
 VBK_REG=1;set_bkg_data(0,64,ui_font);
 SWITCH_ROM_MBC5(3);set_sprite_data(0,ALIS_TILE_COUNT,alis_tiles);set_sprite_palette(0,8,alis_palettes);
 SWITCH_ROM_MBC5(1);VBK_REG=0;set_bkg_data(0,1,checker);fill_bkg_rect(0,0,20,18,0);
 VBK_REG=1;fill_bkg_rect(0,0,20,18,0);VBK_REG=0;set_bkg_palette(0,1,background);
 capture_palette();probe_ready=1;SHOW_BKG;DISPLAY_ON;
 while(1){vsync();if(probe_command){
  DISPLAY_OFF;
  if(probe_command==2){scene_actor_hide();probe_result=1;}
  else probe_result=probe_kind?scene_enemy_show(probe_id,probe_floor_palette):scene_portrait_show(probe_id);
  if(CURRENT_BANK!=1)probe_result|=128;
  capture_palette();DISPLAY_ON;probe_command=0;
 }}
}
'''
def main():
 out=ROOT/'build/verification/scene-actors';out.mkdir(parents=True,exist_ok=True)
 manifest=json.loads((ROOT/'assets/scene-actors/manifest.json').read_text());(out/'main.c').write_text(MAIN)
 sources=[out/'main.c']+[ROOT/'src'/s for s in ('scene_actor.c','scene_actor_data.c','bank_io.c','font.c','assets_sprites.c')]+sorted((ROOT/'src').glob('scene_actor_bank_*.c'))
 rom=out/'actors.gbc'
 subprocess.run(['.tools/gbdk/bin/lcc','-msm83:gb','-Wm-yC','-Wm-yt0x1b','-Wm-yo128','-Wm-ya1','-Wl-m','-Wl-j','-Isrc','-o',str(rom.relative_to(ROOT)),*[str(p.relative_to(ROOT))for p in sources]],cwd=ROOT,check=True)
 sym=load_symbols(rom.with_suffix('.noi'));e=PyBoy(str(rom),window='null',cgb=True,sound_emulated=False,log_level='ERROR');e.set_emulation_speed(0)
 counts={'native_actors':0,'native_pattern_bytes':0,'native_oam_records':0,'protected_bytes':0,'palette_bytes':0};timings=[]
 def palette():return bytes(e.memory[sym['probe_palette']:sym['probe_palette']+64])
 def protected():return bytes(e.memory[0,0x8000:0x9fff])+bytes(e.memory[1,0x8800:0x9fff])+bytes(e.memory[1,0x8000:0x8540])
 def command(number=1):
  e.memory[sym['probe_command']]=number
  for ticks in range(600):
   e.tick(1)
   if not e.memory[sym['probe_command']]:break
  else:raise AssertionError('Actor upload timed out')
  timings.append(ticks+1);assert e.memory[sym['probe_result']]==1
 try:
  e.tick(180);assert e.memory[sym['probe_ready']]==1;original=protected();original_palette=palette()
  for record in manifest['records']:
   for key,value in [('probe_kind',record['kind']),('probe_id',record['id']),('probe_floor_palette',record['palette_index'] if record['palette_index']<12 else 0)]:e.memory[sym[key]]=value
   command();assert e.memory[sym['scene_actor_active']]==1
   data=(ROOT/'assets/scene-actors'/f'{record["name"]}.bin').read_bytes();assert hashlib.sha256(data).hexdigest()==record['data_sha256']
   size=record['tiles']*16;assert bytes(e.memory[1,0x8540:0x8540+size])==data[:size];counts['native_pattern_bytes']+=size
   meta=data[size:size+record['sprites']*4];e.tick(2)
   for n in range(record['sprites']):
    x,y,tile,attribute=meta[n*4:n*4+4];assert bytes(e.memory[0xfe00+n*4:0xfe04+n*4])==bytes((y,x,84+tile,attribute)),(record['name'],n)
    counts['native_oam_records']+=1
   assert all(e.memory[0xfe00+n*4]==0 for n in range(record['sprites'],40))
   assert palette()==data[-64:];counts['palette_bytes']+=64
   # GBC hardware allows at most ten selected sprites on one scanline.
   assert max(sum(meta[n*4+1]-16<=y<meta[n*4+1]-8 for n in range(record['sprites']))for y in range(144))<=10
   assert protected()==original;counts['protected_bytes']+=len(original);counts['native_actors']+=1
   if record['name'] in ('0-25-255','0-52-255','0-59-255','0-58-255','1-22-004','1-46-255','1-49-004','1-71-004'):e.screen.image.save(out/(record['name']+'.png'))
   command(2);e.tick(2);assert not e.memory[sym['scene_actor_active']] and palette()==original_palette
   assert all(e.memory[0xfe00+n*4]==0 for n in range(40))
  report={'passed':True,'header':cartridge_header(rom),**counts,'render_frames':{'min':min(timings),'max':max(timings)},'limits':['Separate native actor probe on unchanged checkerboard background, not a dungeon campaign playthrough','Source initial poses only; animation not implemented','Opaque original enemy BG-overlay pixels are retained using the specified floor palette']}
  (out/'report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
 finally:e.stop(False)
if __name__=='__main__':main()
