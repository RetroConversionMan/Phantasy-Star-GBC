#!/usr/bin/env python3
"""Independent original SAT/scanline/source-index and native consumer audit.

No generator or asset writes. The original576A/5853 routines emit the SAT;
first-opaque rasterization below does not use either shared scene composer.
"""
import hashlib,json,struct
from collections import Counter
from functools import lru_cache
from pathlib import Path
import numpy as np
from PIL import Image
import z80
from extract_scenes import ROOT,SHA,label,cpu_offset,Source
from extract_enemies import decode_graphics
from extract_assets import gbc_color,color_distance
OUT=ROOT/'build/verification/actor-priority-independent'

def main():
 OUT.mkdir(parents=True,exist_ok=True);rom=(ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes();assert hashlib.sha256(rom).hexdigest()==SHA
 original=Source(rom);old=json.loads((ROOT/'build/research/enemy-priority/report.json').read_text());cases={ (r['enemy'],r['frame'],r['y'])for r in old['cases']}
 def desc(enemy):
  row=rom[label('B03_EnemyData')+enemy*32:][:32];off=label('LABEL_B03_8FC7')+(row[19]-1)*24;return row,off,rom[off:off+24]
 for enemy in range(1,75):
  row,off,d=desc(enemy)
  if d[0]and d[1]:cases.add((enemy,d[1],d[2]))
 @lru_cache(None)
 def graphics(enemy):
  row,_,_=desc(enemy);return decode_graphics(rom,row[16],int.from_bytes(row[17:19],'little'))
 def sprite_list(frame,y,x):
  p=cpu_offset(21,int.from_bytes(rom[label('LABEL_B21_8000')+frame*2:][:2],'little'));count=rom[p];r=rom[p+1:p+1+count*3]
  return [((y+r[i])&255,(x+r[count+i*2])&255,r[count+i*2+1])for i in range(count)]
 @lru_cache(None)
 def reference(enemy,frame,y):
  row,off,d=desc(enemy);c=z80.Z80Machine();c.memory[:0x8000]=rom[:0x8000];c.memory[0x8000:0xc000]=rom[21*16384:22*16384]
  actors=[]
  for slot,f,yy,x,enabled in((4,frame,y,d[3],d[0]and frame),(5,d[20],d[21],d[22],d[19]and d[20])):
   if enabled:c.memory[0xc800+slot*32:0xc805+slot*32]=bytes((16,f,yy,0,x));actors.append((slot,f,yy,x))
  c.set_breakpoint(0x100);c.sp=0xdffc;c.memory[0xdffc:0xdffe]=b'\0\1';c.pc=label('LABEL_576A')
  for _ in range(10):
   c.ticks_to_stop=1000000;c.run()
   if c.pc==0x100:break
  assert c.pc==0x100
  count=int.from_bytes(c.memory[0xc217:0xc219],'little')-0xc900;sat=[(c.memory[0xc900+i],c.memory[0xc980+i*2],c.memory[0xc981+i*2])for i in range(count)]
  expected=[p for slot,f,yy,x in sorted(actors,key=lambda a:(-a[2],a[0]))for p in sprite_list(f,yy,x)];assert sat==expected,(enemy,frame,'SAT order')
  assert c.memory[0xc900+count]==208
  tiles=graphics(enemy);bg=np.full((192,256),255,np.uint8);priority=np.zeros((192,256),bool)
  ptr,dst=struct.unpack_from('<HH',d,13);height,width=d[17:19]
  if enemy in(72,73):height=width=0 # Their BG fragments use full scene tiles.
  for by in range(height):
   for bx in range(width):
    word=struct.unpack_from('<H',rom,cpu_offset(24,ptr)+(by*width+bx)*2)[0]
    if not word:continue
    assert 256<=word&511<256+len(tiles),(enemy,frame,'BG tile',hex(word),len(tiles))
    tile=np.array(tiles[(word&511)-256],np.uint8).reshape(8,8)
    if word&512:tile=tile[:,::-1]
    if word&1024:tile=tile[::-1]
    yy=(dst-0xd000)//64*8+by*8;xx=(dst-0xd000)%64//2*8+bx*8
    bg[yy:yy+8,xx:xx+8]=tile;priority[yy:yy+8,xx:xx+8]=bool(word&4096)&(tile!=0)
  plain=bg.copy();limited=bg.copy();used=np.zeros((192,256),bool);used8=used.copy();line_counts=[0]*192;overflow=0;terminated=False
  for i,(sy,sx,tile)in enumerate(sat):
   # D0 is the mode4 SAT end marker, even if emitted as an actor Y.
   if sy==208:terminated=True
   for py in range(8):
    yy=(sy+py+1)&255
    if yy>=192:continue
    line_counts[yy]+=1;selected=line_counts[yy]<=8 and not terminated
    for px in range(8):
     xx=(sx+px)&255;value=tiles[tile][py*8+px]
     if not value or priority[yy,xx]:continue
     if not used[yy,xx]:plain[yy,xx]=value;used[yy,xx]=True
     if selected and not used8[yy,xx]:limited[yy,xx]=value;used8[yy,xx]=True
  return plain,limited,sat,line_counts
 checks=[];source_pixels=0;clip_rows=[]
 for enemy,frame,y in sorted(cases):
  plain,limited,sat,counts=reference(enemy,frame,y);row,off,d=desc(enemy);changed=bytearray(rom);changed[off+1]=frame;changed[off+2]=y
  from extract_scene_actors import source_overlay
  overlay_rom=bytearray(changed)
  if enemy in(72,73):overlay_rom[off+17:off+19]=b'\0\0'
  image=source_overlay(Source(overlay_rom),enemy=enemy,indexed=True);rgba=np.asarray(image);actual=np.where(rgba[:,:,3],rgba[:,:,0]//85+rgba[:,:,1]//85*4+rgba[:,:,2]//85*16,255).astype(np.uint8)
  assert np.array_equal(actual,plain),(enemy,frame,'shared overlay source-index mismatch',int(np.count_nonzero(actual!=plain)))
  source_pixels+=plain.size;delta=plain!=limited
  if np.any(delta):
   # Source.compose observes actual BG priority in a full scene; test whether
   # hardware clipping changes pixels that are visible there as well.
   kind=30 if enemy==72 else 1;composed,palette,_=Source(changed).compose(kind,enemy=enemy,return_indices=True);full=np.frombuffer(composed,np.uint8).reshape(192,256)
   without=bytearray(changed);without[off+1]=without[off+20]=0;base,_,_=Source(without).compose(kind,enemy=enemy,return_indices=True);base=np.frombuffer(base,np.uint8).reshape(192,256)
   bgtiles,bgwords,_=original.background(kind);bgwords=list(bgwords);bgtiles=list(bgtiles)+[(0,)*64]*(256-len(bgtiles))+graphics(enemy)
   pointer,destination=struct.unpack_from('<HH',d,13)
   for by in range(d[17]):
    for bx in range(d[18]):
     word=struct.unpack_from('<H',rom,cpu_offset(24,pointer)+(by*d[18]+bx)*2)[0]
     if word:bgwords[(destination-0xd000)//2+by*32+bx]=word
   bgpriority=np.zeros((192,256),bool)
   for n,word in enumerate(bgwords):
    if not word&4096:continue
    tile=np.array(bgtiles[word&511],np.uint8).reshape(8,8)
    if word&512:tile=tile[:,::-1]
    if word&1024:tile=tile[::-1]
    bgpriority[n//32*8:n//32*8+8,n%32*8:n%32*8+8]=tile!=0
   visible=delta&~bgpriority;clipped=np.where(limited==255,base,limited+16);clipped=np.where(bgpriority,base,clipped);palette=np.array(palette,np.uint8);rgbvisible=visible&(palette[full]!=palette[clipped])
   clip_rows.append({'enemy':enemy,'frame':frame,'y':y,'max_sprites_per_line':max(counts),'over_limit_scanlines':sum(v>8 for v in counts),'source_index_pixels_changed':int(np.count_nonzero(delta)),'full_scene_visible_index_pixels':int(np.count_nonzero(visible)),'full_scene_visible_RGB_pixels':int(np.count_nonzero(rgbvisible))})
  checks.append({'enemy':enemy,'frame':frame,'y':y,'SAT_sprites':len(sat),'max_sprites_per_line':max(counts),'over_limit_scanlines':sum(v>8 for v in counts),'SAT_sha256':hashlib.sha256(bytes(v for t in sat for v in t)).hexdigest()})
 # Consumer checks decode native binary patterns, palettes and source flash
 # masks directly. Source indices at every visible sample come from the SAT.
 xscale=np.array(Image.frombytes('L',(256,1),bytes(range(256))).resize((160,1),Image.Resampling.NEAREST)).ravel();yscale=np.array(Image.frombytes('L',(1,192),bytes(range(192))).resize((1,120),Image.Resampling.NEAREST)).ravel()
 counts=Counter();consumers=[]
 def expected(enemy,frame=None,y=None):
  row,off,d=desc(enemy);p=reference(enemy,frame or d[1],d[2]if y is None else y)[0];return p[np.ix_(yscale,xscale)]
 def decode(group,r,actor=False):
  root=ROOT/'assets'/group;b=(root/(r['name']+'.bin')).read_bytes();n=r['sprites'];result=np.full((120,160),65535,np.uint16);classes=np.full((120,160),255,np.uint8)
  if actor:gfx=b[:r['tiles']*16];meta=b[len(gfx):len(gfx)+n*4];colors=struct.unpack('<32H',b[-64:]);height=8
  else:gfx=(root/'patterns.2bpp').read_bytes();meta=b[:n*5];colors=struct.unpack_from('<32H',b,n*5);masks=b[n*5+64:n*5+80];height=16
  for i in range(n):
   if actor:x,y,tile,prop=meta[i*4:i*4+4];raw=gfx[tile*16:tile*16+16]
   else:x,y,tile,prop=struct.unpack_from('<BBHB',meta,i*5);raw=gfx[tile*32:tile*32+32]
   for py in range(height):
    yy=y-16+py
    if not 0<=yy<120:continue
    for px in range(8):
     xx=x-8+px;code=(raw[py*2]>>(7-px)&1)|((raw[py*2+1]>>(7-px)&1)<<1)
     if code and 0<=xx<160 and result[yy,xx]==65535:
      result[yy,xx]=colors[(prop&7)*4+code]
      if not actor:classes[yy,xx]=0 if masks[(prop&7)+8]>>code&1 else 2 if masks[prop&7]>>code&1 else 1
  return result,classes
 for group,actor in(('scene-actors',True),('battle-scenes',False),('battle-animation',False)):
  manifest=json.loads((ROOT/'assets'/group/'manifest.json').read_text())
  for r in manifest['records']:
   if actor:
    if r['kind']!=1:continue
    enemy=r['id'];frame=None;pal=r['palette_index']if r['palette_index']<12 else 0
   else:
    enemy=r['enemy'];frame=r.get('frame');pal=r.get('palette',0)
    if group=='battle-animation'and not(enemy in(27,43)and frame==68):continue
   want=expected(enemy,frame);got,classes=decode(group,r,actor);opaque=want!=255
   assert np.array_equal(got!=65535,opaque),(group,r['name'],'alpha differs from source SAT')
   row,off,d=desc(enemy);palette=list(rom[label('LABEL_3D1D'):label('LABEL_3D1D')+8])+list(row[8:16]);palette[0]=rom[label('LABEL_B03_B5B9')+pal*8+5];colors=np.array([gbc_color(c)for c in palette],np.uint16)
   errors=int(np.count_nonzero(opaque&(got!=colors[np.minimum(want,15)])))
   assert errors==r['quantized_pixels'],(group,r['name'],'quantization mismatch',errors,r['quantized_pixels'])
   if not actor:
    wanted=np.where(want==0,0,np.where(want<3,1,2));assert np.array_equal(classes[opaque],wanted[opaque]),(group,r['name'],'source7BEE/index16 flash ownership')
    counts['native_flash_class_pixels']+=int(np.count_nonzero(opaque))
   counts[group]+=1;counts['native_opaque_pixels']+=int(np.count_nonzero(opaque));consumers.append({'group':group,'name':r['name'],'opaque_pixels':int(np.count_nonzero(opaque)),'quantized_pixels':errors})
 report={'passed':True,'source_sha256':SHA,'original_Z80_SAT_cases':len(checks),'source_index_pixels':source_pixels,'native_consumers':dict(counts),'source_scanline_overflow_cases':[{k:v for k,v in r.items()if k!='SAT_sha256'}for r in checks if r['max_sprites_per_line']>8],'source_hardware_clipping_differences':clip_rows,'checks':checks,'consumers':consumers,'limits':['Raw source-index comparison covers the complete source overlay before quantization. Native RGB differences are checked against recorded quantization counts.','Source8-sprites-per-line clipping is measured independently; generated art retains unclipped composition.','Native binary assets are decoded here; native ROM PPU upload verification is a separate check.']}
 (OUT/'report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps({k:v for k,v in report.items()if k not in('checks','consumers')},indent=2))
if __name__=='__main__':main()
