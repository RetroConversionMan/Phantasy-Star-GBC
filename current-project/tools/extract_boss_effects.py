#!/usr/bin/env python3
"""Extract original boss primary actors and Dark Falz background rectangles."""
import hashlib,json,struct
from collections import Counter
from PIL import Image
from extract_scenes import ROOT,SHA,Source,label,cpu_offset
from extract_enemies import SYMBOLS
from extract_scene_actors import source_overlay
from extract_weapon_effects import descriptor
from extract_battle_scenes import convert,enemy_palette
from extract_assets import c_array,encode_gb,gbc_color,sms_rgb
from palette_identity import select_palettes
from measure_boss_motion import sequence

def main():
 original=(ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes();assert hashlib.sha256(original).hexdigest()==SHA
 rom=bytearray(original);source=Source(rom);out=ROOT/'assets/boss-effects';out.mkdir(parents=True,exist_ok=True)
 traces=json.loads((ROOT/'build/research/boss-motion/source-traces.json').read_text())['cases']
 patterns=[];pattern_ids={};assets=[];asset_ids={};records=[];motions=[]
 for enemy in(72,73):
  row=rom[label('B03_EnemyData')+enemy*32:][:32];off=label('LABEL_B03_8FC7')+(row[19]-1)*24;desc=bytes(rom[off:off+24]);kind=30 if enemy==72 else 32
  for pointer in([SYMBOLS[n][1]for n in('LABEL_B03_94F6','LABEL_B03_9506','LABEL_B03_9511','LABEL_B03_951C')]if enemy==72 else[int.from_bytes(desc[9:11],'little')]):
   motions.append({'enemy':enemy,'speed':desc[8],'sequence':sequence(rom,pointer)})
  poses=sorted({(t['frame'],t['y'])for c in traces if c['enemy']==enemy for t in c['trace']if t['frame']})
  for frame,y in poses:
   rom[off+1]=frame;rom[off+2]=y
   if enemy==73:rom[off+13:off+15]=(0xbf80).to_bytes(2,'little')
   # Shared composer now preserves 576A's stable equal-Y actor order.
   full,_=source.compose(kind,enemy=enemy)
   rom[off+1]=0;base,_=source.compose(kind,enemy=enemy)
   saved=bytes(rom[off:off+24]);rom[off+1]=frame;rom[off+17:off+19]=b'\0\0';rom[off+19:off+23]=b'\0'*4
   indexed=source_overlay(source,enemy=enemy,indexed=True);rgba=source_overlay(source,enemy=enemy)
   rom[off:off+24]=saved
   # Only strictly higher-Y fixed actors can obscure the primary.
   if desc[19]and desc[20]and desc[21]>y:
    rom[off+17:off+19]=b'\0\0';secondary=source_overlay(source,enemy=enemy);rom[off:off+24]=saved
    for py in range(192):
     for px in range(256):
      if secondary.getpixel((px,py))[3]:indexed.putpixel((px,py),(0,0,0,0));rgba.putpixel((px,py),(0,0,0,0))
   composed=base.convert('RGBA');composed.alpha_composite(rgba);assert composed.convert('RGB').tobytes()==full.tobytes(),(enemy,frame,y,'source composition')
   converted,colors,native,error=convert(indexed,enemy_palette(source,enemy,0));meta=bytearray()
   for x,yy,pattern,prop in converted:
    if pattern not in pattern_ids:pattern_ids[pattern]=len(patterns);patterns.append(pattern)
    meta.extend(struct.pack('<BBHB',x,yy,pattern_ids[pattern],prop))
   data=bytes(meta)+colors;key=(len(converted),data)
   if key not in asset_ids:asset_ids[key]=len(assets);assets.append(key)
   name=f'{enemy}-{frame:03}-{y:03}';(out/(name+'.bin')).write_bytes(data);native.save(out/(name+'.png'));indexed.save(out/(name+'-source-indices.png'))
   scan=max(sum(yy-16<=line<yy for x,yy,p,prop in converted)for line in range(120));assert len(converted)<=40 and scan<=10
   records.append({'enemy':enemy,'frame':frame,'y':y,'asset':asset_ids[key],'name':name,'sprites':len(converted),'scanline':scan,'quantized_pixels':error,'source_composition_exact':True})
  rom[off:off+24]=desc
 # Encode rectangle variants using the existing initial scene's exact palette
 # selection. That preserves all source flash masks and never reallocates BG.
 enemy=73;row=rom[label('B03_EnemyData')+enemy*32:][:32];off=label('LABEL_B03_8FC7')+(row[19]-1)*24;desc=bytes(rom[off:off+24]);images=[]
 for pointer in(0xbf20,0xbf50,0xbf80):
  rom[off+13:off+15]=pointer.to_bytes(2,'little');indices,colors,_=source.compose(32,enemy=73,return_indices=True);images.append(Image.frombytes('L',(256,192),indices).resize((160,120),Image.Resampling.NEAREST))
 rom[off:off+24]=desc
 tiles=[[tuple(im.crop((x,y,x+8,y+8)).get_flattened_data())for y in range(0,120,8)for x in range(0,160,8)]for im in images]
 counts=Counter(tiles[0]);unique=list(counts);classes=[1 if 3<=c<=15 else 2 if c==16 else 3 if c>=19 else 0 for c in range(32)]
 refs,distance=select_palettes([Counter(p)for p in unique],[counts[p]for p in unique],colors,classes,7,4)
 palette=struct.pack('<28H',*[gbc_color(colors[c])for p in refs for c in p]);assert palette==(ROOT/'assets/scenes/32-00-73.pal').read_bytes()
 cells=[i for i in range(300)if any(row[i]!=tiles[0][i]for row in tiles[1:])];assert cells and max(cells)<256
 patchdata=[];patcherrors=[]
 for patch,row in enumerate(tiles):
  data=bytearray();errors=0
  for cell in cells:
   raw=row[cell];hist=Counter(raw);pal=min(range(7),key=lambda i:sum(n*min(distance[c][p]for p in refs[i])for c,n in hist.items()));codes=[min(range(4),key=lambda i:distance[c][refs[pal][i]])for c in raw]
   assert all(classes[c]==classes[refs[pal][code]]for c,code in zip(raw,codes))
   errors+=sum(colors[c]!=colors[refs[pal][code]]for c,code in zip(raw,codes));data+=encode_gb(codes)+bytes([pal])
  patchdata.append(bytes(data));patcherrors.append(errors);(out/f'patch-{patch}.bin').write_bytes(data)
 bins=[];decl=[]
 def place(name,data):
  slot=next((i for i,b in enumerate(bins)if b['size']+len(data)<=15800),None)
  if slot is None:slot=len(bins);bins.append({'size':0,'parts':[]})
  assert slot==0,('Boss data exceeds255',slot)
  bins[slot]['size']+=len(data);bins[slot]['parts'].append(c_array(name,data));decl.append(f'extern const uint8_t {name}[];\n');return 255
 pools=[]
 for first in range(0,len(patterns),256):
  name=f'boss_pairs_{first//256}';bank=place(name,b''.join(patterns[first:first+256]));pools.append(f'{{{bank},{name}}}')
 descriptors=[]
 for i,(count,data)in enumerate(assets):
  name=f'boss_asset_{i}';bank=place(name,data);descriptors.append(f'{{{bank},{count},{name}}}')
 animations=[]
 for i,m in enumerate(motions):
  name=f'boss_sequence_{i}';bank=place(name,bytes(m['sequence']));animations.append(f'{{{m["speed"]},{len(m["sequence"])},0,0,{bank},{name}}}')
 for i,data in enumerate(patchdata):place(f'boss_patch_{i}',data)
 (ROOT/'src/boss_effects_bank_255.c').write_text('#pragma bank 255\n#include <stdint.h>\n'+''.join(bins[0]['parts']))
 (ROOT/'src/boss_effects_data.h').write_text(f'''#ifndef PS_BOSS_EFFECTS_DATA_H
#define PS_BOSS_EFFECTS_DATA_H
#include "battle_animation_data.h"
#define BOSS_DATA_BANK 254u
#define BOSS_POSES {len(records)}u
#define BOSS_PATCH_CELLS {len(cells)}u
extern const uint8_t boss_pose_keys[BOSS_POSES][3],boss_patch_cells[BOSS_PATCH_CELLS];
extern const uint16_t boss_pose_lookup[BOSS_POSES];
extern const BattleAnimation boss_animations[5];
extern const BattleSceneAsset boss_assets[{len(assets)}];
extern const BattleScenePool boss_pools[{len(pools)}];
extern const uint8_t *const boss_patches[3];
#endif
''')
 (ROOT/'src/boss_effects_bank_254.c').write_text('#pragma bank 254\n#include "boss_effects_data.h"\n'+''.join(decl)+'const uint8_t boss_pose_keys[BOSS_POSES][3]={'+','.join('{'+','.join(map(str,[r['enemy'],r['frame'],r['y']]))+'}'for r in records)+'};\nconst uint16_t boss_pose_lookup[BOSS_POSES]={'+','.join(str(r['asset'])for r in records)+'};\nconst BattleAnimation boss_animations[5]={'+','.join(animations)+'};\nconst BattleSceneAsset boss_assets[]={'+','.join(descriptors)+'};\nconst BattleScenePool boss_pools[]={'+','.join(pools)+'};\nconst uint8_t boss_patch_cells[BOSS_PATCH_CELLS]={'+','.join(map(str,cells))+'};\nconst uint8_t *const boss_patches[3]={boss_patch_0,boss_patch_1,boss_patch_2};\n')
 (out/'patterns.2bpp').write_bytes(b''.join(patterns));report={'source_sha256':SHA,'banks':[254,255],'data_bytes':bins[0]['size'],'pattern_pairs':len(patterns),'assets':len(assets),'poses':records,'motions':motions,'patch_cells':cells,'patch_quantized_pixels':patcherrors,'patch_bank':24,'patch_pointers':[0xbf20,0xbf50,0xbf80],'palette_equals_original_scene':True,'limits':['Original256x192 source composition before5/8resize; GBC palettes adapt measured RGB','No battle choreography/native renderer claim from extraction alone']};(out/'manifest.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps({k:v for k,v in report.items()if k not in('poses','motions')},indent=2))
if __name__=='__main__':main()
