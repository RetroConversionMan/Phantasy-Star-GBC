#!/usr/bin/env python3
"""Original interaction backgrounds and NPC initial poses, adapted to 160x120.

The source 256x192 image is composed before nearest-neighbour resizing. Source
graphics, tilemaps, palette records, sprite layouts and priority bits are read
from the hash-pinned original ROM. Native font palette7/VRAM remain reserved.
"""
from pathlib import Path
from collections import Counter
from functools import lru_cache
import hashlib,json,struct
from PIL import Image,ImageDraw
from extract_assets import rle,sms_rgb,choose_palettes,convert_tile,gbc_color,c_array
from extract_enemies import ROOT,SHA,label,decode_graphics,SYMBOLS
from extract_world import scene_source

def cpu_offset(bank,pointer):
    """Only 8000..BFFF follows the selected SMS mapper bank."""
    if pointer<0x8000:return pointer
    if pointer<0xc000:return bank*0x4000+(pointer&0x3fff)
    raise ValueError(f'Not a ROM address: {bank}:{pointer:04x}')

class Source:
    def __init__(self,rom):self.rom=rom
    @lru_cache(None)
    def graphics(self,bank,pointer):return decode_graphics(self.rom,bank,pointer)
    @lru_cache(None)
    def background(self,kind):
        if kind==32:return [(0,)*64],[0x800]*768,[0]*16+list(self.rom[label('LABEL_3D1D'):label('LABEL_3D1D')+8])+[0]*8
        if 64<=kind<76:
            # LABEL_68EC's FF room: a separate bank9 image. LABEL_6D7F places
            # the eight floor colors in C248..C24F, changes C248 to C249,
            # and retains common sprite colors. FF explicitly clears C250.
            tiles=self.graphics(*SYMBOLS['LABEL_B09_B471'])
            low,pos=rle(self.rom,label('LABEL_B09_B130'));high,end=rle(self.rom,pos)
            assert len(low)==len(high)==768
            words=[a|(b<<8) for a,b in zip(low,high)]
            p=label('LABEL_B03_B5B9')+(kind-64)*8;colors=list(self.rom[p:p+8])
            palette=[colors[0]]+[0]*7+[colors[1]]+colors[1:]+list(self.rom[label('LABEL_3D1D'):label('LABEL_3D1D')+8])+[0]*8
            assert all(pixel in (0,9,10,11,12,13,14,15) for tile in tiles for pixel in tile)
            return tiles,words,palette
        assert 1<=kind<=31
        row=self.rom[label('LABEL_3DA6')+(kind-1)*8:label('LABEL_3DA6')+kind*8]
        p,g=struct.unpack_from('<HH',row,1);m=struct.unpack_from('<H',row,6)[0]
        tiles=self.graphics(row[0],g)
        low,pos=rle(self.rom,cpu_offset(row[5],m));high,end=rle(self.rom,pos)
        assert len(low)==len(high) and len(low)>=768,(kind,len(low),len(high))
        words=[a|(b<<8) for a,b in zip(low[:768],high[:768])]
        palette=list(self.rom[cpu_offset(row[0],p):cpu_offset(row[0],p)+16])
        palette+=list(self.rom[label('LABEL_3D1D'):label('LABEL_3D1D')+8])+[0]*8
        #5619 supplies the full high16 palette before scene31's first upload
        # and fade, including the body colors used before5FFE adds actor73.
        if kind==31:palette[16:]=self.rom[label('LABEL_B19_8000'):label('LABEL_B19_8000')+16]
        assert all((w&511)<len(tiles) for w in words),(kind,len(tiles),max(w&511 for w in words))
        return tiles,words,palette
    @lru_cache(None)
    def portrait(self,portrait):
        assert 1<=portrait<=61
        p,v=self.rom[label('LABEL_B03_9540')+portrait*2:label('LABEL_B03_9540')+portrait*2+2]
        palette=list(self.rom[label('LABEL_B03_95BC')+p*8:label('LABEL_B03_95BC')+p*8+8])
        row=self.rom[label('LABEL_B03_966C')+v*8:label('LABEL_B03_966C')+v*8+8]
        ptr=struct.unpack_from('<H',row,6)[0];tiles=self.graphics(row[5],ptr)
        return tiles,palette,(row[0],row[1],row[2],row[3]),{'palette_index':p,'visual_index':v,'graphics_bank':row[5],'graphics_pointer':ptr,'tile_count':len(tiles)}
    def compose(self,kind,portrait=0,enemy=0,return_indices=False):
        tiles,words,palette=self.background(31 if kind==32 and enemy==73 else kind);tiles=list(tiles);words=list(words);palette=list(palette)
        #5619 changes Interaction_Type31->32 after drawing DarkFalz, without
        # calling3D47 again. Preserve the complete scene31 body during battle.
        # Saccubus and a genuinely loaded type32 still use the blank map.
        if kind==32 and enemy!=73:words=[0x800]*768
        sprites=[];metadata={'type':kind,'portrait':portrait,'prepared_enemy':enemy}
        if enemy:
            row=self.rom[label('B03_EnemyData')+enemy*32:label('B03_EnemyData')+(enemy+1)*32]
            desc=self.rom[label('LABEL_B03_8FC7')+(row[19]-1)*24:label('LABEL_B03_8FC7')+row[19]*24]
            tiles+= [(0,)*64]*(256-len(tiles))+self.graphics(row[16],struct.unpack_from('<H',row,17)[0])
            palette[24:]=row[8:16]
            src,dst=struct.unpack_from('<HH',desc,13);h,w=desc[17:19]
            if w and h:
                assert 0xd000<=dst<0xd600
                start=(dst-0xd000)//2
                for y in range(h):
                    for x in range(w):
                        value=struct.unpack_from('<H',self.rom,cpu_offset(24,src)+(y*w+x)*2)[0]
                        if value:words[start+y*32+x]=value
            for fields in (desc[:4],desc[19:23]):
                if fields[0] and fields[1]:sprites.append((21,*fields))
            metadata['enemy_descriptor']=row[19]
        elif portrait:
            npc,npc_palette,fields,details=self.portrait(portrait)
            tiles += [(0,)*64]*(256-len(tiles))+npc
            palette[24:]=npc_palette;sprites=[(3,*fields)];metadata.update(details)
        original_palette=list(palette)
        if return_indices:palette=list(range(32))
        colors=[0]*(256*192);priority=[False]*(256*192)
        def paint(tile,x,y,pal,flipx=False,flipy=False,prio=False,sprite=False):
            assert tile<len(tiles),(kind,portrait,enemy,tile,len(tiles))
            pixels=tiles[tile]
            for py in range(8):
                sy=(y+py)&255
                if sy>=192:continue
                for px in range(8):
                    sx=(x+px)&255;index=sy*256+sx
                    value=pixels[(7-py if flipy else py)*8+(7-px if flipx else px)]
                    if sprite and (not value or priority[index]):continue
                    colors[index]=palette[value+(16 if pal else 0)]
                    if not sprite:priority[index]=prio and value!=0
        for n,word in enumerate(words):
            paint(word&511,n%32*8,n//32*8,bool(word&0x800),bool(word&0x200),bool(word&0x400),bool(word&0x1000))
        # 576A sorts descending Y without swapping equal keys. Lower OAM wins,
        # so reverse original actor order before ascending-Y back-to-front paint.
        for bank,mode,index,y,x in sorted(reversed(sprites),key=lambda s:s[3]):
            table='LABEL_B03_96F4' if bank==3 else 'LABEL_B21_8000'
            ptr=struct.unpack_from('<H',self.rom,label(table)+index*2)[0]
            start=cpu_offset(bank,ptr);count=self.rom[start];assert count<=64
            raw=self.rom[start+1:start+1+count*3]
            for n in reversed(range(count)):
                dx,tile=raw[count+n*2:count+n*2+2]
                paint(256+tile,x+dx,y+raw[n]+1,True,sprite=True)
        if return_indices:return bytes(colors),original_palette,metadata
        image=Image.new('RGB',(256,192));image.putdata([sms_rgb(c) for c in colors])
        return image,metadata

def interaction_type(group,kind):
    """Original GameMode_LoadInteraction, ROM3C52..3CAD; C308 is group."""
    if group==0 and kind==5:kind=4
    elif group in (1,7) and kind==1:kind=5
    elif group==8:kind=6
    elif group==10 and kind==9:kind=8
    return kind or 1

def required_pairs(rom):
    pairs={(kind,0,0) for kind in range(1,33)}
    for group in range(11):
        for x,y,mode,kind,event,portrait in scene_source(rom,group)['exits']:
            if mode==12:
                # Retain raw rows for reference, also cover actual runtime type.
                # Group8 remaps every row, including possibly dormant services.
                pairs.add((kind,portrait,0))
                pairs.add((interaction_type(group,kind),portrait,0))
    # Source event55/172 explicitly select the governor portrait.
    pairs.add((29,53,0))
    # Event62 Luveno and63 his assistant replace the table's zero portrait.
    pairs.update(((17,52,0),(17,16,0)))
    # Explicit story scene/battle preparations; ordinary dungeon overlays are
    # not substituted with an unrelated static room.
    pairs.update(((30,0,72),(31,0,73),(32,0,73),(32,0,74)))
    # All FF rooms with both unlit and original lit floor palettes. Handler
    # 126/127/129 explicitly replace their zero portrait with Noah/assistant/
    # Luveno. Internal types64..75 identify this distinct room renderer.
    start=label('B03_DungeonTransitionData');end=start
    while rom[end]!=255:end+=5
    transitions=rom[start:end]
    info=rom[label('LABEL_B03_B619'):label('LABEL_B03_B619')+61*4]
    pairs.update((64+p,0,0) for p in range(12))
    for n in range(0,len(transitions),5):
        floor,position,kind,event,portrait=transitions[n:n+5]
        if kind!=255:continue
        for p in (0,info[floor*4+2]+1):
            pairs.add((64+p,portrait,0))
            if event in (126,127,129):pairs.add((64+p,{126:59,127:16,129:52}[event],0))
    return sorted(pairs)

def convert(image):
    scaled=image.resize((160,120),Image.Resampling.NEAREST)
    raw=[(r//85)|((g//85)<<2)|((b//85)<<4) for r,g,b in scaled.get_flattened_data()]
    pixels=[tuple(raw[(y+dy)*160+x+dx] for dy in range(8) for dx in range(8))
            for y in range(0,120,8) for x in range(0,160,8)]
    counts=Counter(pixels);unique=list(counts)
    palettes=choose_palettes([Counter(p) for p in unique],[counts[p] for p in unique],7)
    converted={p:convert_tile(p,palettes) for p in unique}
    native=Image.new('RGB',(160,120));mismatches=0
    result=[]
    for n,p in enumerate(pixels):
        tile,palette=converted[p];result.append((tile,palette))
        for y in range(8):
            for x in range(8):
                v=((tile[y*2]>>(7-x))&1)|(((tile[y*2+1]>>(7-x))&1)<<1)
                c=palettes[palette][v];mismatches+=c!=p[y*8+x]
                native.putpixel((n%20*8+x,n//20*8+y),sms_rgb(c))
    return result,[gbc_color(c) for p in palettes for c in p],native,mismatches

def convert_indexed(indices,colors):
    from palette_identity import select_palettes
    from extract_assets import encode_gb
    scaled=Image.frombytes('L',(256,192),indices).resize((160,120),Image.Resampling.NEAREST)
    raw=list(scaled.get_flattened_data())
    pixels=[tuple(raw[(y+dy)*160+x+dx] for dy in range(8) for dx in range(8))for y in range(0,120,8)for x in range(0,160,8)]
    counts=Counter(pixels);unique=list(counts)
    # Unchanged; ordinary background flash; special extra index16; enemy hit.
    classes=[1 if 3<=c<=15 else 2 if c==16 else 3 if c>=19 else 0 for c in range(32)]
    refs,distance=select_palettes([Counter(p)for p in unique],[counts[p]for p in unique],colors,classes,7,4)
    converted={}
    for pixels_ in unique:
        hist=Counter(pixels_)
        pal=min(range(7),key=lambda i:sum(n*min(distance[c][p]for p in refs[i])for c,n in hist.items()))
        codes=[min(range(4),key=lambda i:distance[c][refs[pal][i]])for c in pixels_]
        assert all(classes[c]==classes[refs[pal][code]]for c,code in zip(pixels_,codes))
        converted[pixels_]=(encode_gb(codes),pal)
    native=Image.new('RGB',(160,120));mismatches=0;result=[]
    for n,pixels_ in enumerate(pixels):
        tile,pal=converted[pixels_];result.append((tile,pal))
        for y in range(8):
            for x in range(8):
                code=((tile[y*2]>>(7-x))&1)|(((tile[y*2+1]>>(7-x))&1)<<1)
                output=colors[refs[pal][code]];mismatches+=output!=colors[pixels_[y*8+x]]
                native.putpixel((n%20*8+x,n//20*8+y),sms_rgb(output))
    masks=bytes(sum(1<<i for i,c in enumerate(p)if classes[c]==category)for category in (1,2,3)for p in refs)
    return result,[gbc_color(colors[c])for p in refs for c in p],native,mismatches,masks

def main():
    rom=(ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes();assert hashlib.sha256(rom).hexdigest()==SHA
    source=Source(rom);out=ROOT/'assets/scenes';out.mkdir(parents=True,exist_ok=True)
    pairs=required_pairs(rom);records=[];patterns={};graphics=[];maps=[];palettes=[];flash_masks=[]
    sheet=Image.new('RGB',(8*160,((len(pairs)+7)//8)*136));draw=ImageDraw.Draw(sheet)
    for n,(kind,portrait,enemy) in enumerate(pairs):
        im,record=source.compose(kind,portrait,enemy);name=f'{kind:02d}-{portrait:02d}-{enemy:02d}'
        im.save(out/(name+'-source.png'));im.resize((160,120),Image.Resampling.NEAREST).save(out/(name+'-scaled.png'))
        indices,source_colors,_=source.compose(kind,portrait,enemy,return_indices=True)
        tiles,colors,native,error,masks=convert_indexed(indices,source_colors);mapping=[];flash_masks.append(masks)
        for tile,palette in tiles:
            if tile not in patterns:patterns[tile]=len(patterns);graphics.append(tile)
            assert patterns[tile]<8192
            mapping.append(patterns[tile]|(palette<<13))
        maps.append(struct.pack('<300H',*mapping));palettes.append(colors)
        (out/(name+'.map')).write_bytes(maps[-1]);(out/(name+'.pal')).write_bytes(struct.pack('<28H',*colors));(out/(name+'.flash')).write_bytes(masks)
        native.save(out/(name+'-gbc.png'));sheet.paste(native,((n%8)*160,(n//8)*136+16))
        draw.text(((n%8)*160+2,(n//8)*136),name,fill='white')
        record.update(name=name,color_quantized_pixels=error,source_sha256=hashlib.sha256(im.tobytes()).hexdigest(),gbc_sha256=hashlib.sha256(native.tobytes()).hexdigest())
        records.append(record)
    sheet.save(out/'scenes-gbc.png')
    # Share converted patterns globally. Each frame addresses 300 screen cells,
    # uploaded into BG bank0 0..255 and bank1 64..107. No frame-sized WRAM needed.
    pools=[b''.join(graphics[i:i+512]) for i in range(0,len(graphics),512)]
    (out/'patterns.2bpp').write_bytes(b''.join(graphics))
    banks=list(range(97,111))+list(range(192,200))
    bins=[];declarations=[]
    def place(name,data,kind='uint8_t'):
        size=len(data)*(2 if kind=='uint16_t' else 1)
        slot=next((i for i,b in enumerate(bins) if b['size']+size<=15800),None)
        if slot is None:slot=len(bins);bins.append({'size':0,'parts':[]})
        bins[slot]['size']+=size;bins[slot]['parts'].append(c_array(name,data,kind))
        declarations.append(f'extern const {kind} {name}[];\n')
        assert slot<len(banks), ("Scene bank allocation exhausted",slot)
        return banks[slot]
    poolbanks=[place(f'scene_patterns_{i:02}',data) for i,data in enumerate(pools)]
    descriptors=[]
    for i,record in enumerate(records):
        bank=place(f'scene_map_{i:03}',maps[i]+struct.pack('<28H',*palettes[i])+flash_masks[i])
        descriptors.append(f'{{{record["type"]},{record["portrait"]},{record["prepared_enemy"]},{bank},scene_map_{i:03}}}')
        record.update(gbc_bank=bank,map_sha256=hashlib.sha256(maps[i]).hexdigest())
    assert len(bins)<=len(banks)
    for old in (ROOT/'src').glob('scene_bank_*.c'):
        if int(old.stem.rsplit('_',1)[1]) not in banks[:len(bins)]:old.unlink()
    for i,b in zip(banks,bins):
        (ROOT/f'src/scene_bank_{i:03}.c').write_text(f'/* Generated original scene graphics and maps. */\n#pragma bank {i}\n#include <stdint.h>\n'+''.join(b['parts']))
    header=f'''/* Generated by tools/extract_scenes.py. */
#ifndef PS_SCENE_DATA_H
#define PS_SCENE_DATA_H
#include <stdint.h>
#define SCENE_ASSET_COUNT {len(records)}u
#define SCENE_PATTERN_COUNT {len(patterns)}u
typedef struct {{ uint8_t type,portrait,enemy,bank; const uint8_t *map; }} SceneAsset;
typedef struct {{ uint8_t bank; const uint8_t *data; }} ScenePatternPool;
extern const SceneAsset scene_assets[SCENE_ASSET_COUNT];
extern const ScenePatternPool scene_pattern_pools[{len(pools)}];
#endif
'''
    (ROOT/'src/scene_data.h').write_text(header)
    (ROOT/'src/scene_data.c').write_text('/* Bank13 descriptors, accessed only by bank13 scene renderer. */\n#pragma bank 13\n#include "scene_data.h"\n'+''.join(declarations)+'const SceneAsset scene_assets[SCENE_ASSET_COUNT]={\n'+',\n'.join(descriptors)+'\n};\nconst ScenePatternPool scene_pattern_pools[]={\n'+',\n'.join(f'{{{bank},scene_patterns_{i:02}}}' for i,bank in enumerate(poolbanks))+'\n};\n')
    report={'source_sha256':SHA,'scene_count':len(records),'unique_patterns':len(patterns),'native_banks':banks[:len(bins)],'bank_bytes':[b['size'] for b in bins],'records':records,'scope':'All raw and original group-remapped world entrance scene/portrait pairs, original table backgrounds1..31, blank32 except DarkFalz retains5619 scene31, explicit governor/final boss preparations and original FF bank9 rooms in their lit/unlit floor palettes. Internal types64..75 are distinct FF rooms. Static source poses, nearest-neighbour256x192 to160x120, seven four-color GBC palettes per frame.','limits':['Source animations and transitions are not reproduced','Dynamic portraits over arbitrary dungeon geometry remain separate from static FF rooms','Color quantization is measured, not claimed pixel-exact to the SMS palette','Three7-byte source flash masks follow56 palette bytes: indices3..15, index16, indices19..31; all palette effect classes exact']}
    (out/'manifest.json').write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps({k:v for k,v in report.items() if k!='records'},indent=2))

if __name__=='__main__':main()
