#!/usr/bin/env python3
"""Convert every original party pose with one shared eight-palette OBJ set."""
from pathlib import Path
import argparse,hashlib,json,sys
from collections import Counter
ROOT=next(p for p in Path(__file__).resolve().parents if (p/'upstream/ps1disasm/ps1original.sms').exists())
sys.path.insert(0,str(ROOT/'tools'))
from extract_assets import decode_tile,choose_palettes,DIST,encode_gb,gbc_color,c_array,ROM_SHA256,sms_rgb
PROJECT=Path(__file__).resolve().parents[1]
p=argparse.ArgumentParser(description=__doc__)
p.add_argument('--rom',type=Path,default=ROOT/'upstream/ps1disasm/ps1original.sms')
p.add_argument('--src',type=Path,default=PROJECT/'src')
p.add_argument('--output',type=Path,default=PROJECT/'assets/party-world')
args=p.parse_args();args.src.mkdir(parents=True,exist_ok=True);args.output.mkdir(parents=True,exist_ok=True)
rom=args.rom.read_bytes()
assert hashlib.sha256(rom).hexdigest()==ROM_SHA256
colors=bytes([0])+rom[0xda3:0xdb0]
assert list(colors)==[0,0,63,43,11,47,55,15,56,52,6,1,42,37]
spec=[('alis',0x8000,14,6),('noah',0x8a80,13,6),('odin',0x9440,14,6),('myau',0x9ec0,16,4)]
tiles=[];records=[]
for name,address,frames,width in spec:
 raw=rom[28*16384+address-0x8000:][:frames*width*32]
 decoded=[decode_tile(raw,i)for i in range(frames*width)]
 assert all(max(t)<len(colors)for t in decoded)
 records.append(dict(name=name,address=f'28:{address:04X}',frames=frames,tiles_per_frame=width,start=len(tiles)))
 tiles+=decoded
hist=[Counter(colors[c]for c in t if c)for t in tiles]
pals=choose_palettes(hist,[1]*len(hist),8,3)
data=bytearray();attrs=[];changed=opaque=0
for t,h in zip(tiles,hist):
 pid=min(range(8),key=lambda p:sum(n*min(DIST[c][v]for v in pals[p])for c,n in h.items()))
 pixels=[0 if not c else 1+min(range(3),key=lambda j:DIST[colors[c]][pals[pid][j]])for c in t]
 changed+=sum(c!=0 and colors[c]!=pals[pid][v-1]for c,v in zip(t,pixels));opaque+=sum(c!=0 for c in t)
 data+=encode_gb(pixels);attrs.append(pid)
header='''/* Generated from original28:8000/8A80/9440/9EC0; shared party palettes. */
#ifndef PS_PARTY_WORLD_DATA_H
#define PS_PARTY_WORLD_DATA_H
#include <stdint.h>
#define PARTY_WORLD_BANK 22u
extern const uint8_t party_world_tiles[4960],party_world_attrs[310];
extern const uint16_t party_world_palettes[32];
#endif
'''
assert len(data)==4960
(args.src/'party_world_data.h').write_text(header)
(args.src/'party_world_data.c').write_text('#pragma bank 22\n#include "party_world_data.h"\n'+c_array('party_world_tiles',data)+c_array('party_world_attrs',attrs)+c_array('party_world_palettes',[gbc_color(c)for p in pals for c in (0,)+p],'uint16_t'))
(args.output/'manifest.json').write_text(json.dumps(dict(source_sha256=ROM_SHA256,records=records,opaque_pixels=opaque,quantized_pixels=changed,palettes_sms=[(0,)+p for p in pals],tiles_sha256=hashlib.sha256(data).hexdigest(),attributes_sha256=hashlib.sha256(bytes(attrs)).hexdigest()),indent=2)+'\n')
print(json.dumps(dict(tiles=len(tiles),opaque=opaque,quantized=changed)))
