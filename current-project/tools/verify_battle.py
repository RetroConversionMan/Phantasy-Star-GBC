#!/usr/bin/env python3
"""Source-derived battle and encounter regression suite, with host sanitizers."""
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess

ROOT = Path(__file__).resolve().parents[1]
BUILD = ROOT / 'build' / 'verification'
SOURCES = ['src/rpg.c', 'src/rpg_data.c', 'src/battle.c', 'tests/test_battle.c']

def main():
    BUILD.mkdir(parents=True, exist_ok=True)
    binary = BUILD / 'battle-logic-test'
    command = [os.environ.get('CC', 'cc'), '-std=c99', '-Wall', '-Wextra', '-Werror',
               '-fsanitize=address,undefined', '-I' + str(ROOT / 'src')]
    command += [str(ROOT / p) for p in SOURCES] + ['-o', str(binary)]
    subprocess.run(command, check=True, cwd=ROOT)
    result = subprocess.run([str(binary)], check=True, text=True, capture_output=True, cwd=ROOT)
    match = re.fullmatch(r'Battle logic checks passed: (\d+)\n', result.stdout)
    assert match, result.stdout
    report = {
        'passed': True, 'checks': int(match[1]),
        'sanitizers': ['address', 'undefined'],
        'tested': ['all 94 one-based encounter pools', 'all 74 nonzero enemy records',
                   'every cell of 3 planet maps with 2 vehicle states and 4 seeds',
                   'all 61 dungeon floors with 16 cell classes and 32 seeds',
                   'source 12-swap initiative and retained permutation',
                   'independent exact physical/Fire/Wind/Thunder RNG fixtures',
                   'per-hit target/applied-damage/remaining-HP traces including8targets,earlykill,DarkFalz',
                   'all 8 enemy behavior classes', 'binding and protection',
                   'Dark Falz guns/Thunder and two HP records',
                   'Lassic Crystal and byte-carry behavior', 'Medusa Mirror Shield',
                   'Golden Dragon/Myau party loss', 'talk, run and consumables',
                   'EXP/chest separation, traps and full-inventory rewards',
                   'closed-chest preparation all256chance bytes*31seeds, no reroll on decline/disarm',
                   '1184 complete deterministic basic-attack battle simulations'],
        'not_verified': ['playable emulator battle UI/audio', 'story-specific battle wrappers',
                         'dungeon escape relocation', 'vehicle/key/Nuts battle item interactions',
                         'full campaign playthrough'],
        'inputs_sha256': {p: hashlib.sha256((ROOT / p).read_bytes()).hexdigest() for p in SOURCES},
        'source_rom_sha256': hashlib.sha256((ROOT / 'upstream/ps1disasm/ps1original.sms').read_bytes()).hexdigest(),
    }
    (BUILD / 'battle-report.json').write_text(json.dumps(report, indent=2) + '\n')
    print(result.stdout, end='')
    print('Report: ' + str(BUILD / 'battle-report.json'))

if __name__ == '__main__':
    main()
