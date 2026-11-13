#!/usr/bin/env python3
from pathlib import Path
import subprocess,os,re,json,hashlib
ROOT=Path(__file__).resolve().parents[1]
def main():
 out=ROOT/'build/verification';out.mkdir(exist_ok=True,parents=True)
 sources=['src/field_actions.c','src/rpg.c','src/rpg_data.c','src/battle.c','src/dungeon.c','src/dungeon_data.c','src/bank_io.c','tests/test_field_actions.c']
 binary=out/'field-actions-test'
 subprocess.run([os.environ.get('CC','cc'),'-std=c99','-Wall','-Wextra','-Werror','-Wno-unknown-pragmas','-fsanitize=address,undefined','-Isrc',*sources,'-o',str(binary)],cwd=ROOT,check=True)
 output=subprocess.check_output([str(binary)],text=True);checks=int(re.search(r'passed: (\d+)',output)[1])
 report={'passed':True,'checks':checks,'sanitizers':['address','undefined'],'scope':'Pure field/map spell and item actions; native menu/scene integration separate','verified':['Original MP timing including Rise cancel and invalid-context consumption','All256 door bytes for DungeonKey/MiracleKey/Open','All61floors*256ahead cells independently checked against original object records for Trap/Tele','Flash,Flute,Transfer,church destinations,food fullHP/dead behavior','Torch/Pot/Nuts,Prism projection and raw Myau status gates','Prepared chest Tele/Trap disarm/open without reroll'],'remaining':['Vehicle geometry delegated','Alsulin/Polymaterial delegated to event controller','Prism/Myau flight/Torch scenes emitted for caller; not animated here','Battle use of Wand/Escaper/Hat/Sphere belongs battle controller'],'inputs_sha256':{p:hashlib.sha256((ROOT/p).read_bytes()).hexdigest() for p in sources}}
 (out/'field-actions-report.json').write_text(json.dumps(report,indent=2)+'\n');print(output,end='')
if __name__=='__main__':main()
