#!/usr/bin/env python3
"""Verify extractor dispatch and isolated motion regeneration without changing production."""
import argparse
import ast
import contextlib
import hashlib
import io
import json
from pathlib import Path
import subprocess
import sys
from unittest.mock import patch

import extract_world as world

ROOT = Path(__file__).resolve().parents[1]


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def files(folder):
    return {str(p.relative_to(folder)): digest(p)
            for p in sorted(folder.rglob('*')) if p.is_file()}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, required=True)
    parser.add_argument('--reference', type=Path, required=True)
    parser.add_argument('--before-tool', type=Path, required=True)
    args = parser.parse_args()
    out = args.output.resolve()
    out.mkdir(parents=True, exist_ok=False)
    reference = args.reference.resolve()
    cases = []

    # Exercise the real parser/dispatch while intercepting only the child
    # process; no default-path generation may occur during this check.
    with patch.object(world.subprocess, 'run') as run:
        world.main([])
        expected = [sys.executable, str(ROOT/'tools/extract_world_motion.py'),
                    '--rom', str(ROOT/'upstream/ps1disasm/ps1original.sms'),
                    '--src', str(ROOT/'src'), '--output', str(ROOT/'assets/world'),
                    '--priority-helper', str(ROOT/'tools/world_priority.py')]
        run.assert_called_once_with(expected, check=True)
        cases.append('default delegates to source-motion generator with canonical options')

    with patch.object(world.subprocess, 'run') as run, \
            patch.object(world, 'write_motion_previews') as previews:
        world.main(['--rom', 'custom.sms', '--src', 'isolated/source',
                    '--output', 'isolated/assets', '--previews'])
        expected = [sys.executable, str(ROOT/'tools/extract_world_motion.py'),
                    '--rom', 'custom.sms', '--src', 'isolated/source',
                    '--output', 'isolated/assets',
                    '--priority-helper', str(ROOT/'tools/world_priority.py')]
        run.assert_called_once_with(expected, check=True)
        previews.assert_called_once_with(Path('custom.sms'), Path('isolated/assets'))
        cases.append('explicit paths and optional motion previews retain CLI semantics')

    with patch.object(world.subprocess, 'run', side_effect=subprocess.CalledProcessError(7, 'generator')), \
            patch.object(world, 'write_motion_previews') as previews:
        try:
            world.main(['--previews'])
        except subprocess.CalledProcessError as error:
            assert error.returncode == 7
        else:
            raise AssertionError('Child generator failure was swallowed')
        previews.assert_not_called()
        cases.append('generator failure propagates before previews')

    alias = out/'canonical-src-alias'
    alias.symlink_to(ROOT/'src', target_is_directory=True)
    invalid = [[], ['--src', str(out/'legacy-src')],
               ['--output', str(out/'legacy-assets')],
               ['--src', str(ROOT/'src'), '--output', str(out/'legacy-assets')],
               ['--src', str(out/'legacy-src'), '--output', str(ROOT/'assets/world')],
               ['--src', str(ROOT/'src/subdir'), '--output', str(out/'legacy-assets')],
               ['--src', str(out/'legacy-src'), '--output', str(ROOT/'assets/world/subdir')],
               ['--src', str(alias), '--output', str(out/'legacy-assets')],
               ['--src', str(ROOT), '--output', str(out/'legacy-assets')],
               ['--src', str(out/'legacy-src'), '--output', str(ROOT/'assets')]]
    for index, options in enumerate(invalid):
        with patch.object(world.subprocess, 'run') as run, contextlib.redirect_stderr(io.StringIO()):
            try:
                world.main(['--legacy-static', *options])
            except SystemExit as error:
                assert error.code == 2
            else:
                raise AssertionError(('Unsafe legacy output accepted', options))
            run.assert_not_called()
        cases.append(f'legacy isolated-output rejection {index + 1}')
    alias.unlink()

    legacy_src, legacy_assets = out/'legacy-dispatch-src', out/'legacy-dispatch-assets'
    with patch.object(world.subprocess, 'run') as run, \
            patch.object(world, 'scene_source', side_effect=lambda rom, group: group), \
            patch.object(world, 'convert_scene', side_effect=lambda group: {'tile_count': 0, 'exits': []}) as convert, \
            patch.object(world, 'write_header'), patch.object(world, 'write_group', return_value={}), \
            patch.object(world, 'write_index'), contextlib.redirect_stdout(io.StringIO()):
        world.main(['--legacy-static', '--src', str(legacy_src), '--output', str(legacy_assets)])
        run.assert_not_called()
        assert convert.call_count == 11
        assert 'static snapshots' in (legacy_assets/'manifest.json').read_text()
        cases.append('explicit isolated legacy mode retains static conversion dispatch')

    before = ast.parse(args.before_tool.read_text())
    after = ast.parse((ROOT/'tools/extract_world.py').read_text())
    functions = lambda tree: {n.name: ast.dump(n, include_attributes=False)
                              for n in tree.body if isinstance(n, ast.FunctionDef) and n.name != 'main'}
    old_functions, new_functions = functions(before), functions(after)
    assert all(new_functions[name] == value for name, value in old_functions.items())
    cases.append(f'all {len(old_functions)} imported conversion primitives unchanged')

    protected = {name: files(ROOT/name) for name in ('src', 'assets/world')}
    rom_before = digest(ROOT/'build/phantasy-star-gbc-world.gbc')
    command = [sys.executable, str(ROOT/'tools/extract_world.py'),
               '--src', str(out/'src'), '--output', str(out/'assets')]
    with (out/'generation.log').open('w') as log:
        subprocess.run(command, cwd=ROOT, check=True, stdout=log, stderr=subprocess.STDOUT)
    actual = {name: files(out/name) for name in ('src', 'assets')}
    expected = {name: files(reference/name) for name in ('src', 'assets')}
    assert actual == expected, 'Wrapper regeneration differs from the verified direct motion generator'
    assert len(actual['src']) == 28 and len(actual['assets']) == 46
    assert protected == {name: files(ROOT/name) for name in protected}
    assert rom_before == digest(ROOT/'build/phantasy-star-gbc-world.gbc')
    report = {
        'passed': True, 'dispatch_cases': cases, 'dispatch_case_count': len(cases),
        'source_count': 28, 'asset_count': 46, 'source_files': actual['src'], 'assets': actual['assets'],
        'reference': str(reference), 'reference_report_sha256': digest(reference/'report.json'),
        'production_rom_sha256': rom_before, 'production_source_assets_rom_unchanged': True,
        'inputs_sha256': {name: digest(ROOT/name) for name in (
            'tools/extract_world.py', 'tools/extract_world_motion.py', 'tools/world_priority.py',
            'tools/verify_world_extract_cli.py', 'upstream/ps1disasm/ps1original.sms')},
        'before_tool_sha256': digest(args.before_tool),
        'command': command,
        'scope': 'CLI/parser guards and isolated source-motion regeneration; no ROM rebuild or campaign claim. Legacy data conversion primitives are AST-identical; legacy dispatch is mocked and does not claim a new full legacy extraction.'}
    (out/'report.json').write_text(json.dumps(report, indent=2)+'\n')
    print(json.dumps({k: v for k, v in report.items() if k not in ('source_files', 'assets', 'command')}, indent=2))


if __name__ == '__main__':
    main()
