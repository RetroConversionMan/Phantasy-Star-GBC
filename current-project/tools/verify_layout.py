#!/usr/bin/env python3
"""Reject ROM bank overflow and report fixed WRAM/stack margin after linking."""
from pathlib import Path
import argparse,json,re,hashlib
p=argparse.ArgumentParser(description=__doc__);p.add_argument('rom',type=Path);args=p.parse_args()
rom=args.rom.read_bytes();banks=len(rom)//16384;areas=[];data=None;ram_end=0;seen=set()
for line in args.rom.with_suffix('.map').read_text().splitlines():
 m=re.match(r'(_CODE(?:_\d+)?|_HOME|_INITIALIZER|_GSINIT|_GSFINAL|_DATA|_INITIALIZED|_BSS)\s+([0-9A-F]+)\s+([0-9A-F]+)\s+=',line)
 if not m:continue
 name,address,size=m[1],int(m[2],16),int(m[3],16)
 # SDCC repeats an area's header when its symbol list continues on a new
 # printed page. Only identical entries are duplicates; distinct areas or
 # different extents must still participate in overlap/overflow checks.
 key=(name,address,size)
 if key in seen:continue
 seen.add(key)
 if name in ('_DATA','_INITIALIZED','_BSS'):
  if name=='_DATA':data=(address,size)
  ram_end=max(ram_end,address+size);continue
 bank=address>>16;start=address&65535;end=start+size
 assert bank<banks,(name,bank,banks)
 assert start>= (0x4000 if bank else 0x150) and end<=(0x8000 if bank else 0x4000),(name,hex(start),hex(end),'bank overflow')
 areas.append({'area':name,'bank':bank,'start':start,'bytes':size,'end':end})
for i,a in enumerate(areas):
 for b in areas[i+1:]:
  assert a['bank']!=b['bank'] or a['end']<=b['start'] or b['end']<=a['start'],('ROM overlap',a,b)
assert data is not None
end=ram_end;assert end<=0xdc00,('Less than1KiB reserved for stack',hex(end))
report={'passed':True,'rom_sha256':hashlib.sha256(rom).hexdigest(),'rom_banks':banks,'wram_start':data[0],'wram_bytes':end-data[0],'wram_end':end,'stack_address_space_reserved':0xe000-end,'rom_areas':areas}
out=args.rom.parent/'verification';out.mkdir(exist_ok=True,parents=True)
(out/'layout-report.json').write_text(json.dumps(report,indent=2)+'\n')
print(json.dumps({k:v for k,v in report.items()if k!='rom_areas'},indent=2))
