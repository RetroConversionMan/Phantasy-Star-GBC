#!/usr/bin/env python3
"""Measure authentic enemy magic overlays before allocating native ROM data."""
import hashlib,json,struct
from pathlib import Path
from PIL import Image
from extract_scenes import ROOT,SHA,Source,label,cpu_offset
from extract_scene_actors import source_overlay
from extract_weapon_effects import convert,descriptor
from extract_assets import sms_rgb
ENEMIES=(13,23,47,49,56,57,65)
def sequence(rom,enemy):
 d=descriptor(Source(rom),enemy);ptr=int.from_bytes(d[11:13],'little');start=cpu_offset(3,ptr);data=[rom[start]];zeros=0
 while zeros<2:
  value=rom[start+len(data)];data.append(value);zeros+=not value;assert len(data)<64
 return data

def effect_source(source,enemy,frame,thunder):
 rom=source.rom;row=rom[label('LABEL_5EA8'if thunder else'LABEL_5EA2'):][:6];graphics=source.graphics(11,int.from_bytes(row[4:6],'little'));d=bytearray(descriptor(source,enemy));seq=sequence(rom,enemy);d[1]=next(v for v in reversed(seq[:seq.index(0,1)])if v);y,x=d[6:8]
 # ActorC800 effects sort against the actual enemy pose at the first marker.
 foreground=set();record=rom[label('B03_EnemyData')+enemy*32:][:32];enemy_tiles=source.graphics(record[16],int.from_bytes(record[17:19],'little'))
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
 start=cpu_offset(3,int.from_bytes(rom[label('LABEL_B03_96F4')+frame*2:][:2],'little'));count=rom[start];raw=rom[start+1:start+1+count*3];palette=rom[label('LABEL_3D1D'):label('LABEL_3D1D')+8];image=Image.new('RGBA',(256,192))
 for i in reversed(range(count)):
  dx,tile=raw[count+i*2:count+i*2+2];tile-=0xa0;assert 0<=tile<len(graphics)
  for py in range(8):
   sy=(y+raw[i]+py+1)&255
   if sy>=192:continue
   for px in range(8):
    value=graphics[tile][py*8+px];point=((x+dx+px)&255,sy)
    if value and point not in foreground:image.putpixel(point,(*sms_rgb(palette[value]),255))
 return image,d[1]

def main():
 original=(ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes();assert hashlib.sha256(original).hexdigest()==SHA;rom=bytearray(original);source=Source(rom)
 frames=json.loads((ROOT/'assets/battle-animation/manifest.json').read_text())['enemies'];missing=[];patterns=set();assets=set();requests=0;max_total=max_scan=errors=0;cases=[]
 for enemy in ENEMIES:
  row=rom[label('B03_EnemyData')+enemy*32:][:32];thunder=row[30]&7==5;effect=rom[label('LABEL_5EA8'if thunder else'LABEL_5EA2'):][:6];seq=sequence(rom,enemy)
  missing.extend((enemy,f)for f in sorted(set(seq)-{0})if f not in frames[enemy-1]['frames'])
  d=descriptor(source,enemy);offset=label('LABEL_B03_8FC7')+(row[19]-1)*24
  for frame in range(effect[2]+1,effect[3]):
   image,pose=effect_source(source,enemy,frame,thunder);converted,colors,native,error=convert(image);errors+=error;meta=bytearray()
   for x,y,pattern,prop in converted:patterns.add(pattern);meta+=bytes((x,y,prop))+pattern
   assets.add((len(converted),bytes(meta),colors));requests+=1
   rom[offset+1]=pose;base=source_overlay(source,enemy=enemy,indexed=True).resize((160,120),Image.Resampling.NEAREST);rom[offset+1]=d[1]
   cells=[(x,y)for y in range(0,120,16)for x in range(0,160,8)if base.crop((x,y,x+8,y+16)).getbbox()]+[(x-8,y-16)for x,y,p,prop in converted]
   total=len(cells);scan=max(sum(y<=line<y+16 for x,y in cells)for line in range(120));max_total=max(max_total,total);max_scan=max(max_scan,scan)
   assert total<=40 and scan<=10,(enemy,frame,total,scan)
   cases.append((enemy,frame,total,scan))
 report={'requests':requests,'unique_assets':len(assets),'pattern_pairs':len(patterns),'estimated_effect_bytes':len(patterns)*32+sum(count*5+16 for count,meta,col in assets),'missing_enemy_poses':missing,'max_sprites':max_total,'max_scanline':max_scan,'quantized_pixels':errors,'cases':cases}
 out=ROOT/'assets/enemy-magic';out.mkdir(parents=True,exist_ok=True);(out/'measurement.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps({k:v for k,v in report.items()if k!='cases'},indent=2))
if __name__=='__main__':main()
