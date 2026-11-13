#!/usr/bin/env python3
"""Extract pinned original dungeon data, preserving raw native handler payloads."""
import hashlib
import json
from pathlib import Path

ROOT=Path(__file__).resolve().parents[1]
SHA='9e324e92bd833b45126861b6f1d2dcbb51251bdf3df6d563ab3a3ff784d8cf88'
def address(bank,cpu):return bank*0x4000+(cpu&0x3fff)
def c_array(name,raw):
    return f'const uint8_t {name}[{len(raw)}] = {{\n'+''.join('    '+','.join(f'0x{x:02x}' for x in raw[p:p+16])+',\n' for p in range(0,len(raw),16))+'};\n'
def records(rom,start,size):
    end=start
    while rom[end]!=255:end+=size
    return rom[start:end]
def main():
    rom=(ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes()
    assert hashlib.sha256(rom).hexdigest()==SHA
    arrays={
      'dungeon_layouts':rom[address(15,0x9f6e):address(15,0xbdee)],
      'dungeon_objects':records(rom,address(3,0xaf5c),7),
      'dungeon_transitions':records(rom,address(3,0xb473),5),
      'dungeon_floor_info':rom[address(3,0xb619):address(3,0xb619)+61*4],
      'dungeon_palette_colors':rom[address(3,0xb5b9):address(3,0xb619)],
      'dungeon_view_offsets':rom[0x6c06:0x6c46],
      'dungeon_naturally_lit':rom[0x6dfe:0x6e04],
    }
    assert len(arrays['dungeon_layouts'])==61*128
    assert len(arrays['dungeon_objects'])==186*7
    assert len(arrays['dungeon_transitions'])==65*5
    for p in range(0,len(arrays['dungeon_objects']),7):
        row=arrays['dungeon_objects'][p:p+7]
        assert row[0]<61 and row[3] in (0xc5,0xc6) and row[4]<4
    for p in range(0,len(arrays['dungeon_transitions']),5):
        row=arrays['dungeon_transitions'][p:p+5]
        assert row[0]<61 and (row[2]<24 or row[2] in (0xfc,0xfd,0xfe,0xff))
    out=ROOT/'assets/dungeons';out.mkdir(parents=True,exist_ok=True)
    for name,raw in arrays.items():(out/(name+'.bin')).write_bytes(raw)
    header='''/* Generated from the pinned SMS ROM by tools/extract_dungeons.py. */
#ifndef PS_DUNGEON_DATA_H
#define PS_DUNGEON_DATA_H
#include <stdint.h>
#define DUNGEON_DATA_BANK 16u
#define DUNGEON_FLOOR_COUNT 61u
#define DUNGEON_OBJECT_COUNT 186u
#define DUNGEON_TRANSITION_COUNT 65u
'''
    for name,raw in arrays.items():header+=f'extern const uint8_t {name}[{len(raw)}];\n'
    header+='#endif\n'
    (ROOT/'src/dungeon_data.h').write_text(header)
    (ROOT/'src/dungeon_data.c').write_text('#pragma bank 16\n#include "dungeon_data.h"\n\n'+''.join(c_array(n,b)+'\n' for n,b in arrays.items()))
    report={'source_sha256':SHA,'floors':61,'objects':186,'transitions':65,
            'data_bank':16,'data_bytes':sum(map(len,arrays.values())),
            'tables':{n:{'bytes':len(b),'sha256':hashlib.sha256(b).hexdigest()}for n,b in arrays.items()},
            'limits':['Data extraction only; not dungeon rendering or playable integration',
                      'Object and transition payloads require original native handler behavior']}
    (out/'manifest.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
if __name__=='__main__':main()
