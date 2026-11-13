#!/usr/bin/env python3
"""Replay the production opening and check both dialogue tiles and visible glyphs.

No RAM fixtures or save writes: start a new game and acknowledge all eight
narrative pages with A. The source narrative supplies the expected text.
"""
import argparse
import hashlib
import json
from pathlib import Path

from pyboy import PyBoy
from verify_rom import load_symbols

ROOT = Path(__file__).resolve().parents[1]


def narrative_pages():
    records = {r['id']: r for r in json.loads((ROOT / 'assets/dialogue/decoded.json').read_text())}
    result = []
    for text_id in (0xF49B, 0xF4FC, 0xF5D5):
        lines, row = [''] * 4, 0
        for byte in bytes.fromhex(records[text_id]['expanded_hex']):
            if byte == 0x60:
                row += 1
            elif byte == 0x61 or 0x62 <= byte <= 0x65:
                result.append((text_id, [line.ljust(18) for line in lines]))
                lines, row = [''] * 4, 0
            else:
                lines[row] += chr(39 if byte == 64 else byte)
    return result


def window_lines(emu):
    return [''.join(chr(emu.memory[0, 0x9C00 + (row + 1) * 32 + col + 1] + 32)
                    for col in range(18)) for row in range(4)]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--rom', type=Path, default=ROOT / 'build/phantasy-star-gbc-world.gbc')
    parser.add_argument('--symbols', type=Path)
    parser.add_argument('--output', type=Path, required=True)
    parser.add_argument('--expect-invisible', action='store_true', help='Confirm the original rendering defect.')
    args = parser.parse_args()
    symbols = load_symbols(args.symbols or args.rom.with_suffix('.noi'))
    args.output.mkdir(parents=True, exist_ok=True)
    emu = PyBoy(str(args.rom), window='null', cgb=True, sound_emulated=False, log_level='ERROR')
    emu.set_emulation_speed(0)
    frame = 0
    def tick(count=1):
        nonlocal frame
        emu.tick(count)
        frame += count
    def press_a():
        emu.button_press('a')
        tick(2)
        emu.button_release('a')
        tick()
    report = {'rom_sha256': hashlib.sha256(args.rom.read_bytes()).hexdigest(),
              'expected_invisible': args.expect_invisible, 'pages': [], 'passed': False}
    try:
        tick(300)
        assert emu.memory[symbols['screen_state']] == 0, 'Fresh boot did not reach title.'
        press_a()
        for index, (text_id, expected) in enumerate(narrative_pages()):
            for _ in range(2400):
                if (emu.memory[symbols['screen_state']] == 18
                    and not emu.memory[symbols['dialogue_revealing']]
                    and window_lines(emu) == expected):
                    break
                tick()
            else:
                raise AssertionError(f'Page {index + 1} did not complete: {window_lines(emu)!r}')
            tick(2)  # Present the completed tilemap through a full rendered frame.
            assert emu.memory[0xFF40] & 0x20, 'Dialogue window is disabled.'
            assert emu.memory[0xFF4A] == 80 and emu.memory[0xFF4B] == 7
            picture = emu.screen.image.copy().convert('RGB')
            picture.save(args.output / f'page-{index + 1:02d}.png')
            glyphs = visible = 0
            for row, line in enumerate(expected):
                for col, char in enumerate(line):
                    if char == ' ':
                        continue
                    glyphs += 1
                    x, y = (col + 1) * 8, 88 + row * 8
                    colors = picture.crop((x, y, x + 8, y + 8)).getcolors()
                    visible += len(colors) > 1
            record = {'page': index + 1, 'text_id': hex(text_id), 'frame': frame,
                      'lines': expected, 'glyphs': glyphs, 'visible_glyphs': visible}
            report['pages'].append(record)
            if args.expect_invisible:
                assert visible == 0, f'Original page {index + 1} is unexpectedly visible.'
            else:
                assert visible == glyphs, f'Page {index + 1}: only {visible}/{glyphs} glyphs visible.'
            press_a()
        for _ in range(1200):
            if emu.memory[symbols['screen_state']] == 1:
                break
            tick()
        else:
            raise AssertionError('Opening did not return to playable Camineet.')
        tick(120)
        picture = emu.screen.image.copy()
        picture.save(args.output / 'world.png')
        emu.button_press('start')
        tick(2)
        emu.button_release('start')
        tick(120)
        assert emu.memory[symbols['screen_state']] == 2, 'World menu failed to open.'
        picture = emu.screen.image.copy().convert('RGB')
        assert len(picture.crop((32, 8, 128, 16)).getcolors()) > 1, 'World menu text is invisible.'
        picture.save(args.output / 'world-menu.png')
        report.update(passed=True, total_frames=frame, returned_to_world=True, world_menu_visible=True,
                      limits=['Emulator rendering; physical cartridge boot and audio not tested.'])
        print(json.dumps({'passed': True, 'pages': len(report['pages']),
                          'visible_glyphs': sum(p['visible_glyphs'] for p in report['pages']),
                          'expected_invisible': args.expect_invisible}))
    finally:
        (args.output / 'report.json').write_text(json.dumps(report, indent=2) + '\n')
        emu.stop(False)


if __name__ == '__main__':
    main()
