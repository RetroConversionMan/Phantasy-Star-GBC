#!/usr/bin/env python3
"""Preserve original first-person graphics and wall-layer composition for native GBC.

Original bitmap patterns are decoded to their exact three-bit color indices. The native renderer composes
source tilemaps then scales the entire scene 5/8 to160x120 without replacement
art. Floor palettes are adapted to seven4-color GBC background palettes.
"""
import hashlib
import itertools
import functools
import json
from pathlib import Path
import struct
from extract_assets import sms_rgb,color_distance,gbc_color
ROOT=Path(__file__).resolve().parents[1]
SHA='9e324e92bd833b45126861b6f1d2dcbb51251bdf3df6d563ab3a3ff784d8cf88'
def address(bank,cpu):return bank*16384+(cpu&16383)
@functools.lru_cache(maxsize=1)
def symbols():
    result={}
    for line in (ROOT/'build/sms-reference/ps1built.sym').read_text().splitlines():
        if line.startswith(';') or ':' not in line:continue
        loc,_,name=line.partition(' ')
        try:b,p=(int(x,16) for x in loc.split(':'))
        except ValueError:continue
        result[name]=(b,p)
    return result

def rle(rom,pos):
    out=bytearray()
    while rom[pos]:
        count=rom[pos];pos+=1
        if count&128:count&=127;out.extend(rom[pos:pos+count]);pos+=count
        else:out.extend([rom[pos]]*count);pos+=1
    return bytes(out),pos+1

def graphics(rom,bank,pointer):
    pos=address(bank,pointer);out=bytearray()
    while rom[pos]:
        count=rom[pos];pos+=1
        if count&128:
            count=(count&127)*3;out.extend(rom[pos:pos+count]);pos+=count
        else:out.extend(rom[pos:pos+3]*count);pos+=3
    assert len(out)<=4608
    # Two shared animation streams end104 source4bpp bytes early. Their source
    # tilemaps do not reference the unwritten tail; verify referenced accesses.
    return bytes(out),pos+1

@functools.lru_cache(maxsize=38)
def frame_data(rom,index):
    table=symbols()['LABEL_705F'];off=address(*table)+index*6
    gb,gp,mb,mp=struct.unpack_from('<BHBH',rom,off)
    g,_=graphics(rom,gb,gp)
    start=address(mb,mp);lo,p=rle(rom,start);hi,end=rle(rom,p)
    assert len(lo)==len(hi)==768
    tilemap=bytes(b for pair in zip(lo,hi) for b in pair)
    return g,tilemap,rom[start:end],(gb,gp,mb,mp)

def palette_pack(colors):
    candidates=list(itertools.combinations(range(8),4))
    distance=[[color_distance(colors[a],colors[b])+(10**12 if bool(a)!=bool(b) else 0)for b in range(8)]for a in range(8)]
    error=[[min(distance[c][p] for p in palette)for c in range(8)]for palette in candidates]
    scores=[[sum(err[c] for c in range(8) if mask>>c&1)for mask in range(256)]for err in error]
    selected=[];best=[10**12]*256
    for _ in range(7):
        choice=min((i for i in range(len(candidates))if i not in selected),
                   key=lambda i:sum(min(best[m],scores[i][m])for m in range(1,256)))
        selected.append(choice);best=[min(x,y)for x,y in zip(best,scores[choice])]
    palettes=[candidates[i]for i in selected]
    choices=bytes(min(range(7),key=lambda i:scores[selected[i]][mask])for mask in range(256))
    lookup=bytes(min(range(4),key=lambda j:distance[c][p[j]])for p in palettes for c in range(8))
    rgb=b''.join(struct.pack('<H',gbc_color(colors[c]))for p in palettes for c in p)
    return choices+lookup+rgb+bytes(colors)+bytes(c for p in palettes for c in p)

def source_composite(rom,frame,samples):
    if frame==0 and samples[1]&7:frame=6
    g,base,_,_=frame_data(rom,frame);tilemap=bytearray(base);syms=symbols()
    def copy(dest,rows,width,pointer):
        src=address(6,pointer);dest-=0xd000
        assert 0<=dest and dest+(rows-1)*64+width<=len(tilemap)
        for y in range(rows):tilemap[dest+y*64:dest+y*64+width]=rom[src+y*width:src+(y+1)*width]
    if frame<6:
        table=address(*syms['LABEL_6E8B'])+frame*78
        for depth,(front,left,right)in enumerate(((4,2,3),(7,5,6),(10,8,9))):
            p=table+depth*26;typ=samples[front]&7
            if typ:
                for k in range(2):
                    dest,rows,width,ptr=struct.unpack_from('<HBBH',rom,p+k*6)
                    if k==0 or 2<=typ<=6:copy(dest,rows,width,ptr)
            rows,width=rom[p+12:p+14]
            for k,view in enumerate((left,right)):
                dest,primary,alternate=struct.unpack_from('<HHH',rom,p+14+k*6)
                if not samples[view]&7:copy(dest,rows,width,alternate if typ else primary)
            if typ:break
    elif frame==6:
        typ=samples[1]&7
        if 2<=typ<=6:
            idx=typ-2+(6 if samples[1]&128 else 0)
            ptr=struct.unpack_from('<H',rom,address(*syms['LABEL_6E75'])+idx*2)[0]
            copy(0xd114,18,24,ptr)
    return frame,g,bytes(tilemap)

def indices_image(g,tilemap):
    result=[]
    for y in range(120):
        sy=y*8//5
        for x in range(160):
            sx=x*8//5;word=struct.unpack_from('<H',tilemap,(sy//8)*64+(sx//8)*2)[0]
            tx=7-sx%8 if word&0x200 else sx%8;ty=7-sy%8 if word&0x400 else sy%8
            off=(word&255)*24+ty*3
            assert off+3<=len(g),(word,off,len(g))
            result.append(sum(((g[off+b]>>(7-tx))&1)<<b for b in range(3)))
    return bytes(result)

def adapted_image(g,tilemap,pack):
    from PIL import Image
    indices=indices_image(g,tilemap);image=Image.new('RGB',(160,120))
    colors=struct.unpack_from('<28H',pack,312)
    for ty in range(15):
        for tx in range(20):
            mask=0
            for dy in range(8):
                for dx in range(8):mask|=1<<indices[(ty*8+dy)*160+tx*8+dx]
            pal=pack[mask]
            for dy in range(8):
                for dx in range(8):
                    ix=indices[(ty*8+dy)*160+tx*8+dx];code=pack[256+pal*8+ix]
                    rgb=colors[pal*4+code];image.putpixel((tx*8+dx,ty*8+dy),tuple(((rgb>>s)&31)*255//31 for s in (0,5,10)))
    return image

def c_array(name,raw):
    return f'const uint8_t {name}[{len(raw)}]={{\n'+''.join('    '+','.join(f'0x{x:02x}'for x in raw[p:p+16])+',\n'for p in range(0,len(raw),16))+'};\n'

def main():
    rom=(ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes();assert hashlib.sha256(rom).hexdigest()==SHA
    syms=symbols();blobs={};frames=[];seen_g={};seen_m={}
    for i in range(38):
        g,_,m,source=frame_data(rom,i)
        if source[:2]not in seen_g:
            seen_g[source[:2]]=f'dungeon_graphic_{len(seen_g):02d}'
            pixels=bytes(sum(((g[row+b]>>(7-x))&1)<<b for b in range(3))
                         for row in range(0,len(g),3) for x in range(8))
            blobs[seen_g[source[:2]]]=pixels+bytes(12288-len(pixels))
        if source[2:]not in seen_m:seen_m[source[2:]]=f'dungeon_tilemap_{len(seen_m):02d}';blobs[seen_m[source[2:]]]=m
        frames.append((seen_g[source[:2]],seen_m[source[2:]],source))
    blobs['dungeon_wall_layers']=rom[address(6,0x8000):address(7,0x8000)]
    off=address(*syms['LABEL_6E8B']);blobs['dungeon_layer_table']=rom[off:off+468]
    off=address(*syms['LABEL_6E75']);blobs['dungeon_door_pointers']=rom[off:off+22]
    off=address(*syms['LABEL_B03_B5B9'])
    for i in range(12):blobs[f'dungeon_colors_{i:02d}']=palette_pack(rom[off+i*8:off+(i+1)*8])
    bank_numbers=list(range(20,30))+list(range(64,78))
    bins=[[]for _ in bank_numbers];sizes=[0]*len(bank_numbers);locations={}
    for name in sorted(blobs,key=lambda n:-len(blobs[n])):
        fits=[i for i in range(len(bank_numbers))if sizes[i]+len(blobs[name])<=16384]
        if not fits:raise ValueError(f'Data exceeds reserved dungeon banks at {name}')
        index=max(fits,key=lambda i:sizes[i]);bins[index].append(name);sizes[index]+=len(blobs[name]);locations[name]=bank_numbers[index]
    out=ROOT/'assets/dungeon-graphics';out.mkdir(parents=True,exist_ok=True)
    for name,raw in blobs.items():(out/(name+'.bin')).write_bytes(raw)
    for i,names in enumerate(bins):
        if not names:
            (ROOT/f'src/dungeon_graphics_{i:02d}.c').unlink(missing_ok=True)
            continue
        (ROOT/f'src/dungeon_graphics_{i:02d}.c').write_text(f'#pragma bank {bank_numbers[i]}\n#include <stdint.h>\n\n'+''.join(c_array(n,blobs[n])for n in names))
    header='''/* Generated by tools/extract_dungeon_graphics.py. */
#ifndef PS_DUNGEON_GRAPHICS_H
#define PS_DUNGEON_GRAPHICS_H
#include <stdint.h>
typedef struct {uint8_t bank;const uint8_t *data;} DungeonGraphicAsset;
typedef struct {DungeonGraphicAsset graphic,tilemap;} DungeonGraphicFrame;
extern const DungeonGraphicFrame dungeon_graphic_frames[38];
extern const DungeonGraphicAsset dungeon_graphic_palettes[12];
extern const DungeonGraphicAsset dungeon_graphic_layers,dungeon_graphic_layer_table,dungeon_graphic_doors;
#endif
'''
    (ROOT/'src/dungeon_graphics.h').write_text(header)
    c='#pragma bank 0\n#include "dungeon_graphics.h"\n'
    for name in blobs:c+=f'extern const uint8_t {name}[];\n'
    c+='const DungeonGraphicFrame dungeon_graphic_frames[38]={\n'
    for g,m,_ in frames:c+=f'    {{{{{locations[g]},{g}}},{{{locations[m]},{m}}}}},\n'
    c+='};\nconst DungeonGraphicAsset dungeon_graphic_palettes[12]={\n'
    for i in range(12):n=f'dungeon_colors_{i:02d}';c+=f'    {{{locations[n]},{n}}},\n'
    c+='};\n'
    for symbol,name in [('layers','dungeon_wall_layers'),('layer_table','dungeon_layer_table'),('doors','dungeon_door_pointers')]:
        c+=f'const DungeonGraphicAsset dungeon_graphic_{symbol}={{{locations[name]},{name}}};\n'
    (ROOT/'src/dungeon_graphics.c').write_text(c)
    for name,samples in [('corridor',[0]*16),('wall',[0,1]+[0]*14),('door',[0,4]+[0]*14),('open-door',[0,132]+[0]*14)]:
        frame,g,tmap=source_composite(rom,0,samples)
        adapted_image(g,tmap,blobs['dungeon_colors_04']).save(out/(name+'.png'))
    report={'source_sha256':SHA,'frames':38,'unique_graphics':len(seen_g),'unique_tilemaps':len(seen_m),
            'data_bytes':sum(sizes),'banks':{str(bank_numbers[i]):size for i,size in enumerate(sizes)},
            'scene_size':[160,120],'source_scene_size':[256,192],
            'limits':['Extraction alone is not playable gameplay; native verification is recorded separately',
                      'Palette reduction and nearest-neighbor scaling adapt original art',
                      'Special dynamic overlay at LABEL_6E04 remains separate']}
    (out/'manifest.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
if __name__=='__main__':main()
