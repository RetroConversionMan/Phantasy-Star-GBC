#!/usr/bin/env python3
"""Verify the real frame0 presentation helper waits even on cache hits."""
import hashlib,json,shutil,subprocess
from pathlib import Path
from pyboy import PyBoy
from verify_rom import load_symbols,cartridge_header
ROOT=Path(__file__).resolve().parents[1];SOURCE=ROOT/'build/motion-wait-integration/src';OUT=ROOT/'build/verification/dungeon-motion-wait/cached'
MAIN=r'''
#include <gb/gb.h>
#include <gb/cgb.h>
#include "dungeon_present.h"
#include "dungeon_motion.h"
#include "dungeon_render_scratch.h"
#include "audio.h"
#include "font.h"
uint8_t dungeon_render_map[600],dungeon_render_palette[56],dungeon_render_phase;
DungeonRenderScratch dungeon_render_scratch;
DungeonState probe_state;
uint8_t background_changed,scene_actor_active,ready,command;
uint16_t scene_shared_colors[32],before,after;
void scene_actor_hide(void) __banked {scene_actor_active=0;}
uint8_t travel_fade_color(uint8_t color,uint8_t step,uint8_t in) __banked {step;in;return color;}
void main(void){
 DISPLAY_OFF;cpu_fast();HIDE_WIN;HIDE_SPRITES;
 VBK_REG=1;set_bkg_data(0,64,ui_font);VBK_REG=0;
 audio_install();audio_command(0x91);SHOW_BKG;DISPLAY_ON;
 probe_state.palette_index=1;probe_state.light=255;ready=1;
 while(1){vsync();if(command){
  if(command==1)dungeon_motion_render(&probe_state,0);
  else {before=sys_time;dungeon_present_frame(&probe_state,0);after=sys_time;}
  command=0;
 }}
}
'''
def main():
 OUT.mkdir(parents=True,exist_ok=True);(OUT/'main.c').write_text(MAIN)
 names=['dungeon_motion.c','dungeon_motion_data.c','dungeon_motion_upload.c','dungeon_present.c','dungeon.c','dungeon_data.c','dungeon_view.c','dungeon_upload.c','dungeon_production_data.c','dungeon_production_tables.c','bank_io.c','font.c','audio.c','audio_tables.c','audio_data.c','audio_low_62.c','audio_low_63.c','audio_irq.c']+[p.name for p in sorted(SOURCE.glob('dungeon_motion_bank_*.c'))]
 rom=OUT/'cached.gbc';subprocess.run(['.tools/gbdk/bin/lcc','-msm83:gb','-DPS_DUNGEON_LEAN','-DPS_DUNGEON_MOTION','-Wm-yC','-Wm-yt0x1b','-Wm-yo256','-Wm-ya1','-Wl-m','-Wl-j','-I'+str(SOURCE.relative_to(ROOT)),'-o',str(rom.relative_to(ROOT)),str((OUT/'main.c').relative_to(ROOT)),*[str((SOURCE/n).relative_to(ROOT))for n in names]],cwd=ROOT,check=True)
 s=load_symbols(rom.with_suffix('.noi'));e=PyBoy(str(rom),window='null',cgb=True,sound_emulated=True,log_level='ERROR');e.set_emulation_speed(0);uploads=[]
 def word(name):return e.memory[s[name]]|e.memory[s[name]+1]<<8
 def command(value):
  e.memory[s['command']]=value
  for _ in range(120):
   e.tick(1)
   if not e.memory[s['command']]:return
  raise AssertionError('cached command timeout')
 try:
  e.tick(180);assert e.memory[s['ready']];e.memory[0xdc00:0xdc40]=[0xa5]*64;command(1);e.tick(2)
  a=s['dungeon_motion_upload_begin'];e.hook_register(a>>16,a&65535,lambda _:uploads.append(word('audio_frames')),None)
  picture=hashlib.sha256(e.screen.ndarray.tobytes()).hexdigest();elapsed=[]
  for _ in range(16):
   command(2);elapsed.append((word('after')-word('before'))&65535)
   assert elapsed[-1]>=1 and elapsed[-1]<=2,elapsed
   assert not uploads,'Frame0 unexpectedly missed the cache'
   assert hashlib.sha256(e.screen.ndarray.tobytes()).hexdigest()==picture
   assert bytes(e.memory[0xdc00:0xdc40])==bytes([0xa5])*64
   assert not e.memory[s['audio_fault']]and not e.memory[s['dungeon_motion_fault']]
  report={'passed':True,'header':cartridge_header(rom),'source_present_sha256':hashlib.sha256((SOURCE/'dungeon_present.c').read_bytes()).hexdigest(),'cache_hits':len(elapsed),'native_uploads_during_hits':len(uploads),'VBlanks_per_cached_call':elapsed,'guard_bytes':64,'stubs':'Unused scene-actor and fade services only; real motion/presentation/IRQ code executes.'}
  (OUT/'report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
 finally:e.stop(False)
if __name__=='__main__':main()
