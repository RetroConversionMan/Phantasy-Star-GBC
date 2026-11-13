#!/usr/bin/env python3
"""Rebuild and test the frozen baseline in an isolated sibling copy."""
from pathlib import Path
import hashlib
import json
import shutil
import subprocess
import sys

ROOT=Path(__file__).resolve().parents[1]
TRANSFER=ROOT.parent
EXPECTED='ffe3d67bb15c3d563f6f9b61e08dc166129818d99500a9af6fd8e9eb7c1b1356'

def main():
    frozen=TRANSFER/'verified-baseline'
    work=TRANSFER/'baseline-reproduction'
    if not work.exists(): shutil.copytree(frozen,work)
    manifest=json.loads((TRANSFER/'FILE_MANIFEST.json').read_text())
    def check_frozen():
        for e in manifest['files']:
            if e['path'].startswith('verified-baseline/'):
                assert hashlib.sha256((TRANSFER/e['path']).read_bytes()).hexdigest()==e['sha256'],e['path']
    check_frozen()
    subprocess.run(['make','-B','GBDK_HOME=../current-project/.tools/gbdk',f'PYTHON={sys.executable}'],cwd=work,check=True)
    rom=work/'build/phantasy-star-gbc-exploration.gbc'
    actual=hashlib.sha256(rom.read_bytes()).hexdigest()
    assert actual==EXPECTED,actual
    subprocess.run(['make','verify','GBDK_HOME=../current-project/.tools/gbdk',f'PYTHON={sys.executable}'],cwd=work,check=True)
    check_frozen()
    report={'status':'passed','sha256':actual,'baseline_unchanged':True,'gbdk':'4.5.0','rebuild_path':str(work)}
    (ROOT/'build/baseline-reproduction.json').write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps(report,indent=2))

if __name__=='__main__':main()
