#!/usr/bin/env python3
"""Original ordinary enemy magic sequences, missing poses and actor17/18 effects."""
import hashlib,json,struct
from PIL import Image
from extract_scenes import ROOT,SHA,Source,label
from extract_scene_actors import source_overlay
from extract_battle_scenes import convert as convert_pose,enemy_palette
from extract_weapon_effects import convert as convert_effect,descriptor
from extract_assets import c_array
from measure_enemy_magic import ENEMIES,sequence,effect_source

def main():
 original=(ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes();assert hashlib.sha256(original).hexdigest()==SHA
 rom=bytearray(original);source=Source(rom);out=ROOT/'assets/enemy-magic';out.mkdir(parents=True,exist_ok=True)
 physical=json.loads((ROOT/'assets/battle-animation/manifest.json').read_text())['enemies'];patterns=[];pattern_ids={};assets=[];asset_ids={};records=[];motions=[];effect_lookup=[];poses=[]
 def add(image,converted,colors,native,error,kind,enemy,frame,palette=0):
  meta=bytearray()
  for x,y,pattern,prop in converted:
   if pattern not in pattern_ids:pattern_ids[pattern]=len(patterns);patterns.append(pattern)
   meta.extend(struct.pack('<BBHB',x,y,pattern_ids[pattern],prop))
  data=bytes(meta)+colors;key=(len(converted),data)
  if key not in asset_ids:asset_ids[key]=len(assets);assets.append(key)
  index=asset_ids[key];name=f'{kind}-{enemy:02}-{frame:03}-{palette:02}'
  (out/(name+'.bin')).write_bytes(data)
  if not palette:native.save(out/(name+'.png'))
  records.append({'kind':kind,'enemy':enemy,'frame':frame,'palette':palette,'asset':index,'name':name,'sprites':len(converted),'quantized_pixels':error,'source_sha256':hashlib.sha256(image.tobytes()).hexdigest(),'native_sha256':hashlib.sha256(native.tobytes()).hexdigest()})
  return index
 for enemy in ENEMIES:
  row=rom[label('B03_EnemyData')+enemy*32:][:32];d=descriptor(source,enemy);seq=sequence(rom,enemy);mode=(row[30]&7)-4;effect=rom[label('LABEL_5EA8'if mode else'LABEL_5EA2'):][:6]
  motions.append({'enemy':enemy,'speed':d[8],'first_frame':d[1],'sequence':seq,'effect':mode,'anchor_y':d[6],'anchor_x':d[7]})
  lookup=[]
  for frame in range(effect[2]+1,effect[3]):
   image,pose=effect_source(source,enemy,frame,mode);lookup.append(add(image,*convert_effect(image),'effect',enemy,frame))
  effect_lookup.append(lookup)
  offset=label('LABEL_B03_8FC7')+(row[19]-1)*24
  for frame in sorted(set(seq)-{0}):
   if frame in physical[enemy-1]['frames']:continue
   rom[offset+1]=frame;indices=[]
   for palette in range(12):
    image=source_overlay(source,enemy=enemy,palette_index=palette,indexed=True)
    indices.append(add(image,*convert_pose(image,enemy_palette(source,enemy,palette)),'pose',enemy,frame,palette))
   poses.append({'enemy':enemy,'frame':frame,'indices':indices})
  rom[offset:offset+24]=d
 bins=[];decl=[]
 def place(name,data):
  slot=next((i for i,b in enumerate(bins)if b['size']+len(data)<=15800),None)
  if slot is None:slot=len(bins);bins.append({'size':0,'parts':[]})
  assert slot<3,('Magic exceeds253..255',slot)
  bins[slot]['size']+=len(data);bins[slot]['parts'].append(c_array(name,data));decl.append(f'extern const uint8_t {name}[];\n');return 253+slot
 pools=[]
 for start in range(0,len(patterns),256):
  name=f'enemy_magic_pairs_{start//256:02}';bank=place(name,b''.join(patterns[start:start+256]));pools.append(f'{{{bank},{name}}}')
 descriptors=[]
 for index,(count,data)in enumerate(assets):
  name=f'enemy_magic_asset_{index:03}';bank=place(name,data);descriptors.append(f'{{{bank},{count},{name}}}')
 anim=[]
 for m in motions:
  name=f'enemy_magic_sequence_{m["enemy"]:02}';bank=place(name,bytes(m['sequence']));anim.append(f'{{{m["speed"]},{len(m["sequence"])},0,{m["first_frame"]},{bank},{name}}}')
 for bank,b in enumerate(bins,253):(ROOT/f'src/enemy_magic_bank_{bank}.c').write_text(f'#pragma bank {bank}\n#include <stdint.h>\n'+''.join(b['parts']))
 effects=[list(rom[label(name):label(name)+4])for name in ('LABEL_5EA2','LABEL_5EA8')]
 (ROOT/'src/enemy_magic_data.h').write_text(f'''#ifndef PS_ENEMY_MAGIC_DATA_H
#define PS_ENEMY_MAGIC_DATA_H
#include "battle_animation_data.h"
#define ENEMY_MAGIC_BANK 252u
#define ENEMY_MAGIC_ASSETS {len(assets)}u
#define ENEMY_MAGIC_POSES {len(poses)}u
extern const uint8_t enemy_magic_enemies[7],enemy_magic_kinds[7],enemy_magic_effects[2][4];
extern const BattleAnimation enemy_magic_animations[7];
extern const uint8_t enemy_magic_pose_keys[ENEMY_MAGIC_POSES][2];
extern const uint16_t enemy_magic_pose_lookup[ENEMY_MAGIC_POSES][12],enemy_magic_effect_lookup[7][8];
extern const BattleSceneAsset enemy_magic_assets[ENEMY_MAGIC_ASSETS];
extern const BattleScenePool enemy_magic_pools[{len(pools)}];
#endif
''')
 def rows(table):return '{'+','.join('{'+','.join(map(str,row))+'}'for row in table)+'}'
 (ROOT/'src/enemy_magic_bank_252.c').write_text('#pragma bank 252\n#include "enemy_magic_data.h"\n'+''.join(decl)+'const uint8_t enemy_magic_enemies[7]={'+','.join(map(str,ENEMIES))+'};\nconst uint8_t enemy_magic_kinds[7]={'+','.join(str(m['effect'])for m in motions)+'};\nconst uint8_t enemy_magic_effects[2][4]='+rows(effects)+';\nconst BattleAnimation enemy_magic_animations[7]={'+','.join(anim)+'};\nconst uint8_t enemy_magic_pose_keys[ENEMY_MAGIC_POSES][2]='+rows([[p['enemy'],p['frame']]for p in poses])+';\nconst uint16_t enemy_magic_pose_lookup[ENEMY_MAGIC_POSES][12]='+rows([p['indices']for p in poses])+';\nconst uint16_t enemy_magic_effect_lookup[7][8]='+rows(effect_lookup)+';\nconst BattleSceneAsset enemy_magic_assets[ENEMY_MAGIC_ASSETS]={'+','.join(descriptors)+'};\nconst BattleScenePool enemy_magic_pools[]={'+','.join(pools)+'};\n')
 (out/'patterns.2bpp').write_bytes(b''.join(patterns));report={'source_sha256':SHA,'native_banks':[252]+list(range(253,253+len(bins))),'data_bank_bytes':[b['size']for b in bins],'assets':len(assets),'pattern_pairs':len(patterns),'effects':effects,'motions':motions,'poses':poses,'records':records,'scope':'Seven ordinary enemy casters. Actor17/18 overlays and four missing alternate poses; special bosses and integrated choreography remain separate.'}
 (out/'manifest.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps({k:v for k,v in report.items()if k not in('records','motions','poses')},indent=2))
if __name__=='__main__':main()
