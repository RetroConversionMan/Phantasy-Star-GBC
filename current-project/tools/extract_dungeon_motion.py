#!/usr/bin/env python3
"""Original38-frame dungeon geometry, shared blocks, flash-aware native patterns."""
from pathlib import Path
import hashlib,json,pickle,struct
from extract_dungeon_graphics import ROOT,SHA,source_composite,indices_image,palette_pack,address,c_array
from extract_dungeon_views import scenes
from extract_scenes import label
rom=(ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes();assert hashlib.sha256(rom).hexdigest()==SHA
out=ROOT/'assets/dungeon-motion';out.mkdir(parents=True,exist_ok=True)
cache=ROOT/'build/verification/dungeon-motion';cache.mkdir(parents=True,exist_ok=True)
all_scenes=scenes();indexed=[];image_lookup={};lookup=[[65535]*243 for _ in range(6)];fixed=[65535]*38
for frame in range(38):
 if frame==6:continue
 cases=all_scenes if frame==0 else all_scenes[:232] if frame<6 else [[0]*16]
 for case,samples in enumerate(cases):
  _,gfx,tmap=source_composite(rom,frame,samples);pixels=indices_image(gfx,tmap)
  if pixels not in image_lookup:image_lookup[pixels]=len(indexed);indexed.append(pixels)
  image=image_lookup[pixels]
  if frame<6:lookup[frame][case]=image
  else:fixed[frame]=image
 print('source frame',frame,'images',len(indexed),flush=True)
raw_patterns=[];raw_lookup={};blocks=[];block_lookup={};maps=[];tilemaps=[]
for pixels in indexed:
 ids=[]
 for y in range(16):
  for x in range(20):
   tile=b''.join(pixels[(y*8+dy)*160+x*8:(y*8+dy)*160+x*8+8]for dy in range(8))if y<15 else bytes(64)
   if tile not in raw_lookup:raw_lookup[tile]=len(raw_patterns);raw_patterns.append(tile)
   ids.append(raw_lookup[tile])
 tilemaps.append(ids[:300]);record=[]
 for y in range(8):
  for x in range(10):
   n=y*40+x*2;block=(ids[n],ids[n+1],ids[n+20],ids[n+21])
   if block not in block_lookup:block_lookup[block]=len(blocks);blocks.append(block)
   record.append(block_lookup[block])
 maps.append(record)
patterns=[];pattern_lookup={};variants=[];max_native=0
for palette in range(12):
 p=address(3,0xb5b9)+palette*8;pack=palette_pack(rom[p:p+8]);variant=[]
 for tile in raw_patterns:
  mask=0
  for c in tile:mask|=1<<c
  pal=pack[mask];raw=bytearray()
  for row in range(8):
   codes=[pack[256+pal*8+c]for c in tile[row*8:row*8+8]]
   raw.extend(sum(((c>>bit)&1)<<(7-x)for x,c in enumerate(codes))for bit in range(2))
  raw=bytes(raw)
  if raw not in pattern_lookup:pattern_lookup[raw]=len(patterns);patterns.append(raw)
  variant.append((pattern_lookup[raw],pal))
 variants.append(variant);max_native=max(max_native,max(len(set(variant[p][0]for p in row))for row in tilemaps))
 print('palette',palette,'native patterns',len(patterns),'maximum scene',max_native,flush=True)
assert max_native<=209
# Stable slots are assigned separately for each palette. Co-occurring native
# patterns are graph neighbors, so different patterns can share a slot only
# when no valid source image displays them together.
slot_counts=[]
for palette,variant in enumerate(variants):
 ids=sorted(set(v[0]for v in variant));local={p:i for i,p in enumerate(ids)};adj=[0]*len(ids)
 for row in tilemaps:
  visible=set(local[variant[p][0]]for p in row);bits=sum(1<<p for p in visible)
  for p in visible:adj[p]|=bits^(1<<p)
 used=[0]*len(ids);colors=[0]*len(ids)
 for p in sorted(range(len(ids)),key=lambda p:-adj[p].bit_count()):
  free=~used[p];color=(free&-free).bit_length()-1;colors[p]=color;mask=1<<color;neighbors=adj[p]
  while neighbors:
   bit=neighbors&-neighbors;neighbors^=bit;used[bit.bit_length()-1]|=mask
 variants[palette]=[(p,a,colors[local[p]])for p,a in variant];slot_counts.append(max(colors)+1)
 print('palette slots',palette,slot_counts[-1],flush=True)
cache_slots=max(slot_counts);assert cache_slots<=224
blobs={};pool_names=[];block_names=[];map_names=[];variant_names=[]
for i,start in enumerate(range(0,len(patterns),1024)):
 n=f'motion_patterns_{i:02d}';pool_names.append(n);blobs[n]=b''.join(patterns[start:start+1024])
for i,start in enumerate(range(0,len(blocks),2048)):
 n=f'motion_blocks_{i}';block_names.append(n);blobs[n]=b''.join(struct.pack('<4H',*b)for b in blocks[start:start+2048])
for i,row in enumerate(maps):
 n=f'motion_map_{i:04d}';map_names.append(n);blobs[n]=struct.pack('<80H',*row)
for i,row in enumerate(variants):
 n=f'motion_variant_{i:02d}';variant_names.append(n);blobs[n]=b''.join(struct.pack('<HBB',*v)for v in row)
assert all(len(blobs[n])<=16384 for n in variant_names)
banks=[209,210,211,212,214,215]+list(range(216,256));bins=[bytearray()for _ in banks];locations={}
# Pattern pools must start at aligned offset0 for CGB DMA. Place them first.
ordered=pool_names+sorted((n for n in blobs if n not in pool_names),key=lambda n:-len(blobs[n]))
for name in ordered:
 raw=blobs[name];align=16 if name in pool_names else 1
 fits=[i for i,b in enumerate(bins)if (len(b)+align-1)//align*align+len(raw)<=16384]
 assert fits,('Motion assets exceed allocated banks',name,len(raw))
 i=next((j for j in fits if not bins[j]),fits[0])if name in pool_names else max(fits,key=lambda j:len(bins[j]))
 data=bins[i];data.extend(bytes((-len(data))%align));locations[name]=(banks[i],len(data));data.extend(raw)
 (out/(name+'.bin')).write_bytes(raw)
for bank,data in zip(banks,bins):
 target=ROOT/f'src/dungeon_motion_bank_{bank:03d}.c'
 if data:target.write_text(f'#pragma bank {bank}\n#include <stdint.h>\n'+c_array(f'dungeon_motion_bank_{bank}',data));(out/f'bank-{bank}.bin').write_bytes(data)
 else:target.unlink(missing_ok=True)
def asset(n):
 bank,offset=locations[n];return '{'+f'{bank},dungeon_motion_bank_{bank}+{offset}'+'}'
assert all(locations[n][1]==0 for n in pool_names)
header=f'''/* Generated by tools/extract_dungeon_motion.py. */
#ifndef PS_DUNGEON_MOTION_DATA_H
#define PS_DUNGEON_MOTION_DATA_H
#include "dungeon_graphics.h"
#define MOTION_IMAGE_COUNT {len(maps)}u
#define MOTION_RAW_PATTERNS {len(raw_patterns)}u
#define MOTION_NATIVE_PATTERNS {len(patterns)}u
#define MOTION_MAX_PATTERNS {max_native}u
#define MOTION_CACHE_SLOTS {cache_slots}
#define MOTION_USED_BYTES {(cache_slots+7)//8}
#define MOTION_PATTERN_BANKS {','.join(str(locations[n][0]) for n in pool_names)}
#define MOTION_CODE_BANK 77u
extern const DungeonGraphicAsset motion_maps[MOTION_IMAGE_COUNT],motion_variants[12],motion_blocks[{len(block_names)}],motion_patterns[{len(pool_names)}];
extern const uint16_t motion_lookup[6][243],motion_fixed[38];
extern const uint8_t motion_sequences[10][9];
#endif
''';(ROOT/'src/dungeon_motion_data.h').write_text(header)
c='#pragma bank 77\n#include "dungeon_motion_data.h"\n'
for bank,data in zip(banks,bins):
 if data:c+=f'extern const uint8_t dungeon_motion_bank_{bank}[];\n'
for name,names in [('maps',map_names),('variants',variant_names),('blocks',block_names),('patterns',pool_names)]:
 c+=f'const DungeonGraphicAsset motion_{name}[]={{\n'+',\n'.join(asset(n)for n in names)+'\n};\n'
c+='const uint16_t motion_lookup[6][243]={\n'+',\n'.join('{'+','.join(map(str,row))+'}'for row in lookup)+'\n};\n'
c+='const uint16_t motion_fixed[38]={'+','.join(map(str,fixed))+'};\n'
sequence=[]
for i in range(10):
 ptr=struct.unpack_from('<H',rom,label('LABEL_6A76')+i*2)[0];row=[]
 while rom[ptr]!=255:row.append(rom[ptr]);ptr+=1
 assert len(row)<=8;sequence.append(row+[255]*(9-len(row)))
c+='const uint8_t motion_sequences[10][9]={\n'+',\n'.join('{'+','.join(map(str,row))+'}'for row in sequence)+'\n};\n'
(ROOT/'src/dungeon_motion_data.c').write_text(c)
manifest={'source_sha256':SHA,'images':len(maps),'raw_patterns':len(raw_patterns),'native_patterns':len(patterns),'blocks':len(blocks),'max_native_patterns_per_image':max_native,'cache_slots':cache_slots,'palette_slot_counts':slot_counts,'bytes':sum(map(len,blobs.values())),'banks':{str(b):len(d)for b,d in zip(banks,bins)if d},'locations':{n:list(locations[n])for n in blobs},'lookup':lookup,'fixed':fixed,'sequences':sequence,'limits':['Extraction proves asset coverage, not main-controller movement/event ordering or native cadence.','Original256x192 art is scaled160x120 with seven flash-aware four-color palettes.']}
(out/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
pickle.dump({'indexed':indexed,'raw_patterns':raw_patterns,'patterns':patterns,'blocks':blocks,'maps':maps,'tilemaps':tilemaps,'variants':variants,'lookup':lookup,'fixed':fixed},open(cache/'source-data.pkl','wb'))
print(json.dumps({k:v for k,v in manifest.items()if k not in('locations','lookup','fixed','sequences')},indent=2),flush=True)
