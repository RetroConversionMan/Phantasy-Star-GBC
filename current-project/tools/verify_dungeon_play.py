#!/usr/bin/env python3
"""Source-derived dungeon controller checks with host memory/UB sanitizers."""
import hashlib,json,os,re,subprocess
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
SOURCES=['src/dungeon_play.c','src/dungeon.c','src/dungeon_data.c','src/bank_io.c','src/rpg.c','src/rpg_data.c','tests/test_dungeon_play.c']
def main():
    out=ROOT/'build/verification';out.mkdir(parents=True,exist_ok=True);binary=out/'dungeon-play-test'
    subprocess.run([os.environ.get('CC','cc'),'-std=c99','-O1','-Wall','-Wextra','-Werror','-Wno-unknown-pragmas',
                    '-fsanitize=address,undefined','-I'+str(ROOT/'src'),*[str(ROOT/p)for p in SOURCES],'-o',str(binary)],check=True,cwd=ROOT)
    result=subprocess.run([str(binary)],check=True,capture_output=True,text=True,cwd=ROOT)
    match=re.fullmatch(r'Dungeon controller checks passed: (\d+)\n',result.stdout);assert match,result.stdout
    report={'passed':True,'checks':int(match[1]),'sanitizers':['address','undefined'],
      'tested':['every active first-match object across front/rear views and five flag values',
                'fake-wall intermediate callbacks and dynamically resumed second step',
                'backward front/rear fixed battles with original facing changes',
                'item chest trap updates even from rear; money chest retains trap',
                'all eight escape geometry combinations, four directions and32 seeds',
                'escape bypasses current-cell fall and does not repeat backward collision check',
                'movement/turn versus door/stair/fall encounter latches',
                'entry object callbacks before dynamic light check and dark-menu continuation',
                'special transition payloads including rawFF/FE/FD/FC kind'],
      'limits':['Host controller evidence, not integrated emulator campaign evidence',
                'Fixed battle/drop and chest flag completion still depend on caller battle UI',
                'Callback replacement of the entire DungeonPlay object can discard pending continuations'],
      'inputs_sha256':{p:hashlib.sha256((ROOT/p).read_bytes()).hexdigest()for p in SOURCES}}
    (out/'dungeon-play-report.json').write_text(json.dumps(report,indent=2)+'\n');print(result.stdout,end='');print('Report: '+str(out/'dungeon-play-report.json'))
if __name__=='__main__':main()
