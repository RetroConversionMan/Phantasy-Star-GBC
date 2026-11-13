#!/usr/bin/env python3
"""Extract the original ending tail through real Z80 movement/VDP handlers."""
import sys,pickle,collections,hashlib,struct,time,json,argparse
from pathlib import Path
sys.path.insert(0,'tools')
from ending_reference import Ending,ROOT,ROM
from extract_dungeon_graphics import SHA,c_array
from extract_assets import choose_palettes,convert_tile,gbc_color,sms_rgb
from PIL import Image
assert hashlib.sha256(ROM).hexdigest()==SHA
E=[]
for light in(1,0):E.append(Ending(light).trace())
assert E[0].audio==E[1].audio and E[0].logs==E[1].logs
# Cache the scale-to-GBC index image by original VDP pattern/name memory and scroll.
def pixels(vram,regs):
 tiles=[]
 for t in range(512):
  raw=vram[t*32:t*32+32];tiles.append(bytes(sum(((raw[y*4+b]>>(7-x))&1)<<b for b in range(4))for y in range(8)for x in range(8)))
 pix=bytearray()
 for y in range(120):
  sy=(y*8//5+regs[9])%224
  for x in range(160):
   sx=(x*8//5-regs[8])%256;off=0x3800+sy//8*64+sx//8*2;w=int.from_bytes(vram[off:off+2],'little')
   pix.append(tiles[w&511][(7-sy%8 if w&1024 else sy%8)*8+(7-sx%8 if w&512 else sx%8)]+(16 if w&2048 else 0))
 return bytes(pix)
e=E[0];snaps=[v[1]for v in e.unique.values()];pix_cache={};frames=[];layouts=[];layout_lookup={};palettes=[];groups=collections.defaultdict(set)
for f,sourceid in enumerate(e.frames):
 vram,cram,regs=snaps[sourceid];key=(vram,regs)
 if key not in pix_cache:pix_cache[key]=pixels(vram,regs)
 pix=pix_cache[key];target=e.targets[f];key=(pix,target)
 if key not in layout_lookup:layout_lookup[key]=len(layouts);layouts.append(key)
 layout=layout_lookup[key];frames.append(layout);groups[target].add(layout)
print('layouts',len(layouts),'targetgroups',len(groups),flush=True)
tilelists=[]
for pix,target in layouts:tilelists.append([tuple(pix[(ty*8+dy)*160+tx*8+dx]for dy in range(8)for dx in range(8))for ty in range(15)for tx in range(20)])
plans={}
for target,ids in groups.items():
 counts=collections.Counter(tuple(target[c]for c in tile)for i in ids for tile in tilelists[i]);plan=choose_palettes([collections.Counter(p)for p in counts],[counts[p]for p in counts],7)
 plans[target]=(plan,[[target.index(c)for c in p]for p in plan]);print('plan',len(ids),len(counts),flush=True)
patterns=[];pattern_lookup={};native=[];maxpatterns=0
for n,(pix,target)in enumerate(layouts):
 plan,refs=plans[target];patlist=[];attrs=[];lookup={}
 for tile in tilelists[n]:
  if tile not in lookup:lookup[tile]=convert_tile(tuple(target[c]for c in tile),plan)
  gfx,attr=lookup[tile]
  if gfx not in pattern_lookup:pattern_lookup[gfx]=len(patterns);patterns.append(gfx)
  patlist.append(pattern_lookup[gfx]);attrs.append(attr)
 maxpatterns=max(maxpatterns,len(set(patlist)));native.append((patlist,bytes(attrs),refs))
print('native',len(native),'globalpatterns',len(patterns),'maxlocal',maxpatterns,'estimate',len(native)*1000+len(patterns)*16,flush=True)
compiled={'frames':frames,'native':native,'patterns':patterns,'layouts':layouts,'traces':[{'frames':e.frames,'unique':[v[1]for v in e.unique.values()],'targets':e.targets,'audio':e.audio,'logs':e.logs,'credits':e.credits}for e in E]}
out=ROOT/'assets/ending-walk';out.mkdir(parents=True,exist_ok=True)
cache=ROOT/'build/verification/ending-walk';cache.mkdir(parents=True,exist_ok=True)
pickle.dump(compiled,open(cache/'source-compiled.pkl','wb'))

# Native frame maps address a compact per-frame pattern list. The global
# pattern pool is 16-byte aligned and transferred with the CGB DMA engine.
# Group patterns by their complete image-presence signature. This packs
# co-occurring patterns together, allowing native bulk DMA instead of one
# expensive setup per tile. Slot IDs are local to each image.
presence=[0]*len(patterns)
for i,(ids,attrs,refs) in enumerate(native):
 for p in set(ids):presence[p]|=1<<i
order=sorted(range(len(patterns)),key=lambda p:presence[p]);newid={p:i for i,p in enumerate(order)}
patterns=[patterns[p]for p in order]
native=[([newid[p]for p in ids],attrs,refs)for ids,attrs,refs in native]
blobs={};images=[];group_counts=[];slots=maxpatterns
poolbanks=[137,138,139,193,194,195,196]
for i,(ids,attrs,refs) in enumerate(native):
 unique=sorted(set(ids));local={p:n for n,p in enumerate(unique)};groups=[]
 for slot,p in enumerate(unique):
  if groups and p==groups[-1][1]+groups[-1][2] and p//1024==groups[-1][1]//1024 and slot!=128 and groups[-1][2]<128:groups[-1][2]+=1
  else:groups.append([slot,p,1])
 commands=bytearray()
 for slot,p,n in groups:
  source=0x4000+(p%1024)*16;dest=0x9000+slot*16 if slot<128 else 0x8800+(slot-128)*16
  commands.extend((poolbanks[p//1024],source>>8,source&255,dest>>8,dest&255,n-1))
 runs_attr=[]
 for color in attrs:
  if runs_attr and runs_attr[-1][1]==color and runs_attr[-1][0]<255:runs_attr[-1][0]+=1
  else:runs_attr.append([1,color])
 raw=bytes([len(groups)])+commands+bytes(local[p]for p in ids)+bytes(x for pair in runs_attr for x in pair)
 name=f'ending_image_{i:03d}';blobs[name]=raw;images.append(name);group_counts.append(len(groups))
for i,start in enumerate(range(0,len(patterns),1024)):blobs[f'ending_patterns_{i}']=b''.join(patterns[start:start+1024])
# The same source geometry uses the original retained C315 lighting palette.
palette_data=[];palette_lookup={};logical=[]
for f,i in enumerate(frames):
 refs=native[i][2];palids=[]
 for e in E:
  snap=list(e.unique.values())[e.frames[f]][1];cram=snap[1]
  raw=b''.join(struct.pack('<H',gbc_color(cram[c]))for p in refs for c in p)
  if raw not in palette_lookup:palette_lookup[raw]=len(palette_data);palette_data.append(raw)
  palids.append(palette_lookup[raw])
 logical.append((i,*palids))
runs=[]
for row in logical:
 if runs and tuple(runs[-1][:3])==row and runs[-1][3]<255:runs[-1][3]+=1
 else:runs.append([*row,1])
banks=list(range(137,140))+list(range(193,216))+[136];packed=[bytearray()for _ in banks];locations={}
for name in sorted(blobs,key=lambda k:-len(blobs[k])):
 raw=blobs[name];align=16 if 'patterns' in name else 1
 fit=next((i for i,p in enumerate(packed)if (len(p)+align-1)//align*align+len(raw)<=(6000 if banks[i]==136 else 16384)),None)
 assert fit is not None,('Ending bank allocation exhausted',name,len(raw))
 data=packed[fit];data.extend(bytes((-len(data))%align));locations[name]=(banks[fit],len(data));data.extend(raw)
 (out/(name+'.bin')).write_bytes(raw)
for bank,data in zip(banks,packed):
 if not data:
  (ROOT/f'src/ending_walk_bank_{bank:03d}.c').unlink(missing_ok=True)
  (out/f'bank-{bank}.bin').unlink(missing_ok=True)
 if data:
  (ROOT/f'src/ending_walk_bank_{bank:03d}.c').write_text(f'#pragma bank {bank}\n#include <stdint.h>\n'+c_array(f'ending_walk_bank_{bank}',data))
  (out/f'bank-{bank}.bin').write_bytes(data)
header='''/* Generated by tools/extract_ending_walk.py from original Z80 output. */
#ifndef PS_ENDING_WALK_DATA_H
#define PS_ENDING_WALK_DATA_H
#include <stdint.h>
typedef struct {uint8_t bank;const uint8_t *data;} EndingAsset;
typedef struct {uint16_t image;uint8_t light,dark,duration;} EndingRun;
typedef struct {uint16_t frame;uint8_t command;} EndingSound;
'''
header+=f'#define ENDING_PATTERN_SLOTS {slots}\n#define ENDING_PATTERN_BANKS {{'+','.join(str(locations[f'ending_patterns_{i}'][0])+'u'for i in range((len(patterns)+1023)//1024))+'}\n'
header+=f'#define ENDING_WALK_FRAMES {len(frames)}u\n#define ENDING_RUN_COUNT {len(runs)}u\n#define ENDING_IMAGE_COUNT {len(images)}u\n#define ENDING_SOUND_COUNT {len(E[0].audio)}u\n'
header+=f'extern const EndingAsset ending_images[{len(images)}],ending_patterns[{(len(patterns)+1023)//1024}];\nextern const uint16_t ending_palettes[{len(palette_data)}][28];\nextern const EndingRun ending_runs[ENDING_RUN_COUNT];\nextern const EndingSound ending_sounds[ENDING_SOUND_COUNT];\n#endif\n'
(ROOT/'src/ending_walk_data.h').write_text(header)
text='#pragma bank 136\n#include "ending_walk_data.h"\n'
for bank,data in zip(banks,packed):
 if data:text+=f'extern const uint8_t ending_walk_bank_{bank}[];\n'
def descriptor(n):
 bank,off=locations[n];return '{'+f'{bank},ending_walk_bank_{bank}+{off}'+'}'
text+='const EndingAsset ending_images[]={\n'+',\n'.join(descriptor(n)for n in images)+'\n};\n'
text+='const EndingAsset ending_patterns[]={\n'+',\n'.join(descriptor(f'ending_patterns_{i}')for i in range((len(patterns)+1023)//1024))+'\n};\n'
text+='const uint16_t ending_palettes[][28]={\n'+',\n'.join('{'+','.join(hex(x)for x in struct.unpack('<28H',p))+'}'for p in palette_data)+'\n};\n'
text+='const EndingRun ending_runs[]={\n'+',\n'.join('{'+','.join(map(str,r))+'}'for r in runs)+'\n};\n'
text+='const EndingSound ending_sounds[]={'+','.join('{'+str(f)+','+str(v)+'}'for f,v in E[0].audio)+'};\n'
(ROOT/'src/ending_walk_data.c').write_text(text)
manifest={'source_sha256':SHA,'logical_frames':len(frames),'source_vdp_bytes_written':E[0].vwrites,'source_vram_states_lit':len(E[0].unique),'source_vram_states_unlit':len(E[1].unique),'pattern_slots':slots,'packet_format':'group-count,6-byte-DMA-commands,300tile-IDs,RLE-attributes','dma_groups':{'max':max(group_counts),'mean':sum(group_counts)/len(group_counts)},'native_images':len(images),'native_patterns':len(patterns),'max_patterns_per_image':maxpatterns,'palette_states':len(palette_data),'timeline_runs':len(runs),'audio':E[0].audio,'credits':E[0].credits,'banks':{b:len(p)for b,p in zip(banks,packed)if p},'image_locations':{n:list(locations[n])for n in images},'pattern_locations':[list(locations[f'ending_patterns_{i}'])for i in range((len(patterns)+1023)//1024)],'runs':runs,'palettes':[list(struct.unpack('<28H',p))for p in palette_data], 'limits':['Original indexed art is scaled from256x192 to160x120; seven4-color GBC palettes quantize the original colors.','Source trace calls VBlank handlers at WaitForVInt; it records logical VBlanks rather than a full SMS CPU/PPU timing simulation.']}
(out/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n');print('Packed ending', {k:v for k,v in manifest.items()if k not in('image_locations','runs','palettes')},flush=True)
