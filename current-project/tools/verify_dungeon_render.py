#!/usr/bin/env python3
"""Compare native dungeon art composition and CGB rasterization with SMS bytes."""
import argparse
import ctypes as C
import hashlib
import json
import os
from pathlib import Path
import subprocess
import tempfile
from pyboy import PyBoy
from extract_dungeon_graphics import source_composite,indices_image,adapted_image,palette_pack,address
from verify_dungeon_logic import State
from verify_rom import load_symbols,cartridge_header
ROOT=Path(__file__).resolve().parents[1]
MAIN=r'''
#include <gb/gb.h>
#include <gb/cgb.h>
#include "dungeon_render.h"
#include "assets.h"
#include "font.h"
DungeonState probe_state;
uint8_t probe_command,probe_done,probe_error,probe_floor,probe_position,probe_direction,probe_frame,probe_palette;
uint8_t probe_geometry_override,probe_samples[16];
static const uint16_t ui_colors[4]={0,0x2108,0x4210,0x7fff};
void main(void) {
    uint8_t view;
    DISPLAY_OFF;cpu_fast();HIDE_WIN;HIDE_SPRITES;
    VBK_REG=1;set_bkg_data(0,64,ui_font);
    SWITCH_ROM_MBC5(3);set_sprite_data(0,ALIS_TILE_COUNT,alis_tiles);
    SWITCH_ROM_MBC5(1);VBK_REG=0;set_bkg_palette(7,1,ui_colors);
    probe_done=0x55;DISPLAY_ON;SHOW_BKG;
    while(1) {
        vsync();
        if(probe_command) {
            if(!dungeon_enter(&probe_state,probe_floor,probe_position,probe_direction))probe_error|=1u;
            if(probe_geometry_override) for(view=0;view<16u;++view)
                probe_state.layout[dungeon_sample_position(&probe_state,view)]=probe_samples[view];
            probe_state.palette_index=probe_palette;
            if(!dungeon_render(&probe_state,probe_frame))probe_error|=2u;
            if(CURRENT_BANK!=1u)probe_error|=4u;
            probe_done++;probe_command=0;
        }
    }
}
'''

def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--gbdk-home',type=Path,default=ROOT/'.tools/gbdk')
    parser.add_argument('--quick',action='store_true')
    parser.add_argument('--lean',action='store_true',help='Verify the production standing-only renderer')
    parser.add_argument('--host-only',action='store_true')
    args=parser.parse_args();rom=(ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes()
    assert hashlib.sha256(rom).hexdigest()=='9e324e92bd833b45126861b6f1d2dcbb51251bdf3df6d563ab3a3ff784d8cf88'
    out=ROOT/('build/verification/dungeon-render-lean' if args.lean else 'build/verification/dungeon-render');out.mkdir(parents=True,exist_ok=True)
    sources=[ROOT/'src'/n for n in ('dungeon.c','dungeon_data.c','dungeon_render.c','dungeon_render_pixels.c','dungeon_graphics.c','dungeon_view.c','dungeon_views.c','dungeon_upload.c','bank_io.c')]
    sources+=sorted((ROOT/'src').glob('dungeon_graphics_*.c'))
    sources+=sorted((ROOT/'src').glob('dungeon_views_*.c'))
    counts={'source_flash_class_checks':0,'host_compositions':0,'host_source_tilemap_bytes':0,'emulator_scenes':0,'emulator_patterns':0,'emulator_pixels':0}
    for palette_id in range(12):
        pack=(ROOT/f'assets/dungeon-graphics/dungeon_colors_{palette_id:02}.bin').read_bytes()
        assert len(pack)==404
        for mask in range(256):
            pal=pack[mask]
            for original in range(8):
                if mask>>original&1:
                    selected=pack[376+pal*4+pack[256+pal*8+original]]
                    assert bool(selected)==bool(original),(palette_id,mask,original,selected)
                    counts['source_flash_class_checks']+=1
    offsets=rom[0x6c06:0x6c46]
    def samples(floor,pos,direction):
        raw=rom[address(15,0x9f6e)+floor*128:address(15,0x9f6e)+(floor+1)*128]
        cells=bytes(n for b in raw for n in (b>>4,b&15))
        return [cells[(pos+o)&255]for o in offsets[direction*16:direction*16+16]]
    with tempfile.TemporaryDirectory(prefix='ps-dungeon-render-') as tmp:
        libpath=Path(tmp)/'dungeon.dylib'
        subprocess.run(['cc','-std=c99','-O2','-Wno-unknown-pragmas','-dynamiclib','-o',str(libpath),*[str(s)for s in sources]],check=True)
        lib=C.CDLL(str(libpath));lib.dungeon_enter.argtypes=[C.POINTER(State),C.c_uint8,C.c_uint8,C.c_uint8]
        lib.dungeon_compose.argtypes=[C.POINTER(State),C.c_uint8];lib.dungeon_compose.restype=C.c_uint8
        buffer=(C.c_uint8*1536).in_dll(lib,'dungeon_render_map')
        lib.dungeon_view_scene_id.argtypes=[C.POINTER(State)];lib.dungeon_view_scene_id.restype=C.c_uint16
        cache_maps=[(ROOT/f'assets/dungeon-views/dungeon_view_{i:03d}.bin').read_bytes()for i in range(243)]
        from extract_dungeon_views import scenes
        cache_reference=[source_composite(rom,0,v)[2]for v in scenes()]
        s=State()
        for floor in range(1 if args.quick else 61):
            assert lib.dungeon_enter(C.byref(s),floor,0,0)
            for pos in range(256):
                s.position=pos
                for direction in range(4):
                    s.direction=direction
                    frame=lib.dungeon_compose(C.byref(s),0)
                    expect,g,tmap=source_composite(rom,0,samples(floor,pos,direction))
                    assert frame==expect and bytes(buffer)==tmap,(floor,pos,direction,frame,expect)
                    scene_id=lib.dungeon_view_scene_id(C.byref(s));assert cache_reference[scene_id]==tmap
                    counts['host_compositions']+=1;counts['host_source_tilemap_bytes']+=1536
        # All movement frames, multiple real source geometry contexts. Verify
        # no reference reaches unwritten tails of shortened original streams.
        for floor,pos,direction in ((0,0xde,0),(1,0xd2,2),(14,0x77,1),(60,0x88,3)):
            lib.dungeon_enter(C.byref(s),floor,pos,direction)
            for f in range(38):
                actual=lib.dungeon_compose(C.byref(s),f)
                expect,g,tmap=source_composite(rom,f,samples(floor,pos,direction))
                assert actual==expect and bytes(buffer)==tmap,(floor,pos,direction,f)
                indices_image(g,tmap)
                counts['host_compositions']+=1;counts['host_source_tilemap_bytes']+=1536
    if args.host_only:
        report={'passed':True,**counts,'limits':['Host compositor only; no emulator invoked']}
        (out/'host-report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2));return
    (out/'main.c').write_text(MAIN);gbrom=out/'dungeon-probe.gbc'
    native_sources=[out/'main.c',*sources,ROOT/'src/font.c',ROOT/'src/assets_sprites.c']
    if args.lean:
        native_sources=[p for p in native_sources if p.name not in ('dungeon_render.c','dungeon_render_pixels.c')]
        native_sources.append(ROOT/'src/dungeon_render_play.c')
    build=subprocess.run([os.path.relpath(args.gbdk_home/'bin/lcc',ROOT),'-msm83:gb',*(['-DPS_DUNGEON_LEAN'] if args.lean else []),'-Wm-yC','-Wm-yt0x1b','-Wm-yo128','-Wm-ya1','-Wm-ynPSDUNGEON-PROBE','-Wl-m','-Wl-j','-I'+str(ROOT/'src'),'-o',str(gbrom),*[str(s)for s in native_sources]],cwd=ROOT,capture_output=True,text=True)
    (out/'build.log').write_text(build.stdout+build.stderr);build.check_returncode()
    sym=load_symbols(gbrom.with_suffix('.noi'));emu=PyBoy(str(gbrom),window='null',cgb=True,sound_emulated=False,log_level='ERROR');emu.set_emulation_speed(0)
    timings=[];phases={};uploads=[];fast_timings=[];slow_timings=[]
    try:
        emu.tick(180);assert emu.memory[sym['probe_done']]==0x55
        keep=bytes(emu.memory[1,0x9000:0x9400])+bytes(emu.memory[1,0x8000:0x8540])
        cases=[(0,0xde,0,0,4),(0,0xde,0,0,4),(0,0xce,0,0,4),(0,0xbe,0,0,4),(0,0xae,0,0,4),(0,0xae,1,0,4),(0,0x5d,3,0,4),(1,0xd2,2,0,5),(60,0x88,3,0,0)]
        if not args.lean:cases += [(0,0xde,0,f,4)for f in range(1,38)]
        cases += [(0,0xde,0,0,p)for p in range(12)]
        cases=[(*case,None)for case in cases]
        from extract_dungeon_views import scenes
        cases += [(0,0x88,0,0,4,s)for s in scenes()]
        for n,(floor,pos,direction,frame,palette,geometry)in enumerate(cases[:3]if args.quick else cases):
            for key,value in [('probe_floor',floor),('probe_position',pos),('probe_direction',direction),('probe_frame',frame),('probe_palette',palette)]:emu.memory[sym[key]]=value
            emu.memory[sym['probe_geometry_override']]=int(geometry is not None)
            if geometry is not None:
                for i,value in enumerate(geometry):emu.memory[sym['probe_samples']+i]=value
            emu.memory[sym['probe_command']]=1
            for elapsed in range(1200):
                emu.tick(1)
                phase=emu.memory[sym['dungeon_render_phase']];phases[phase]=phases.get(phase,0)+1
                if emu.memory[sym['probe_command']]==0:break
            else:raise AssertionError('Dungeon renderer timed out')
            timings.append(elapsed+1);(fast_timings if not frame else slow_timings).append(elapsed+1)
            uploads.append((emu.memory[sym['dungeon_uploaded_patterns']]|emu.memory[sym['dungeon_uploaded_patterns']+1]<<8)if not frame else None)
            assert emu.memory[sym['probe_error']]==0
            emu.tick(2)
            _,g,tmap=source_composite(rom,frame,geometry if geometry is not None else samples(floor,pos,direction))
            if frame:assert bytes(emu.memory[sym['dungeon_render_map']:sym['dungeon_render_map']+1536])==tmap
            pack=palette_pack(rom[address(3,0xb5b9)+palette*8:address(3,0xb5b9)+(palette+1)*8])
            assert bytes(emu.memory[sym['dungeon_render_palette']:sym['dungeon_render_palette']+(56 if args.lean else 376)])==(pack[312:368] if args.lean else pack[:376])
            indices=indices_image(g,tmap)
            for ty in range(15):
                for tx in range(20):
                    mask=0
                    for yy in range(8):
                        for xx in range(8):mask|=1<<indices[(ty*8+yy)*160+tx*8+xx]
                    pal=pack[mask];expected=bytearray()
                    for yy in range(8):
                        lo=hi=0
                        for xx in range(8):
                            ix=indices[(ty*8+yy)*160+tx*8+xx];code=pack[256+pal*8+ix]
                            lo=lo*2+(code&1);hi=hi*2+(code>>1)
                        expected.extend((lo,hi))
                    mapaddr=0x9800+ty*32+tx
                    logical=emu.memory[0,mapaddr];attr=emu.memory[1,mapaddr];bank=(attr>>3)&1
                    pattern=0x9000+logical*16 if logical<128 else 0x8800+(logical-128)*16
                    assert bytes(emu.memory[bank,pattern:pattern+16])==expected,(n,tx,ty)
                    assert attr&7==pal
                    if not frame:assert bank==0
                    counts['emulator_patterns']+=1;counts['emulator_pixels']+=64
            assert bytes(emu.memory[1,0x9000:0x9400])+bytes(emu.memory[1,0x8000:0x8540])==keep
            if n<4:
                emu.screen.image.save(out/f'emulator-{n:02d}.png')
                adapted_image(g,tmap,pack).save(out/f'expected-{n:02d}.png')
            if n==1:assert uploads[-1]==0,'Repeated scene should reuse all cached patterns'
            counts['emulator_scenes']+=1
        report={'passed':True,'header':cartridge_header(gbrom),**counts,
                'production_lean':args.lean,'cpu_speed':'CGB double speed','pattern_uploads':uploads,'fast_render_frames':fast_timings,'slow_motion_frames':slow_timings,'phase_frames':phases,'render_elapsed_emulator_frames':{'min':min(timings),'max':max(timings),'all':timings},
                'limits':['Separate renderer probe; not playable dungeon campaign',
                          'Standing frames use native cache; motion frames remain too slow for gameplay',
                          'Nearest-neighbor scaling and palette reduction alter source resolution/color count',
                          'Special dynamic overlay LABEL_6E04 pending','No physical hardware validation']}
        (out/('quick-report.json'if args.quick else 'report.json')).write_text(json.dumps(report,indent=2)+'\n');print(json.dumps({**counts,'passed':True,'fast_frames_min':min(fast_timings),'fast_frames_max':max(fast_timings),'motion_frames_min':min(slow_timings)if slow_timings else None,'motion_frames_max':max(slow_timings)if slow_timings else None,'report':str(out/('quick-report.json'if args.quick else 'report.json'))},indent=2))
    finally:emu.stop(False)
if __name__=='__main__':main()
