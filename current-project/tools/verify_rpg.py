#!/usr/bin/env python3
"""Compile and exercise native RPG rules on the host with memory/UB checking."""
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess

ROOT = Path(__file__).resolve().parents[1]
BUILD = ROOT / 'build' / 'verification'
SOURCES = ['src/rpg.c', 'src/rpg_data.c', 'tests/test_rpg.c']

def main():
    BUILD.mkdir(parents=True, exist_ok=True)
    executable = BUILD / 'rpg-logic-test'
    command = [os.environ.get('CC', 'cc'), '-std=c99', '-Wall', '-Wextra', '-Werror',
               '-fsanitize=address,undefined', '-I' + str(ROOT / 'src')]
    command += [str(ROOT / f) for f in SOURCES] + ['-o', str(executable)]
    subprocess.run(command, check=True)
    result = subprocess.run([str(executable)], check=True, text=True, capture_output=True)
    match = re.fullmatch(r'RPG logic checks passed: (\d+)\n', result.stdout)
    assert match, result.stdout
    report = {
        'passed': True, 'checks': int(match[1]), 'sanitizers': ['address', 'undefined'],
        'scope': ['initial state', 'recruitment mechanics', 'inventory bounds and replacement',
                  'equipment exchanges', 'shop options and purchases', 'vehicle duplicate charge',
                  'sell prices and money saturation', 'food and spell healing', 'rest',
                  'hospital byte-overflow fee', 'revival', 'EXP thresholds and overflow',
                  'LFSR sequence', 'direct physical damage bounds'],
        'not_verified': ['playable RPG UI', 'story recruitment prerequisites', 'battle orchestration',
                         'Secrets shop event', 'non-healing items/spells'],
        'inputs_sha256': {f: hashlib.sha256((ROOT / f).read_bytes()).hexdigest() for f in SOURCES},
        'source_rom_sha256': hashlib.sha256((ROOT / 'upstream/ps1disasm/ps1original.sms').read_bytes()).hexdigest(),
    }
    (BUILD / 'rpg-report.json').write_text(json.dumps(report, indent=2) + '\n')
    print(result.stdout, end='')
    print('Report: ' + str(BUILD / 'rpg-report.json'))

if __name__ == '__main__':
    main()
