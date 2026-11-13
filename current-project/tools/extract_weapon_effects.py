#!/usr/bin/env python3
"""Original source actor11/12 weapon and offensive magic sprite effects."""
from collections import Counter
import hashlib,json,struct
from PIL import Image
from extract_scenes import ROOT,SHA,Source,label,cpu_offset
from extract_scene_actors import source_overlay
from extract_assets import sms_rgb,choose_palettes,color_distance,encode_gb,gbc_color,c_array

def descriptor(source,enemy):
 rom=source.rom;visual=rom[label('B03_EnemyData')+enemy*32+19]
 return rom[label('LABEL_B03_8FC7')+(visual-1)*24:][:24]
def source_effect(source,effect,frame,enemy):
 rom=source.rom;row=rom[label('LABEL_5BF1')+effect*6:][:6]
 graphics=source.graphics(18,int.from_bytes(row[4:6],'little'));d=descriptor(source,enemy);y,x=d[4:6]
 # The source actor list is sorted by descending Y. Equal Y keeps C800
 # (weapon) ahead. Enemy BG fragments never occlude a sprite effect.
 foreground=set();record=rom[label('B03_EnemyData')+enemy*32:][:32]
 enemy_tiles=source.graphics(record[16],int.from_bytes(record[17:19],'little'))
 for mode,index,ey,ex in (d[:4],d[19:23]):
  if not mode or not index or ey<=y:continue
  start=cpu_offset(21,int.from_bytes(rom[label('LABEL_B21_8000')+index*2:][:2],'little'));count=rom[start];raw=rom[start+1:start+1+count*3]
  for i in range(count):
   dx,tile=raw[count+i*2:count+i*2+2]
   for py in range(8):
    sy=(ey+raw[i]+py+1)&255
    if sy>=192:continue
    for px in range(8):
     if enemy_tiles[tile][py*8+px]:foreground.add(((ex+dx+px)&255,sy))
 start=cpu_offset(3,int.from_bytes(rom[label('LABEL_B03_96F4')+frame*2:][:2],'little'));count=rom[start];raw=rom[start+1:start+1+count*3]
 image=Image.new('RGBA',(256,192));palette=rom[label('LABEL_3D1D'):label('LABEL_3D1D')+8]
 for i in reversed(range(count)):
  dx,tile=raw[count+i*2:count+i*2+2];tile-=0xa0;assert 0<=tile<len(graphics)
  for py in range(8):
   sy=(y+raw[i]+py+1)&255
   if sy>=192:continue
   for px in range(8):
    value=graphics[tile][py*8+px];point=((x+dx+px)&255,sy)
    if value and point not in foreground:image.putpixel(point,(*sms_rgb(palette[value]),255))
 return image

def convert(image):
 image=image.resize((160,120),Image.Resampling.NEAREST);cells=[]
 for y in range(0,120,16):
  for x in range(0,160,8):
   raw=tuple((r//85)|((g//85)<<2)|((b//85)<<4)if a else None for r,g,b,a in image.crop((x,y,x+8,y+16)).get_flattened_data())
   if any(c is not None for c in raw):cells.append((x,y,raw))
 if not cells:return [],bytes(16),image,0
 palettes=choose_palettes([Counter(c for c in p if c is not None)for x,y,p in cells],[1]*len(cells),2,3)
 converted=[];native=Image.new('RGBA',(160,120));errors=0
 for x,y,pixels in cells:
  hist=Counter(c for c in pixels if c is not None)
  pal=min(range(2),key=lambda i:sum(n*min(color_distance(c,p)for p in palettes[i])for c,n in hist.items()))
  codes=[0 if c is None else 1+min(range(3),key=lambda i:color_distance(c,palettes[pal][i]))for c in pixels]
  converted.append((x+8,y+16,encode_gb(codes[:64])+encode_gb(codes[64:]),pal|14))
  for n,(code,c)in enumerate(zip(codes,pixels)):
   if code and y+n//8<120:
    output=palettes[pal][code-1];native.putpixel((x+n%8,y+n//8),(*sms_rgb(output),255));errors+=output!=c
 return converted,struct.pack('<8H',*[gbc_color(c)for p in palettes for c in (0,*p)]),native,errors

def main():
 rom=(ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes();assert hashlib.sha256(rom).hexdigest()==SHA
 source=Source(rom);out=ROOT/'assets/weapon-effects';out.mkdir(parents=True,exist_ok=True)
 effects=[];frames={}
 for effect in range(19):
  r=rom[label('LABEL_5BF1')+effect*6:][:6];effects.append(list(r[:4]))
  for frame in range(r[2]+1,r[3]):
   if frame in frames:assert frames[frame][1]==r[4:6]
   else:frames[frame]=(effect,r[4:6])
 frame_numbers=sorted(frames);frame_indices=[255]*256
 for i,f in enumerate(frame_numbers):frame_indices[f]=i
 patterns=[];pair_ids={};assets=[];asset_ids={};groups=[];group_ids={};enemy_groups=[];records=[];max_total=max_scan=0
 for enemy in range(1,75):
  base=source_overlay(source,enemy=enemy,indexed=True).resize((160,120),Image.Resampling.NEAREST)if enemy not in(72,73)else Image.new('RGBA',(160,120))
  base_cells=[(x,y)for y in range(0,120,16)for x in range(0,160,8)if base.crop((x,y,x+8,y+16)).getbbox()];lookup=[]
  for frame in frame_numbers:
   effect=frames[frame][0];im=source_effect(source,effect,frame,enemy);converted,colors,native,error=convert(im);meta=bytearray()
   for x,y,pattern,prop in converted:
    if pattern not in pair_ids:pair_ids[pattern]=len(patterns);patterns.append(pattern)
    meta.extend(struct.pack('<BBHB',x,y,pair_ids[pattern],prop))
   data=bytes(meta)+colors;key=(len(converted),data)
   if key not in asset_ids:asset_ids[key]=len(assets);assets.append(key)
   index=asset_ids[key];lookup.append(index)
   positions=base_cells+[(x-8,y-16)for x,y,p,prop in converted]
   total=len(positions);scan=max(sum(y<=line<y+16 for x,y in positions)for line in range(120))
   assert total<=40 and scan<=10,(enemy,effect,frame,total,scan);max_total=max(max_total,total);max_scan=max(max_scan,scan)
   name=f'{enemy:02}-{frame:03}';(out/(name+'.bin')).write_bytes(data)
   if enemy in(1,19,49,58,60,72,73):native.save(out/(name+'.png'))
   records.append({'enemy':enemy,'effect':effect,'frame':frame,'asset':index,'name':name,'sprites':len(converted),'combined_sprites':total,'combined_scanline_max':scan,'quantized_pixels':error,'source_sha256':hashlib.sha256(im.tobytes()).hexdigest(),'native_sha256':hashlib.sha256(native.tobytes()).hexdigest()})
  group=tuple(lookup)
  if group not in group_ids:group_ids[group]=len(groups);groups.append(group)
  enemy_groups.append(group_ids[group]);print('enemy',enemy,'assets',len(assets),'groups',len(groups),flush=True)
 print('Raw sizes',len(patterns)*32,sum(len(data)for count,data in assets),len(patterns),len(assets),flush=True)
 banks=[147]+list(range(183,192))+list(range(213,216));bins=[];declarations=[]
 def place(name,data):
  slot=next((i for i,b in enumerate(bins)if b['size']+len(data)<=15800),None)
  if slot is None:slot=len(bins);bins.append({'size':0,'parts':[]})
  assert slot<len(banks),('Weapon asset banks exhausted',slot)
  bins[slot]['size']+=len(data);bins[slot]['parts'].append(c_array(name,data));declarations.append(f'extern const uint8_t {name}[];\n');return banks[slot]
 pools=[]
 for start in range(0,len(patterns),128):
  name=f'weapon_pairs_{start//128:02}';bank=place(name,b''.join(patterns[start:start+128]));pools.append(f'{{{bank},{name}}}')
 descriptors=[]
 for index,(count,data)in enumerate(assets):
  name=f'weapon_asset_{index:04}';bank=place(name,data);descriptors.append(f'{{{bank},{count},{name}}}')
 metadata=len(assets)*4+len(groups)*len(frame_numbers)*2+74+256+76+len(pools)*3
 assert metadata<=15800,('Weapon descriptor bank182 full',metadata)
 for bank,b in zip(banks,bins):(ROOT/f'src/weapon_bank_{bank:03}.c').write_text(f'#pragma bank {bank}\n#include <stdint.h>\n'+''.join(b['parts']))
 for old in (ROOT/'src').glob('weapon_bank_*.c'):
  if int(old.stem.rsplit('_',1)[1])not in [182]+banks[:len(bins)]:old.unlink()
 (ROOT/'src/weapon_data.h').write_text(f'''#ifndef PS_WEAPON_DATA_H
#define PS_WEAPON_DATA_H
#include "battle_scene_data.h"
#define WEAPON_DATA_BANK 182u
#define WEAPON_FRAMES {len(frame_numbers)}u
#define WEAPON_ASSETS {len(assets)}u
#define WEAPON_POOL_SHIFT 7u
extern const uint8_t weapon_effects[19][4],weapon_frame_indices[256],weapon_enemy_groups[74];
extern const uint16_t weapon_lookup[{len(groups)}][WEAPON_FRAMES];
extern const BattleSceneAsset weapon_assets[WEAPON_ASSETS];
extern const BattleScenePool weapon_pools[{len(pools)}];
#endif
''')
 (ROOT/'src/weapon_bank_182.c').write_text('#ifdef __SDCC\n#pragma bank 182\n#endif\n#include "weapon_data.h"\n'+''.join(declarations)+'const uint8_t weapon_effects[19][4]={'+','.join('{'+','.join(map(str,r))+'}'for r in effects)+'};\nconst uint8_t weapon_frame_indices[256]={'+','.join(map(str,frame_indices))+'};\nconst uint8_t weapon_enemy_groups[74]={'+','.join(map(str,enemy_groups))+'};\nconst uint16_t weapon_lookup[][WEAPON_FRAMES]={'+','.join('{'+','.join(map(str,g))+'}'for g in groups)+'};\nconst BattleSceneAsset weapon_assets[WEAPON_ASSETS]={\n'+',\n'.join(descriptors)+'\n};\nconst BattleScenePool weapon_pools[]={'+','.join(pools)+'};\n')
 (out/'patterns.2bpp').write_bytes(b''.join(patterns))
 report={'source_sha256':SHA,'effects':effects,'frames':frame_numbers,'unique_assets':len(assets),'unique_groups':len(groups),'pattern_pairs':len(patterns),'native_banks':[182]+banks[:len(bins)],'bank_bytes':[metadata]+[b['size']for b in bins],'combined_sprites_max':max_total,'combined_scanline_max':max_scan,'records':records,'scope':'Original actor11/12 weapon and offensive spell effects, original enemy anchors and source higher-priority enemy sprite occlusion. Two GBC palettes6/7 reserved. Extracted data alone does not implement per-hit battle choreography.'}
 (out/'manifest.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps({k:v for k,v in report.items()if k!='records'},indent=2))
if __name__=='__main__':main()
