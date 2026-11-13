#!/usr/bin/env python3
"""Compile and run meaningful dialogue/event tests with bounds/undefined-behavior checks."""
from pathlib import Path
import json
import subprocess
import tempfile
from make_font import GLYPHS
ROOT=Path(__file__).resolve().parents[1]
def main():
    with tempfile.TemporaryDirectory(prefix='ps-events-') as tmp:
        binary=Path(tmp)/'test-events'
        sources=['tests/test_events.c','src/events.c','src/events_data.c','src/dialogue.c','src/dialogue_data.c','src/rpg.c','src/rpg_data.c']
        sources += [str(p.relative_to(ROOT)) for p in sorted((ROOT/'src').glob('dialogue_text_*.c'))]
        command=['clang','-std=c99','-Wall','-Wextra','-Werror','-fsanitize=address,undefined','-g','-I',str(ROOT/'src'),'-o',str(binary)]+[str(ROOT/p) for p in sources]
        subprocess.run(command,check=True)
        result=subprocess.run([str(binary)],text=True,capture_output=True)
        if result.returncode: raise SystemExit(result.stderr or result.stdout)
        report=json.loads(result.stdout)
        report['sanitizers']=['address','undefined'];report['emulator_tested']=False
        records=json.loads((ROOT/'assets/dialogue/decoded.json').read_text())
        characters={chr(c) if c!=64 else chr(39) for record in records for c in bytes.fromhex(record['expanded_hex']) if c<0x5b}
        assert characters<=set(GLYPHS), f'Missing font glyphs: {characters-set(GLYPHS)}'
        report['dialogue_font_characters']=len(characters)
        out=ROOT/'build/verification/events-report.json';out.parent.mkdir(parents=True,exist_ok=True)
        out.write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
if __name__=='__main__':main()
