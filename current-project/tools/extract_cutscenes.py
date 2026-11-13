#!/usr/bin/env python3
"""Render original467C/46D1 narrative portrait frames from the pinned SMS ROM."""
from pathlib import Path
import hashlib,json,struct
from PIL import Image,ImageDraw
from extract_scenes import ROOT,SHA,label,cpu_offset,Source,SYMBOLS,convert
from extract_assets import rle,sms_rgb,c_array
def portrait_source(source,portrait):
 rom=source.rom
 palette=[0]*16+list(rom[label('LABEL_B24_A57A'):label('LABEL_B24_A57A')+16])
 tiles=list(source.graphics(*SYMBOLS['LABEL_B24_A58A']))
 low,pos=rle(rom,label('LABEL_B24_A484'));high,end=rle(rom,pos)
 assert len(low)==len(high)==768
 words=[a|(b<<8) for a,b in zip(low,high)]
 record=rom[label('LABEL_471E')+portrait*5:label('LABEL_471E')+(portrait+1)*5]
 bank=record[0];pointer,mapping=struct.unpack_from('<HH',record,1)
 palette[:16]=rom[cpu_offset(bank,pointer):cpu_offset(bank,pointer)+16]
 tiles += [(0,)*64]*(256-len(tiles))+source.graphics(bank,pointer+16)
 # LABEL390 transfers twelve rows of twenty16-bit cells, toVRAM78CC.
 for y in range(12):
  words[102+y*32:122+y*32]=struct.unpack_from('<20H',rom,cpu_offset(24,mapping)+y*40)
 canvas=Image.new('RGB',(256,192))
 for n,word in enumerate(words):
  tile=word&511;assert tile<len(tiles)
  raw=tiles[tile];pal=16 if word&0x800 else 0
  for py in range(8):
   for px in range(8):
    c=raw[(7-py if word&0x400 else py)*8+(7-px if word&0x200 else px)]
    canvas.putpixel((n%32*8+px,n//32*8+py),sms_rgb(palette[pal+c]))
 return canvas,{'portrait':portrait,'sms_bank':bank,'sms_palette_address':pointer,'sms_map_address':mapping}
def main():
 rom=(ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes();assert hashlib.sha256(rom).hexdigest()==SHA
 source=Source(rom);out=ROOT/'assets/cutscenes';out.mkdir(parents=True,exist_ok=True)
 bins=[];records=[];decl=[];descs=[];sheet=Image.new('RGB',(3*160,3*136));draw=ImageDraw.Draw(sheet)
 for portrait in range(9):
  im,record=portrait_source(source,portrait);im.save(out/f'portrait-{portrait}-source.png')
  rendered,colors,native,error=convert(im);patterns={};gfx=bytearray();mapping=bytearray();attrs=bytearray()
  for tile,pal in rendered:
   if tile not in patterns:patterns[tile]=len(patterns);gfx.extend(tile)
   index=patterns[tile];mapping.append(index if index<256 else index-256+64);attrs.append(pal|(8 if index>=256 else 0))
  assert len(patterns)<=448
  data=bytes(gfx+mapping+attrs)+struct.pack('<28H',*colors);symbol=f'cutscene_portrait_{portrait}'
  slot=next((i for i,b in enumerate(bins) if b['size']+len(data)<=15800),None)
  if slot is None:slot=len(bins);bins.append({'size':0,'parts':[]})
  bank=116+slot;bins[slot]['size']+=len(data);bins[slot]['parts'].append(c_array(symbol,data))
  decl.append(f'extern const uint8_t {symbol}[];\n');descs.append(f'{{{bank},{len(patterns)},{symbol}}}')
  record.update(bank=bank,tiles=len(patterns),color_quantized_pixels=error,data_sha256=hashlib.sha256(data).hexdigest());records.append(record)
  (out/f'portrait-{portrait}.bin').write_bytes(data);native.save(out/f'portrait-{portrait}-gbc.png')
  sheet.paste(native,(portrait%3*160,portrait//3*136+16));draw.text((portrait%3*160+2,portrait//3*136),str(portrait),fill='white')
 assert len(bins)<=5,('Cutscene art overlaps audio121+',len(bins))
 for n,b in enumerate(bins,116):(ROOT/f'src/cutscene_art_bank_{n:03}.c').write_text(f'#pragma bank {n}\n#include <stdint.h>\n'+''.join(b['parts']))
 (ROOT/'src/cutscene_art_data.h').write_text('''#ifndef PS_CUTSCENE_ART_DATA_H
#define PS_CUTSCENE_ART_DATA_H
#include <stdint.h>
typedef struct {uint8_t bank;uint16_t tiles;const uint8_t *data;} CutscenePortrait;
extern const CutscenePortrait cutscene_portraits[9];
#endif
''')
 (ROOT/'src/cutscene_art_data.c').write_text('#pragma bank 12\n#include "cutscene_art_data.h"\n'+''.join(decl)+'const CutscenePortrait cutscene_portraits[9]={\n'+',\n'.join(descs)+'\n};\n')
 sheet.save(out/'portraits.png');report={'source_sha256':SHA,'native_banks':list(range(116,116+len(bins))),'bank_bytes':[b['size'] for b in bins],'records':records,'limits':['Native color and resolution adaptation','Original fades and surrounding intro/ending camera sequences are separate']}
 (out/'manifest.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps({k:v for k,v in report.items() if k!='records'},indent=2))
if __name__=='__main__':main()
