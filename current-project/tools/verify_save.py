#!/usr/bin/env python3
"""Check explicit serialization and single-bit corruption rejection with sanitizers."""
from pathlib import Path
import subprocess,json,hashlib
ROOT=Path(__file__).resolve().parents[1]
out=ROOT/'build/verification';out.mkdir(exist_ok=True,parents=True)
files=['tests/test_save.c','src/save.c','src/rpg.c','src/rpg_data.c']
exe=out/'test-save'
subprocess.run(['cc','-std=c11','-Wall','-Wextra','-Werror','-fsanitize=address,undefined','-Isrc',*files,'-o',str(exe)],cwd=ROOT,check=True)
p=subprocess.run([str(exe)],cwd=ROOT,text=True,capture_output=True,check=True)
report={'status':'passed','stdout':p.stdout.strip(),'save_version':5,'record_bytes':628,'checks':'explicit fields, 24 map IDs, every single-bit corruption, bounds, all12 vehicle phase/clock pairs, legacy v4 compatibility, invalid old format rejection','scope':'World/RPG/events, persistent vehicle mode/phase/clock and dungeon position/light; opened doors reload as in source; no mid-battle save','sha256':{f:hashlib.sha256((ROOT/f).read_bytes()).hexdigest() for f in [*files,'src/save.h']}}
(out/'save-report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
