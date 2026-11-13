#!/usr/bin/env python3
"""Original enemy overlays at original scene coordinates, GBC 8x16 OBJ format.

No image generation: all pixels/layouts/palettes come from the pinned source ROM.
Each sprite pair shares a global pattern pool; floor-dependent palette0 is retained.
"""
from collections import Counter
from itertools import combinations
import hashlib,json,struct
from PIL import Image,ImageDraw
from extract_scene_actors import source_overlay
from extract_scenes import ROOT,SHA,Source,label
from extract_assets import sms_rgb,color_distance,encode_gb,gbc_color,c_array

def enemy_palette(source,enemy,palette_index):
 rom=source.rom;row=rom[label('B03_EnemyData')+enemy*32:label('B03_EnemyData')+(enemy+1)*32]
 palette=list(rom[label('LABEL_3D1D'):label('LABEL_3D1D')+8])+list(row[8:16])
 palette[0]=rom[label('LABEL_B03_B5B9')+palette_index*8+5]
 return palette

def convert(image,palette,palette_count=6):
 # Source indices, not RGB, are essential: equal black values may belong to
 # unchanged floor/index0, unchanged sprite1/2, or flashed sprite3..15.
 image=image.resize((160,120),Image.Resampling.NEAREST);cells=[]
 for y in range(0,120,16):
  for x in range(0,160,8):
   raw=tuple((r//85)|((g//85)<<2)|((b//85)<<4) if a else None for r,g,b,a in image.crop((x,y,x+8,y+16)).get_flattened_data())
   if any(c is not None for c in raw):cells.append((x,y,raw))
 assert 0<len(cells)<=40
 assert max(sum(y<=line<y+16 for x,y,p in cells) for line in range(120))<=10
 def flash_class(c):return 0 if not c else 1 if c<3 else 2
 # Merge only indices that behave identically in all battle flash phases.
 equivalent={};aliases={}
 for c in range(16):aliases[c]=equivalent.setdefault((palette[c],flash_class(c)),c)
 histograms=[Counter(aliases[c] for c in p if c is not None) for x,y,p in cells]
 used=sorted(set(c for h in histograms for c in h));size=min(3,len(used))
 candidates=[p+(p[0],)*(3-len(p)) for p in combinations(used,size)]
 distance=[[color_distance(palette[a],palette[b])+(10**12 if flash_class(a)!=flash_class(b) else 0) for b in range(16)]for a in range(16)]
 error=[[min(distance[c][p] for p in pal) for c in range(16)]for pal in candidates]
 scores=[[sum(n*err[c] for c,n in h.items())for h in histograms]for err in error]
 best=[10**20]*len(cells);selected=[]
 for _ in range(min(palette_count,len(candidates))):
  ix=min((i for i in range(len(candidates))if i not in selected),key=lambda i:sum(min(a,b)for a,b in zip(best,scores[i])))
  selected.append(ix);best=[min(a,b)for a,b in zip(best,scores[ix])]
 refs=[candidates[i]for i in selected];refs += [refs[0]]*(8-len(refs))
 converted=[];native=Image.new('RGBA',(160,120));errors=0
 for (x,y,pixels),hist in zip(cells,histograms):
  pal=min(range(8),key=lambda i:sum(n*min(distance[c][p]for p in refs[i])for c,n in hist.items()))
  codes=[0 if c is None else 1+min(range(3),key=lambda i:distance[c][refs[pal][i]])for c in pixels]
  converted.append((x+8,y+16,encode_gb(codes[:64])+encode_gb(codes[64:]),pal|8))
  for n,(code,c) in enumerate(zip(codes,pixels)):
   if code and y+n//8<120:
    selected_index=refs[pal][code-1]
    assert flash_class(selected_index)==flash_class(c),(x,y,c,selected_index)
    output=palette[selected_index];native.putpixel((x+n%8,y+n//8),(*sms_rgb(output),255));errors+=output!=palette[c]
 colors=struct.pack('<32H',*[gbc_color(c)for p in refs for c in (0,*[palette[r]for r in p])])
 masks=bytes(sum(1<<(i+1)for i,c in enumerate(p)if c>=3)for p in refs)+bytes(sum(1<<(i+1)for i,c in enumerate(p)if not c)for p in refs)
 return converted,colors+masks,native,errors

def main():
 rom=(ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes();assert hashlib.sha256(rom).hexdigest()==SHA
 source=Source(rom);out=ROOT/'assets/battle-scenes';out.mkdir(parents=True,exist_ok=True)
 patterns=[];pattern_ids={};assets=[];asset_ids={};requests=[];lookup=[]
 sheet=Image.new('RGBA',(8*160,10*136),(32,36,44,255));draw=ImageDraw.Draw(sheet)
 for enemy in range(1,75):
  if enemy in (72,73):lookup.extend([65535]*12);continue
  row=rom[label('B03_EnemyData')+enemy*32:label('B03_EnemyData')+(enemy+1)*32]
  desc=rom[label('LABEL_B03_8FC7')+(row[19]-1)*24:label('LABEL_B03_8FC7')+row[19]*24]
  background=bool(desc[17] and desc[18]);first=None
  for palette in range(12):
   if palette and not background:lookup.append(first);continue
   image=source_overlay(source,enemy=enemy,palette_index=palette)
   indexed=source_overlay(source,enemy=enemy,palette_index=palette,indexed=True)
   converted,colors,native,errors=convert(indexed,enemy_palette(source,enemy,palette));meta=bytearray()
   for x,y,pattern,prop in converted:
    if pattern not in pattern_ids:pattern_ids[pattern]=len(patterns);patterns.append(pattern)
    meta.extend(struct.pack('<BBHB',x,y,pattern_ids[pattern],prop))
   data=bytes(meta)+colors;key=(len(converted),data)
   if key not in asset_ids:asset_ids[key]=len(assets);assets.append(key)
   index=asset_ids[key];lookup.append(index)
   if first is None:first=index
   name=f'{enemy:02}-{palette:02}'
   (out/(name+'.bin')).write_bytes(data)
   if palette==0:
    image.save(out/(name+'-source.png'));native.save(out/(name+'-gbc.png'))
    sheet.paste(native,(((enemy-1)%8)*160,((enemy-1)//8)*136+16),native)
    draw.text((((enemy-1)%8)*160+2,((enemy-1)//8)*136),str(enemy),fill='white')
   requests.append({'enemy':enemy,'palette':palette,'asset':index,'sprites':len(converted),'quantized_pixels':errors,'name':name,'source_sha256':hashlib.sha256(image.tobytes()).hexdigest(),'native_sha256':hashlib.sha256(native.tobytes()).hexdigest()})
 bins=[];declarations=[]
 def place(name,data):
  slot=next((i for i,b in enumerate(bins) if b['size']+len(data)<=15800),None)
  if slot is None:slot=len(bins);bins.append({'size':0,'parts':[]})
  bins[slot]['size']+=len(data);bins[slot]['parts'].append(c_array(name,data));declarations.append(f'extern const uint8_t {name}[];\n');return 140+slot
 pools=[]
 for start in range(0,len(patterns),256):
  name=f'battle_pairs_{start//256:02}';bank=place(name,b''.join(patterns[start:start+256]));pools.append(f'{{{bank},{name}}}')
 descriptors=[]
 for i,(count,data) in enumerate(assets):
  name=f'battle_overlay_{i:03}';bank=place(name,data);descriptors.append(f'{{{bank},{count},{name}}}')
 assert len(bins)<=8,('Battle assets exceed reserved140..147',len(bins))
 for old in (ROOT/'src').glob('battle_scene_bank_*.c'):
  if int(old.stem.rsplit('_',1)[1])>=140+len(bins):old.unlink()
 for n,b in enumerate(bins,140):(ROOT/f'src/battle_scene_bank_{n:03}.c').write_text(f'/* Generated original enemy overlay data. */\n#pragma bank {n}\n#include <stdint.h>\n'+''.join(b['parts']))
 (ROOT/'src/battle_scene_data.h').write_text(f'''/* Generated by tools/extract_battle_scenes.py. */
#ifndef PS_BATTLE_SCENE_DATA_H
#define PS_BATTLE_SCENE_DATA_H
#include <stdint.h>
#define BATTLE_SCENE_ASSETS {len(assets)}u
typedef struct {{uint8_t bank,sprites;const uint8_t *data;}} BattleSceneAsset;
typedef struct {{uint8_t bank;const uint8_t *data;}} BattleScenePool;
extern const BattleSceneAsset battle_scene_assets[BATTLE_SCENE_ASSETS];
extern const BattleScenePool battle_scene_pools[{len(pools)}];
extern const uint16_t battle_scene_lookup[74][12];
#endif
''')
 (ROOT/'src/battle_scene_data.c').write_text('#pragma bank 31\n#include "battle_scene_data.h"\n'+''.join(declarations)+'const BattleSceneAsset battle_scene_assets[BATTLE_SCENE_ASSETS]={\n'+',\n'.join(descriptors)+'\n};\nconst BattleScenePool battle_scene_pools[]={'+','.join(pools)+'};\nconst uint16_t battle_scene_lookup[74][12]={\n'+',\n'.join('{'+','.join(map(str,lookup[i:i+12]))+'}' for i in range(0,len(lookup),12))+'\n};\n')
 (out/'patterns.2bpp').write_bytes(b''.join(patterns));sheet.save(out/'enemies.png')
 report={'source_sha256':SHA,'enemy_obj_palettes':6,'reserved_effect_palettes':[6,7],'native_banks':list(range(140,140+len(bins))),'bank_bytes':[b['size'] for b in bins],'pattern_pairs':len(patterns),'unique_assets':len(assets),'records':requests,'scope':'Source initial enemy poses1..71,74 at original256x192 coordinates scaled5/8;8x16OBJ;all12 original floor palette variants; Lassic/Dark Falz use source precomposed scenes.','limits':['This manifest contains initial poses; physical frame assets are in battle-animation','GBC8 palettes of3 opaque colors per8x16 sprite quantize source colors','Original transparent composition verified before quantization; not pixel-identical RGB to SMS hardware','Append8 enemy-hit masks then8 source-index0 masks after64 palette bytes; exact source flash classes retained']}
 (out/'manifest.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps({k:v for k,v in report.items() if k!='records'},indent=2))
if __name__=='__main__':main()
