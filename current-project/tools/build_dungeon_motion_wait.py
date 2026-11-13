#!/usr/bin/env python3
"""Build only the narrower intermediate-pose wait change atop frozen30fcd2fe."""
import hashlib,json,shutil,subprocess
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1];BASE=ROOT/'build/motion-integration';OUT=ROOT/'build/motion-wait-integration';FROZEN=ROOT/'build/source-snapshots/dungeon-motion-candidate'
def main():
 manifest=json.loads((FROZEN/'manifest.json').read_text());assert manifest['sha256']=='30fcd2fe47b494532202629444ace2aa25cc881fec2ea8273a70258f29bad9f5'
 assert hashlib.sha256((BASE/'motion-integration.gbc').read_bytes()).hexdigest()==manifest['sha256']
 shutil.copytree(FROZEN/'src',OUT/'src',dirs_exist_ok=True);shutil.copyfile(ROOT/'src/dungeon_present.c',OUT/'src/dungeon_present.c');(OUT/'obj').mkdir(exist_ok=True)
 subprocess.run(['.tools/gbdk/bin/lcc','-msm83:gb','-DPS_DUNGEON_LEAN','-DPS_DUNGEON_MOTION','-c','-o',str((OUT/'obj/dungeon_present.o').relative_to(ROOT)),str((OUT/'src/dungeon_present.c').relative_to(ROOT))],cwd=ROOT,check=True)
 objects=[str(((OUT if n=='src/dungeon_present.c'else BASE)/'obj'/(Path(n).stem+'.o')).relative_to(ROOT))for n in manifest['compiled_sources']]
 rom=OUT/'motion-wait.gbc';subprocess.run(['.tools/gbdk/bin/lcc','-msm83:gb','-Wm-yC','-Wm-yt0x1b','-Wm-yo256','-Wm-ya1','-Wm-ynPSGBC-WORLD','-Wl-m','-Wl-j','-o',str(rom.relative_to(ROOT)),*objects],cwd=ROOT,check=True)
 subprocess.run(['../../.venv-transfer/bin/python','tools/verify_layout.py',str(rom.relative_to(ROOT))],cwd=ROOT,check=True)
 manifest.update(candidate=str(rom.relative_to(ROOT)),sha256=hashlib.sha256(rom.read_bytes()).hexdigest(),base_sha256=manifest['sha256'],changes=['src/dungeon_present.c:keep frame0 wait; omit nonzero pose wait','cartridge title PSGBC-WORLD'])
 manifest['sources']={str(p.relative_to(OUT)):hashlib.sha256(p.read_bytes()).hexdigest()for p in sorted((OUT/'src').glob('*'))};(OUT/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n');print(manifest['sha256'])
if __name__=='__main__':main()
