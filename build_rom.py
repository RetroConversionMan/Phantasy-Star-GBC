#!/usr/bin/env python3
"""Force-build the shipped source and compare with the accepted GBC ROM."""
from pathlib import Path
import argparse
import hashlib
import json
import os
import platform
import re
import subprocess
import sys
from datetime import datetime, timezone

EXPECTED = '0b9cee5c4cf9dca47887436237cf34ba19e76a26c79714bc64430d3f923e1133'

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--jobs', type=int, default=4)
    parser.add_argument('--gbdk', type=Path, help='GBDK 4.5.0 root, relative to this package or absolute; default bundled macOS ARM64 distribution')
    args = parser.parse_args()
    root = Path(__file__).resolve().parent
    project = root/'current-project'
    if args.jobs < 1:
        parser.error('--jobs must be positive')
    if args.gbdk is None and (platform.system(), platform.machine()) != ('Darwin', 'arm64'):
        parser.error('The bundled GBDK is macOS ARM64. Install the matching OS/CPU GBDK 4.5.0 distribution and pass --gbdk PATH; see BUILD_AND_TEST.md.')
    gbdk = args.gbdk if args.gbdk is not None else project/'.tools/gbdk'
    if not gbdk.is_absolute():
        gbdk = root/gbdk
    # The relative form avoids lcc's fixed-size absolute-path buffer issue.
    relative = os.path.relpath(gbdk.resolve(), project)
    # The frozen Makefile expands these in unquoted shell recipes. Reject
    # unsupported paths instead of interpreting whitespace or shell syntax.
    relative = relative.replace('\\', '/')
    python = sys.executable.replace('\\', '/')
    for label, value in [('package location', str(project).replace('\\', '/')),
                         ('GBDK path', relative), ('Python path', python)]:
        if not re.fullmatch(r'[A-Za-z0-9_./:+-]+', value):
            parser.error(label+' must use a short, space-free path containing only letters, digits, underscores, dots, slashes, colons, plus or minus signs. Use a separate working copy/toolchain/interpreter in such a path.')
    executable = gbdk/'bin'/('lcc.exe' if platform.system() == 'Windows' else 'lcc')
    if not executable.is_file():
        parser.error('GBDK compiler not found: '+str(executable))
    run = project/'build'/('package-rebuild-'+datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'))
    run.mkdir(parents=True)
    command = ['make','-B','-j'+str(args.jobs),'GBDK_HOME='+relative,'PYTHON='+python]
    print('Building all native modules. Log: '+str(run/'build.log'), flush=True)
    with (run/'build.log').open('w') as log:
        result = subprocess.run(command,cwd=project,stdout=log,stderr=subprocess.STDOUT)
    if result.returncode:
        print((run/'build.log').read_text()[-6000:],file=sys.stderr)
        raise SystemExit(result.returncode)
    rom = project/'build/phantasy-star-gbc-world.gbc'
    actual = hashlib.sha256(rom.read_bytes()).hexdigest()
    report = {'passed':actual == EXPECTED,'expected_sha256':EXPECTED,'actual_sha256':actual,'rom_bytes':rom.stat().st_size,'command':command,'host':platform.platform(),'python':sys.version,'log':'build.log'}
    (run/'report.json').write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps(report,indent=2))
    if not report['passed']:
        raise SystemExit('Build succeeded but differs from the accepted cartridge. Keep the report and inspect toolchain/source differences.')

if __name__ == '__main__':
    main()
