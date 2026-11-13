#!/usr/bin/env python3
"""Original actor15/16 flight poses84..8B from4517/5D30/5D5B."""
import hashlib,json,struct
from PIL import Image
from extract_scenes import ROOT,SHA,Source,SYMBOLS,label,cpu_offset
from extract_scene_actors import convert
from extract_assets import sms_rgb,c_array,gbc_color

def extract(rom):
 source=Source(rom);tiles=source.graphics(*SYMBOLS['LABEL_B22_B9E7']);assert all(c<8 for t in tiles for c in t);palette=[0]+list(rom[label('LABEL_B22_B9D8'):label('LABEL_B22_B9D8')+15]);frames=[]
 for pose in range(0x84,0x8c):
  pointer=struct.unpack_from('<H',rom,label('LABEL_B03_96F4')+pose*2)[0];p=cpu_offset(3,pointer);count=rom[p];raw=rom[p+1:p+1+count*3];im=Image.new('RGBA',(256,192))
  for n in reversed(range(count)):
   y=raw[n]+1;x,tile=raw[count+n*2:count+n*2+2]
   for dy in range(8):
    for dx in range(8):
     value=tiles[tile][dy*8+dx]
     if value:im.putpixel((x+dx,y+dy),(*sms_rgb(palette[value]),255))
  gfx,meta,colors,native,error=convert(im);frames.append((pose,gfx,meta,colors,im,native,error))
 return frames

def main():
 rom=(ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes();assert hashlib.sha256(rom).hexdigest()==SHA
 out=ROOT/'assets/myau-flight';out.mkdir(parents=True,exist_ok=True);frames=extract(rom);gfx=bytearray();dedupe={};metas=[];records=[]
 for pose,patterns,meta,colors,source,native,error in frames:
  mapping={}
  for n in range(0,len(patterns),16):
   tile=patterns[n:n+16]
   if tile not in dedupe:dedupe[tile]=len(dedupe);gfx.extend(tile)
   mapping[n//16]=dedupe[tile]
  meta=bytearray(meta)
  for n in range(2,len(meta),4):meta[n]=mapping[meta[n]]
  metas.append(bytes(meta)+colors);source.save(out/f'{pose:02x}-source.png');native.save(out/f'{pose:02x}-gbc.png')
  records.append({'pose':pose,'sprites':len(meta)//4,'quantized_pixels':error})
 assert len(dedupe)<=172
 data=bytes(gfx);descs=[]
 for record,meta in zip(records,metas):record['offset']=len(data);descs.append(f'{{{len(data)},{record["sprites"]}}}');data+=meta
 # Source4497 restores only low8 sprite colors after initially setting16
 # colors to30. Flight graphics use source indices0..7 exclusively.
 source_palette=[0]+list(rom[label('LABEL_B22_B9D8'):label('LABEL_B22_B9D8')+15]);restored=list(rom[label('LABEL_B11_8000'):label('LABEL_B11_8000')+8])
 native=struct.unpack('<32H',frames[3][3]);prelude=[]
 for i,color in enumerate(native):
  sms=((color&31)*3+15)//31|(((((color>>5)&31)*3+15)//31)<<2)|(((((color>>10)&31)*3+15)//31)<<4)
  index=0 if i%4==0 else next(j for j in range(1,8)if source_palette[j]==sms)
  prelude.append(gbc_color(restored[index]))
 prelude_offset=len(data);data+=struct.pack('<32H',*prelude)
 (out/'flight.bin').write_bytes(data)
 (ROOT/'src/myau_flight_bank_131.c').write_text('#pragma bank 131\n#include <stdint.h>\n'+c_array('myau_flight_data',data))
 (ROOT/'src/myau_flight_data.h').write_text(f'''#ifndef PS_MYAU_FLIGHT_DATA_H
#define PS_MYAU_FLIGHT_DATA_H
#include <stdint.h>
#define MYAU_FLIGHT_TILES {len(dedupe)}u
#define MYAU_BATTLE_PALETTE_OFFSET {prelude_offset}u
extern const uint8_t myau_flight_data[];
typedef struct {{uint16_t offset;uint8_t sprites;}} MyauFlightFrame;
extern const MyauFlightFrame myau_flight_frames[8];
#endif
''')
 (ROOT/'src/myau_flight_data.c').write_text('#pragma bank 132\n#include "myau_flight_data.h"\nconst MyauFlightFrame myau_flight_frames[8]={'+','.join(descs)+'};\n')
 report={'source_sha256':SHA,'native_bank':131,'tiles':len(dedupe),'data_bytes':len(data),'data_sha256':hashlib.sha256(data).hexdigest(),'battle_palette_offset':prelude_offset,'frames':records,'limits':['Original source trajectory; native anchors and artwork scaled5/8','Nearest-neighbor poses use fixed pixel phase while moving on native pixel grid']}
 (out/'manifest.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
if __name__=='__main__':main()
