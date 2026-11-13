#!/usr/bin/env python3
"""Source narrative order/text and all nine native portrait images."""
from pathlib import Path
import json,subprocess,tempfile
from pyboy import PyBoy
from verify_rom import load_symbols,cartridge_header
ROOT=Path(__file__).resolve().parents[1]
MAIN=r'''
#include <gb/gb.h>
#include <gb/cgb.h>
#include <string.h>
#include "cutscene.h"
#include "dialogue.h"
#include "font.h"
#include "assets.h"
uint16_t scene_shared_colors[32];uint8_t scene_shared_bytes[40];
uint8_t probe_ready,probe_command,probe_portrait,probe_result,probe_done,probe_term;
uint16_t probe_text;DialogueCursor probe_cursor;char probe_lower[2][19],probe_upper[2][19];
void main(void){
 DISPLAY_OFF;cpu_fast();HIDE_WIN;HIDE_SPRITES;
 VBK_REG=1;set_bkg_data(0,64,ui_font);SWITCH_ROM_MBC5(3);set_sprite_data(0,84,alis_tiles);
 SWITCH_ROM_MBC5(1);VBK_REG=0;probe_ready=1;SHOW_BKG;DISPLAY_ON;
 while(1){vsync();if(probe_command){
  if(probe_command==1){DISPLAY_OFF;probe_result=cutscene_portrait_show(probe_portrait);DISPLAY_ON;}
  else{
   if(probe_command==2)dialogue_open(&probe_cursor,probe_text);
   probe_result=dialogue_next_story_page(&probe_cursor,probe_lower);
   memcpy(probe_upper,probe_cursor.lines,38);probe_done=probe_cursor.done;probe_term=probe_cursor.terminator;
  }
  if(CURRENT_BANK!=1)probe_result|=128;probe_command=0;
 }}
}
'''
def source_pages(raw):
 pages=[];lines=['']*4;row=0
 for b in raw:
  if 0x62<=b<=0x65:pages.append([s.ljust(18) for s in lines]);return pages,b
  if b==0x61:pages.append([s.ljust(18) for s in lines]);lines=['']*4;row=0
  elif b==0x60:row+=1;assert row<4
  elif b==0x5f:lines=['']*4;row=0
  else:lines[row]+=chr(39 if b==64 else b);assert len(lines[row])<=18
 raise AssertionError('No original narrative terminator')
def main():
 out=ROOT/'build/verification/cutscenes';out.mkdir(parents=True,exist_ok=True)
 with tempfile.TemporaryDirectory(prefix='ps-narrative-') as tmp:
  binary=Path(tmp)/'test';names=['tests/test_cutscenes.c','src/cutscene.c','src/events.c','src/events_data.c','src/rpg.c','src/rpg_data.c','src/dialogue.c','src/dialogue_data.c']+[str(p.relative_to(ROOT))for p in (ROOT/'src').glob('dialogue_text_*.c')]
  subprocess.run(['clang','-std=c99','-Wall','-Wextra','-Werror','-fsanitize=address,undefined','-I',str(ROOT/'src'),'-o',str(binary),*[str(ROOT/n)for n in names]],check=True)
  host=json.loads(subprocess.check_output([str(binary)],text=True))
 (out/'main.c').write_text(MAIN);rom=out/'cutscene-probe.gbc'
 sources=[out/'main.c']+[ROOT/'src'/s for s in ('cutscene.c','cutscene_art.c','cutscene_art_data.c','dialogue.c','dialogue_data.c','bank_io.c','font.c','assets_sprites.c')]+sorted((ROOT/'src').glob('cutscene_art_bank_*.c'))+sorted((ROOT/'src').glob('dialogue_text_*.c'))
 subprocess.run(['.tools/gbdk/bin/lcc','-msm83:gb','-Wm-yC','-Wm-yt0x1b','-Wm-yo128','-Wm-ya1','-Wl-m','-Wl-j','-Isrc','-o',str(rom.relative_to(ROOT)),*[str(p.relative_to(ROOT))for p in sources]],cwd=ROOT,check=True)
 sym=load_symbols(rom.with_suffix('.noi'));e=PyBoy(str(rom),window='null',cgb=True,sound_emulated=False,log_level='ERROR');e.set_emulation_speed(0)
 counts={'native_portraits':0,'native_pattern_bytes':0,'native_map_attributes':0,'native_narrative_pages':0,'native_narrative_characters':0}
 def run(command):
  e.memory[sym['probe_command']]=command
  for ticks in range(1000):
   e.tick(1)
   if not e.memory[sym['probe_command']]:break
  else:raise AssertionError('Cutscene probe timed out')
  assert e.memory[sym['probe_result']]==1
 def protected():return bytes(e.memory[1,0x9000:0x9400])+bytes(e.memory[0,0x8000:0x8800])+bytes(e.memory[1,0x8000:0x8800])
 try:
  e.tick(180);assert e.memory[sym['probe_ready']]==1;keep=protected()
  manifest=json.loads((ROOT/'assets/cutscenes/manifest.json').read_text())
  for record in manifest['records']:
   p=record['portrait'];e.memory[sym['probe_portrait']]=p;run(1)
   data=(ROOT/f'assets/cutscenes/portrait-{p}.bin').read_bytes();size=record['tiles']*16
   for tile in range(record['tiles']):
    bank=int(tile>=256);index=tile if tile<256 else tile-256+64;address=0x9000+index*16 if index<128 else 0x8800+(index-128)*16
    assert bytes(e.memory[bank,address:address+16])==data[tile*16:tile*16+16];counts['native_pattern_bytes']+=16
   for n in range(300):
    address=0x9800+(n//20)*32+n%20
    assert (e.memory[0,address],e.memory[1,address])==(data[size+n],data[size+300+n]);counts['native_map_attributes']+=1
   assert protected()==keep;counts['native_portraits']+=1;e.tick(2);e.screen.image.save(out/f'portrait-{p}.png')
  records=json.loads((ROOT/'assets/dialogue/decoded.json').read_text())
  for record in records:
   if record['id']<0xc000:continue
   expected,term=source_pages(bytes.fromhex(record['expanded_hex']))
   e.memory[sym['probe_text']]=record['id']&255;e.memory[sym['probe_text']+1]=record['id']>>8
   for n,lines in enumerate(expected):
    run(2 if not n else 3);actual=bytes(e.memory[sym['probe_upper']:sym['probe_upper']+38])+bytes(e.memory[sym['probe_lower']:sym['probe_lower']+38])
    assert actual==b''.join(s.encode()+b'\0' for s in lines),(hex(record['id']),n,actual,lines)
    assert bool(e.memory[sym['probe_done']])==(n==len(expected)-1);counts['native_narrative_pages']+=1;counts['native_narrative_characters']+=72
   assert e.memory[sym['probe_term']]==term
  report={'passed':True,'host':host,'header':cartridge_header(rom),**counts,'limits':['Separate narrative/portrait probe; recruitment game-loop integration tested separately','Intro/ending surrounding camera and movement sequences remain separate from their decoded narrative']}
  (out/'report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
 finally:e.stop(False)
if __name__=='__main__':main()
