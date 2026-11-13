#!/usr/bin/env python3
"""Check visible text while the production cartridge executes every story route.

Reuse the source-valid SRAM/controller routes from verify_story_ui. Observe the
real PPU output at completed dialogue pages; do not modify rendering or game
state to make a scene visible. Also run with the original ROM to locate failures.
"""
import argparse
import faulthandler
import hashlib
import json
from pathlib import Path
import shutil
import sys
import tempfile

import verify_story_ui as story

ROOT = Path(__file__).resolve().parents[1]
SEQUENCES = {
    'myau': [0xF617, 0xF646, 0xF64D, 0xF66E, 0xF6C1],
    'odin': [0xF6F3, 0xF746, 0xF786, 0xF7B9, 0xF7D1],
    'noah': [0xF85C, 0xF884],
    'opening': [0xF49B, 0xF4FC, 0xF5D5],
    'flight': [0xF929, 0xF97C],
    'ending': [0xF9E8, 0xF9F0, 0xF9FB, 0xFA06, 0xFA12, 0xFA54],
}
CLOSING_IDS = [0xBEB6, 0xBED0, 0xBEE8, 0xBEFD, 0xBF09, 0xBF21]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--rom', type=Path, required=True)
    parser.add_argument('--output', type=Path, required=True)
    parser.add_argument('--allow-invisible', action='store_true')
    args = parser.parse_args()
    out = args.output.resolve()
    out.mkdir(parents=True, exist_ok=True)
    pages, seen, sessions = [], set(), []
    base_fixture = []

    class VisibleSession(story.Session):
        def __init__(self, *a, **kw):
            self.stable_key, self.stable_count = None, 0
            self.is_closed = False
            super().__init__(*a, **kw)
            sessions.append(self)
            print('Story route:', self.rom.parent.name, flush=True)

        def boot(self):
            self.is_closed = False
            super().boot()

        def close(self):
            if not self.is_closed:
                super().close()
                self.is_closed = True

        def install(self, record):
            if not base_fixture:
                base_fixture.append(bytes(record))
            super().install(record)

        def tick(self, n=1):
            for _ in range(n):
                if self.tick_count % 100 == 0:
                    faulthandler.dump_traceback_later(45, exit=True)
                self.e.tick()
                self.tick_count += 1
                self.inspect_page()

        def inspect_page(self):
            state = self.state()
            if (state not in (4, 18, 24) or self.revealing()
                    or self.e.memory[0xFF40] & 0xA0 != 0xA0):
                self.stable_key, self.stable_count = None, 0
                return
            text_id = self.word('dialogue')
            rows = 4 if state == 18 else 2
            y = self.e.memory[0xFF4A]
            window = 0x9C00 if self.e.memory[0xFF40] & 0x40 else 0x9800
            lines = [''.join(chr(self.e.memory[0, window + (row + 1) * 32 + col + 1] + 32)
                             for col in range(18)) for row in range(rows)]
            key = (self.rom.parent.name, state, text_id, tuple(lines))
            if not any(line.strip() for line in lines):
                return
            if key == self.stable_key:
                self.stable_count += 1
            else:
                self.stable_key, self.stable_count = key, 1
            if self.stable_count < 3 or key in seen:
                return
            # Three complete native frames prevent a just-written tile from
            # being checked against the preceding scan's framebuffer.
            image = self.e.screen.image.copy().convert('RGB')
            glyphs = visible = 0
            for row, line in enumerate(lines):
                for col, char in enumerate(line):
                    if char == ' ':
                        continue
                    glyphs += 1
                    x, yy = (col + 1) * 8, y + (row + 1) * 8
                    assert yy + 8 <= 144, (key, y)
                    visible += len(image.crop((x, yy, x + 8, yy + 8)).getcolors()) > 1
            index = len(pages) + 1
            filename = f'page-{index:03d}-{text_id:04x}.png'
            image.save(out / filename)
            portrait = self.e.memory[self.s['game_cutscene'] + 4] if state == 18 else None
            pages.append({'session': self.rom.parent.name, 'state': state,
                          'text_id': text_id, 'portrait': portrait,
                          'frame': self.tick_count, 'lines': lines,
                          'glyphs': glyphs, 'visible_glyphs': visible,
                          'visible': glyphs == visible, 'image': filename})
            seen.add(key)
            print(f"Page {index}: {self.rom.parent.name} {text_id:04x}, "
                  f"{visible}/{glyphs} glyphs visible", flush=True)

    story.Session = VisibleSession
    prior_args = sys.argv
    sys.argv = [str(ROOT / 'tools/verify_story_ui.py'), str(args.rom.resolve()),
                '--output', str(out / 'routes'), '--ending-audio-guard']
    report = {'rom_sha256': hashlib.sha256(args.rom.read_bytes()).hexdigest(),
              'passed': False, 'pages': pages, 'limits': [
                  'Late-game routes start from documented SRAM fixtures; this is not an earned full campaign.',
                  'Real production ROM and controller-driven scene progression; pixel checks run in PyBoy.',
                  'Physical cartridge and audible playback remain unverified.']}
    try:
        story.main()
        # The nightmare and guest-room rest use normal dialogue, not the
        # six narrative sequences. Enter their real map triggers as well.
        extra_report = {'checks': [], 'screenshots': [], 'injected_fixtures': []}
        with tempfile.TemporaryDirectory(prefix='ps-text-extra-') as temp:
            for name in ('nightmare', 'guest-rest'):
                folder = Path(temp) / name
                folder.mkdir()
                rom = folder / 'game.gbc'
                shutil.copyfile(args.rom, rom)
                q = VisibleSession(rom, sessions[0].s, out, extra_report)
                record = bytearray(story.patch_save(
                    base_fixture[0], map_id=14, x=520 if name == 'nightmare' else 536,
                    y=320 if name == 'nightmare' else 336, party=1))
                record[104:618] = bytes(514)
                record[10:26] = bytes((1,16,0,0,0,1,16,0,8,8,0,0,0,0,0,0))
                story.seal_save(record)
                q.install(record)
                q.e.button_press('up')
                q.wait(lambda: q.state() == 4, name + ' entry')
                q.e.button_release('up')
                target = 0xaa if name == 'nightmare' else 0xb8
                for n in range(25000):
                    if q.state() == 4 and q.word('dialogue') == target:
                        break
                    if (q.state() in (4,18,24) or
                        (q.state() == 15 and q.byte('battle_view_state') in (1,5))):
                        if not q.revealing() and n % 24 == 0:
                            q.press('a', 2)
                            continue
                    q.tick()
                else:
                    raise AssertionError((name, 'did not reach return dialogue', q.state()))
                q.wait(lambda: not q.revealing(), name + ' return text')
                q.tick(3)
                q.drain(lambda: q.state() == 1, name + ' return to walking')
                ids = {p['text_id'] for p in pages if p['session'] == name}
                expected_ids = {0x29c,0x2a0,0x2a2,0xaa} if name == 'nightmare' else {0xb8}
                assert expected_ids <= ids, (name, ids)
                assert list(q.e.memory[q.s['game_rpg']:q.s['game_rpg']+2]) == [1,16]
                if name == 'nightmare':
                    assert 55 in q.items(), 'Nightmare route did not retain Letter'
                extra_report['checks'].append({'scene': name, 'text_ids': sorted(ids),
                                               'returned_to_walking': True})
                q.close()
        report['extra_scenes'] = extra_report
        records = {r['id']: bytes.fromhex(r['expanded_hex'])
                   for r in json.loads((ROOT / 'assets/dialogue/decoded.json').read_text())}
        coverage = {}
        for name, ids in SEQUENCES.items():
            observed = [p for p in pages if p['state'] == 18 and p['text_id'] in ids]
            expected = sum(records[t].count(b'\x61') + 1 for t in ids)
            assert len(observed) == expected, (name, len(observed), expected)
            assert set(p['text_id'] for p in observed) == set(ids), name
            coverage[name] = {'pages': len(observed),
                              'invisible_pages': sum(not p['visible'] for p in observed)}
        closing = [p for p in pages if p['state'] == 24]
        assert [p['text_id'] for p in closing] == CLOSING_IDS, closing
        report.update(coverage=coverage, closing_text_pages=len(closing),
                      invisible_pages=[p['image'] for p in pages if not p['visible']],
                      route_report=str(out / 'routes/report.json'))
        assert args.allow_invisible or not report['invisible_pages'], report['invisible_pages']
        report['passed'] = True
    finally:
        faulthandler.cancel_dump_traceback_later()
        sys.argv = prior_args
        (out / 'visibility-report.json').write_text(json.dumps(report, indent=2) + '\n')
        for session in sessions:
            try:
                session.close()
            except Exception:
                pass
        (out / 'visibility-report.json').write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps({k: report[k] for k in ('passed', 'coverage', 'closing_text_pages', 'invisible_pages')}, indent=2))


if __name__ == '__main__':
    main()
