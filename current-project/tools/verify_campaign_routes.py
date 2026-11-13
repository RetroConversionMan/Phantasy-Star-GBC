#!/usr/bin/env python3
"""Compare planned source campaign routes with the compiled native dungeon kernel.

This is a host logic test, separate from controller campaign evidence. Door
opening in this test fixture represents the appropriate source Key action.
"""
from pathlib import Path
import ctypes as C
import json
import subprocess
import tempfile
from campaign_dungeon_route import DungeonRoutes, ROOT
from verify_dungeon_logic import State, Action


def main():
    planner = DungeonRoutes()
    routes = [
        ('Naula seller', (19, 0x13, 3), (16, 0x64, 1), (255, 124, 47)),
        ('Naula return', (16, 0x64, 1), (19, 0x13, 1), None),
        ('Noah room', (30, 0x69, 1), (29, 0x68, 2), (255, 126, 0)),
        ('Noah return', (29, 0x68, 2), (30, 0x69, 3), None),
        ('Palace guard', (33, 0xd4, 0), (33, 0xa4, 0), None),
        ('Palace upstairs', (33, 0xa4, 0), (33, 0x61, 0), None),
        ('Noah-enabled Gothic passage', (0, 0xde, 0), (0, 0x2e, 0), None),
        ('Bortevo north passage', (22, 0xde, 0), (22, 0x21, 0), None),
        ('Bortevo return passage', (22, 0x21, 2), (22, 0xde, 2), None),
        ('Uzo-side Casba cave', (39, 0xd3, 0), (39, 0xdc, 2), None),
        ('Casba cave return', (39, 0xdc, 0), (39, 0xd3, 2), None),
        ('Laconia Armor through Myau Trap', (42, 0xdd, 3), (42, 0x89, 2), None),
        ('Laconia Shield', (52, 0xd3, 0), (47, 0x12, 3), None),
        ('Tarzimal original island cave', (36, 0xd9, 0), (34, 0x25, 3), None),
        ('Abion laboratory tunnel', (2, 0x12, 1), (2, 0xde, 2), None),
        ('Abion town return tunnel', (2, 0xde, 0), (2, 0x12, 3), None),
        ('Baya prison with Open', (20, 0xcb, 0), (20, 0x21, 0), None),
        ('Baya connecting cave', (0, 0x5a, 0), (0, 0x15, 3), None),
        ('Baya Crystal sage with Open', (11, 0xb9, 0), (15, 0xc4, 1), None),
        ('Baya sage to summit', (15, 0xc4, 1), (15, 0x1c, 1), None),
        ('Baya Miracle Key', (11, 0xb9, 0), (12, 0x21, 0), None),
        ('Baya Miracle Key to summit', (12, 0x21, 0), (15, 0x1c, 1), None),
        ('Castle Shadow', (57, 0xd6, 0), (53, 0xb2, 2), None),
        ('Castle Lassic', (53, 0xb2, 2), (57, 0xcc, 3), None),
        ('Final maze mandatory pitfalls', (33, 0xe6, 0), (31, 0xde, 0), None),
    ]
    command_ids = {'wait': 0, 'up': 1, 'down': 2, 'left': 3, 'right': 4}
    results = []
    with tempfile.TemporaryDirectory(prefix='ps-campaign-routes-') as temp:
        library = Path(temp) / 'dungeon.dylib'
        subprocess.run([
            'cc', '-std=c99', '-O2', '-Wno-unknown-pragmas', '-dynamiclib',
            '-o', str(library),
            *[str(ROOT / 'src' / name) for name in ('dungeon.c', 'dungeon_data.c', 'bank_io.c')],
        ], check=True)
        kernel = C.CDLL(str(library))
        for name, start, goal, room in routes:
            miracle = name.startswith(('Castle', 'Final')) or name == 'Baya Miracle Key to summit'
            route = planner.route(start, goal, items=(45,62) if miracle else (45,), avoid_objects=not name.startswith(('Laconia', 'Baya')), can_disarm=not name.startswith('Final'), allow_falls=name.startswith('Final'), can_open=name.startswith('Baya'))
            state, action = State(), Action()
            assert kernel.dungeon_enter(C.byref(state), *start)
            for row in route:
                key = row['input']
                if key == 'trap_up':
                    ahead = (state.position + planner.offsets[state.direction * 16 + 1]) & 255
                    assert state.layout[ahead] == 8 and (state.floor, ahead) not in planner.objects
                    # Host geometry fixture for the source Myau Trap action.
                    # Its MP/rules/native UI are verified separately.
                    state.layout[ahead] = 0
                    key = 'up'
                if key == 'a_up':
                    assert kernel.dungeon_step(C.byref(state), 5, C.byref(action)) == 3
                    key = 'up'
                elif key in ('key_up', 'open_up'):
                    ahead = (state.position + planner.offsets[state.direction * 16 + 1]) & 255
                    assert state.layout[ahead] & 7 in ((6,) if key == 'open_up' else (5,6) if miracle else (5,))
                    state.layout[ahead] |= 128
                    key = 'up'
                mode = kernel.dungeon_step(C.byref(state), command_ids[key], C.byref(action))
                assert [state.floor, state.position, state.direction] == row['to'], (name, row, mode)
            if room:
                assert kernel.dungeon_step(C.byref(state), 5, C.byref(action)) == 3
                assert kernel.dungeon_step(C.byref(state), 1, C.byref(action)) == 12
                assert (action.target, action.a, action.b) == room
            results.append({'name': name, 'commands': len(route), 'source_room': room})
    # Shared floors do not imply connected dungeons.
    try:
        planner.route((19, 0xde, 0), (16, 0x64, 1), items=(45,), avoid_objects=False)
    except ValueError:
        pass
    else:
        raise AssertionError('Disconnected non-Naula entrance incorrectly reaches Cake seller')
    report = {'passed': True, 'scope': 'Host geometry only; not emulator campaign progress', 'routes': results}
    output = ROOT / 'build/verification/campaign-routes'
    output.mkdir(parents=True, exist_ok=True)
    (output / 'report.json').write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps(report, indent=2))


if __name__ == '__main__':
    main()
