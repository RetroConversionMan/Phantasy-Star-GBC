#!/usr/bin/env python3
"""PPU audit of flash transitions using a frozen production source/object set."""
from pathlib import Path
import argparse, hashlib, json, re, subprocess
import numpy as np
from pyboy import PyBoy
from verify_rom import load_symbols, cartridge_header, read_word
ROOT=Path(__file__).resolve().parents[1]
MAIN=r'''
#include <gb/gb.h>
#include <gb/cgb.h>
#include "battle_scene.h"
#include "audio.h"
volatile uint8_t flash_ready,flash_command,flash_type,flash_enemy,flash_white,flash_extra,flash_error;
void main(void){
 DISPLAY_OFF;cpu_fast();HIDE_WIN;HIDE_SPRITES;SWITCH_ROM_MBC5(1);
 audio_install();DISPLAY_ON;audio_command(0x85);flash_ready=1;
 while(1){vsync();if(flash_command){
  if(flash_command==1){DISPLAY_OFF;battle_scene_configure(flash_type,0);flash_error=!battle_scene_begin(flash_enemy);SHOW_BKG;SHOW_SPRITES;DISPLAY_ON;}
  else if(flash_command==2)battle_scene_flash_enemy(flash_white);
  else battle_scene_flash_party(flash_white,flash_extra);
  flash_command=0;
 }}
}
'''
def main():
 p=argparse.ArgumentParser();p.add_argument('--snapshot',type=Path,default=ROOT/'build/source-snapshots/item-chronology-candidate');p.add_argument('--label',default='baseline');p.add_argument('--require-pass',action='store_true');a=p.parse_args()
 snap=a.snapshot.resolve();out=ROOT/'build/verification/battle-flash-frames'/a.label;out.mkdir(parents=True,exist_ok=True);(out/'main.c').write_text(MAIN)
 compiler='.tools/gbdk/bin/lcc';flags=['-msm83:gb','-DPS_DUNGEON_LEAN','-I'+str(snap/'src')]
 if '-DPS_DUNGEON_MOTION' in(snap/'Makefile').read_text():flags.append('-DPS_DUNGEON_MOTION')
 for source,obj,extra in [(snap/'src/main.c',out/'production-main.o',['-Dmain=production_main']),(out/'main.c',out/'probe-main.o',[])]:
  subprocess.run([compiler,*flags,*extra,'-c','-o',str(obj.relative_to(ROOT)),str(source.relative_to(ROOT))],cwd=ROOT,check=True)
 content=(snap/'Makefile').read_text().replace('\\\n',' ');value=re.search(r'^SOURCES := (.*)$',content,re.M)[1]
 value=re.sub(r'\$\(wildcard ([^)]+)\)',lambda m:' '.join(str(p.relative_to(snap))for pattern in m[1].split()for p in sorted(snap.glob(pattern))),value)
 objects=[snap/'build/obj'/(Path(n).stem+'.o')for n in value.split()if n!='src/main.c']+[out/'production-main.o',out/'probe-main.o']
 assert all(n.is_file()for n in objects)
 rom=out/'battle-flash.gbc';subprocess.run([compiler,'-msm83:gb','-Wm-yC','-Wm-yt0x1b','-Wm-yo256','-Wm-ya1','-Wl-m','-Wl-j','-o',str(rom.relative_to(ROOT)),*[str(n.relative_to(ROOT))for n in objects]],cwd=ROOT,check=True)
 symbols=load_symbols(rom.with_suffix('.noi'));e=PyBoy(str(rom),window='null',cgb=True,sound_emulated=True,log_level='ERROR');e.set_emulation_speed(0);cases=[]
 def issue(command):
  before=e.screen.ndarray.copy();frames=[];audio=read_word(e,symbols['audio_frames']);e.memory[symbols['flash_command']]=command
  for _ in range(1000):
   e.tick(1);frames.append(e.screen.ndarray.copy());assert not e.memory[symbols['audio_fault']];assert not e.memory[symbols['flash_error']]
   if not e.memory[symbols['flash_command']]:break
  else:raise AssertionError('Flash command did not finish')
  for _ in range(3):e.tick(1);frames.append(e.screen.ndarray.copy())
  return before,frames,(read_word(e,symbols['audio_frames'])-audio)&65535
 try:
  e.tick(180);assert e.memory[symbols['flash_ready']]
  for scene,enemy in [(1,1),(1,13),(14,70),(30,72),(31,73),(32,73)]:
   e.memory[symbols['flash_type']]=scene;e.memory[symbols['flash_enemy']]=enemy;issue(1)
   for command,extra in [(2,0),(3,0),(3,1)]:
    for white in [1,0]:
     e.memory[symbols['flash_white']]=white;e.memory[symbols['flash_extra']]=extra
     before,frames,audio=issue(command);after=frames[-1];bad=[];label=f'{scene}-{enemy}-{command}-{extra}-{white}'
     assert abs(audio-len(frames))<=1,(label,'score cadence',audio,len(frames))
     for tick,frame in enumerate(frames):
      if not(np.array_equal(frame,before)or np.array_equal(frame,after)):
       bad.append(tick);from PIL import Image;Image.fromarray(frame).save(out/f'{label}-{tick}.png')
     cases.append({'scene':scene,'enemy':enemy,'command':command,'extra':extra,'white':white,'physical_frames':len(frames),'audio_updates':audio,'changed_pixels':int(np.any(before!=after,axis=2).sum()),'mixed_frames':bad})
  report={'passed':all(not c['mixed_frames']for c in cases),'header':cartridge_header(rom),'source_snapshot':str(snap.relative_to(ROOT)),'cases':cases,'mixed_frames':sum(len(c['mixed_frames'])for c in cases),'scope':'Production palette flash functions and actual original art, with production score interrupts; every completed PPU frame must equal the stable before or after image. Original source-mask semantics are covered separately.'}
  report['linked_objects_sha256']={str(n.relative_to(ROOT)):hashlib.sha256(n.read_bytes()).hexdigest()for n in objects}
  (out/'report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
  if a.require_pass:assert report['passed']
 finally:e.stop(save=False)
if __name__=='__main__':main()
