#!/usr/bin/env python3
"""Sanitized terrain rules plus exact route triples from the pinned source ROM."""
from pathlib import Path
import ctypes as C,hashlib,json,subprocess
ROOT=Path(__file__).resolve().parents[1]
out=ROOT/'build/verification';out.mkdir(exist_ok=True,parents=True)
files=['src/world_rules.c','src/rpg.c','src/rpg_data.c']
exe=out/'test-world-rules'
subprocess.run(['cc','-std=c11','-Wall','-Wextra','-Werror','-fsanitize=address,undefined','-Isrc','tests/test_world_rules.c',*files,'-o',str(exe)],cwd=ROOT,check=True)
p=subprocess.run([str(exe)],text=True,capture_output=True,check=True)
lib=out/'world-rules.dylib'
subprocess.run(['cc','-std=c11','-dynamiclib','-Isrc',*files,'-o',str(lib)],cwd=ROOT,check=True)
f=C.CDLL(str(lib)).travel_route
class Action(C.Structure):_fields_=[(s,C.c_uint8)for s in ['mode','target','a','b','metatile','flags']]
f.argtypes=[C.c_uint8,*([C.POINTER(Action)]*3)];f.restype=C.c_uint8
rom=(ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes()
assert hashlib.sha256(rom).hexdigest()=='9e324e92bd833b45126861b6f1d2dcbb51251bdf3df6d563ab3a3ff784d8cf88'
symbols=(ROOT/'build/sms-reference/ps1built.sym').read_text().splitlines()
line=next(x for x in symbols if x.endswith(' LABEL_ABF'));address=int(line.split()[0].split(':')[1],16)
assert address<0x4000
for n in range(8):
    parts=[Action(),Action(),Action()];assert f(0x81+n,*[C.byref(x)for x in parts])
    actual=bytes(v for a in parts for v in [a.target,a.a,a.b])
    assert actual==rom[address+n*9:address+(n+1)*9]
    assert all(a.mode==8 for a in parts)
report={'status':'passed','stdout':p.stdout.strip(),'source_route_bytes':72,'scope':'Original terrain side effects and route endpoint triples; ship presentation not covered','sources':{f:hashlib.sha256((ROOT/f).read_bytes()).hexdigest()for f in files}}
(out/'world-rules-report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
