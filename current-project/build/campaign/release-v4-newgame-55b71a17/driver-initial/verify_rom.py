#!/usr/bin/env python3
"""Check the cartridge header and run a bounded headless GBC smoke test.

Use the project-only environment: .tools/venv/bin/python tools/verify_rom.py ROM.
Screenshots and report go to build/verification by default. Emulator saves are
isolated in a temporary directory, so this never edits a player's save file.
This checks a development build, not completion of the original game.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import re
from pathlib import Path
import shutil
import tempfile


def cartridge_header(rom: Path) -> dict:
    data = rom.read_bytes()
    if len(data) < 0x150:
        raise AssertionError('ROM is shorter than the cartridge header')
    logo = bytes.fromhex(
        'ceed6666cc0d000b03730083000c000d0008111f8889000edccc6ee6'
        'ddddd999bbbb67636e0eecccdddc999fbbb9333e'
    )
    if data[0x104:0x134] != logo:
        raise AssertionError('Cartridge boot logo is invalid')
    checksum = 0
    for value in data[0x134:0x14D]:
        checksum = (checksum - value - 1) & 255
    if checksum != data[0x14D]:
        raise AssertionError('Cartridge header checksum is invalid')
    global_sum = (sum(data[:0x14E]) + sum(data[0x150:])) & 65535
    stored_sum = int.from_bytes(data[0x14E:0x150], 'big')
    if global_sum != stored_sum:
        raise AssertionError('ROM global checksum is invalid')
    if data[0x143] not in (0x80, 0xC0):
        raise AssertionError('ROM is not marked Game Boy Color capable')
    sizes = {n: 32768 << n for n in range(9)}
    sizes.update({0x52: 72 * 16384, 0x53: 80 * 16384, 0x54: 96 * 16384})
    if sizes.get(data[0x148]) != len(data):
        raise AssertionError('Actual ROM size does not match the cartridge header')
    return {
        'title': data[0x134:0x143].split(b'\x00', 1)[0].decode('ascii', errors='replace'),
        'bytes': len(data),
        'sha256': hashlib.sha256(data).hexdigest(),
        'cgb_flag': hex(data[0x143]),
        'cartridge_type': hex(data[0x147]),
        'ram_size_code': hex(data[0x149]),
        'header_checksum': 'passed',
        'global_checksum': 'passed',
        'boot_logo': 'passed',
        'size': 'passed',
    }


def button(emulator, key: str, frames: int = 12, settle: int = 20) -> None:
    emulator.button_press(key)
    if not emulator.tick(frames):
        raise AssertionError('Emulator stopped while processing input')
    emulator.button_release(key)
    if not emulator.tick(settle):
        raise AssertionError('Emulator stopped after releasing input')


def capture(emulator, destination: Path) -> dict:
    image = emulator.screen.image.copy().convert('RGB')
    image.save(destination)
    colors = image.getcolors(160 * 144)
    return {
        'file': str(destination.resolve()),
        'sha256_pixels': hashlib.sha256(image.tobytes()).hexdigest(),
        'unique_colors': len(colors),
        'lcd_enabled': bool(emulator.memory[0xFF40] & 0x80),
        'pc': hex(emulator.register_file.PC),
    }


def read_word(emulator, address: int, width: int = 2) -> int:
    return sum(emulator.memory[address + offset] << (8 * offset) for offset in range(width))


def load_symbols(path: Path) -> dict:
    symbols = {}
    for line in path.read_text().splitlines():
        match = re.match(r"DEF\s+(\S+)\s+(?:0x)?([0-9a-fA-F]+)", line)
        if match:
            symbols[match[1].lstrip('_')] = int(match[2], 16)
    return symbols


def is_text_revealing(emulator, symbols: dict) -> bool:
    """Read-only guard for harnesses that intend to acknowledge a whole page."""
    state=emulator.memory[symbols['screen_state']]
    name='battle_view_text_revealing' if state==15 else 'dialogue_revealing'
    return state in (4,15,18,24) and name in symbols and bool(emulator.memory[symbols[name]])


def finish_new_game_intro(emulator, symbols: dict, max_frames: int = 16000) -> None:
    """Controller-only opening navigation, shared by production route tests.

    Call after choosing New Game. The baseline/older milestones have no movie
    dispatcher, so this is a no-op for them. Timing waits are never patched.
    """
    if 'game_movie_mode' not in symbols:
        return
    for tick in range(max_frames):
        state=emulator.memory[symbols['screen_state']]
        if state==1 and emulator.memory[0xff40]&128:
            before=read_word(emulator,symbols['frame_counter'])
            for _ in range(1000):
                emulator.tick(1)
                if read_word(emulator,symbols['frame_counter'])!=before:
                    return
            raise AssertionError('New-game world setup did not complete')
        if state in (18,23) and not is_text_revealing(emulator,symbols) and tick%8==0:
            button(emulator,'a',1,1)
        else:
            emulator.tick(1)
    raise AssertionError(('Opening did not reach gameplay',emulator.memory[symbols['screen_state']],emulator.memory[symbols['game_movie_stage']]))


def finish_continue_menu(emulator, symbols: dict, slot: int | None = None) -> None:
    """After title Continue, choose the actual LOAD/file controls, when present."""
    if 'save_ui_mode' not in symbols:
        return
    for _ in range(1000):
        state=emulator.memory[symbols['screen_state']]
        if state==25:
            button(emulator,'a',4,24)
        elif state==26:
            current=emulator.memory[symbols['save_ui_choice']]
            if slot is not None and current!=slot:
                button(emulator,'down' if current<slot else 'up',4,24)
            else:
                button(emulator,'a',4,24)
        elif state!=0:
            return
        else:
            emulator.tick(1)
    raise AssertionError('Continue file selection did not finish')


def confirm_existing_save(emulator, symbols: dict) -> None:
    """Choose current file and YES in the actual menu-save flow."""
    if 'save_ui_mode' not in symbols:
        return
    for _ in range(1000):
        state=emulator.memory[symbols['screen_state']]
        if state in (26,27):
            button(emulator,'a',4,24)
        elif state==8:
            return
        elif state==28:
            raise AssertionError('Expected an existing file, reached new-file naming')
        else:
            emulator.tick(1)
    raise AssertionError('Menu save did not reach confirmation')


def port_suite(args, report: dict) -> dict:
    """Check observable behavior of the native exploration build in isolation."""
    from pyboy import PyBoy
    symbol_path = args.symbols or args.rom.with_suffix('.noi')
    symbols = load_symbols(symbol_path)
    required = ('player_x', 'player_y', 'screen_state', 'saved_position_valid', 'facing')
    for name in required:
        if name not in symbols:
            raise AssertionError(f'Missing exported symbol {name} in {symbol_path}')
    output = args.output.resolve()
    output.mkdir(parents=True, exist_ok=True)
    checks = []
    screenshots = {}
    movement = []
    emulator = None
    with tempfile.TemporaryDirectory(prefix='ps-gbc-behavior-') as temp:
        test_rom = Path(temp) / args.rom.name
        save_path = Path(str(test_rom) + '.ram')
        shutil.copyfile(args.rom, test_rom)

        def boot():
            instance = PyBoy(str(test_rom), window='null', cgb=True,
                             sound_emulated=False, log_level='ERROR')
            instance.set_emulation_speed(0)
            if not instance.tick(args.boot_frames):
                raise AssertionError('Emulator stopped during boot')
            return instance

        def state():
            return emulator.memory[symbols['screen_state']]

        def position():
            return (read_word(emulator, symbols['player_x']), read_word(emulator, symbols['player_y']))

        def expect_state(expected):
            actual = state()
            if actual != expected:
                raise AssertionError(f'Expected screen state {expected}; got {actual}')

        def screenshot(name):
            snap = capture(emulator, output / f'{name}.png')
            if not snap['lcd_enabled'] or snap['unique_colors'] < 2:
                raise AssertionError(f'{name} did not render a visible screen')
            screenshots[name] = snap
            return snap

        try:
            emulator = boot()
            expect_state(0)
            assert not emulator.memory[symbols['saved_position_valid']], 'Fresh cartridge has a phantom save'
            title = screenshot('title')
            button(emulator, 'start')
            expect_state(1)
            initial_position = position()
            initial = screenshot('walk')
            assert title['sha256_pixels'] != initial['sha256_pixels'], 'Start did not change the display'
            assert not (emulator.memory[0xFF40] & 0x20), 'Window remains visible after starting walk'
            assert emulator.memory[0xFF40] & 2, 'Player sprites are hidden in walk mode'
            checks.append('Fresh cartridge reaches title; Start begins exploration')

            for direction in ('right', 'down', 'left', 'up'):
                old = position()
                button(emulator, direction, args.move_frames)
                movement.append({'direction': direction, 'before': old, 'after': position()})
                expect_state(1)
            assert any(m['before'] != m['after'] for m in movement), 'All movement is blocked at the starting position'
            screenshot('after-movement')
            checks.append('Directional input moves the 16-bit player position')

            button(emulator, 'start')
            expect_state(2)
            screenshot('menu')
            stopped_position = position()
            button(emulator, 'right', 40)
            assert position() == stopped_position, 'Player moves while the menu is open'
            button(emulator, 'b')
            expect_state(1)
            button(emulator, 'a')
            expect_state(3)
            screenshot('help')
            button(emulator, 'up', 40)
            assert position() == stopped_position, 'Player moves behind the help screen'
            button(emulator, 'b')
            expect_state(1)
            checks.append('Menu and help open/close and pause movement')

            # Save a nondefault location so a failed load cannot pass by coincidence.
            for direction in ('right', 'down', 'left', 'up'):
                if position() != initial_position:
                    break
                button(emulator, direction, args.move_frames)
            expected_position = position()
            assert expected_position != initial_position, 'Cannot save-test an unchanged starting position'
            expected_facing = emulator.memory[symbols['facing']]
            button(emulator, 'select')
            expect_state(1)
            assert emulator.memory[symbols['saved_position_valid']] == 1, 'Select did not mark a valid save'
            screenshot('saved')
            emulator.stop()
            emulator = None
            saved_bytes = save_path.read_bytes()
            assert saved_bytes[:4] == b'PSW\x01', 'Battery file does not contain the save record'
            assert int.from_bytes(saved_bytes[4:6], 'little') == expected_position[0]
            assert int.from_bytes(saved_bytes[6:8], 'little') == expected_position[1]
            emulator = boot()
            expect_state(0)
            assert emulator.memory[symbols['saved_position_valid']] == 1, 'Fresh boot rejected the valid save'
            button(emulator, 'start')
            expect_state(1)
            assert position() == expected_position, f'Continue restored {position()}, expected {expected_position}'
            assert emulator.memory[symbols['facing']] == expected_facing, 'Continue lost the facing direction'
            screenshot('continued')
            checks.append('Select saves position/facing and Continue restores them after a fresh boot')

            button(emulator, 'start')
            expect_state(2)
            button(emulator, 'down')
            button(emulator, 'a')
            expect_state(2)
            assert emulator.memory[symbols['saved_position_valid']] == 1
            button(emulator, 'down')
            button(emulator, 'a')
            expect_state(0)
            button(emulator, 'up')  # Default selection is Continue; choose New Walk.
            button(emulator, 'a')
            expect_state(1)
            assert position() == initial_position, 'New Walk failed to reset the player position'
            checks.append('Menu save/title actions work; New Walk resets to the start')
            emulator.stop(False)
            emulator = None

            for corruption in ('magic', 'checksum'):
                corrupted = bytearray(saved_bytes)
                corrupted[0 if corruption == 'magic' else 10] ^= 0xFF
                save_path.write_bytes(corrupted)
                emulator = boot()
                expect_state(0)
                assert not emulator.memory[symbols['saved_position_valid']], f'Corrupt {corruption} was accepted'
                button(emulator, 'start')
                expect_state(1)
                assert position() == initial_position, f'Corrupt {corruption} did not fall back to a new walk'
                emulator.stop(False)
                emulator = None
            checks.append('Damaged save signature and checksum are rejected without preventing a new walk')
        finally:
            if emulator is not None:
                emulator.stop(False)
    report['port_suite'] = {
        'status': 'passed', 'checks': checks,
        'initial_position': initial_position, 'saved_position': expected_position,
        'movement': movement, 'screenshots': screenshots,
        'emulator': 'PyBoy 2.9.0, accurate CGB mode, no fast_mode',
    }
    report['scope'] = 'Native exploration behavior only; original RPG/story/combat completion is not tested.'
    return report


def run(args) -> dict:
    report = {'rom': str(args.rom.resolve()), 'header': cartridge_header(args.rom)}
    if args.header_only:
        return report
    if args.port_suite:
        return port_suite(args, report)
    from pyboy import PyBoy

    output = args.output.resolve()
    output.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix='ps-gbc-test-') as temp:
        test_rom = Path(temp) / args.rom.name
        shutil.copyfile(args.rom, test_rom)

        def boot():
            emulator = PyBoy(str(test_rom), window='null', cgb=True,
                              sound_emulated=False, log_level='ERROR')
            emulator.set_emulation_speed(0)
            if not emulator.tick(args.boot_frames):
                raise AssertionError('Emulator stopped during boot')
            return emulator

        emulator = boot()
        try:
            report['boot'] = capture(emulator, output / 'boot.png')
            if not report['boot']['lcd_enabled'] or report['boot']['unique_colors'] < 2:
                raise AssertionError('Boot did not produce a visible nonblank screen')
            if args.start_button:
                button(emulator, args.start_button)
                report['started'] = capture(emulator, output / 'started.png')
            initial_position = tuple(read_word(emulator, a, args.coordinate_width) for a in args.position_addresses or [])
            if args.exercise:
                report['input'] = {}
                for direction in ('right', 'down', 'left', 'up'):
                    old = tuple(read_word(emulator, a, args.coordinate_width) for a in args.position_addresses or [])
                    button(emulator, direction, args.move_frames)
                    now = tuple(read_word(emulator, a, args.coordinate_width) for a in args.position_addresses or [])
                    snap = capture(emulator, output / f'move-{direction}.png')
                    if args.position_addresses:
                        snap.update(position_before=old, position_after=now,
                                    moved=now != old)
                    report['input'][direction] = snap
                if args.position_addresses and not any(v['moved'] for v in report['input'].values()):
                    raise AssertionError('Directional input did not change player position')
            if args.save_button:
                if not args.position_addresses:
                    raise AssertionError('Save/reload test requires position addresses')
                expected = tuple(read_word(emulator, a, args.coordinate_width) for a in args.position_addresses)
                for direction in ('right', 'down', 'left', 'up'):
                    if expected != initial_position:
                        break
                    button(emulator, direction, args.move_frames)
                    expected = tuple(read_word(emulator, a, args.coordinate_width) for a in args.position_addresses)
                if expected == initial_position:
                    raise AssertionError('Cannot test save reload at an unchanged starting position')
                button(emulator, args.save_button)
                report['saved'] = capture(emulator, output / 'saved.png')
                emulator.stop()
                emulator = boot()
                if args.load_button:
                    button(emulator, args.load_button)
                actual = tuple(read_word(emulator, a, args.coordinate_width) for a in args.position_addresses)
                if expected != actual:
                    raise AssertionError(f'Save/reload position mismatch: {expected} != {actual}')
                report['battery_save_reload'] = {
                    'status': 'passed', 'expected': expected, 'actual': actual,
                    'ram_file_bytes': Path(str(test_rom) + '.ram').stat().st_size,
                }
                report['reloaded'] = capture(emulator, output / 'reloaded.png')
        finally:
            emulator.stop(False)
    report['scope'] = 'Cartridge and development-build smoke checks; not full-game validation.'
    return report


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('rom', type=Path)
    parser.add_argument('--output', type=Path, default=Path('build/verification'))
    parser.add_argument('--header-only', action='store_true')
    parser.add_argument('--port-suite', action='store_true', help='Run exploration UI, movement, and save regressions')
    parser.add_argument('--symbols', type=Path, help='GBDK .noi file (defaults to ROM stem + .noi)')
    parser.add_argument('--coordinate-width', type=int, choices=(1,2), default=2)
    parser.add_argument('--boot-frames', type=int, default=180)
    parser.add_argument('--start-button', choices=('a', 'b', 'start', 'select'))
    parser.add_argument('--exercise', action='store_true')
    parser.add_argument('--move-frames', type=int, default=32)
    parser.add_argument('--position-addresses', type=lambda s: int(s, 0), nargs=2)
    parser.add_argument('--save-button', choices=('a', 'b', 'start', 'select'))
    parser.add_argument('--load-button', choices=('a', 'b', 'start', 'select'))
    args = parser.parse_args()
    report = run(args)
    args.output.mkdir(parents=True, exist_ok=True)
    (args.output / 'report.json').write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps(report, indent=2))


if __name__ == '__main__':
    main()
