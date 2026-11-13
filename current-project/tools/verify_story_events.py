#!/usr/bin/env python3
"""Source-specific story/item/search branches, distinct from campaign completion."""
from pathlib import Path
import json,subprocess,tempfile
ROOT=Path(__file__).resolve().parents[1]
def main():
 with tempfile.TemporaryDirectory(prefix='ps-story-') as tmp:
  binary=Path(tmp)/'story';sources=['tests/test_story_events.c','src/events.c','src/events_data.c','src/rpg.c','src/rpg_data.c']
  subprocess.run(['clang','-std=c99','-Wall','-Wextra','-Werror','-fsanitize=address,undefined','-g','-I',str(ROOT/'src'),'-o',str(binary)]+[str(ROOT/p) for p in sources],check=True)
  result=subprocess.run([str(binary)],text=True,capture_output=True)
  if result.returncode:raise SystemExit(result.stderr or result.stdout)
  report=json.loads(result.stdout);report['sanitizers']=['address','undefined'];report['emulator_tested']=False
  out=ROOT/'build/verification/story-events-report.json';out.parent.mkdir(parents=True,exist_ok=True);out.write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
if __name__=='__main__':main()
