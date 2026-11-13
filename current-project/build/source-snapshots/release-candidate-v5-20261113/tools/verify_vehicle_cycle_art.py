#!/usr/bin/env python3
"""Original vehicle source-index ownership versus generated two-layer assets."""
from pathlib import Path
import hashlib,json,struct,sys
import numpy as np
from PIL import Image
ROOT=next(p for p in Path(__file__).resolve().parents if(p/'upstream/ps1disasm/ps1original.sms').exists());WORK=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'tools'))
from extract_assets import ROM_SHA256
def rgb(v):return tuple((v>>s&3)*85 for s in(0,2,4))
def gb(v):return sum(round(c*31/255)<<s for c,s in zip(rgb(v),(0,5,10)))
def decode(raw,planes):return np.array([sum(((raw[y*planes+p]>>(7-x))&1)<<p for p in range(planes))for y in range(8)for x in range(8)],np.uint8).reshape(8,8)
def main():
 rom=(ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes();assert hashlib.sha256(rom).hexdigest()==ROM_SHA256
 manifest=json.loads((WORK/'assets/vehicle-cycles/manifest.json').read_text());pal=[0]+list(rom[0xdb2:0xdc1]);counts=dict(frames=0,alpha_pixels=0,cycling_pixels=0,static_pixels=0,max_scanline_sprites=0);records=[]
 sheet=Image.new('RGB',(4*68,12*36),(24,32,40))
 for row in manifest['records']:
  f=row['frame'];dynamic=set(row['animated_indices']);source=np.zeros((32,32),np.uint8)
  for q in range(16):source[q//4*8:q//4*8+8,q%4*8:q%4*8+8]=decode(rom[18*16384+f*512+q*32:][:32],4)
  data=(WORK/f'assets/vehicle-cycles/{f:02x}.bin').read_bytes();n=row['tiles'];meta=data[n*16:n*20];nativepal=list(struct.unpack('<32H',data[-64:]));cycle=np.isin(source,list(dynamic));last_static=None
  for phase in range(-1,3):
   sourcepal=pal.copy();displaypal=nativepal.copy()
   if phase>=0:
    start=(0x7c73 if row['mode']==8 else 0x7c6d)+phase;values=rom[start:start+3]
    for index,value in zip(sorted(dynamic),values):sourcepal[index]=value
    displaypal[29:32]=[gb(v)for v in values]
   result=np.full((32,32),65535,np.uint16);classes=np.zeros((32,32),np.uint8);scan=[0]*32
   for i in range(n):
    x,y,tile,prop=meta[i*4:i*4+4];x-=64;y-=64;codes=decode(data[tile*16:tile*16+16],2)
    for yy in range(8):
     scan[y+yy]+=1
     for xx in range(8):
      c=codes[yy,xx]
      if not c:continue
      assert result[y+yy,x+xx]==65535,(f,'layers overlap',i,xx,yy)
      result[y+yy,x+xx]=displaypal[(prop&7)*4+c];classes[y+yy,x+xx]=2 if prop&7==7 else 1
   assert np.array_equal(result!=65535,source!=0),(f,phase,'alpha')
   assert np.array_equal(classes==2,cycle),(f,phase,'cycle/static ownership')
   expected=np.array([gb(sourcepal[int(c)])for c in source.flat],np.uint16).reshape(32,32)
   assert np.array_equal(result[cycle],expected[cycle]),(f,phase,'cycling colors')
   static=(source!=0)&~cycle
   if last_static is not None:assert np.array_equal(last_static,result[static]),(f,phase,'static pixels animated')
   last_static=result[static].copy();errors=int(np.count_nonzero(result[static]!=expected[static]));assert errors==row['quantized_static_pixels']
   assert max(scan)<=8;counts['max_scanline_sprites']=max(counts['max_scanline_sprites'],max(scan));counts['frames']+=1;counts['alpha_pixels']+=1024;counts['cycling_pixels']+=int(cycle.sum());counts['static_pixels']+=int(static.sum())
   for y in range(32):
    for x in range(32):
     if source[y,x]:
      sx=(phase+1)*68+x;sy=f*36+y;sheet.putpixel((sx,sy),rgb(sourcepal[int(source[y,x])]))
      v=int(result[y,x]);sheet.putpixel((sx+34,sy),tuple((v>>s&31)*255//31 for s in(0,5,10)))
   records.append(dict(frame=f,phase=phase,sprites=n,cycle_pixels=int(cycle.sum()),static_quantized=errors))
 out=WORK/'evidence';sheet.resize((816,1296),Image.Resampling.NEAREST).save(out/'vehicle-source-native-cycles.png');report=dict(passed=True,counts=counts,records=records,scope='All12 directional frames, base palette and3 original cycle phases. Exact source cycling colors, disjoint index classes, unchanged static pixels, alpha and8-per-line sprite bound.')
 (out/'vehicle-art.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps({k:v for k,v in report.items()if k!='records'},indent=2))
if __name__=='__main__':main()
