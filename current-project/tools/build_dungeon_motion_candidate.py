#!/usr/bin/env python3
"""Build an isolated production-motion candidate without replacing canonical ROM."""
import concurrent.futures,hashlib,json,re,shutil,subprocess
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1];OUT=ROOT/'build/motion-integration'
FROZEN=ROOT/'build/source-snapshots/enemy-magic-sale-candidate/src'
PINNED={'battle.c','rpg.h','battle_view.c','battle_view.h','battle_scene.c','battle_scene.h','battle_motion.c','battle_motion.h','enemy_magic.c','enemy_magic.h','enemy_magic_data.h','enemy_magic_bank_252.c','enemy_magic_bank_253.c','services.c'}
def main():
 text=(ROOT/'Makefile').read_text().replace('\\\n',' ');value=re.search(r'^SOURCES := (.*)$',text,re.M)[1]
 value=re.sub(r'\$\(wildcard ([^)]+)\)',lambda m:' '.join(str(p.relative_to(ROOT))for pattern in m[1].split()for p in sorted(ROOT.glob(pattern))),value)
 names=value.split();names=[n for n in names if n not in('src/dungeon_graphics.c','src/dungeon_views.c') and not re.fullmatch(r'src/dungeon_(?:graphics|views)_\d+\.c',n)]
 names+=['src/dungeon_motion.c','src/dungeon_motion_upload.c','src/dungeon_motion_data.c','src/dungeon_present.c','src/dungeon_production_data.c','src/dungeon_production_tables.c','src/enemy_magic.c','src/enemy_magic_bank_252.c','src/enemy_magic_bank_253.c']+[str(p.relative_to(ROOT))for p in sorted((ROOT/'src').glob('dungeon_motion_bank_*.c'))]
 names=list(dict.fromkeys(names));(OUT/'src').mkdir(parents=True,exist_ok=True);(OUT/'obj').mkdir(exist_ok=True)
 for n in names+[str(p.relative_to(ROOT))for p in (ROOT/'src').glob('*.h')]:
  dest=OUT/'src'/Path(n).name
  source=FROZEN/Path(n).name if Path(n).name in PINNED else ROOT/n
  if Path(n).name in('battle_view.c','battle_view.h'):source=ROOT/'build/source-snapshots/item-chronology-candidate/src'/Path(n).name
  if not dest.exists()or dest.read_bytes()!=source.read_bytes():shutil.copyfile(source,dest)
 def latest_dependency(path,seen=None):
  seen=set()if seen is None else seen
  if path in seen:return 0
  seen.add(path);times=[path.stat().st_mtime]
  for include in re.findall(r'^#include "([^"]+)"',path.read_text(),re.M):
   dependency=path.parent/include
   if dependency.exists():times.append(latest_dependency(dependency,seen))
  return max(times)
 def compile(n):
  source=OUT/'src'/Path(n).name;obj=OUT/'obj'/(source.stem+'.o')
  if obj.exists()and obj.stat().st_mtime>=latest_dependency(source):return str(obj.relative_to(ROOT))
  cmd=['.tools/gbdk/bin/lcc','-msm83:gb','-DPS_DUNGEON_LEAN','-DPS_DUNGEON_MOTION','-c','-o',str(obj.relative_to(ROOT)),str(source.relative_to(ROOT))]
  result=subprocess.run(cmd,cwd=ROOT,text=True,capture_output=True)
  if result.returncode:raise RuntimeError(n+'\n'+result.stdout+result.stderr)
  return str(obj.relative_to(ROOT))
 with concurrent.futures.ThreadPoolExecutor(max_workers=4)as pool:objects=list(pool.map(compile,names))
 rom=OUT/'motion-integration.gbc'
 subprocess.run(['.tools/gbdk/bin/lcc','-msm83:gb','-Wm-yC','-Wm-yt0x1b','-Wm-yo256','-Wm-ya1','-Wm-ynPSGBC-MOTION','-Wl-m','-Wl-j','-o',str(rom.relative_to(ROOT)),*objects],cwd=ROOT,check=True)
 subprocess.run(['../../.venv-transfer/bin/python','tools/verify_layout.py',str(rom.relative_to(ROOT))],cwd=ROOT,check=True)
 manifest={'candidate':str(rom.relative_to(ROOT)),'sha256':hashlib.sha256(rom.read_bytes()).hexdigest(),'production_flags':['PS_DUNGEON_LEAN','PS_DUNGEON_MOTION'],'compiled_sources':names,'pinned_battle_snapshot':'enemy-magic-sale-candidate; battle_view.c/h from item-chronology-candidate','sources':{str(p.relative_to(OUT)):hashlib.sha256(p.read_bytes()).hexdigest()for p in sorted((OUT/'src').glob('*'))},'canonical_replaced':False}
 (OUT/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n');print(json.dumps({k:v for k,v in manifest.items()if k!='sources'},indent=2))
if __name__=='__main__':main()
