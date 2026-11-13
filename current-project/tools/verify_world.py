#!/usr/bin/env python3
"""Walk source-map-derived routes; verify collision and visible VRAM contents."""
from collections import deque
from pathlib import Path
import argparse
import json
import shutil
import tempfile
from pyboy import PyBoy
from verify_rom import button, capture, cartridge_header, load_symbols, read_word

ROOT = Path(__file__).resolve().parents[1]
DIRS = {'right': (1, 0), 'down': (0, 1), 'left': (-1, 0), 'up': (0, -1)}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('rom', type=Path)
    args = parser.parse_args()
    header = cartridge_header(args.rom)
    symbols = load_symbols(args.rom.with_suffix('.noi'))
    collision = (ROOT / 'assets/camineet.collision').read_bytes()
    tilemap = (ROOT / 'assets/camineet.map').read_bytes()
    attrs = (ROOT / 'assets/camineet.attr').read_bytes()
    manifest = json.loads((ROOT / 'assets/manifest.json').read_text())
    output = ROOT / 'build/verification'
    output.mkdir(parents=True, exist_ok=True)
    report = {'header': header, 'routes': [], 'walls': [], 'tile_checks': 0}

    def floor(p):
        x, y = p
        return 0 <= x < 32 and 0 <= y < 24 and not collision[y * 32 + x]

    def paths(start):
        previous = {start: None}
        queue = deque([start])
        while queue:
            p = queue.popleft()
            for direction, (dx, dy) in DIRS.items():
                q = p[0] + dx, p[1] + dy
                if floor(q) and q not in previous:
                    previous[q] = (p, direction)
                    queue.append(q)
        return previous

    with tempfile.TemporaryDirectory(prefix='ps-gbc-world-') as tmp:
        rom = Path(tmp) / args.rom.name
        shutil.copyfile(args.rom, rom)
        emulator = PyBoy(str(rom), window='null', cgb=True, sound_emulated=False, log_level='ERROR')
        emulator.set_emulation_speed(0)

        def pos():
            return tuple(read_word(emulator, symbols[k]) for k in ('player_x', 'player_y'))

        def check_vram():
            cx, cy = (read_word(emulator, symbols[k]) for k in ('camera_x', 'camera_y'))
            assert emulator.memory[0xff43] == cx % 256
            assert emulator.memory[0xff42] == cy % 256
            for ty in range(cy // 8, cy // 8 + 19):
                for tx in range(cx // 8, cx // 8 + 21):
                    address = 0x9800 + ty % 32 * 32 + tx % 32
                    index = ty * 64 + tx
                    expected = (tilemap[index], attrs[index]) if tx < 64 and ty < 48 else (0, 0)
                    actual = (emulator.memory[0, address], emulator.memory[1, address])
                    assert actual == expected, f'VRAM mismatch at world tile {(tx, ty)}: {actual} != {expected}'
                    report['tile_checks'] += 1

        def walk_route(start, destination):
            prev = paths(start)
            route = []
            p = destination
            while p != start:
                p, direction = prev[p]
                route.append(direction)
            route.reverse()
            current = start
            for direction in route:
                button(emulator, direction, frames=16, settle=1)
                dx, dy = DIRS[direction]
                current = current[0] + dx, current[1] + dy
                expected = current[0] * 16 + 8, current[1] * 16 + 12
                assert pos() == expected, f'Route {direction} expected {expected}, got {pos()}'
                check_vram()
            report['routes'].append({'from': start, 'to': destination, 'steps': len(route)})
            return destination

        try:
            emulator.tick(180)
            button(emulator, 'start')
            assert pos() == (manifest['map']['start_x'], manifest['map']['start_y'])
            check_vram()
            # Align to a clear point in the initial source metatile via real input.
            current = pos()[0] // 16, (pos()[1] - 2) // 16
            target_y = current[1] * 16 + 12
            button(emulator, 'up', frames=pos()[1] - target_y, settle=1)
            reachable = paths(current)
            report['reachable_floor_cells'] = len(reachable)
            destinations = []
            for key in (lambda p: p[0] + p[1], lambda p: -p[0] + p[1],
                        lambda p: p[0] - p[1], lambda p: -p[0] - p[1]):
                q = min(reachable, key=key)
                if q not in destinations:
                    destinations.append(q)
            for i, destination in enumerate(destinations):
                current = walk_route(current, destination)
                capture(emulator, output / f'world-route-{i}.png')

            # Every direction must stop against a blocked source metatile.
            for direction, (dx, dy) in DIRS.items():
                candidates = [p for p in reachable if not floor((p[0] + dx, p[1] + dy))]
                destination = min(candidates, key=lambda p: abs(current[0] - p[0]) + abs(current[1] - p[1]))
                current = walk_route(current, destination)
                before = pos()
                button(emulator, direction, frames=32, settle=1)
                wall = pos()
                button(emulator, direction, frames=32, settle=1)
                assert pos() == wall, f'{direction} failed to stop at a wall'
                assert 0 <= abs(wall[0] - before[0]) + abs(wall[1] - before[1]) < 16
                check_vram()
                report['walls'].append({'direction': direction, 'from': before, 'stopped': wall})
                distance = abs(wall[0] - before[0]) + abs(wall[1] - before[1])
                if distance:
                    reverse = {'right': 'left', 'left': 'right', 'up': 'down', 'down': 'up'}[direction]
                    button(emulator, reverse, frames=distance, settle=1)
                assert pos() == before
            report['status'] = 'passed'
        finally:
            emulator.stop(False)
    (output / 'world-report.json').write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps(report, indent=2))


if __name__ == '__main__':
    main()
