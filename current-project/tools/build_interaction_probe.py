#!/usr/bin/env python3
from pathlib import Path
import subprocess,hashlib,json,argparse,sys
HERE=Path(__file__).resolve().parents[1]
a=argparse.ArgumentParser();a.add_argument('--snapshot',type=Path,required=True);args=a.parse_args();P=args.snapshot.resolve()
s=(P/'src/main.c').read_text();s=s[:s.index('void main(void) {')]+ '\n#include "ending_walk.h"\n'+(HERE/'tests/interaction_probe_driver.inc').read_text();(P/'build/interaction_probe.c').write_text(s)
lcc='../../../.tools/gbdk/bin/lcc'
subprocess.run([lcc,'-msm83:gb','-DPS_DUNGEON_LEAN','-DPS_DUNGEON_MOTION','-Isrc','-c','-o','build/interaction_probe.o','build/interaction_probe.c'],cwd=P,check=True)
objects=[str(v.relative_to(P))for v in sorted((P/'build/obj').glob('*.o'))if v.name!='main.o']
subprocess.run([lcc,'-msm83:gb','-Wm-yC','-Wm-yt0x1b','-Wm-yo256','-Wm-ya1','-Wm-ynINTERACTION','-Wl-m','-Wl-j','-o','build/interaction-probe.gbc']+objects+['build/interaction_probe.o'],cwd=P,check=True)
subprocess.run([sys.executable,str(HERE/'tools/verify_layout.py'),str(P/'build/interaction-probe.gbc')],check=True)
print(json.dumps({'probe_sha256':hashlib.sha256((P/'build/interaction-probe.gbc').read_bytes()).hexdigest()}))
