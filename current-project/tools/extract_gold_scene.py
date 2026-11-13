#!/usr/bin/env python3
"""Scene14's exact4497/5FFE/1613/1663 palette phases, with source-index identity."""
from collections import Counter
import hashlib,json,struct
from PIL import Image
from extract_scenes import ROOT,SHA,Source,label
from extract_assets import palette_candidates,color_distance,encode_gb,gbc_color,sms_rgb,c_array

def main():
 rom=(ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes();assert hashlib.sha256(rom).hexdigest()==SHA
 indices,base,_=Source(rom).compose(14,return_indices=True)
 low=list(rom[label('LABEL_B11_8000'):][:8]);high=list(rom[label('B03_EnemyData')+70*32+8:][:8])
 phases=[base[:16]+[0x30]*16,base[:16]+low+[0x30]*8,base[:16]+low+high]
 classes=[0 if i<3 else 1 if i<16 else 2 if i==16 else 3 if i<19 else 4 for i in range(32)]
 im=Image.frombytes('L',(256,192),indices).resize((160,120),Image.Resampling.NEAREST)
 tiles=[tuple(im.crop((x,y,x+8,y+8)).get_flattened_data())for y in range(0,120,8)for x in range(0,160,8)]
 hist=[Counter(t)for t in tiles];candidates=palette_candidates(hist,4)
 dist=[[sum(color_distance(p[a],p[b])for p in phases)+(10**12 if classes[a]!=classes[b]else 0)for b in range(32)]for a in range(32)]
 scores=[[sum(n*min(dist[c][p]for p in pal)for c,n in h.items())for h in hist]for pal in candidates]
 best=[10**20]*300;selected=[]
 for _ in range(min(7,len(candidates))):
  index=min((i for i in range(len(candidates))if i not in selected),key=lambda i:sum(min(a,b)for a,b in zip(best,scores[i])))
  selected.append(index);best=[min(a,b)for a,b in zip(best,scores[index])]
 refs=[candidates[i]for i in selected];refs += [refs[0]]*(7-len(refs));graphics=bytearray();dedupe={};maps=[];attrs=[];codes_by_cell=[]
 for tile,h in zip(tiles,hist):
  pal=min(range(7),key=lambda i:sum(n*min(dist[c][p]for p in refs[i])for c,n in h.items()));codes=[min(range(4),key=lambda i:dist[c][refs[pal][i]])for c in tile]
  assert all(classes[c]==classes[refs[pal][code]]for c,code in zip(tile,codes)),('source class lost',pal)
  raw=encode_gb(codes)
  if raw not in dedupe:dedupe[raw]=len(dedupe);graphics+=raw
  maps.append(dedupe[raw]);attrs.append(pal);codes_by_cell.append((pal,codes))
 assert len(dedupe)<256
 colors=b''.join(struct.pack('<28H',*[gbc_color(p[c])for refs_ in refs for c in refs_])for p in phases)
 masks=bytes(sum(1<<i for i,c in enumerate(refs_)if (3<=c<=15 if group==0 else c==16 if group==1 else c>=19))for group in range(3)for refs_ in refs)
 out=ROOT/'assets/gold-scene';out.mkdir(parents=True,exist_ok=True);errors=[]
 for phase,palette in enumerate(phases):
  image=Image.new('RGB',(160,120));error=0
  for cell,(pal,codes)in enumerate(codes_by_cell):
   for i,code in enumerate(codes):
    c=palette[refs[pal][code]];error+=c!=palette[tiles[cell][i]];image.putpixel((cell%20*8+i%8,cell//20*8+i//8),sms_rgb(c))
  image.save(out/f'phase-{phase}-gbc.png');original=Image.new('RGB',(256,192));original.putdata([sms_rgb(palette[c])for c in indices]);original.save(out/f'phase-{phase}-source.png');errors.append(error)
 data=bytes(graphics)+bytes(maps+attrs)+colors+masks;mapping=len(graphics);palette_offset=mapping+600;mask_offset=palette_offset+168
 (out/'scene.bin').write_bytes(data);(out/'indices.bin').write_bytes(indices)
 (ROOT/'src/gold_scene_bank_123.c').write_text('#pragma bank 123\n#include <stdint.h>\n'+c_array('gold_scene_data',data))
 (ROOT/'src/gold_scene_data.h').write_text(f'''#ifndef PS_GOLD_SCENE_DATA_H
#define PS_GOLD_SCENE_DATA_H
#include <stdint.h>
#define GOLD_SCENE_BANK 123u
#define GOLD_SCENE_TILES {len(dedupe)}u
#define GOLD_SCENE_MAP {mapping}u
#define GOLD_SCENE_PALETTE {palette_offset}u
#define GOLD_SCENE_MASKS {mask_offset}u
extern const uint8_t gold_scene_data[];
#endif
''')
 report={'source_sha256':SHA,'bank':123,'bytes':len(data),'tiles':len(dedupe),'map_offset':mapping,'palette_offset':palette_offset,'mask_offset':mask_offset,'phases':phases,'palette_refs':refs,'quantized_pixels':errors,'source_classes_preserved':True,'scope':'Exact scene14 BG source-index geometry; palette phases allblue, low8restore, enemy-loaded. Blueoutcome equalsphase0; OBJpalette is handled separately.'};(out/'manifest.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps({k:v for k,v in report.items()if k not in('palette_refs','phases')},indent=2))
if __name__=='__main__':main()
