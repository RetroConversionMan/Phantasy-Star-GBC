#!/usr/bin/env python3
"""Native opening ring streaming vs independent source WRAM/VRAM simulation."""
from pathlib import Path
import json,subprocess,struct
from pyboy import PyBoy
from verify_rom import load_symbols,cartridge_header,read_word
from extract_opening import extract,ROOT,SHA
MAIN=r'''
#include <gb/gb.h>
#include <gb/cgb.h>
#include "opening.h"
#include "font.h"
#include "assets.h"
uint16_t scene_shared_colors[32];uint8_t scene_shared_bytes[40];
uint8_t probe_ready,probe_command,probe_skip,probe_image,probe_result,probe_bank_error;
void main(void){
 DISPLAY_OFF;cpu_fast();HIDE_WIN;HIDE_SPRITES;VBK_REG=1;set_bkg_data(0,64,ui_font);
 SWITCH_ROM_MBC5(3);set_sprite_data(0,84,alis_tiles);SWITCH_ROM_MBC5(1);VBK_REG=0;
 probe_ready=1;SHOW_BKG;DISPLAY_ON;
 while(1){vsync();if(probe_command){
  if(probe_command==1){DISPLAY_OFF;opening_begin();probe_result=0;DISPLAY_ON;}
  else if(probe_command==2)probe_result=opening_tick(probe_skip);
  else if(probe_command==4){movie_city_caption();probe_result=1;}
  else{DISPLAY_OFF;probe_result=movie_scene_show(probe_image);DISPLAY_ON;}
  if(CURRENT_BANK!=1)probe_bank_error=1;probe_command=0;
 }}
}
'''
def main():
 out=ROOT/'build/verification/opening';out.mkdir(parents=True,exist_ok=True);(out/'main.c').write_text(MAIN);rom=out/'opening-probe.gbc'
 sources=[out/'main.c']+[ROOT/'src'/n for n in ('opening.c','opening_data.c','bank_io.c','font.c','assets_sprites.c')]+sorted((ROOT/'src').glob('opening_bank_*.c'))
 subprocess.run(['.tools/gbdk/bin/lcc','-msm83:gb','-Wm-yC','-Wm-yt0x1b','-Wm-yo256','-Wm-ya1','-Wl-m','-Wl-j','-Isrc','-o',str(rom.relative_to(ROOT)),*[str(p.relative_to(ROOT))for p in sources]],cwd=ROOT,check=True)
 sym=load_symbols(rom.with_suffix('.noi'));e=PyBoy(str(rom),window='null',cgb=True,sound_emulated=False,log_level='ERROR');e.set_emulation_speed(0)
 pan,layouts,images=extract((ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes());counts={'source_frame_ticks':0,'visible_tile_cells':0,'static_images':0,'static_pattern_bytes':0,'skips':0}
 def command(c):
  e.memory[sym['probe_command']]=c
  for _ in range(600):
   e.tick(1)
   if not e.memory[sym['probe_command']]:break
  else:raise AssertionError('Opening probe timeout')
  assert not e.memory[sym['probe_bank_error']];return e.memory[sym['probe_result']]
 def protected():return bytes(e.memory[1,0x9000:0x9400])+bytes(e.memory[0,0x8000:0x8800])+bytes(e.memory[1,0x8000:0x8540])
 def capture(name):e.tick(2);e.screen.image.save(out/(name+'.png'))
 try:
  e.tick(180);assert e.memory[sym['probe_ready']];keep=protected();command(1)
  # Independent model starts with original12 star rows repeated across28 rows.
  vram=[(0,row%12)for row in range(28)];wram=list(vram);scroll=128;turns=2
  for frame in range(225):
   pos=128+frame;assert read_word(e,sym['opening_position'])==pos;assert e.memory[0xff42]==(pos+24)%256
   head=(pos+24)//8
   for logical in range(head,head+19):
    kind,row=vram[logical%28];base=1624+kind*768+row*32+6
    for col in range(20):
     address=0x9800+(logical%32)*32+col
     actual=(e.memory[0,address],e.memory[1,address]);expected=(pan[base+col],pan[base+384+col])
     assert actual==expected,(frame,logical,col,actual,expected);counts['visible_tile_cells']+=1
   if frame in (0,95,128,176,224):capture(f'pan-{frame:03}')
   if frame==224:break
   # Source73D0 runs before43AA; only WRAM changes at the first scrollwrap.
   row=((scroll+192)%224)//8;vram[row]=wram[row]
   scroll+=1
   if scroll==224:
    scroll=0;turns-=1
    if turns==1:wram[:12]=[(1,r)for r in range(12)]
   assert command(2)==int(frame==223);counts['source_frame_ticks']+=1
  assert protected()==keep
  for frame in (0,95,96,128,223):
   command(1);e.memory[sym['probe_skip']]=0
   for _ in range(frame):assert not command(2)
   pos=read_word(e,sym['opening_position']);e.memory[sym['probe_skip']]=1;assert command(2)==1;assert read_word(e,sym['opening_position'])==pos;counts['skips']+=1
  manifest=json.loads((ROOT/'assets/opening/manifest.json').read_text())
  for record in manifest['static_images']:
   e.memory[sym['probe_image']]=record['id'];assert command(3)==1;data=(ROOT/'assets/opening'/f'{record["name"]}.bin').read_bytes();offset=record['tiles']*16
   for tile in range(record['tiles']):
    bank=int(tile>=256);ix=tile if tile<256 else tile-256+64;address=0x9000+ix*16 if ix<128 else 0x8800+(ix-128)*16
    assert bytes(e.memory[bank,address:address+16])==data[tile*16:tile*16+16];counts['static_pattern_bytes']+=16
   for cell in range(300):
    address=0x9800+(cell//20)*32+cell%20;assert(e.memory[0,address],e.memory[1,address])==(data[offset+cell],data[offset+300+cell])
   assert protected()==keep;capture(record['name']);counts['static_images']+=1
   if record['id']==1:
    assert command(4)==1;offset=record['caption_map_offset']
    for cell in range(300):
     address=0x9800+(cell//20)*32+cell%20;assert(e.memory[0,address],e.memory[1,address])==(data[offset+cell],data[offset+300+cell]),('caption',cell)
    assert protected()==keep;capture('city-caption')
  e.memory[sym['probe_image']]=255;assert command(3)==0
  report={'passed':True,'header':cartridge_header(rom),**counts,'limits':['Probe uses one logical pan tick per command; integrated cadence requires separate test','Centered160x144 crop for pan; static source pictures adapt160x120','Outer fades, delays, narration and ending credits are separately orchestrated']}
  (out/'report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
 finally:e.stop(False)
if __name__=='__main__':main()
