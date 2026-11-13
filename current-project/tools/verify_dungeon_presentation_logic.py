#!/usr/bin/env python3
"""Check source presentation checkpoints in the production controller path."""
import hashlib,json,os,re,subprocess
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
SOURCES=['src/dungeon_play.c','src/dungeon.c','src/dungeon_data.c','src/bank_io.c','src/rpg.c','src/rpg_data.c','tests/test_dungeon_presentation.c']
def main():
 out=ROOT/'build/verification/dungeon-motion';out.mkdir(parents=True,exist_ok=True);binary=out/'presentation-test'
 subprocess.run([os.environ.get('CC','cc'),'-std=c99','-O1','-Wall','-Wextra','-Werror','-Wno-unknown-pragmas','-fsanitize=address,undefined','-DPS_DUNGEON_MOTION','-Isrc',*SOURCES,'-o',str(binary)],cwd=ROOT,check=True)
 result=subprocess.run([str(binary)],capture_output=True,text=True,check=True);match=re.fullmatch(r'Dungeon presentation order checks passed: (\d+)\n',result.stdout);assert match
 report={'passed':True,'checks':int(match[1]),'sanitizers':['address','undefined'],'source_checkpoints':['forward at old position then standing at advanced cell','backward after advancing position','turn after updating direction','fake-wall intermediate callback and changed position/direction','rear enemy two left turns; rear event two right turns','normal/key/miracle door styles','stairs and open passages do not set traversal encounter latch','fall at retained position on lower floor'],'inputs':{p:hashlib.sha256((ROOT/p).read_bytes()).hexdigest()for p in SOURCES},'limit':'Presentation callbacks are recorded on host; native artwork, timing, audio and stack are separate checks.'}
 (out/'presentation-logic-report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
if __name__=='__main__':main()
