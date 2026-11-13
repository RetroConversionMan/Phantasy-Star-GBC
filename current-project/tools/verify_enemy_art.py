#!/usr/bin/env python3
"""Separate native graphics probe for all extracted enemy initial poses."""
from pathlib import Path
import json,subprocess,hashlib
from pyboy import PyBoy
from verify_rom import cartridge_header,load_symbols
ROOT=Path(__file__).resolve().parents[1]
MAIN=r'''
#include <gb/gb.h>
#include <gb/cgb.h>
#include "enemy_art.h"
#include "assets.h"
#include "font.h"
uint8_t probe_command,probe_enemy,probe_error,probe_ready;
void main(void){
 DISPLAY_OFF;HIDE_WIN;HIDE_SPRITES;
 VBK_REG=1;set_bkg_data(0,64,ui_font);
 SWITCH_ROM(3);set_sprite_data(0,ALIS_TILE_COUNT,alis_tiles);SWITCH_ROM(1);
 VBK_REG=0;probe_ready=1;SHOW_BKG;DISPLAY_ON;
 while(1){vsync();if(probe_command){
  DISPLAY_OFF;probe_error=!enemy_art_draw(probe_enemy);
  if(CURRENT_BANK!=1)probe_error|=2;
  DISPLAY_ON;probe_command=0;
 }}
}
'''
def main():
 out=ROOT/'build/verification/enemy-probe';out.mkdir(parents=True,exist_ok=True)
 (out/'main.c').write_text(MAIN);rom=out/'enemy-probe.gbc'
 sources=[out/'main.c']+[ROOT/'src'/s for s in ['enemy_art.c','bank_io.c','font.c','assets_sprites.c']]+sorted((ROOT/'src').glob('enemy_art_*.c'))
 subprocess.run(['.tools/gbdk/bin/lcc','-msm83:gb','-Wm-yC','-Wm-yt0x1b','-Wm-yo64','-Wm-ya1','-Wl-m','-Wl-j','-Isrc','-o',str(rom),*map(str,sources)],cwd=ROOT,check=True)
 syms=load_symbols(rom.with_suffix('.noi'));e=PyBoy(str(rom),window='null',cgb=True,sound_emulated=False,log_level='ERROR');e.set_emulation_speed(0)
 counts={'enemies':0,'graphics_bytes':0,'tile_attribute_pairs':0,'protected_bytes':0}
 def protected():return bytes(e.memory[1,0x9000:0x9400])+bytes(e.memory[1,0x8000:0x8540])
 try:
  e.tick(180);assert e.memory[syms['probe_ready']]==1;keep=protected()
  for n in range(1,75):
   e.memory[syms['probe_enemy']]=n;e.memory[syms['probe_command']]=1
   for _ in range(600):
    e.tick(1)
    if not e.memory[syms['probe_command']]:break
   else:raise AssertionError(f'enemy{n} timed out')
   assert not e.memory[syms['probe_error']],n
   base=ROOT/f'assets/enemies/{n:02d}'
   graphics=base.with_suffix('.2bpp').read_bytes();tilemap=base.with_suffix('.map').read_bytes();attrs=base.with_suffix('.attr').read_bytes()
   for tile in range(len(graphics)//16):
    addr=0x9000+tile*16 if tile<128 else 0x8800+(tile-128)*16
    assert bytes(e.memory[0,addr:addr+16])==graphics[tile*16:tile*16+16],(n,tile)
    counts['graphics_bytes']+=16
   for i,(tile,attr) in enumerate(zip(tilemap,attrs)):
    addr=0x9800+i//20*32+i%20
    assert (e.memory[0,addr],e.memory[1,addr])==(tile,attr),(n,i)
    counts['tile_attribute_pairs']+=1
   assert protected()==keep,n;counts['protected_bytes']+=len(keep);counts['enemies']+=1
   e.tick(2)
   if n in [1,5,14,49,67,72,73]:e.screen.image.save(out/f'enemy-{n:02d}.png')
  report={'passed':True,'header':cartridge_header(rom),**counts,'scope':'Native static-pose asset loads and banking; not battle gameplay, animations, scene rendering, or SMS emulator image equivalence'}
  (out/'report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
 finally:e.stop(False)
if __name__=='__main__':main()
