#!/usr/bin/env python3
"""Source-branch service state-machine tests; not a campaign playthrough."""
from pathlib import Path
import json
import subprocess
import tempfile
ROOT=Path(__file__).resolve().parents[1]
def main():
    with tempfile.TemporaryDirectory(prefix='ps-services-') as tmp:
        binary=Path(tmp)/'services'
        sources=['tests/test_services.c','src/services.c','src/events.c','src/events_data.c','src/rpg.c','src/rpg_data.c']
        subprocess.run(['clang','-std=c99','-Wall','-Wextra','-Werror','-fsanitize=address,undefined','-g','-I',str(ROOT/'src'),'-o',str(binary)]+[str(ROOT/p) for p in sources],check=True)
        result=subprocess.run([str(binary)],text=True,capture_output=True)
        if result.returncode:raise SystemExit(result.stderr or result.stdout)
        report=json.loads(result.stdout);report['sanitizers']=['address','undefined'];report['emulator_tested']=False
        out=ROOT/'build/verification/services-report.json';out.parent.mkdir(parents=True,exist_ok=True);out.write_text(json.dumps(report,indent=2)+'\n')
        print(json.dumps(report,indent=2))
if __name__=='__main__':main()
