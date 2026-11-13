#!/usr/bin/env python3
"""Decode original initial enemy poses, never substitute creature artwork.

Source: ps1.asm 5FFE/60FD copies enemy graphics/24-byte visual descriptors;
615A overlays bank24 tilemaps; 5853 emits bank21 sprite layouts. This extracts
initial poses only. Animation and scene backgrounds remain separate work.
"""
from pathlib import Path
from collections import Counter
import hashlib,json,struct,re
from PIL import Image,ImageDraw
from extract_assets import address,rle,decode_tile,sms_rgb,choose_palettes,convert_tile,gbc_color,c_array
ROOT=Path(__file__).resolve().parents[1]
SYMBOLS={m[3]:(int(m[1],16),int(m[2],16)) for line in (ROOT/'build/sms-reference/ps1built.sym').read_text().splitlines() if (m:=re.match(r'^([0-9a-f]+):([0-9a-f]+) (\w+)$',line))}
def label(name):
    bank,cpu=SYMBOLS[name]
    return address(bank,cpu) if cpu>=0x8000 else bank*0x4000+(cpu&0x3fff)
SHA='9e324e92bd833b45126861b6f1d2dcbb51251bdf3df6d563ab3a3ff784d8cf88'

def decode_graphics(rom,bank,pointer):
    pos=address(bank,pointer);planes=[]
    for _ in range(4):plane,pos=rle(rom,pos);planes.append(plane)
    assert len(set(map(len,planes)))==1 and len(planes[0])%8==0
    raw=bytes(v for row in zip(*planes) for v in row)
    return [decode_tile(raw,n) for n in range(len(raw)//32)]

def initial_pose(rom,enemy,scene=1):
    rec=rom[label("B03_EnemyData")+32*enemy:label("B03_EnemyData")+32*(enemy+1)]
    desc=rom[label("LABEL_B03_8FC7")+24*(rec[19]-1):label("LABEL_B03_8FC7")+24*rec[19]]
    bank=rec[16];ptr=int.from_bytes(rec[17:19],'little')
    enemy_pixels=decode_graphics(rom,bank,ptr)
    scene_rec=rom[label('LABEL_3DA6')+(scene-1)*8:label('LABEL_3DA6')+scene*8]
    scene_palette_ptr,scene_graphics_ptr=struct.unpack_from('<HH',scene_rec,1)
    scene_pixels=decode_graphics(rom,scene_rec[0],scene_graphics_ptr)
    palette=list(rom[address(scene_rec[0],scene_palette_ptr):address(scene_rec[0],scene_palette_ptr)+16])+list(rom[label('LABEL_3D1D'):label('LABEL_3D1D')+8])+list(rec[8:16])
    pixels=scene_pixels+[(0,)*64]*(256-len(scene_pixels))+enemy_pixels
    canvas=[None]*(256*192); priority=[False]*(256*192)
    def paint(tile,x,y,pal,flipx=False,flipy=False,prio=False,sprite=False):
        if tile>=len(pixels):raise ValueError(f'enemy{enemy} tile{tile} outside {len(pixels)}')
        data=pixels[tile]
        for py in range(8):
            for px in range(8):
                sx=(x+px)&255;sy=(y+py)&255
                if sy>=192:continue
                value=data[(7-py if flipy else py)*8+(7-px if flipx else px)]
                if value==0:continue
                index=sy*256+sx
                if sprite and priority[index]:continue
                canvas[index]=palette[value+(16 if pal else 0)]
                if not sprite:priority[index]=prio
    source,dest=struct.unpack_from('<HH',desc,13);h,w=desc[17:19]
    overlay_words=0
    if w and h:
        assert 0xd000<=dest<0xd600
        ox=(dest-0xd000)%64//2*8;oy=(dest-0xd000)//64*8
        for y in range(h):
            for x in range(w):
                word=struct.unpack_from('<H',rom,address(24,source)+(y*w+x)*2)[0]
                if word==0:continue
                tile=word&511
                paint(tile,ox+x*8,oy+y*8,bool(word&0x800),bool(word&0x200),bool(word&0x400),bool(word&0x1000))
                overlay_words+=1
    layers=[]
    for mode,index,y,x in [(desc[0],desc[1],desc[2],desc[3]),(desc[19],desc[20],desc[21],desc[22])]:
        if not mode or not index:continue
        layout=struct.unpack_from('<H',rom,label("LABEL_B21_8000")+index*2)[0]
        count=rom[address(21,layout)];assert count<=64
        coords=rom[address(21,layout)+1:address(21,layout)+1+count*3]
        layers.append((y,x,index,count,coords))
    # Stable descending-Y OAM: earlier actors win ties, including equal X/Y.
    for y,x,index,count,coords in sorted(reversed(layers),key=lambda layer:layer[0]):
        for n in reversed(range(count)):
            dy=coords[n];dx,tile=coords[count+n*2:count+n*2+2]
            paint(256+tile,(x+dx)&255,(y+dy+1)&255,True,sprite=True)
    im=Image.new('RGBA',(256,192))
    im.putdata([(*sms_rgb(p),255) if p is not None else (0,0,0,0) for p in canvas])
    bbox=im.getbbox()
    assert bbox,enemy
    return im,{'enemy':enemy,'name':rec[:8].split(b'\x65')[0].decode('ascii'),'sms_graphics_bank':bank,'sms_graphics_pointer':hex(ptr),'visual_descriptor':rec[19],'scene':scene,'decoded_tiles':len(enemy_pixels),'overlay_tiles':overlay_words,'initial_sprite_layers':[{'index':a[2],'sprites':a[3]} for a in layers],'source_bbox':list(bbox),'width':bbox[2]-bbox[0],'height':bbox[3]-bbox[1]}

def convert_pose(pose):
    canvas=Image.new('RGB',(160,112));canvas.paste(pose,((160-pose.width)//2,112-pose.height),pose)
    pixels=[]
    for ty in range(14):
        for tx in range(20):
            pixels.append(tuple((r//85)|((g//85)<<2)|((b//85)<<4) for r,g,b in canvas.crop((tx*8,ty*8,tx*8+8,ty*8+8)).get_flattened_data()))
    counts=Counter(pixels);unique=list(counts)
    palettes=choose_palettes([Counter(p) for p in unique],[counts[p] for p in unique],7)
    graphics=bytearray();tile_ids={};mapping={};tilemap=bytearray();attrs=bytearray()
    converted=Image.new('RGB',(160,112))
    for p in unique:
        tile,pid=convert_tile(p,palettes)
        if tile not in tile_ids:tile_ids[tile]=len(tile_ids);graphics.extend(tile)
        mapping[p]=(tile_ids[tile],pid)
    assert len(tile_ids)<256
    for n,p in enumerate(pixels):
        number,pid=mapping[p];tilemap.append(number);attrs.append(pid)
        raw=graphics[number*16:number*16+16]
        for y in range(8):
            for x in range(8):
                color=((raw[y*2]>>(7-x))&1)|(((raw[y*2+1]>>(7-x))&1)<<1)
                converted.putpixel((n%20*8+x,n//20*8+y),sms_rgb(palettes[pid][color]))
    return bytes(graphics),bytes(tilemap),bytes(attrs),[gbc_color(c) for p in palettes for c in p],converted

def main():
    rom=(ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes();assert hashlib.sha256(rom).hexdigest()==SHA
    out=ROOT/'assets/enemies';out.mkdir(parents=True,exist_ok=True);records=[]
    banks=[[]];bank_sizes=[0];descriptors=[];declarations=[]
    sheet=Image.new('RGB',(8*160,10*144),(18,22,34));draw=ImageDraw.Draw(sheet)
    for enemy in range(1,75):
        im,record=initial_pose(rom,enemy,30 if enemy in (72,73) else 1);records.append(record)
        im.save(out/f'{enemy:02d}-source.png')
        pose=im.crop(tuple(record['source_bbox']));pose.save(out/f'{enemy:02d}-pose.png')
        gfx,tilemap,attrs,palettes,converted=convert_pose(pose);converted.save(out/f'{enemy:02d}-gbc.png')
        size=len(gfx)+len(tilemap)+len(attrs)+len(palettes)*2
        if bank_sizes[-1]+size>15800:banks.append([]);bank_sizes.append(0)
        bank=54+len(banks)-1;bank_sizes[-1]+=size
        name=f'enemy_{enemy:02d}'
        banks[-1].append(c_array(name+'_tiles',gfx)+c_array(name+'_map',tilemap)+c_array(name+'_attrs',attrs)+c_array(name+'_palettes',palettes,'uint16_t'))
        declarations.append(f'extern const uint8_t {name}_tiles[],{name}_map[],{name}_attrs[];\nextern const uint16_t {name}_palettes[];\n')
        descriptors.append(f'{{{bank},{len(gfx)//16},{name}_tiles,{name}_map,{name}_attrs,{name}_palettes}}')
        record.update(gbc_bank=bank,gbc_tiles=len(gfx)//16,gbc_bytes=size)
        (out/f'{enemy:02d}.2bpp').write_bytes(gfx);(out/f'{enemy:02d}.map').write_bytes(tilemap);(out/f'{enemy:02d}.attr').write_bytes(attrs)
        (out/f'{enemy:02d}.pal').write_bytes(struct.pack('<28H',*palettes))
        col=(enemy-1)%8;row=(enemy-1)//8
        sheet.paste(pose,(col*160+(160-pose.width)//2,row*144+20+(120-pose.height)//2),pose)
        draw.text((col*160+4,row*144+3),f'{enemy:02d} {record["name"]}',fill='white')
    sheet.save(out/'initial-poses.png')
    for i,parts in enumerate(banks,54):
        (ROOT/f'src/enemy_art_bank_{i:02d}.c').write_text(f'/* Generated original initial enemy poses. */\n#pragma bank {i}\n#include <stdint.h>\n'+''.join(parts))
    (ROOT/'src/enemy_art_data.c').write_text('/* Generated ROM0 descriptors; pointers require banking. */\n#include "enemy_art.h"\n'+''.join(declarations)+'const EnemyArt enemy_art[74]={\n'+',\n'.join(descriptors)+'\n};\n')
    report={'source_sha256':SHA,'scope':'Initial poses converted to GBC; source scene30 supplies Lassic/DarkFalz background patterns. Static poses only, not animated or reference-emulator validated','enemies':records,'gbc_banks':list(range(54,54+len(banks))),'bank_bytes':bank_sizes,'max_width':max(x['width'] for x in records),'max_height':max(x['height'] for x in records)}
    (out/'manifest.json').write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps({k:v for k,v in report.items() if k!='enemies'},indent=2))
if __name__=='__main__':main()
