#!/usr/bin/env python3
"""Snapshot the project, known-good release, tools and handoff notes without mutation."""
from pathlib import Path
import datetime
import hashlib
import json
import os
import stat
import zipfile

ROOT = Path(__file__).resolve().parents[1]
TOP = 'phantasy-star-gbc-transfer/'
DEST = ROOT / 'dist/phantasy-star-gbc-complete-handoff.zip'
SKIP_DIRS = {'.git', '__pycache__', '.aws', '.codex', '.agents'}


def main():
    DEST.parent.mkdir(exist_ok=True)
    manifest = {'format': 1, 'files': [], 'exclusions': [
        'Git internal metadata; source commits are recorded in PROJECT_STATE.json',
        'Python bytecode caches and macOS .DS_Store metadata',
        'Account/configuration directories .aws, .codex, .agents',
        'Output ZIPs are not recursively embedded; the previous delivered source ZIP is preserved in history/',
    ]}
    with zipfile.ZipFile(DEST, 'w', zipfile.ZIP_DEFLATED, compresslevel=6, allowZip64=True) as z:
        def add_bytes(relative, data, mode=0o100644, kind='file'):
            info = zipfile.ZipInfo(TOP + relative, date_time=(2026, 11, 11, 0, 0, 0))
            info.create_system = 3
            info.external_attr = mode << 16
            info.compress_type = zipfile.ZIP_DEFLATED
            z.writestr(info, data)
            item = {'path': relative, 'type': kind, 'bytes': len(data), 'sha256': hashlib.sha256(data).hexdigest()}
            if kind == 'symlink':
                item['target'] = data.decode()
            manifest['files'].append(item)

        for directory, subdirs, names in os.walk(ROOT, followlinks=False):
            parent = Path(directory)
            subdirs[:] = sorted(d for d in subdirs if d not in SKIP_DIRS and not (parent == ROOT and d in {'dist', 'handoff'}))
            for name in sorted(names):
                if name == '.DS_Store' or name.endswith(('.pyc', '.pyo')):
                    continue
                path = parent / name
                rel = 'current-project/' + path.relative_to(ROOT).as_posix()
                st = path.lstat()
                if stat.S_ISLNK(st.st_mode):
                    add_bytes(rel, os.readlink(path).encode(), st.st_mode, 'symlink')
                elif stat.S_ISREG(st.st_mode):
                    add_bytes(rel, path.read_bytes(), st.st_mode)

        for path in sorted((ROOT / 'handoff').iterdir()):
            if path.is_file() and path.suffix not in ('.pyc', '.pyo'):
                add_bytes(path.name, path.read_bytes(), path.stat().st_mode)

        baseline = ROOT / 'dist/phantasy-star-gbc-exploration-source.zip'
        add_bytes('history/' + baseline.name, baseline.read_bytes())
        with zipfile.ZipFile(baseline) as previous:
            for item in previous.infolist():
                if item.is_dir():
                    continue
                prefix = 'phantasy-star-gbc/'
                if not item.filename.startswith(prefix) or '..' in Path(item.filename).parts:
                    raise ValueError('Unexpected baseline archive path')
                rel = 'verified-baseline/' + item.filename[len(prefix):]
                add_bytes(rel, previous.read(item), item.external_attr >> 16 or 0o100644)

        manifest['files'].sort(key=lambda e: e['path'])
        manifest['payload_entries'] = len(manifest['files'])
        manifest['payload_bytes'] = sum(e['bytes'] for e in manifest['files'])
        z.writestr(TOP + 'FILE_MANIFEST.json', json.dumps(manifest, indent=2) + '\n')

    h = hashlib.sha256()
    with DEST.open('rb') as f:
        while chunk := f.read(1024 * 1024):
            h.update(chunk)
    checksum = h.hexdigest()
    DEST.with_suffix('.zip.sha256').write_text(checksum + '  ' + DEST.name + '\n')
    print(json.dumps({'archive': str(DEST), 'bytes': DEST.stat().st_size,
                      'payload_entries': manifest['payload_entries'], 'payload_bytes': manifest['payload_bytes'],
                      'sha256': checksum}, indent=2))


if __name__ == '__main__':
    main()
