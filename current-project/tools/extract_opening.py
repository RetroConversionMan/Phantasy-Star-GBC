#!/usr/bin/env python3
"""Original opening pan tiles, city caption and final story bitmap."""
from collections import Counter
import hashlib,json,struct
from PIL import Image
from extract_scenes import ROOT,SHA,Source,SYMBOLS,label,rle,convert
from extract_assets import choose_palettes,convert_tile,gbc_color,sms_rgb,c_array

def picture(tiles,words,palette):
 im=Image.new('RGB',(256,192))
 for n,word in enumerate(words):
  tile=tiles[word&511];base=16 if word&2048 else 0
  for y in range(8):
   for x in range(8):
    value=tile[(7-y if word&1024 else y)*8+(7-x if word&512 else x)]
    im.putpixel((n%32*8+x,n//32*8+y),sms_rgb(palette[base+value]))
 return im

def extract(rom):
 source=Source(rom);tiles=source.graphics(*SYMBOLS['LABEL_B23_B778']);assert len(tiles)==98
 palette=list(rom[label('LABEL_B23_B767'):label('LABEL_B23_B767')+16]);pixels=[tuple(palette[p]for p in tile)for tile in tiles]
 palettes=choose_palettes([Counter(t)for t in pixels],[1]*98,7);converted=[convert_tile(t,palettes)for t in pixels]
 pan=b''.join(t for t,p in converted)+struct.pack('<28H',*[gbc_color(c)for p in palettes for c in p]);layouts=[]
 for name in ('LABEL_B28_BE00','LABEL_B28_BE88'):
  low,p=rle(rom,label(name));high,p=rle(rom,p);assert len(low)==len(high)==384
  words=[a|(b<<8)for a,b in zip(low,high)];layouts.append(words)
  pan+=bytes(w&511 for w in words)+bytes(converted[w&511][1]|(32 if w&512 else 0)|(64 if w&1024 else 0)for w in words)
 # Source city background8 plus original font patterns and the five-row caption.
 city_plain=source.compose(8)[0]
 city,words,colors=source.background(8);city=list(city)+[(0,)*64]*(512-len(city));words=list(words)
 city[192:236]=source.graphics(*SYMBOLS['LABEL_B16_BAD8']);city[496:508]=source.graphics(*SYMBOLS['LABEL_B16_BD58'])
 p=label('LABEL_B18_BEF4')
 for y in range(5):words[(y+2)*32+3:(y+2)*32+23]=struct.unpack_from('<20H',rom,p+y*40)
 city=picture(city,words,colors)
 # Source454E writes19 rows of22bytes at D0D4, i.e. sourcecell106.
 tiles=source.graphics(*SYMBOLS['LABEL_B31_9687']);words=[0]*768;p=label('LABEL_B24_A5E0')
 for y in range(19):words[106+y*32:117+y*32]=struct.unpack_from('<11H',rom,p+y*22)
 colors=list(rom[label('LABEL_B31_9676'):label('LABEL_B31_9676')+17])+[0]*15
 ending=picture(tiles,words,colors)
 tiles=source.graphics(*SYMBOLS['LABEL_B31_A8BD']);low,p=rle(rom,label('LABEL_B14_BC68'));high,p=rle(rom,p)
 assert len(low)==len(high)==768
 title=picture(tiles,[a|(b<<8)for a,b in zip(low,high)],list(rom[label('LABEL_7BA'):label('LABEL_7BA')+32]))
 return pan,layouts,[city_plain,ending,title,city]

def convert_group(images):
 scaled=[im.resize((160,120),Image.Resampling.NEAREST)for im in images];all_tiles=[]
 for im in scaled:
  raw=[(r//85)|((g//85)<<2)|((b//85)<<4)for r,g,b in im.get_flattened_data()]
  all_tiles.append([tuple(raw[(y+dy)*160+x+dx]for dy in range(8)for dx in range(8))for y in range(0,120,8)for x in range(0,160,8)])
 counts=Counter(t for group in all_tiles for t in group);unique=list(counts)
 pals=choose_palettes([Counter(t)for t in unique],[counts[t]for t in unique],7)
 converted={t:convert_tile(t,pals)for t in unique};gfx=bytearray();dedupe={};maps=[];previews=[];errors=[]
 for tiles in all_tiles:
  mapping=bytearray();attrs=bytearray();native=Image.new('RGB',(160,120));error=0
  for n,t in enumerate(tiles):
   tile,pal=converted[t]
   if tile not in dedupe:dedupe[tile]=len(dedupe);gfx.extend(tile)
   ix=dedupe[tile];mapping.append(ix if ix<256 else ix-256+64);attrs.append(pal|(8 if ix>=256 else 0))
   for y in range(8):
    for x in range(8):
     code=((tile[y*2]>>(7-x))&1)|(((tile[y*2+1]>>(7-x))&1)<<1);color=pals[pal][code];native.putpixel((n%20*8+x,n//20*8+y),sms_rgb(color));error+=color!=t[y*8+x]
  maps.append(bytes(mapping+attrs));previews.append(native);errors.append(error)
 assert len(dedupe)<=448
 return bytes(gfx),maps,struct.pack('<28H',*[gbc_color(c)for p in pals for c in p]),previews,errors

def main():
 rom=(ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes();assert hashlib.sha256(rom).hexdigest()==SHA
 out=ROOT/'assets/opening';out.mkdir(parents=True,exist_ok=True);pan,layouts,images=extract(rom)
 (out/'pan.bin').write_bytes(pan);(ROOT/'src/opening_bank_129.c').write_text('#pragma bank 129\n#include <stdint.h>\n'+c_array('opening_pan',pan))
 arrays=[];descs=[];records=[];size=0
 for n,name in enumerate(('city','ending','title'),1):
  group=[images[0],images[3]]if n==1 else[images[n-1]]
  gfx,maps,palette,natives,errors=convert_group(group)
  data=gfx+maps[0]+palette+(maps[1]if n==1 else b'');symbol='movie_'+name;arrays.append(c_array(symbol,data));descs.append(f'{{130,{len(gfx)//16},{symbol}}}');size+=len(data)
  (out/f'{name}.bin').write_bytes(data);group[0].save(out/f'{name}-source.png');natives[0].save(out/f'{name}-gbc.png')
  if n==1:group[1].save(out/'city-caption-source.png');natives[1].save(out/'city-caption-gbc.png')
  records.append({'id':n,'name':name,'bank':130,'tiles':len(gfx)//16,'bytes':len(data),'source_sha256':hashlib.sha256(group[0].tobytes()).hexdigest(),'data_sha256':hashlib.sha256(data).hexdigest(),'color_quantized_pixels':errors[0],'caption_map_offset':len(gfx)+656 if n==1 else 0})
 assert size<15800,size
 (ROOT/'src/opening_bank_130.c').write_text('#pragma bank 130\n#include <stdint.h>\n'+''.join(arrays))
 (ROOT/'src/opening_data.h').write_text('''#ifndef PS_OPENING_DATA_H
#define PS_OPENING_DATA_H
#include <stdint.h>
extern const uint8_t opening_pan[];
typedef struct {uint8_t bank;uint16_t tiles;const uint8_t *data;} MovieImage;
extern const MovieImage movie_images[3];
#endif
''')
 (ROOT/'src/opening_data.c').write_text('#pragma bank 132\n#include "opening_data.h"\nextern const uint8_t movie_city[],movie_ending[],movie_title[];\nconst MovieImage movie_images[3]={'+','.join(descs)+'};\n')
 report={'source_sha256':SHA,'pan_bytes':len(pan),'native_banks':[129,130],'pan_viewport':'Native pixel-size160x144 centered crop of original256x192; source224-pixel vertical scroll ring preserved','static_images':records,'bank130_bytes':size}
 (out/'manifest.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
if __name__=='__main__':main()
