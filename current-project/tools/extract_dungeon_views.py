#!/usr/bin/env python3
"""Compile every source standing-view geometry into shared native GBC patterns."""
import hashlib
import json
from pathlib import Path
import struct
from extract_dungeon_graphics import source_composite,indices_image,palette_pack,address,c_array,ROOT,SHA

def signature(samples):
    if samples[1]&7:return None
    key=0
    for depth,(front,left,right)in enumerate(((4,2,3),(7,5,6),(10,8,9))):
        value=samples[front]&7;kind=0 if not value else 1 if value in (1,7)else 2
        key|=((bool(samples[left]&7))|(bool(samples[right]&7)<<1)|(kind<<2))<<(depth*4)
        if kind:break
    return key

def scenes():
    result=[]
    def recurse(depth,s):
        front,left,right=((4,2,3),(7,5,6),(10,8,9))[depth]
        for l in range(2):
            for r in range(2):
                for f in range(3):
                    t=s.copy();t[front]=f;t[left]=l;t[right]=r
                    if not f and depth<2:recurse(depth+1,t)
                    else:result.append(t)
    recurse(0,[0]*16)
    assert len(result)==232
    for v in [1,2,3,4,5,6,130,131,132,133,134]:
        s=[0]*16;s[1]=v;result.append(s)
    return result

def main():
    rom=(ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes();assert hashlib.sha256(rom).hexdigest()==SHA
    all_scenes=scenes();raw_patterns=[];seen={};maps=[];lookup=[65535]*4096;front_lookup=[0]*16
    for scene_id,samples in enumerate(all_scenes):
        _,g,tmap=source_composite(rom,0,samples);pixels=indices_image(g,tmap);out=[]
        for ty in range(15):
            for tx in range(20):
                tile=b''.join(pixels[(ty*8+dy)*160+tx*8:(ty*8+dy)*160+tx*8+8]for dy in range(8))
                if tile not in seen:seen[tile]=len(raw_patterns);raw_patterns.append(tile)
                out.append(seen[tile])
        maps.append(struct.pack('<300H',*out));key=signature(samples)
        if key is not None:lookup[key]=scene_id
        else:front_lookup[(samples[1]&7)|(8 if samples[1]&128 else 0)]=scene_id
    front_lookup[7]=front_lookup[1];front_lookup[9]=front_lookup[1];front_lookup[15]=front_lookup[1]
    blobs={f'dungeon_view_{i:03d}':raw for i,raw in enumerate(maps)}
    blobs['dungeon_view_lookup']=struct.pack('<4096H',*lookup)
    blobs['dungeon_front_lookup']=struct.pack('<16H',*front_lookup)
    variants=[]
    for palette in range(12):
        pack=palette_pack(rom[address(3,0xb5b9)+palette*8:address(3,0xb5b9)+(palette+1)*8]);native=bytearray()
        for tile in raw_patterns:
            mask=0
            for c in tile:mask|=1<<c
            pal=pack[mask]
            for row in range(8):
                lo=hi=0
                for p in tile[row*8:row*8+8]:
                    code=pack[256+pal*8+p];lo=lo*2+(code&1);hi=hi*2+(code>>1)
                native.extend((lo,hi))
            native.append(pal)
        parts=[]
        for chunk,start in enumerate(range(0,len(raw_patterns),512)):
            name=f'dungeon_view_patterns_{palette:02d}_{chunk:02d}'
            blobs[name]=bytes(native[start*17:(start+512)*17]);parts.append(name)
        variants.append(parts)
    max_scene_patterns=max(len(set(struct.unpack('<300H',raw)))for raw in maps)
    assert max_scene_patterns<=255, 'Standing scene exceeds native cache slots'
    report={'source_sha256':SHA,'scenes':len(maps),'unique_indexed_patterns':len(raw_patterns),'max_patterns_per_scene':max_scene_patterns,
            'data_bytes':sum(map(len,blobs.values())),'scene_map_bytes':len(maps)*600,
            'pattern_variants':12,'patterns_per_chunk':512}
    print(json.dumps(report,indent=2),flush=True)
    out=ROOT/'assets/dungeon-views';out.mkdir(parents=True,exist_ok=True)
    for name,raw in blobs.items():(out/(name+'.bin')).write_bytes(raw)
    (out/'scenes.json').write_text(json.dumps(all_scenes))
    (out/'manifest.json').write_text(json.dumps(report,indent=2)+'\n')
    # Reserved after other current artwork. Parent can expand this allocation
    # when future systems need space; every blob remains within one bank.
    bank_numbers=list(range(78,112));bins=[[]for _ in bank_numbers];sizes=[0]*len(bins);locations={}
    for name in sorted(blobs,key=lambda n:-len(blobs[n])):
        fits=[i for i in range(len(bins))if sizes[i]+len(blobs[name])<=16384]
        if not fits:raise ValueError('Standing views exceed reserved banks78..111')
        i=max(fits,key=lambda j:sizes[j]);bins[i].append(name);sizes[i]+=len(blobs[name]);locations[name]=bank_numbers[i]
    for i,names in enumerate(bins):
        if not names:
            (ROOT/f'src/dungeon_views_{i:02d}.c').unlink(missing_ok=True)
            continue
        (ROOT/f'src/dungeon_views_{i:02d}.c').write_text(f'#pragma bank {bank_numbers[i]}\n#include <stdint.h>\n'+''.join(c_array(n,blobs[n])for n in names))
    header='''/* Generated native cache of exact source standing-view combinations. */
#ifndef PS_DUNGEON_VIEWS_H
#define PS_DUNGEON_VIEWS_H
#include "dungeon_graphics.h"
'''
    header+=f'#define DUNGEON_VIEW_SCENES {len(maps)}u\n#define DUNGEON_VIEW_PATTERNS {len(raw_patterns)}u\n#define DUNGEON_VIEW_CHUNKS {len(variants[0])}u\n'
    header+='extern const DungeonGraphicAsset dungeon_view_maps[DUNGEON_VIEW_SCENES];\nextern const DungeonGraphicAsset dungeon_view_variants[12][DUNGEON_VIEW_CHUNKS];\nextern const DungeonGraphicAsset dungeon_view_index,dungeon_view_front;\n#endif\n'
    (ROOT/'src/dungeon_views.h').write_text(header)
    c='#pragma bank 0\n#include "dungeon_views.h"\n'
    for name in blobs:c+=f'extern const uint8_t {name}[];\n'
    c+='const DungeonGraphicAsset dungeon_view_maps[DUNGEON_VIEW_SCENES]={\n'
    for i in range(len(maps)):n=f'dungeon_view_{i:03d}';c+=f'    {{{locations[n]},{n}}},\n'
    c+='};\nconst DungeonGraphicAsset dungeon_view_variants[12][DUNGEON_VIEW_CHUNKS]={\n'
    for parts in variants:c+='    {'+','.join('{'+str(locations[n])+','+n+'}'for n in parts)+'},\n'
    c+='};\n'
    for symbol,name in [('index','dungeon_view_lookup'),('front','dungeon_front_lookup')]:c+=f'const DungeonGraphicAsset dungeon_view_{symbol}={{{locations[name]},{name}}};\n'
    (ROOT/'src/dungeon_views.c').write_text(c)
    report['banks']={str(bank_numbers[i]):size for i,size in enumerate(sizes)if size}
    (out/'manifest.json').write_text(json.dumps(report,indent=2)+'\n');print('Packed banks',report['banks'],flush=True)
if __name__=='__main__':main()
