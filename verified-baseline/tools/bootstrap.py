#!/usr/bin/env python3
"""Fetch the pinned source and a local GBDK toolchain without global installs."""
from pathlib import Path
import hashlib
import platform
import subprocess
import tarfile

ROOT = Path(__file__).resolve().parents[1]
COMMIT = '8efc4110adcf1a81c70d40522016393ba6f6b5ae'
VERSION = '4.5.0'
MAC_ARM_SHA256 = '289ee60e46c5a2785a21e35533f84a5131ed4a063b21b0dbdedc9a10af15bf78'


def run(*args):
    subprocess.run(args, cwd=ROOT, check=True)


def main():
    upstream = ROOT / 'upstream/ps1disasm'
    if not upstream.exists():
        upstream.parent.mkdir(exist_ok=True)
        run('git', 'clone', '--no-checkout', 'https://github.com/sung3r/ps1disasm.git', str(upstream))
        run('git', '-C', str(upstream), 'checkout', '--detach', COMMIT)
    actual = subprocess.check_output(['git', '-C', str(upstream), 'rev-parse', 'HEAD'], text=True).strip()
    if actual != COMMIT:
        raise SystemExit(f'Existing source is {actual}, expected {COMMIT}; left it unchanged.')
    tool_dir = ROOT / '.tools'
    tool_dir.mkdir(exist_ok=True)
    if (tool_dir / 'gbdk/bin/lcc').exists():
        print('Pinned source and local compiler already present.')
        return
    machine, system = platform.machine().lower(), platform.system()
    if system == 'Darwin':
        name = 'gbdk-macos-arm64.tar.gz' if machine in ('arm64', 'aarch64') else 'gbdk-macos.tar.gz'
    elif system == 'Linux':
        name = 'gbdk-linux-arm64.tar.gz' if machine in ('arm64', 'aarch64') else 'gbdk-linux64.tar.gz'
    else:
        raise SystemExit('Install GBDK 4.5.0 manually and set GBDK_HOME; automatic setup supports macOS/Linux.')
    archive = tool_dir / name
    run('curl', '--fail', '--location', f'https://github.com/gbdk-2020/gbdk-2020/releases/download/{VERSION}/{name}', '--output', str(archive))
    if name == 'gbdk-macos-arm64.tar.gz' and hashlib.sha256(archive.read_bytes()).hexdigest() != MAC_ARM_SHA256:
        raise SystemExit('GBDK download checksum mismatch; archive was not extracted.')
    with tarfile.open(archive) as tar:
        for member in tar.getmembers():
            target = (tool_dir / member.name).resolve()
            if not target.is_relative_to(tool_dir.resolve()) or member.issym() or member.islnk():
                raise SystemExit(f'Unsafe archive entry: {member.name}')
        tar.extractall(tool_dir, filter='data')
    print('Pinned source and GBDK are ready. Run make assets, then make.')


if __name__ == '__main__':
    main()
