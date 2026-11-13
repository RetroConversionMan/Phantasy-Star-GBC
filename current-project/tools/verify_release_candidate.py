#!/usr/bin/env python3
"""Run existing integrated suites and preserve only reports for the exact ROM."""
from pathlib import Path
import argparse, concurrent.futures, hashlib, json, shutil, subprocess, sys, time

ROOT=Path(__file__).resolve().parents[1]
SUITES={
 'expansion':('verify_expansion.py','expansion',[]),
 'dungeon':('verify_dungeon_emulator.py','dungeon-emulator',[]),
 'battle':('verify_integrated_battle.py','integrated-battle',[]),
 'field':('verify_field_integration.py','field-integration',[]),
 'travel':('verify_travel_integration.py','travel-integration',[]),
 'chest':('verify_chest_menu_integration.py','chest-menu-integration',[]),
 'save':('verify_save_ui.py','save-ui',[]),
 'audio':('verify_integrated_audio.py','integrated-audio',[]),
 'story':('verify_story_ui.py','story-ui/all',['--ending-audio-guard']),
 'dialogue':('verify_dialogue_input.py','dialogue-input',[]),
 'services':('verify_services_emulator.py','services-emulator',[]),
 'battle-vehicle':('verify_battle_vehicle_integration.py','battle-vehicle-integration',[]),
 'enemy-magic':('verify_enemy_magic_integration.py','enemy-magic-integration',[]),
}

def digest(path):return hashlib.sha256(path.read_bytes()).hexdigest()

def main():
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('rom',type=Path)
 p.add_argument('--output',type=Path,required=True);p.add_argument('--jobs',type=int,default=4)
 p.add_argument('--suite',action='append',choices=SUITES);a=p.parse_args()
 rom=a.rom.resolve();out=a.output.resolve();out.mkdir(parents=True,exist_ok=True)
 expected=digest(rom);selected=a.suite or list(SUITES)
 assert rom.with_suffix('.noi').is_file()
 for name in selected:assert not(out/name).exists(),('Evidence directory already exists',out/name)
 results={};started=time.monotonic()
 def verify(name):
  script,report_dir,extra=SUITES[name];case=out/name;case.mkdir()
  command=[sys.executable,str(ROOT/'tools'/script),str(rom),*extra]
  t=time.monotonic()
  with(case/'output.log').open('w')as log:run=subprocess.run(command,cwd=ROOT,stdout=log,stderr=subprocess.STDOUT)
  result={'suite':name,'script':script,'script_sha256':digest(ROOT/'tools'/script),
          'returncode':run.returncode,'seconds':round(time.monotonic()-t,2),'passed':False}
  source=ROOT/'build/verification'/report_dir
  try:
   report=json.loads((source/'report.json').read_text())
   actual=report.get('header',{}).get('sha256')
   result['reported_rom_sha256']=actual
   result['passed']=run.returncode==0 and report.get('passed')is True and actual==expected
   if actual==expected:shutil.copytree(source,case/'evidence')
   else:result['evidence_error']='Missing or stale report; report was not copied.'
  except Exception as error:result['evidence_error']=str(error)
  (case/'result.json').write_text(json.dumps(result,indent=2)+'\n')
  return name,result
 with concurrent.futures.ThreadPoolExecutor(max_workers=max(1,a.jobs))as pool:
  pending={pool.submit(verify,name):name for name in selected}
  for future in concurrent.futures.as_completed(pending):
   name=pending[future]
   try:name,result=future.result()
   except Exception as error:result={'suite':name,'passed':False,'exception':str(error)}
   results[name]=result
   print(f'{name}: {"PASS"if result["passed"]else"FAIL"}',flush=True)
   (out/'progress.json').write_text(json.dumps(results,indent=2)+'\n')
 unchanged=digest(rom)==expected
 summary={'passed':unchanged and all(r['passed']for r in results.values()),'rom':str(rom),
          'rom_sha256':expected,'rom_unchanged':unchanged,'seconds':round(time.monotonic()-started,2),
          'suites':results,'full_campaign':False,
          'scope':'Existing integrated controller and explicitly labeled fixture suites. Every preserved report must name this exact ROM. This runner does not promote or modify the tested cartridge.'}
 (out/'report.json').write_text(json.dumps(summary,indent=2)+'\n')
 if not summary['passed']:raise SystemExit(1)

if __name__=='__main__':main()
