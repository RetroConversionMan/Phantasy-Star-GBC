#!/usr/bin/env python3
"""Exhaustively compare native world lookup/trigger logic with the pinned SMS ROM.

Builds the actual C world modules for the host; does not run a reimplementation
instead of them. Graphics compare against shipped conversion bytes. Collision,
map decoding, entrances, gates and destinations compare directly with SMS bytes.
"""
import argparse
import ctypes as C
import hashlib
import json
from pathlib import Path
import struct
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]
ROM_SHA = '9e324e92bd833b45126861b6f1d2dcbb51251bdf3df6d563ab3a3ff784d8cf88'

class Action(C.Structure):
    _fields_ = [(n, C.c_uint8) for n in ('mode','target','a','b','metatile','flags')]

def addr(bank, cpu):
    return bank * 0x4000 + (cpu & 0x3fff)

def unpack_chunk(rom, start):
    # Independent decoder of original map RLE, with exact output length check.
    result = bytearray()
    while rom[start]:
        control = rom[start]; start += 1
        if control & 128:
            count = control & 127
            result.extend(rom[start:start+count]); start += count
        else:
            result.extend([rom[start]] * control); start += 1
    assert len(result) == 192
    return result

def source_group(rom, group):
    row = rom[0xdf1+14*group:0xdf1+14*(group+1)]
    pointer = struct.unpack_from('<H', row)[0]
    grid = bytearray(128*96)
    for cy in range(8):
        for cx in range(8):
            chunkptr = struct.unpack_from('<H',rom,addr(row[2],pointer)+2*(cy*9+cx))[0]
            chunk = unpack_chunk(rom,addr(row[2],chunkptr))
            for yy in range(12):
                off = (cy*12+yy)*128+cx*16
                grid[off:off+16] = chunk[yy*16:yy*16+16]
    flags = rom[addr(3,0xbc6f if group<4 else 0xbd6f):][:256]
    entries=[]
    off=addr(3,struct.unpack_from('<H',row,12)[0])
    while rom[off]!=255:
        entries.append(tuple(rom[off:off+6])); off+=6
    return grid,flags,entries

def source_action(rom, map_id, grid, flags_table, entries, x, y, vehicle=0):
    # LABEL_77AC primary sample and LABEL_792A special dispatch. Tests below use
    # completed on-foot grid steps, so there are no extra vehicle sample points.
    meta=grid[y*128+x]; flags=flags_table[meta]
    if flags&8:
        source_y=y+96 if y<6 else y
        source_x=x+128 if x<8 else x
        packed=(source_y//12)*16+source_y%12
        for ey,ex,mode,target,a,b in entries:
            ey_next=(ey+1)&255
            if ey_next&15>=12: ey_next=(ey_next+16)&0x70
            if packed in (ey,ey_next) and source_x in (ex,ex+1):
                return (mode,target,a,b,meta,flags)
        return (0,0,0,0,0,0)
    if flags&4:
        if meta==0xad and map_id>=4:
            target,a,b=rom[0x7ac1+(map_id-4)*3:0x7ac4+(map_id-4)*3]
            return (8,target,a,b,meta,flags)
        applicable=(meta==0x4c and map_id==5 or meta==0x5e and not vehicle or
                    0x5f<=meta<0x64 and vehicle!=8 or
                    0xc3<=meta<0xc7 and not vehicle or 0xc7<=meta<0xd2)
        if applicable: return (128,flags>>4,meta,vehicle,meta,flags)
        return (0,0,0,0,meta,flags)
    return (0,0,0,0,0,0)

def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--source',type=Path,default=ROOT)
    parser.add_argument('--assets',type=Path,default=ROOT/'assets/world')
    parser.add_argument('--output',type=Path,default=ROOT/'build/verification/world-logic-report.json')
    args=parser.parse_args();src=args.source.resolve()/'src';assets=args.assets.resolve()
    motion=(src/'world_motion.c').is_file()
    rom=(ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes()
    assert hashlib.sha256(rom).hexdigest()==ROM_SHA
    counts=dict(map_cells=0,collision_cells=0,tile_attribute_pairs=0,trigger_cells=0,
                gated_false_matches=0,destination_records=0,footstep_cases=0)
    groups=[source_group(rom,g) for g in range(11)]
    mapping=rom[0xdc1:0xdd9]
    with tempfile.TemporaryDirectory(prefix='ps-world-test-') as temp:
        output=Path(temp)/'world.dylib'
        sources=['world.c','bank_io.c','world_assets.c']
        sources += [p.name for p in sorted(src.glob('world_assets_*_*.c'))]
        if motion:sources += ['world_motion.c','world_motion_data.c']+[p.name for p in sorted(src.glob('world_motion_bank_*.c'))]
        subprocess.run(['cc','-std=c99','-O2','-Wno-unknown-pragmas','-dynamiclib',
                        '-o',str(output),*[str(src/p) for p in sources]],check=True)
        lib=C.CDLL(str(output))
        for name, argtypes, result in [
            ('world_select',[C.c_uint8],C.c_uint8),
            ('world_meta_at',[C.c_uint16,C.c_uint16],C.c_uint8),
            ('world_flags_at',[C.c_uint16,C.c_uint16],C.c_uint8),
            ('world_tile_at',[C.c_uint16,C.c_uint16,C.POINTER(C.c_uint8),C.POINTER(C.c_uint8)],None),
            ('world_step_allowed',[C.c_uint16,C.c_uint16,C.c_uint8,C.c_uint8],C.c_uint8),
            ('world_check_trigger',[C.c_uint16,C.c_uint16,C.c_uint8,C.POINTER(Action)],C.c_uint8),
            ('world_decode_destination',[C.POINTER(Action),C.POINTER(C.c_uint16),C.POINTER(C.c_uint16)],None),
            ('world_road_destination',[C.c_uint8,C.POINTER(Action)],C.c_uint8),
        ]:
            func=getattr(lib,name);func.argtypes=argtypes;func.restype=result
        checked_groups=set()
        for map_id,group in enumerate(mapping):
            assert lib.world_select(map_id)==1
            grid,flags,entries=groups[group]
            for yy in range(96):
                for xx in range(128):
                    x=xx*16+8;y=(yy*16+16)%1536
                    action=Action();lib.world_check_trigger(x,y,0,C.byref(action))
                    got=tuple(getattr(action,n) for n,_ in Action._fields_)
                    want=source_action(rom,map_id,grid,flags,entries,xx,yy)
                    assert got==want,(map_id,xx,yy,got,want)
                    counts['trigger_cells']+=1
                    if not flags[grid[yy*128+xx]]&12:
                        for ey,ex,*_ in entries:
                            ey=(ey>>4)*12+(ey&15)
                            if xx in (ex,ex+1) and yy in (ey,(ey+1)%96):
                                counts['gated_false_matches']+=1;break
            if group in checked_groups: continue
            checked_groups.add(group)
            metas=(assets/f'world_g{group:02d}.metatiles').read_bytes()
            for yy in range(96):
                for xx in range(128):
                    cell=grid[yy*128+xx]
                    assert lib.world_meta_at(xx*16,yy*16)==cell
                    assert lib.world_flags_at(xx*16,yy*16)==flags[cell]
                    counts['map_cells']+=1;counts['collision_cells']+=1
                    for q in range(4):
                        tile=C.c_uint8();attr=C.c_uint8()
                        lib.world_tile_at(xx*2+(q&1),yy*2+(q>>1),C.byref(tile),C.byref(attr))
                        assert (tile.value,attr.value)==tuple(metas[cell*8+q*2:cell*8+q*2+2])
                        if motion:
                            source_word=struct.unpack_from('<H',rom,addr(rom[0xDF1+group*14+9],0x8000)+cell*8+q*2)[0]
                            assert bool(attr.value&128)==bool(source_word&0x1000)
                        counts['tile_attribute_pairs']+=1
                    for facing,(dx,dy) in enumerate(((0,1),(0,-1),(-1,0),(1,0))):
                        target=grid[((yy+dy)%96)*128+(xx+dx)%128]
                        assert lib.world_step_allowed(xx*16+8,(yy*16+16)%1536,facing,0)==int(not(flags[target]&1))
                        counts['footstep_cases']+=1
            for _,_,mode,target,a,b in entries:
                if mode!=8: continue
                action=Action(mode,target,a,b,0,0); x=C.c_uint16();y=C.c_uint16()
                lib.world_decode_destination(C.byref(action),C.byref(x),C.byref(y))
                assert x.value==((b*16+8)%2048)
                # Direct source packed-origin arithmetic: subtract six rows,
                # then add player feet offset seven rows, wrapping 8 chunks.
                assert y.value==(((a>>4)*12+(a&15)+1)%96)*16
                counts['destination_records']+=1
            for tx,ty in ((256,192),(511,383),(0,192),(256,0)):
                a=C.c_uint8();b=C.c_uint8();c=C.c_uint8();d=C.c_uint8()
                lib.world_tile_at(tx,ty,C.byref(a),C.byref(b))
                lib.world_tile_at(tx%256,ty%192,C.byref(c),C.byref(d))
                assert (a.value,b.value)==(c.value,d.value)
        for index in range(8):
            action=Action();valid=lib.world_road_destination(index,C.byref(action))
            assert valid==int(1<=index<=6)
            if valid:
                assert (action.target,action.a,action.b)==tuple(rom[0xf0c+(index-1)*8+5:0xf0c+index*8])
        assert lib.world_select(24)==0
    report={'passed':True,'source_sha256':ROM_SHA,'groups':11,'map_ids':24,**counts,
            'limits':['Host logic test, not emulator rendering or cartridge test',
                      'Special story/terrain actions are explicitly deferred',
                      'Road endpoints checked; road animation is verified separately',
                      'Vehicle entry/exit and ice-breaking are covered by separate verify_vehicles.py; travel animation is separate']}
    report['source_path']=str(args.source);report['source_priority_attributes_checked']=motion
    out=args.output;out.parent.mkdir(parents=True,exist_ok=True)
    out.write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps(report,indent=2))
if __name__=='__main__':main()
