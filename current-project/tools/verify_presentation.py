#!/usr/bin/env python3
"""Verify bank128 source effects, every palette-write frame, and protected VRAM."""
from pathlib import Path
import json,subprocess
from pyboy import PyBoy
from verify_rom import load_symbols,cartridge_header,read_word
ROOT=Path(__file__).resolve().parents[1]
MAIN=r'''
#include <gb/gb.h>
#include <gb/cgb.h>
#include "presentation.h"
#include "scene.h"
#include "font.h"
#include "assets.h"
uint16_t scene_shared_colors[32];uint8_t scene_shared_bytes[40];
uint8_t probe_ready,probe_command,probe_effect,probe_result,probe_bank_error;
uint8_t probe_bg[64],probe_obj[64];
static const uint16_t bg[4]={0,0x2108,0x4210,0x7fff};
static void capture(void){uint8_t i;for(i=0;i<64u;++i){BCPS_REG=i;probe_bg[i]=BCPD_REG;OCPS_REG=i;probe_obj[i]=OCPD_REG;}}
void main(void){
 DISPLAY_OFF;cpu_fast();HIDE_WIN;HIDE_SPRITES;
 VBK_REG=1;set_bkg_data(0,64,ui_font);SWITCH_ROM_MBC5(3);set_sprite_data(0,84,alis_tiles);set_sprite_palette(0,8,alis_palettes);
 SWITCH_ROM_MBC5(1);VBK_REG=0;set_bkg_palette(7,1,bg);probe_ready=1;capture();SHOW_BKG;DISPLAY_ON;
 while(1){vsync();if(probe_command){
  if(probe_command==1){DISPLAY_OFF;probe_result=presentation_begin(probe_effect);}
  else if(probe_command==2){probe_result=presentation_tick();DISPLAY_OFF;}
  else{DISPLAY_OFF;scene_actor_hide();probe_result=1;}
  if(CURRENT_BANK!=1)probe_bank_error=1;capture();DISPLAY_ON;probe_command=0;
 }}
}
'''
def palette_index(kind,frame):
 if kind==1:return 0 if frame<15 else min(6,1+(frame-15)//16)
 if kind==2:return 1
 if kind==3:return 1+(frame//3)%24 if frame<216 else 25+(frame-216)//8
 return 1+frame//24
def main():
 out=ROOT/'build/verification/presentation';out.mkdir(parents=True,exist_ok=True);(out/'main.c').write_text(MAIN);rom=out/'presentation-probe.gbc'
 sources=[out/'main.c']+[ROOT/'src'/n for n in ('presentation.c','presentation_data.c','scene_actor.c','scene_actor_data.c','bank_io.c','font.c','assets_sprites.c')]+sorted((ROOT/'src').glob('presentation_bank_*.c'))+sorted((ROOT/'src').glob('scene_actor_bank_*.c'))
 subprocess.run(['.tools/gbdk/bin/lcc','-msm83:gb','-Wm-yC','-Wm-yt0x1b','-Wm-yo256','-Wm-ya1','-Wl-m','-Wl-j','-Isrc','-o',str(rom.relative_to(ROOT)),*[str(p.relative_to(ROOT))for p in sources]],cwd=ROOT,check=True)
 sym=load_symbols(rom.with_suffix('.noi'));e=PyBoy(str(rom),window='null',cgb=True,sound_emulated=False,log_level='ERROR');e.set_emulation_speed(0)
 manifest=json.loads((ROOT/'assets/presentation/manifest.json').read_text());counts={'effects':0,'source_timed_ticks':0,'palette_bytes':0,'pattern_bytes':0};records=[]
 def protected():return bytes(e.memory[1,0x9000:0x9400])+bytes(e.memory[0,0x8000:0x8800])+bytes(e.memory[1,0x8000:0x8540])
 def command(value):
  e.memory[sym['probe_command']]=value
  for _ in range(600):
   e.tick(1)
   if not e.memory[sym['probe_command']]:break
  else:raise AssertionError('Effect probe timeout')
  assert not e.memory[sym['probe_bank_error']]
  return e.memory[sym['probe_result']]
 def capture(name):e.tick(2);e.screen.image.save(out/(name+'.png'))
 try:
  e.tick(180);assert e.memory[sym['probe_ready']]==1;keep=protected();font_palette=bytes(e.memory[sym['probe_bg']+56:sym['probe_bg']+64])
  for record in manifest['records']:
   kind=record['kind'];data=(ROOT/'assets/presentation'/f'{record["name"]}.bin').read_bytes();offset=record['tiles']*16+(record['sprites']*4 if record['sprites'] else 600);width=64 if record['sprites'] else 56
   e.memory[sym['probe_effect']]=kind;assert command(1)==1
   for tile in range(record['tiles']):
    if record['sprites']:bank=1;address=0x8540+tile*16
    else:
     bank=int(tile>=256);ix=tile if tile<256 else tile-256+64;address=0x9000+ix*16 if ix<128 else 0x8800+(ix-128)*16
    assert bytes(e.memory[bank,address:address+16])==data[tile*16:tile*16+16];counts['pattern_bytes']+=16
   address=sym['probe_obj'if record['sprites'] else 'probe_bg']
   changes=[];previous=-1
   for frame in range(record['duration_frames']):
    ix=palette_index(kind,frame);expected=data[offset+ix*width:offset+(ix+1)*width]
    assert bytes(e.memory[address:address+width])==expected,(kind,frame,ix)
    counts['palette_bytes']+=width
    if ix!=previous:changes.append((frame,ix));previous=ix
    if frame in (0,record['duration_frames']-1):capture(f'{record["name"]}-{frame:03}')
    result=command(2);assert result==int(frame+1==record['duration_frames']);counts['source_timed_ticks']+=1
    assert read_word(e,sym['presentation_frame'])==frame+1
   assert not e.memory[sym['presentation_active']];assert protected()==keep
   assert bytes(e.memory[sym['probe_bg']+56:sym['probe_bg']+64])==font_palette
   command(3);counts['effects']+=1;records.append({'kind':kind,'palette_changes':changes,'frames':record['duration_frames']})
  report={'passed':True,'header':cartridge_header(rom),**counts,'sequences':records,'limits':['Tests call one effect tick per source logical VBlank; production-loop cadence verified separately','Palette/resolution adaptation is native GBC, not SMS pixel identity','Odin effect does not itself consume Alsulin or recruit; event logic owns state']}
  (out/'report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps({k:v for k,v in report.items()if k!='sequences'},indent=2))
 finally:e.stop(False)
if __name__=='__main__':main()
