#!/usr/bin/env python3
"""Original space-flight graphics, 12-row layouts, planet palettes and ships."""
from collections import Counter
import hashlib,json,struct
from PIL import Image
from extract_scenes import ROOT,SHA,Source,SYMBOLS,label,rle
from extract_assets import choose_palettes,convert_tile,gbc_color,sms_rgb,c_array
from extract_vehicle_graphics import convert_frames

def extract(rom):
    source=Source(rom);tiles=source.graphics(*SYMBOLS['LABEL_B23_B778']);assert len(tiles)==98
    words=[]
    for name in ('LABEL_B28_BE00','LABEL_B28_BE88','LABEL_B28_BD00'):
        low,pos=rle(rom,label(name));high,pos=rle(rom,pos);assert len(low)==len(high)==384
        words.append([a|(b<<8)for a,b in zip(low,high)])
    records=[]
    for planet in range(3):
        palette=list(rom[label('LABEL_B23_B767'):label('LABEL_B23_B767')+16])
        palette[2:8]=rom[label('LABEL_A4A')+planet*6:label('LABEL_A4A')+(planet+1)*6]
        pixels=[tuple(palette[p]for p in tile)for tile in tiles]
        palettes=choose_palettes([Counter(tile)for tile in pixels],[1]*98,7)
        converted=[convert_tile(tile,palettes)for tile in pixels]
        gfx=b''.join(tile for tile,pal in converted);maps=bytearray()
        for layout in words:
            maps.extend(word&511 for word in layout)
            maps.extend(converted[word&511][1]|(32 if word&512 else 0)|(64 if word&1024 else 0)for word in layout)
        colors=struct.pack('<28H',*[gbc_color(c)for p in palettes for c in p])
        records.append((gfx,colors,bytes(maps),palette,palettes))
    ships=convert_frames(rom,14)[12:]
    return tiles,words,records,ships

def main():
    rom=(ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes();assert hashlib.sha256(rom).hexdigest()==SHA
    out=ROOT/'assets/travel-art';out.mkdir(parents=True,exist_ok=True)
    tiles,words,records,ships=extract(rom);arrays=[];descriptors=[];manifest=[]
    for planet,(gfx,colors,maps,palette,palettes)in enumerate(records):
        name=f'travel_planet_{planet}';data=gfx+colors+maps
        arrays.append(c_array(name,data));descriptors.append(name);(out/f'planet{planet}.bin').write_bytes(data)
        im=Image.new('RGB',(256,192))
        for y in range(192):
            for x in range(256):
                layout=words[0 if y<96 else 1];word=layout[(y%96)//8*32+x//8]
                px=7-x%8 if word&512 else x%8;py=7-y%8 if word&1024 else y%8
                im.putpixel((x,y),sms_rgb(palette[tiles[word&511][py*8+px]]))
        im.save(out/f'planet{planet}-source.png')
        manifest.append({'planet':planet,'bytes':len(data),'sha256':hashlib.sha256(data).hexdigest(),'native_palettes':palettes})
    for n,(data,source,native,error)in enumerate(ships):
        arrays.append(c_array(f'travel_ship_{n}',data));(out/f'ship{n}.bin').write_bytes(data)
        source.save(out/f'ship{n}-source.png');native.save(out/f'ship{n}-gbc.png')
    total=sum(len(g)+len(c)+len(m)for g,c,m,*_ in records)+sum(len(s[0])for s in ships)
    assert total<16000,total
    (ROOT/'src/travel_art.c').write_text('/* Generated original travel graphics. */\n#pragma bank 120\n#include "travel_art.h"\n'+''.join(arrays))
    (ROOT/'src/travel_art.h').write_text('''#ifndef PS_TRAVEL_ART_H
#define PS_TRAVEL_ART_H
#include <stdint.h>
#define TRAVEL_ART_BANK 120u
#define TRAVEL_GRAPHICS_BYTES 1568u
#define TRAVEL_MAP_OFFSET 1624u
extern const uint8_t travel_planet_0[],travel_planet_1[],travel_planet_2[];
extern const uint8_t travel_ship_0[],travel_ship_1[];
#endif
''')
    report={'source_sha256':SHA,'native_bank':120,'data_bytes':total,'planets':manifest,'ships':2,
      'limits':['Space artwork is cropped to native160x144 viewport at original pixel size','Three planet adaptations use seven four-color BG palettes','Source animation row/ring sequencing belongs to travel controller']}
    (out/'manifest.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps({k:v for k,v in report.items()if k!='planets'},indent=2))
if __name__=='__main__':main()
