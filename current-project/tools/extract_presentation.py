#!/usr/bin/env python3
"""Original palette effects with source index identity retained across frames.

Equal initial RGB values may represent distinct source indices (the hidden
castle). Optimizing all source palette frames together avoids merging those
indices into an unrevealable flat color.
"""
from collections import Counter
from pathlib import Path
import hashlib,json,struct
from PIL import Image,ImageDraw
from extract_scenes import ROOT,SHA,Source,label
from extract_scene_actors import source_overlay
from extract_assets import palette_candidates,DIST,encode_gb,gbc_color,c_array,sms_rgb

def indexed_convert(indices,frames,sprite=False):
 image=Image.frombytes('L',(256,192),indices).resize((160,120),Image.Resampling.NEAREST)
 tiles=[];positions=[]
 for y in range(0,120,8):
  for x in range(0,160,8):
   raw=tuple(image.crop((x,y,x+8,y+8)).get_flattened_data())
   if sprite and all(c==255 for c in raw):continue
   tiles.append(raw);positions.append((x,y))
 assert not sprite or len(tiles)<=40
 histograms=[Counter(c for c in t if c!=255) for t in tiles]
 colors=len(frames[0]);distance=[[sum(DIST[f[a]][f[b]] for f in frames) for b in range(colors)]for a in range(colors)]
 candidates=palette_candidates(histograms,3 if sprite else 4)
 scores=[[sum(n*min(distance[c][p] for p in pal) for c,n in h.items()) for h in histograms] for pal in candidates]
 best=[10**20]*len(tiles);selected=[];count=8 if sprite else 7
 for _ in range(min(count,len(candidates))):
  ix=min((i for i in range(len(candidates)) if i not in selected),key=lambda i:sum(min(a,b)for a,b in zip(best,scores[i])))
  selected.append(ix);best=[min(a,b)for a,b in zip(best,scores[ix])]
 refs=[candidates[i]for i in selected];refs += [refs[0]]*(count-len(refs))
 graphics=bytearray();dedupe={};maps=bytearray();attrs=bytearray();metas=bytearray();render=[]
 for (x,y),raw,hist in zip(positions,tiles,histograms):
  pal=min(range(count),key=lambda i:sum(n*min(distance[c][p]for p in refs[i])for c,n in hist.items()))
  codes=[0 if c==255 else min(range(len(refs[pal])),key=lambda i:distance[c][refs[pal][i]])+(1 if sprite else 0)for c in raw]
  tile=encode_gb(codes)
  if tile not in dedupe:dedupe[tile]=len(dedupe);graphics.extend(tile)
  ix=dedupe[tile]
  if sprite:metas.extend((x+8,y+16,ix,pal|8))
  else:maps.append(ix if ix<256 else ix-256+64);attrs.append(pal|(8 if ix>=256 else 0))
  render.append((x,y,pal,codes))
 assert len(dedupe)<=(172 if sprite else 448)
 palette_bytes=bytearray();images=[]
 for frame in frames:
  colors_native=[]
  for refs_ in refs:colors_native.extend(([0]if sprite else [])+[gbc_color(frame[c])for c in refs_])
  palette_bytes.extend(struct.pack('<'+str(len(colors_native))+'H',*colors_native))
  im=Image.new('RGBA',(160,120))
  for x,y,pal,codes in render:
   for n,c in enumerate(codes):
    if sprite and not c:continue
    im.putpixel((x+n%8,y+n//8),(*sms_rgb(frame[refs[pal][c-(1 if sprite else 0)]]),255))
  images.append(im)
 return bytes(graphics),bytes(metas if sprite else maps+attrs),bytes(palette_bytes),images,refs

def effects(rom):
 source=Source(rom);result=[]
 # Odin revival: original portrait58. C238..C23F changes six times.
 image=source_overlay(source,portrait=58,indexed=True)
 indices=bytes((r//85)|((g//85)<<2)|((b//85)<<4) if a else 255 for r,g,b,a in image.get_flattened_data())
 common=list(rom[label('LABEL_3D1D'):label('LABEL_3D1D')+8]);high=source.portrait(58)[1]
 frames=[common+high]+[common+list(rom[label('LABEL_B03_BE1D')+i*8:label('LABEL_B03_BE1D')+(i+1)*8]) for i in range(6)]
 result.append((1,'odin',indices,frames,True,111))
 # Eclipse Torch:5bytes toC23B..C23F, distinct from Odin's7C85.
 indices,palette,_=source.compose(6,56,return_indices=True);final=list(palette)
 final[27:32]=rom[label('LABEL_B03_BE4D'):label('LABEL_B03_BE4D')+5]
 result.append((2,'torch',indices,[palette,final],False,1))
 # AeroPrism: three24-step flashes, then13 palette-reveal steps.
 indices,palette,_=source.compose(13,return_indices=True);frames=[palette];current=list(palette)
 for i in range(24):
  first,second=rom[label('LABEL_B03_BE52')+i*2:label('LABEL_B03_BE52')+i*2+2]
  current=list(current);current[0]=first;current[10:16]=[first]*6;current[7]=second;frames.append(current)
 for i in range(13):
  current=list(current);current[10:16]=rom[label('LABEL_B03_BE82')+i*6:label('LABEL_B03_BE82')+(i+1)*6];frames.append(current)
 result.append((3,'prism',indices,frames,False,320))
 # Ending sky: same source landscape, nine24-frame color transitions.
 frames=[palette];current=list(palette)
 for i in range(9):
  first,second=rom[label('LABEL_B03_BED0')+i*2:label('LABEL_B03_BED0')+i*2+2]
  current=list(current);current[0]=first;current[10:16]=[first]*6;current[7]=second;frames.append(current)
 result.append((4,'ending-sky',indices,frames,False,216))
 return result

def main():
 rom=(ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes();assert hashlib.sha256(rom).hexdigest()==SHA
 out=ROOT/'assets/presentation';out.mkdir(parents=True,exist_ok=True)
 bins=[];descs=[];decl=[];records=[]
 for kind,name,indices,frames,sprite,duration in effects(rom):
  gfx,mapping,palettes,images,refs=indexed_convert(indices,frames,sprite);data=gfx+mapping+palettes
  slot=next((i for i,b in enumerate(bins)if b['size']+len(data)<=15800),None)
  if slot is None:slot=len(bins);bins.append({'size':0,'parts':[]})
  bank=128+slot;symbol='presentation_'+name.replace('-','_');bins[slot]['size']+=len(data);bins[slot]['parts'].append(c_array(symbol,data));decl.append(f'extern const uint8_t {symbol}[];\n')
  sprites=len(mapping)//4 if sprite else 0;descs.append(f'{{{bank},{len(gfx)//16},{sprites},{len(frames)},{symbol}}}')
  (out/(name+'.bin')).write_bytes(data)
  sheet=Image.new('RGB',(8*160,((len(frames)+7)//8)*136),(25,29,36));draw=ImageDraw.Draw(sheet)
  for n,image in enumerate(images):
   image.save(out/f'{name}-{n:02}.png');sheet.paste(image,(n%8*160,n//8*136+16),image);draw.text((n%8*160+2,n//8*136),str(n),fill='white')
  sheet.save(out/(name+'-sheet.png'))
  records.append({'kind':kind,'name':name,'bank':bank,'tiles':len(gfx)//16,'sprites':sprites,'palettes':len(frames),'duration_frames':duration,'data_sha256':hashlib.sha256(data).hexdigest(),'source_index_palette_refs':refs})
 assert len(bins)<=2,('Palette effects exceeded128/129 reservation',len(bins))
 for bank,b in enumerate(bins,128):(ROOT/f'src/presentation_bank_{bank:03}.c').write_text(f'#pragma bank {bank}\n#include <stdint.h>\n'+''.join(b['parts']))
 (ROOT/'src/presentation_data.h').write_text('''#ifndef PS_PRESENTATION_DATA_H
#define PS_PRESENTATION_DATA_H
#include <stdint.h>
typedef struct {uint8_t bank;uint16_t tiles;uint8_t sprites,palettes;const uint8_t *data;} PresentationAsset;
extern const PresentationAsset presentation_assets[4];
#endif
''')
 (ROOT/'src/presentation_data.c').write_text('#pragma bank 12\n#include "presentation_data.h"\n'+''.join(decl)+'const PresentationAsset presentation_assets[4]={\n'+',\n'.join(descs)+'\n};\n')
 report={'source_sha256':SHA,'native_banks':list(range(128,128+len(bins))),'bank_bytes':[b['size']for b in bins],'records':records,'scope':'Original source palette-write sequences; fixed native graphics retain distinct SMS palette indices across all frames'}
 (out/'manifest.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps({k:v for k,v in report.items()if k!='records'},indent=2))
if __name__=='__main__':main()
