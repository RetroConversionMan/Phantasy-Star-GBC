#!/usr/bin/env python3
"""Package only native-motion lookup/palette dependencies for production."""
import hashlib,json
from extract_dungeon_graphics import ROOT,SHA,c_array

def main():
 assert hashlib.sha256((ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes()).hexdigest()==SHA
 paths=['assets/dungeon-views/dungeon_view_lookup.bin','assets/dungeon-views/dungeon_front_lookup.bin']+[f'assets/dungeon-graphics/dungeon_colors_{i:02}.bin'for i in range(12)]
 inputs=[(ROOT/p).read_bytes()for p in paths];assert [len(p)for p in inputs]==[8192,32]+[404]*12
 raw=b''.join(inputs)
 (ROOT/'src/dungeon_production_data.c').write_text('#pragma bank 20\n#include <stdint.h>\n'+c_array('dungeon_production_data',raw))
 c='#pragma bank 0\n#include "dungeon_graphics.h"\n#include "dungeon_views.h"\nextern const uint8_t dungeon_production_data[];\nconst DungeonGraphicAsset dungeon_view_index={20,dungeon_production_data},dungeon_view_front={20,dungeon_production_data+8192};\nconst DungeonGraphicAsset dungeon_graphic_palettes[12]={\n'+''.join('{20,dungeon_production_data+'+str(8224+i*404)+'},\n'for i in range(12))+'};\n'
 (ROOT/'src/dungeon_production_tables.c').write_text(c)
 report={'source_sha256':SHA,'bank':20,'bytes':len(raw),'sha256':hashlib.sha256(raw).hexdigest(),'inputs':{p:hashlib.sha256(d).hexdigest()for p,d in zip(paths,inputs)},'purpose':'Production motion dependencies only; original raw/compositor/standing assets and probes remain separate.'}
 out=ROOT/'assets/dungeon-motion/production-manifest.json';out.write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
if __name__=='__main__':main()
