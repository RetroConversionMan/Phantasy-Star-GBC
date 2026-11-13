#!/usr/bin/env python3
"""Source NPC/enemy initial poses as native OBJ overlays for dungeon geometry."""
from collections import Counter
from pathlib import Path
import hashlib,json,struct
from PIL import Image,ImageDraw
from extract_scenes import ROOT,SHA,Source,cpu_offset,label
from extract_assets import sms_rgb,choose_palettes,color_distance,encode_gb,gbc_color,c_array

ENEMIES=(8,22,27,43,46,49,62,71)
BACKGROUND_ENEMIES=(22,49,62,71)
def source_overlay(source,portrait=0,enemy=0,palette_index=0,indexed=False):
 rom=source.rom;canvas=[None]*(256*192)
 if portrait:
  tiles,high,fields,meta=source.portrait(portrait)
  palette=list(rom[label('LABEL_3D1D'):label('LABEL_3D1D')+8])+high;sprites=[(3,*fields)]
 else:
  row=rom[label('B03_EnemyData')+enemy*32:label('B03_EnemyData')+(enemy+1)*32]
  desc=rom[label('LABEL_B03_8FC7')+(row[19]-1)*24:label('LABEL_B03_8FC7')+row[19]*24]
  tiles=source.graphics(row[16],struct.unpack_from('<H',row,17)[0])
  palette=list(rom[label('LABEL_3D1D'):label('LABEL_3D1D')+8])+list(row[8:16])
  # LABEL_6D7F loads original C250 from the floor's fifth color.
  palette[0]=rom[label('LABEL_B03_B5B9')+palette_index*8+5]
  sprites=[(21,*fields) for fields in (desc[:4],desc[19:23]) if fields[0] and fields[1]]
 if indexed:palette=list(range(16))
 def paint(tile,x,y,sprite,flipx=False,flipy=False):
  assert 0<=tile<len(tiles),(portrait,enemy,tile,len(tiles))
  raw=tiles[tile]
  for py in range(8):
   sy=(y+py)&255
   if sy>=192:continue
   for px in range(8):
    value=raw[(7-py if flipy else py)*8+(7-px if flipx else px)]
    if not value and sprite:continue
    canvas[sy*256+((x+px)&255)]=palette[value]
 if enemy:
  src,dst=struct.unpack_from('<HH',desc,13);height,width=desc[17:19]
  if height and width:
   assert 0xd000<=dst<0xd600
   for y in range(height):
    for x in range(width):
     word=struct.unpack_from('<H',rom,cpu_offset(24,src)+(y*width+x)*2)[0]
     if word:
      assert word&0x800 and word&511>=256
      paint((word&511)-256,(dst-0xd000)%64//2*8+x*8,(dst-0xd000)//64*8+y*8,False,bool(word&0x200),bool(word&0x400))
 # Stable descending-Y source OAM: actor4 wins a tie against actor5.
 for bank,mode,index,y,x in sorted(reversed(sprites),key=lambda s:s[3]):
  table='LABEL_B03_96F4' if bank==3 else 'LABEL_B21_8000'
  ptr=struct.unpack_from('<H',rom,label(table)+index*2)[0];start=cpu_offset(bank,ptr);count=rom[start]
  raw=rom[start+1:start+1+count*3];assert count<=64
  for n in reversed(range(count)):
   dx,tile=raw[count+n*2:count+n*2+2];paint(tile,x+dx,y+raw[n]+1,True)
 image=Image.new('RGBA',(256,192));image.putdata([(*sms_rgb(c),255) if c is not None else (0,0,0,0) for c in canvas])
 return image

def convert(image):
 image=image.resize((160,120),Image.Resampling.NEAREST);tiles=[];positions=[]
 for y in range(0,120,8):
  for x in range(0,160,8):
   raw=tuple((r//85)|((g//85)<<2)|((b//85)<<4) if a else None for r,g,b,a in image.crop((x,y,x+8,y+8)).get_flattened_data())
   if all(p is None for p in raw):continue
   positions.append((x,y));tiles.append(raw)
 assert 0<len(tiles)<=40, len(tiles)
 palettes=choose_palettes([Counter(c for c in t if c is not None) for t in tiles],[1]*len(tiles),8,3)
 gfx=[];ids={};metas=bytearray();native=Image.new('RGBA',(160,120));errors=0
 for (x,y),pixels in zip(positions,tiles):
  hist=Counter(p for p in pixels if p is not None)
  pal=min(range(8),key=lambda i:sum(n*min(color_distance(c,p) for p in palettes[i]) for c,n in hist.items()))
  codes=[0 if c is None else 1+min(range(3),key=lambda i:color_distance(c,palettes[pal][i])) for c in pixels]
  tile=encode_gb(codes)
  if tile not in ids:ids[tile]=len(gfx);gfx.append(tile)
  metas.extend((x+8,y+16,ids[tile],pal|8))
  for n,(code,c) in enumerate(zip(codes,pixels)):
   if code:
    output=palettes[pal][code-1];native.putpixel((x+n%8,y+n//8),(*sms_rgb(output),255));errors+=output!=c
 colors=[gbc_color(c) for p in palettes for c in (0,*p)]
 return b''.join(gfx),bytes(metas),struct.pack('<32H',*colors),native,errors

def main():
 rom=(ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes();assert hashlib.sha256(rom).hexdigest()==SHA
 source=Source(rom);out=ROOT/'assets/scene-actors';out.mkdir(parents=True,exist_ok=True)
 requests=[(0,p,255) for p in range(1,62)]
 requests += [(1,e,p) for e in ENEMIES for p in (range(12) if e in BACKGROUND_ENEMIES else (255,))]
 bins=[];records=[];declarations=[];descriptors=[]
 sheet=Image.new('RGBA',(8*160,((len(requests)+7)//8)*136),(32,36,44,255));draw=ImageDraw.Draw(sheet)
 for index,(kind,identity,pal) in enumerate(requests):
  name=f'{kind}-{identity:02}-{pal:03}'
  im=source_overlay(source,portrait=identity if not kind else 0,enemy=identity if kind else 0,palette_index=pal if pal<12 else 0)
  gfx,meta,colors,native,error=convert(im);data=gfx+meta+colors
  im.save(out/(name+'-source.png'));native.save(out/(name+'-gbc.png'));(out/(name+'.bin')).write_bytes(data)
  slot=next((i for i,b in enumerate(bins) if b['size']+len(data)<=15800),None)
  if slot is None:slot=len(bins);bins.append({'size':0,'parts':[]})
  bank=111+slot;symbol=f'scene_actor_{index:03}';bins[slot]['size']+=len(data);bins[slot]['parts'].append(c_array(symbol,data))
  declarations.append(f'extern const uint8_t {symbol}[];\n')
  descriptors.append(f'{{{kind},{identity},{pal},{bank},{len(gfx)//16},{len(meta)//4},{symbol}}}')
  records.append({'kind':kind,'id':identity,'palette_index':pal,'name':name,'bank':bank,'tiles':len(gfx)//16,'sprites':len(meta)//4,'source_bbox':list(im.getbbox()),'quantized_pixels':error,'data_sha256':hashlib.sha256(data).hexdigest()})
  sheet.paste(native,((index%8)*160,(index//8)*136+16),native);draw.text(((index%8)*160+2,(index//8)*136),name,fill='white')
 assert len(bins)<=4,('Actor data overlaps chest banks115+',len(bins))
 for old in (ROOT/'src').glob('scene_actor_bank_*.c'):
  if int(old.stem.rsplit('_',1)[1])>=111+len(bins):old.unlink()
 for n,bank in enumerate(bins,111):
  (ROOT/f'src/scene_actor_bank_{n:03}.c').write_text(f'/* Source initial portrait/enemy overlays. */\n#pragma bank {n}\n#include <stdint.h>\n'+''.join(bank['parts']))
 (ROOT/'src/scene_actor_data.h').write_text(f'''/* Generated by tools/extract_scene_actors.py. */
#ifndef PS_SCENE_ACTOR_DATA_H
#define PS_SCENE_ACTOR_DATA_H
#include <stdint.h>
#define SCENE_ACTOR_COUNT {len(records)}u
typedef struct {{ uint8_t kind,id,palette,bank,tiles,sprites;const uint8_t *data; }} SceneActorAsset;
extern const SceneActorAsset scene_actors[SCENE_ACTOR_COUNT];
#endif
''')
 (ROOT/'src/scene_actor_data.c').write_text('#pragma bank 13\n#include "scene_actor_data.h"\n'+''.join(declarations)+'const SceneActorAsset scene_actors[SCENE_ACTOR_COUNT]={\n'+',\n'.join(descriptors)+'\n};\n')
 sheet.save(out/'actors.png')
 report={'source_sha256':SHA,'native_banks':list(range(111,111+len(bins))),'bank_bytes':[b['size'] for b in bins],'records':records,'limits':['Static first poses, not source animation','Native OBJ maximum40 sprites; source image scaled5/8','Enemy overlays supported only for explicitly extracted IDs and source floor palette variants']}
 (out/'manifest.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps({k:v for k,v in report.items() if k!='records'},indent=2))
if __name__=='__main__':main()
