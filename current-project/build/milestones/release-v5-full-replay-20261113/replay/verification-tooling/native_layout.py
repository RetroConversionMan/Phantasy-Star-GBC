"""Derive native EventState layout from the compiled routine in the tested ROM.

Save versions describe serialized records, not C struct layouts. In particular,
the service-only v4 build already appends EventAction.sound. Reject stale compiler
sidecars by matching the complete event_init routine, including its linked call.
"""
from pathlib import Path
import hashlib
import json
import re


def _digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def native_event_layout(rom, layout_path=None):
    """Return ROM-bound layout evidence, or validate an explicitly frozen record.

    A copied ROM without obj/events.asm must supply layout_path. The frozen record
    is accepted only for the identical ROM SHA; no save-version inference occurs.
    """
    rom = Path(rom).resolve()
    digest = _digest(rom)
    if layout_path is not None:
        record = json.loads(Path(layout_path).read_text())
        assert record['rom_sha256'] == digest, 'Native layout belongs to another ROM'
        assert record['method'] == 'compiled-event-init-exact-rom-match'
        assert record['event_state_size'] == record['event_object_flags_offset'] + 256
        return record
    asm_path = rom.parent / 'obj/events.asm'
    assembly = asm_path.read_text()
    body = re.search(r'^_event_init::?\n(.*?)(?=^_event_begin::?)', assembly,
                     re.MULTILINE | re.DOTALL).group(1)
    size = int(re.search(r'ld\s+de,\s*#0x([0-9a-f]+)\s*\n\s*push\s+de', body).group(1), 16)
    flags = re.search(r';[^\n]*s->object_flags\[0\]=255[^\n]*\n'
                      r'\s*ld\s+hl,\s*#0x([0-9a-f]+)\s*\n'
                      r'\s*add\s+hl,\s*bc\s*\n\s*ld\s+\(hl\),\s*#0xff\s*\n'
                      r'\s*ld\s+hl,\s*#0x([0-9a-f]+)', body)
    assert flags, 'Missing compiled object flag initialization'
    offset, fourth = (int(value, 16) for value in flags.groups())
    assert fourth == offset + 4 and size == offset + 256
    symbols = {}
    for line in rom.with_suffix('.noi').read_text().splitlines():
        match = re.fullmatch(r'DEF (\S+) 0x([0-9A-Fa-f]+)', line)
        if match:
            symbols[match[1]] = int(match[2], 16)
    linked = symbols['_event_init']
    bank, address = linked >> 16, linked & 65535
    assert symbols['b_event_init'] == bank and 0x4000 <= address < 0x8000
    little = lambda value: value.to_bytes(2, 'little')
    # SDCC's complete event_init: memset(sizeof), assign rpg, set object 0/4.
    # The linked memset address is resolved from this ROM's NOI, not masked out.
    expected = (bytes.fromhex('f8062a4f4611') + little(size)
                + bytes.fromhex('d5110000d5c5cd') + little(symbols['_memset'] & 65535)
                + bytes.fromhex('e806f8062a4f46210001095d54f8082a12137e1221')
                + little(offset) + bytes.fromhex('0936ff21') + little(fourth)
                + bytes.fromhex('0936ffc9'))
    file_offset = bank * 0x4000 + address - 0x4000
    actual = rom.read_bytes()[file_offset:file_offset + len(expected)]
    assert actual == expected, ('Stale compiler sidecars or unrecognized event_init',
                                str(rom), actual.hex(), expected.hex())
    assert (symbols['_event_begin'] & 65535) == address + len(expected)
    files = {'events_asm': asm_path, 'rom_symbols': rom.with_suffix('.noi')}
    for name in ('events.o', 'events.lst'):
        path = asm_path.with_name(name)
        if path.exists():
            files[name.replace('.', '_')] = path
    return {
        'rom_sha256': digest,
        'method': 'compiled-event-init-exact-rom-match',
        'event_object_flags_offset': offset,
        'event_state_size': size,
        'event_init': {'bank': bank, 'address': address, 'rom_file_offset': file_offset,
                       'bytes': len(expected), 'machine_code_hex': actual.hex()},
        'inputs': {key: {'path': str(path), 'sha256': _digest(path)}
                   for key, path in files.items()},
    }


def event_object_flags_offset(rom, layout_path=None):
    """Offset within native EventState, verified against the supplied cartridge."""
    return native_event_layout(rom, layout_path)['event_object_flags_offset']
