#!/usr/bin/env python3
"""Exercise original world phases through exact production objects on a CGB.

Explicit mailbox fixtures select maps/roads and request logical animation ticks.
Original62BC executes independently for expected counters and source VRAM bytes.
The production audio IRQ remains active; no campaign completion is implied.
"""
from pathlib import Path
import argparse,hashlib,json,os,struct,subprocess
from pyboy import PyBoy
from verify_rom import load_symbols,cartridge_header,capture
from verify_world_motion_source import OriginalWorld
from extract_assets import decode_tile,DIST,encode_gb
from extract_world import scene_source,ROOT
from ending_reference import ROM

MAIN=r'''
#include <gb/gb.h>
#include <gb/cgb.h>
#include "world.h"
#include "world_motion.h"
#include "assets.h"
#include "font.h"
#include "audio.h"
uint8_t probe_command,probe_map,probe_road,probe_result,probe_error,probe_ready;
uint16_t probe_x,probe_y;
void main(void) {
    DISPLAY_OFF;HIDE_WIN;HIDE_SPRITES;cpu_fast();audio_install();
    VBK_REG=1;set_bkg_data(0,64,ui_font);
    SWITCH_ROM_MBC5(3);set_sprite_data(0,ALIS_TILE_COUNT,alis_tiles);
    set_sprite_palette(0,ALIS_PALETTE_COUNT,alis_palettes);SWITCH_ROM_MBC5(1);VBK_REG=0;
    SHOW_BKG;DISPLAY_ON;probe_ready=0x55;
    while(1) {
        vsync();
        if(probe_command==1u) {
            DISPLAY_OFF;world_select(probe_map);world_load_graphics();
            world_motion_reset(probe_road);world_draw(probe_x,probe_y,1u);
            audio_command(audio_map_track(probe_map));DISPLAY_ON;
        } else if(probe_command==2u)probe_result=world_motion_step();
        if(probe_command) {
            if(CURRENT_BANK!=1u||VBK_REG&1u)probe_error=1u;
            probe_command=0;
        }
    }
}
'''

def digest(path):return hashlib.sha256(path.read_bytes()).hexdigest()
def pattern_address(tile):return 0x9000+(tile if tile<128 else tile-256)*16

def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--source',type=Path,required=True);p.add_argument('--assets',type=Path,required=True)
    p.add_argument('--output',type=Path,required=True);args=p.parse_args()
    source=args.source.resolve();assets=args.assets.resolve();out=args.output.resolve();out.mkdir(parents=True,exist_ok=True)
    manifest=json.loads((assets/'motion-manifest.json').read_text())
    names=['world','bank_io','world_assets','world_motion','world_motion_data','world_motion_bank_24','world_motion_bank_25','font','assets_sprites','audio','audio_irq','audio_data','audio_tables','audio_low_62','audio_low_63']
    names += [f'world_assets_{g:02d}_{suffix}' for g in range(11) for suffix in ('map','tiles')]
    objects=[source/'build/obj'/f'{n}.o' for n in names]
    mainfile=out/'main.c';mainfile.write_text(MAIN);mainobj=out/'main.o';rom=out/'world-motion-probe.gbc'
    lcc='.tools/gbdk/bin/lcc'
    subprocess.run([lcc,'-msm83:gb','-DPS_DUNGEON_LEAN','-DPS_DUNGEON_MOTION','-I'+os.path.relpath(source/'src',ROOT),'-c','-o',os.path.relpath(mainobj,ROOT),os.path.relpath(mainfile,ROOT)],cwd=ROOT,check=True)
    subprocess.run([lcc,'-msm83:gb','-Wm-yC','-Wm-yt0x1b','-Wm-yo64','-Wm-ya1','-Wm-ynPSWORLD-MOTION','-Wl-m','-Wl-j','-o',os.path.relpath(rom,ROOT),os.path.relpath(mainobj,ROOT),*[os.path.relpath(x,ROOT) for x in objects]],cwd=ROOT,check=True)
    import sys
    subprocess.run([sys.executable,str(ROOT/'tools/verify_layout.py'),str(rom)],cwd=ROOT,check=True)
    symbols=load_symbols(rom.with_suffix('.noi'))
    for group in range(2):
        for slot,keys in enumerate(manifest['groups'][group]['patch_source_keys']):
            if keys:
                address=symbols[f'world_motion_g{group}_s{slot}']
                assert not address&15 and len(keys)<=16,'Generated phase does not satisfy native atomic-transfer constraints'
    e=PyBoy(str(rom),window='null',cgb=True,sound_emulated=True,log_level='ERROR');e.set_emulation_speed(0)
    ticks=0;counts={'logical_steps':0,'source_native_pattern_bytes':0,'counter_bytes':0,'priority_attributes':0,'completed_frames':0,'mixed_frames':0,'protected_bytes':0};cases=[]
    def tick():
        nonlocal ticks
        assert e.tick();ticks+=1
    def byte(name,off=0):return e.memory[symbols[name]+off]
    def put(name,value):e.memory[symbols[name]]=value
    def word(name,value):e.memory[symbols[name]]=value&255;e.memory[symbols[name]+1]=value>>8
    def protection():return bytes(e.memory[1,0x9000:0x9400])+bytes(e.memory[1,0x8000:0x8540])
    def issue(command,capture_frames=False):
        seen=[];start=ticks;put('probe_command',command)
        while byte('probe_command'):
            assert ticks-start<300,'Native animation request hung';tick()
            if capture_frames:seen.append(e.screen.ndarray.tobytes())
        assert not byte('probe_error'),'Native bank or VRAM-bank restoration failed'
        tick();tick()
        return seen,ticks-start
    while byte('probe_ready')!=0x55:tick();assert ticks<1000
    original_protected=protection();guard=bytes((i*29+7)&255 for i in range(64));e.memory[0xDBC0:0xDC00]=guard
    for group,road in [(g,0) for g in range(11)]+[(g,r) for g in range(2) for r in range(1,7)]:
        src=scene_source(ROM,group);meta=(assets/f'world_g{group:02d}.metatiles').read_bytes();gp=manifest['groups'][group]
        palettes=gp['palettes_sms_colors'];mapping={};priority=set()
        for m,words in src['definitions'].items():
            for q,w in enumerate(words):
                tile,attr=meta[m*8+q*2:m*8+q*2+2];key=w&0x9ff
                assert bool(attr&128)==bool(w&0x1000)
                assert bool(attr&32)==bool(w&0x200) and bool(attr&64)==bool(w&0x400)
                mapping[key]=(tile,(attr>>3)&1,attr&7);counts['priority_attributes']+=1
                if w&0x1000:priority.add(key)
        dynamic={k for keys in gp['patch_source_keys'] for k in keys}
        # Choose a source viewport containing as many animated cells as possible.
        scores=[]
        for y in range(0,88,4):
            for x in range(0,118,4):
                score=sum(any((w&0x9ff)in dynamic for w in src['definitions'][src['grid'][(y+dy)*128+x+dx]]) for dy in range(9) for dx in range(10))
                scores.append((score,x,y))
        _,x,y=max(scores);word('probe_x',x*16);word('probe_y',y*16)
        map_id=next(i for i in range(24) if ROM[0xDC1+i]==group);put('probe_map',map_id);put('probe_road',road);issue(1)
        original=OriginalWorld(group,road);original.vram[:len(src['source_tiles'])]=src['source_tiles']
        local_frames=[];first_audio=int.from_bytes(bytes(e.memory[symbols['audio_frames']:symbols['audio_frames']+2]),'little')
        for step in range(128):
            old=e.screen.ndarray.tobytes();expected=original.step();seen,elapsed=issue(2,group<2 and step<32)
            assert byte('probe_result')==expected[0],(group,road,step,'slot')
            assert list(e.memory[symbols['world_motion_countdown']:symbols['world_motion_countdown']+6])==expected[1]
            assert list(e.memory[symbols['world_motion_phase']:symbols['world_motion_phase']+6])==expected[2]
            counts['counter_bytes']+=12;counts['logical_steps']+=1
            for key in dynamic:
                tile,vb,pal=mapping[key];indices=decode_tile(original.vram,key&511);source_palette=src['source_palettes'][16 if key&0x800 else 0:32 if key&0x800 else 16]
                native_palette=palettes[pal]
                quantized=[0 if key in priority and i==0 else min(range(1 if key in priority else 0,4),key=lambda j:DIST[source_palette[i]][native_palette[j]]) for i in indices]
                want=encode_gb(quantized);a=pattern_address(tile);got=bytes(e.memory[vb,a:a+16]);assert got==want,(group,road,step,key,got.hex(),want.hex())
                counts['source_native_pattern_bytes']+=16
            after=e.screen.ndarray.tobytes()
            for frame in seen:
                counts['completed_frames']+=1
                if frame not in (old,after):counts['mixed_frames']+=1
            local_frames.append(elapsed)
            if group<2 and step in (2,7,15) and road in (0,4):capture(e,out/f'group{group}-road{road}-phase{step}.png')
            assert protection()==original_protected,'Animated pattern upload corrupted font/Alis VRAM';counts['protected_bytes']+=len(original_protected)
            assert bytes(e.memory[0xDBC0:0xDC00])==guard
        last_audio=int.from_bytes(bytes(e.memory[symbols['audio_frames']:symbols['audio_frames']+2]),'little')
        elapsed_audio=(last_audio-first_audio)&65535
        assert abs(elapsed_audio-sum(local_frames))<=1,('Production audio lost frame cadence',group,road,elapsed_audio,sum(local_frames))
        record={'group':group,'road':road,'steps':128,'native_frames':sum(local_frames),'max_native_frames_per_requested_step':max(local_frames),'audio_frames':elapsed_audio,'viewport':[x*16,y*16]};cases.append(record);print(json.dumps(record),flush=True)
    e.stop(save=False)
    report={'passed':counts['mixed_frames']==0,'header':cartridge_header(rom),'original_rom_sha256':hashlib.sha256(ROM).hexdigest(),'counts':counts,'cases':cases,'guard_bytes':64,'fixture_scope':'Explicit probe requests map/road/step only; RPG/campaign not linked. Exact production world and audio objects used.','objects':{x.name:digest(x) for x in objects},'source_rom_sha256':digest(source/'build/phantasy-star-gbc-world.gbc'),'atomic_frame_check':'Every completed native display frame during sampled updates must equal either its preceding or completed phase image.'}
    (out/'report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps({k:v for k,v in report.items() if k not in ('objects','cases')},indent=2));assert report['passed'],'World phase displayed a mixed completed frame'

if __name__=='__main__':main()
