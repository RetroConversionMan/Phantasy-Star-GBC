#!/usr/bin/env python3
"""Emulate a banked world harness: real modules, every group, VRAM seams.

The probe is separate from the playable build and does not imply input-driven
campaign coverage. All emulator saves and build output are isolated.
"""
import argparse
import hashlib
import json
import os
from pathlib import Path
import subprocess
from pyboy import PyBoy
from verify_rom import load_symbols, cartridge_header

ROOT=Path(__file__).resolve().parents[1]
MAIN=r'''
#include <gb/gb.h>
#include <gb/cgb.h>
#include <stdint.h>
#include "world.h"
#include "assets.h"
#include "font.h"
void probe_banks(void) __banked;
uint8_t probe_command, probe_done, probe_error, probe_map, probe_force;
uint16_t probe_x,probe_y;
void main(void) {
    DISPLAY_OFF;HIDE_WIN;HIDE_SPRITES;
    VBK_REG=1;set_bkg_data(0,64,ui_font);
    SWITCH_ROM_MBC5(3);
    set_sprite_data(0,ALIS_TILE_COUNT,alis_tiles);
    set_sprite_palette(0,ALIS_PALETTE_COUNT,alis_palettes);
    SWITCH_ROM_MBC5(1);VBK_REG=0;
    probe_done=0x55;
    DISPLAY_ON;SHOW_BKG;
    while(1) {
        vsync();
        if(probe_command) {
            if(probe_command==1u) {
                DISPLAY_OFF;
                world_select(probe_map);world_load_graphics();
                world_draw(probe_x,probe_y,1);
                probe_banks();
                DISPLAY_ON;
            } else world_draw(probe_x,probe_y,probe_force);
            if(CURRENT_BANK!=1u) probe_error|=8u;
            probe_done++;probe_command=0;
        }
    }
}
'''
CHECK=r'''
#pragma bank 6
#include <gb/gb.h>
#include "world_assets.h"
#include "bank_io.h"
extern uint8_t probe_error;
void probe_banks(void) __banked {
    uint8_t g,value,buffer[32];
    for(g=0;g<WORLD_GROUP_COUNT;++g) {
        const WorldScene *s=&world_scenes[g];
        value=bank_read8(s->map_bank,s->map);
        if(CURRENT_BANK!=6u) probe_error|=1u;
        bank_copy(buffer,s->map_bank,s->map,32u);
        if(CURRENT_BANK!=6u) probe_error|=2u;
        if(value!=buffer[0]) probe_error|=4u;
    }
}
'''

def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--gbdk-home',type=Path,default=ROOT/'.tools/gbdk')
    parser.add_argument('--source',type=Path,default=ROOT)
    parser.add_argument('--assets',type=Path,default=ROOT/'assets/world')
    parser.add_argument('--output',type=Path,default=ROOT/'build/verification/world-probe')
    args=parser.parse_args()
    src=args.source.resolve()/'src';assets=args.assets.resolve()
    out=args.output.resolve();out.mkdir(parents=True,exist_ok=True)
    (out/'main.c').write_text(MAIN);(out/'bank_check.c').write_text(CHECK)
    sources=[out/'main.c',out/'bank_check.c']+[src/name for name in
              ('world.c','bank_io.c','world_assets.c','font.c','assets_sprites.c')]
    sources+=sorted(src.glob('world_assets_*_*.c'))
    if(src/'world_motion.c').is_file():sources += [src/'world_motion.c',src/'world_motion_data.c']+sorted(src.glob('world_motion_bank_*.c'))
    rom=out/'world-probe.gbc'
    subprocess.run([os.path.relpath(args.gbdk_home/'bin/lcc',ROOT),'-msm83:gb','-Wm-yC','-Wm-yt0x1b',
                    '-Wm-yo64','-Wm-ya1','-Wm-ynPSWORLD-PROBE','-Wl-m','-Wl-j',
                    '-I'+str(src),'-o',str(rom),*[str(p) for p in sources]],check=True,cwd=ROOT)
    symbols=load_symbols(rom.with_suffix('.noi'))
    counts={'groups':0,'viewports':0,'tile_attribute_pairs':0,'graphics_bytes':0,'protected_bytes':0}
    emu=PyBoy(str(rom),window='null',cgb=True,sound_emulated=False,log_level='ERROR');emu.set_emulation_speed(0)
    def putword(name,value):
        for off in range(2):emu.memory[symbols[name]+off]=(value>>(off*8))&255
    def protected():
        # Signed BG tiles0..63 at9000..93FF; OBJ0..83 at8000..853F.
        return bytes(emu.memory[1,0x9000:0x9400])+bytes(emu.memory[1,0x8000:0x8540])
    def issue(command,map_id,x,y,force=0):
        emu.memory[symbols['probe_map']]=map_id;putword('probe_x',x);putword('probe_y',y)
        emu.memory[symbols['probe_force']]=force;emu.memory[symbols['probe_command']]=command
        for _ in range(300):
            emu.tick(1)
            if emu.memory[symbols['probe_command']]==0:break
        else:raise AssertionError('Probe command timed out')
        assert emu.memory[symbols['probe_error']]==0,emu.memory[symbols['probe_error']]
        emu.tick(2)
    def check_view(g,x,y):
        grid=(assets/f'world_g{g:02d}.map').read_bytes()
        metas=(assets/f'world_g{g:02d}.metatiles').read_bytes()
        assert emu.memory[0xff43]==x%256 and emu.memory[0xff42]==y%256
        for ty in range(y//8,y//8+19):
            for tx in range(x//8,x//8+21):
                sx,sy=tx%256,ty%192
                meta=grid[(sy//2)*128+sx//2]
                pos=meta*8+(sy&1)*4+(sx&1)*2
                expected=tuple(metas[pos:pos+2]);addr=0x9800+(ty%32)*32+tx%32
                got=(emu.memory[0,addr],emu.memory[1,addr])
                assert got==expected,(g,x,y,tx,ty,got,expected)
                counts['tile_attribute_pairs']+=1
        counts['viewports']+=1
    try:
        emu.tick(180);assert emu.memory[symbols['probe_done']]==0x55
        keep=protected()
        first_ids=[0,1,2,3,4,7,12,14,19,21,23]
        for g,map_id in enumerate(first_ids):
            issue(1,map_id,2000,1496)
            graphics=(assets/f'world_g{g:02d}.2bpp').read_bytes()
            for tile in range(len(graphics)//16):
                bank=0 if tile<256 else 1;logical=tile if tile<256 else tile-256+64
                address=0x9000+logical*16 if logical<128 else 0x8800+(logical-128)*16
                got=bytes(emu.memory[bank,address:address+16])
                assert got==graphics[tile*16:tile*16+16],(g,tile,bank,hex(address))
                counts['graphics_bytes']+=16
            assert protected()==keep;counts['protected_bytes']+=len(keep)
            check_view(g,2000,1496)
            # Both hardware map seams and the 2048x1536 world seams, forward,
            # backward, sub-tile scroll, diagonal increment, and discontinuity.
            path=[(2008,1504),(2016,1512),(2024,1520),(2032,1528),(2040,0),
                  (0,8),(8,16),(0,8),(2040,0),(2032,1528),(2035,1531),
                  (248,248),(256,256),(264,264),(256,256),(0,0)]
            for x,y in path:
                issue(2,map_id,x,y);check_view(g,x,y)
            if g in (0,4,7):emu.screen.image.save(out/f'group-{g:02d}.png')
            counts['groups']+=1
        report={'passed':True,'header':cartridge_header(rom),**counts,
                'bank_restore_checks':'All11 map banks from code executing in bank6, returning to bank1',
                'limits':['Isolated engine harness, not input-driven campaign traversal',
                          'PyBoy only; no physical hardware test','Initial graphics only; audio and animation use separate production-object probes'],
                'source_path':str(args.source)}
        (out/'report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
    finally:emu.stop(False)
if __name__=='__main__':main()
