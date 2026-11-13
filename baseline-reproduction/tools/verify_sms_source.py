#!/usr/bin/env python3
"""Assemble the pinned source in a temporary copy and demand byte identity."""
from pathlib import Path
import argparse
import hashlib
import json
import re
import shutil
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--wla-bin', type=Path, default=ROOT / '.tools/wla-dx-build/binaries')
    args = parser.parse_args()
    binaries = args.wla_bin.resolve()
    upstream = ROOT / 'upstream/ps1disasm'
    output = ROOT / 'build/sms-reference'
    output.mkdir(parents=True, exist_ok=True)
    reference = (upstream / 'ps1original.sms').read_bytes()
    with tempfile.TemporaryDirectory(prefix='ps-sms-reference-') as tmp:
        work = Path(tmp) / 'source'
        shutil.copytree(upstream, work, ignore=shutil.ignore_patterns('.git', 'binaries', 'ps1original.sms'))
        bank = work / 'banks/bank15.asm'
        text, renamed = re.subn(r'^DungeonID_(\w+):', r'Dungeon_\1:', bank.read_text(), flags=re.M)
        bank.write_text(text)
        subprocess.run([str(binaries / 'wla-z80'), '-o', 'ps1.o', 'ps1.asm'], cwd=work, check=True)
        (work / 'link.txt').write_text('[objects]\nps1.o\n')
        subprocess.run([str(binaries / 'wlalink'), '-r', '-s', 'link.txt', 'ps1built.sms'], cwd=work, check=True)
        built = (work / 'ps1built.sms').read_bytes()
        report = {
            'reference_sha256': hashlib.sha256(reference).hexdigest(),
            'assembled_sha256': hashlib.sha256(built).hexdigest(),
            'reference_bytes': len(reference), 'assembled_bytes': len(built),
            'identical': reference == built, 'labels_renamed_in_temporary_copy': renamed,
            'source_adjustment': 'Only conflicting bank15 DungeonID_ labels renamed Dungeon_; upstream untouched.',
        }
        (output / 'report.json').write_text(json.dumps(report, indent=2) + '\n')
        print(json.dumps(report, indent=2))
        if built != reference:
            raise SystemExit('Assembly does not match reference ROM.')


if __name__ == '__main__':
    main()
