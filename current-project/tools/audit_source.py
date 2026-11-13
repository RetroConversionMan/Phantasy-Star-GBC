#!/usr/bin/env python3
"""Inventory the pinned SMS disassembly; this is a lexical audit, not a translator."""
from __future__ import annotations

import argparse
from collections import Counter
import hashlib
import json
from pathlib import Path
import re
import subprocess

ROOT = Path(__file__).resolve().parents[1]
UNSUPPORTED = set('djnz ex exx im in out ini inir ind indr outi otir outd otdr ldi ldir ldd lddr cpi cpir cpd cpdr neg retn rld rrd'.split())
IO = set('in out ini inir ind indr outi otir outd otdr'.split())
MNEMONICS = set('adc add and bit call ccf cp cpl daa dec di djnz ei ex exx halt im in inc ind indr ini inir jp jr ld ldd lddr ldi ldir neg nop or otdr otir out outd outi pop push res ret reti retn rl rla rlc rlca rld rr rra rrc rrca rrd rst sbc scf set sla sll sra srl sub xor cpi cpir cpd cpdr'.split())
LABEL = re.compile(r'^([A-Za-z_][\w]*):')
INDEX = re.compile(r'\b(?:ix|iy|ixh|ixl|iyh|iyl)\b', re.I)
ALT = re.compile(r"\b(?:af|bc|de|hl)'", re.I)
CONDITION = re.compile(r'^(?:jp|call|ret)\s+(?:p|m|pe|po)(?:\s*,|\s*$)', re.I)
SPECIAL = re.compile(r'^ld\s+(?:[ir]\s*,|a\s*,\s*[ir]\s*$)', re.I)
LONG_ARITH = re.compile(r'^(?:adc|sbc)\s+hl\s*,', re.I)
ABS16 = re.compile(r'^ld\s+(?:(?:bc|de|hl)\s*,\s*\([^)]{2,}\)|\([^)]{2,}\)\s*,\s*(?:bc|de|hl))\s*$', re.I)
HEX = re.compile(r'\$([0-9a-fA-F]{4})(?![0-9a-fA-F])')
MEM = re.compile(r'\(\s*\$([0-9a-fA-F]{4})\s*\)')
PORT = re.compile(r'\bPort_[A-Za-z_0-9]+\b')
ENTRY_POINTS = {
    'startup_and_interrupts': ['_START', 'MainSetup', 'MainGameLoop', 'GameModeTbl', 'VInt', 'WaitForVInt', 'ReadJoypad'],
    'intro_and_transport': ['GameMode_InitIntro', 'GameMode_LoadIntro', 'GameMode_Intro', 'GameMode_LoadShip', 'GameMode_Ship', 'GameMode_LoadRoad', 'GameMode_Road'],
    'maps': ['GameMode_LoadMap', 'GameMode_Map', 'LABEL_576A', 'LABEL_77AC', 'Map_RunRandomBattles'],
    'dungeons': ['GameMode_LoadDungeon', 'GameMode_Dungeon', 'Dungeon_GetEncounter', 'B03_DungeonEntrancePoints', 'B03_DungeonTransitionData', 'B03_ObjectData'],
    'interaction_and_battle': ['GameMode_LoadInteraction', 'GameMode_Interaction', 'LABEL_3C1A', 'LABEL_100F', 'BattleMenu_OptionTbl', 'BattleMenu_Attack', 'BattleMenu_Talk', 'BattleMenu_Run', 'BattleMenu_Magic', 'BattleMenu_Item'],
    'menus_and_character_state': ['PlayerMenu_OptionTbl', 'PlayerMenu_Stats', 'PlayerMenu_Magic', 'PlayerMenu_Item', 'PlayerMenu_Search', 'UnlockCharacter', 'B03_AlisLevelTable', 'B03_MyauLevelTable', 'B03_OdinLevelTable', 'B03_NoahLevelTable', 'B03_ShopData'],
    'dialogue': ['ShowDialogue_B12', 'ShowDialogue_B2', 'LABEL_31D4', 'DialogueBlock'],
    'save_and_load': ['PlayerMenu_Save', 'LABEL_634', 'LABEL_73A', 'GameMode_NameInput', 'GameMode_LoadNameInput'],
    'sound': ['CallSndInit', 'CallSndUpdate', 'CallSndMute', 'Snd_InitDriver', 'Snd_SilencePSG', 'Snd_UpdateAll'],
}


def strip_comment(line: str) -> str:
    """A semicolon inside a quoted .db string is not a comment delimiter."""
    quoted = False
    escaped = False
    for i, c in enumerate(line):
        if c == '"' and not escaped:
            quoted = not quoted
        elif c == ';' and not quoted:
            return line[:i]
        escaped = c == '\\' and not escaped
    return line


def region(address: int) -> str:
    if address >= 0xFFFC:
        return 'sega_mapper_FFFC_FFFF'
    if 0xC000 <= address <= 0xDFFF:
        return 'sms_work_ram_C000_DFFF'
    if 0xE000 <= address <= 0xFFFB:
        return 'sms_ram_mirror_E000_FFFB'
    if 0x8000 <= address <= 0xBFFF:
        return 'sms_rom_window2_8000_BFFF'
    if 0x4000 <= address <= 0x7FFF:
        return 'sms_rom_window1_4000_7FFF'
    return 'sms_rom_window0_0000_3FFF'


def inventory(source: Path) -> dict:
    files = []
    symbols = {}
    aggregate = Counter()
    all_mnemonics = Counter()
    all_unsupported = Counter()
    all_ports = Counter()
    all_hazards = Counter()
    for path in sorted(source.rglob('*.asm')):
        rel = path.relative_to(source).as_posix()
        raw = path.read_bytes()
        lines = raw.decode('utf-8-sig').splitlines()
        opcodes, unsupported, ports = Counter(), Counter(), Counter()
        hazards, numeric_regions, memory_regions = Counter(), Counter(), Counter()
        examples = {}
        label_count = data_lines = 0
        for number, original in enumerate(lines, 1):
            text = strip_comment(original).strip()
            match = LABEL.match(text)
            if match:
                label_count += 1
                symbols[match[1]] = {'file': rel, 'line': number}
                text = text[match.end():].strip()
            text = re.sub(r'^[+-]+(?::|(?=\s|$))\s*', '', text)
            if not text:
                continue
            if text.startswith('.'):
                if re.match(r'\.(?:db|dw|dsb|dsw|incbin)\b', text, re.I):
                    data_lines += 1
                continue
            op = text.split(None, 1)[0].lower()
            if op not in MNEMONICS:
                continue
            opcodes[op] += 1
            kinds = []
            if op in UNSUPPORTED:
                unsupported[op] += 1
                kinds.append('unsupported_mnemonic')
            if op in IO:
                kinds.append('port_io_instruction')
            if INDEX.search(text):
                kinds.append('ix_iy_register_instruction')
            if ALT.search(text) or op == 'exx':
                kinds.append('alternate_register_instruction')
            if CONDITION.search(text):
                kinds.append('unsupported_condition_flag')
            if SPECIAL.search(text):
                kinds.append('i_or_r_register_instruction')
            if LONG_ARITH.search(text):
                kinds.append('adc_sbc_hl_instruction')
            if ABS16.search(text):
                kinds.append('absolute_16bit_load_instruction')
            for kind in kinds:
                hazards[kind] += 1
                sample = examples.setdefault(kind, [])
                if len(sample) < 5:
                    sample.append({'line': number, 'instruction': text})
            ports.update(PORT.findall(text))
            numeric_regions.update(region(int(h, 16)) for h in HEX.findall(text))
            memory_regions.update(region(int(h, 16)) for h in MEM.findall(text))
        item = {
            'path': rel, 'sha256': hashlib.sha256(raw).hexdigest(),
            'bytes': len(raw), 'lines': len(lines), 'labels': label_count,
            'data_directive_lines': data_lines, 'instructions': sum(opcodes.values()),
            'mnemonics': dict(sorted(opcodes.items())),
            'unsupported_mnemonics': dict(sorted(unsupported.items())),
            'port_symbol_references': dict(sorted(ports.items())),
            'porting_hazards': dict(sorted(hazards.items())),
            'numeric_operand_regions': dict(sorted(numeric_regions.items())),
            'literal_memory_operand_regions': dict(sorted(memory_regions.items())),
            'hazard_examples': examples,
        }
        files.append(item)
        aggregate.update({k: item[k] for k in ('bytes', 'lines', 'labels', 'data_directive_lines', 'instructions')})
        all_mnemonics.update(opcodes)
        all_unsupported.update(unsupported)
        all_ports.update(ports)
        all_hazards.update(hazards)
    try:
        commit = subprocess.check_output(['git', '-C', str(source), 'rev-parse', 'HEAD'], text=True).strip()
    except (OSError, subprocess.CalledProcessError):
        commit = None
    rom = source / 'ps1original.sms'
    report = {
        'format_version': 1,
        'repository': 'https://github.com/sung3r/ps1disasm',
        'commit': commit,
        'method': 'Lexical audit of .asm source, excluding comments and assembler directives from instruction counts. Hazard categories overlap; references are not runtime frequencies. Numeric operands are address candidates, not proven memory accesses. No macros or expressions are evaluated.',
        'source_file_count': len(files),
        'totals': dict(aggregate),
        'mnemonics': dict(sorted(all_mnemonics.items())),
        'unsupported_mnemonics': dict(sorted(all_unsupported.items())),
        'port_symbol_references': dict(sorted(all_ports.items())),
        'porting_hazards': dict(sorted(all_hazards.items())),
        'game_mode_symbols': {k: v for k, v in symbols.items() if k.startswith('GameMode_')},
        'entry_points': {group: {name: symbols.get(name) for name in names} for group, names in ENTRY_POINTS.items()},
        'files': files,
    }
    if rom.exists():
        data = rom.read_bytes()
        report['reference_rom'] = {'path': rom.name, 'bytes': len(data), 'sha256': hashlib.sha256(data).hexdigest()}
    return report


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--source', type=Path, default=ROOT / 'upstream/ps1disasm')
    parser.add_argument('--output', type=Path, default=ROOT / 'build/source_audit.json')
    args = parser.parse_args()
    if not (args.source / 'ps1.asm').is_file():
        parser.error('source must contain ps1.asm')
    report = inventory(args.source)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps({key: report[key] for key in ('commit', 'source_file_count', 'totals', 'porting_hazards', 'reference_rom')}, indent=2))
    print(f'Wrote {args.output}')


if __name__ == '__main__':
    main()
