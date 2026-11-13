#!/usr/bin/env python3
"""Verify all package bytes, either in this directory or in a ZIP argument."""
from pathlib import Path, PurePosixPath
import argparse
import hashlib
import json
import stat
import zipfile

MANIFEST = 'PACKAGE_MANIFEST.json'

def require(condition, message):
    if not condition:
        raise ValueError(message)

def digest_stream(stream):
    h = hashlib.sha256()
    while data := stream.read(1024 * 1024):
        h.update(data)
    return h.hexdigest()

def safe_path(name):
    p = PurePosixPath(name)
    if not name or p.is_absolute() or '\\' in name or ':' in name or any(part in ('', '.', '..') for part in name.split('/')):
        raise ValueError('Unsafe package path: '+repr(name))
    return p

def check_manifest(data):
    require(data['format'] == 1, 'Unsupported manifest format')
    files = data['files']
    require(isinstance(files, dict) and MANIFEST not in files, 'Invalid manifest file table')
    for name, expected in files.items():
        safe_path(name)
        require(expected['bytes'] >= 0 and len(expected['sha256']) == 64, 'Invalid file metadata: '+name)
    return files

def verify_directory(root):
    files = check_manifest(json.loads((root/MANIFEST).read_text()))
    actual = set()
    for p in root.rglob('*'):
        if p.relative_to(root).parts[0] == '.git':
            continue
        require(not p.is_symlink(), 'Unexpected symbolic link: '+str(p))
        if p.is_file():
            actual.add(p.relative_to(root).as_posix())
    require(actual == set(files) | {MANIFEST}, 'Missing or unlisted files: '+str(sorted(actual ^ (set(files)|{MANIFEST}))[:20]))
    for name, expected in files.items():
        p = root/name
        require(p.stat().st_size == expected['bytes'], 'Size differs: '+name)
        with p.open('rb') as f:
            require(digest_stream(f) == expected['sha256'], 'Hash differs: '+name)
    return files

def verify_zip(path):
    with zipfile.ZipFile(path) as z:
        members = z.infolist()
        names = [m.filename for m in members]
        require(len(names) == len(set(names)), 'Duplicate ZIP member')
        for m in members:
            safe_path(m.filename.rstrip('/'))
            require(not stat.S_ISLNK(m.external_attr >> 16), 'Symbolic link in ZIP')
        roots = {name.split('/')[0] for name in names}
        require(len(roots) == 1, 'Expected one top-level package folder')
        prefix = roots.pop()+'/'
        files = check_manifest(json.loads(z.read(prefix+MANIFEST)))
        actual = {m.filename[len(prefix):] for m in members if not m.is_dir()}
        require(actual == set(files)|{MANIFEST}, 'Missing or unlisted ZIP files')
        for name, expected in files.items():
            member = z.getinfo(prefix+name)
            require(member.file_size == expected['bytes'], 'ZIP size differs: '+name)
            with z.open(member) as f:
                require(digest_stream(f) == expected['sha256'], 'ZIP hash differs: '+name)
        # Full streaming reads also check each member's ZIP CRC.
    return files

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('zip', nargs='?', type=Path)
    args = parser.parse_args()
    files = verify_zip(args.zip) if args.zip else verify_directory(Path(__file__).resolve().parent)
    print(json.dumps({'passed':True,'payload_files':len(files),'payload_bytes':sum(e['bytes'] for e in files.values()),'scope':'All package payload SHA-256 hashes and sizes; ZIP paths, duplicates and CRCs when ZIP supplied.'}, indent=2))

if __name__ == '__main__':
    main()
