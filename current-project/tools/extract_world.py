#!/usr/bin/env python3
"""Convert all 11 Phantasy Star map groups into banked native GBC assets.

Preserves original 24 map IDs, 128x96 metatile grids, tile attributes, collision
flags, and unedited suffix-sharing entrance/interaction tables. This converts
world data only; event, battle, transport, and dungeon engines remain separate.
"""
from __future__ import annotations
import argparse
import hashlib
import json
import struct
import subprocess
import sys
from collections import Counter
from pathlib import Path
from extract_assets import (address, rle, decode_tile, choose_palettes, convert_tile,
                            gbc_color, c_array, sms_rgb)

ROOT = Path(__file__).resolve().parents[1]
SOURCE_SHA256 = '9e324e92bd833b45126861b6f1d2dcbb51251bdf3df6d563ab3a3ff784d8cf88'
BASE_BANK = 32
WORLD_WIDTH, WORLD_HEIGHT = 128, 96
GROUP_COUNT, MAP_COUNT = 11, 24
GROUP_NAMES = ['Palma', 'Motavia', 'Dezolis', 'Dezolis shared map',
               'Camineet / Parolit / Spaceport', 'Palma town group 2',
               'Palma town group 3', 'Town group 4', 'Town group 5',
               'Town group 6', 'Town group 7']


def y_linear(packed: int) -> int:
    """SMS map Y has twelve cells in each sixteen-count chunk."""
    return ((packed >> 4) * 12 + (packed & 15)) % WORLD_HEIGHT


def scene_source(rom: bytes, group: int) -> dict:
    row = rom[0xDF1 + group * 14:0xDF1 + (group + 1) * 14]
    map_pointer = struct.unpack_from('<H', row)[0]
    map_bank, tile_bank = row[2], row[9]
    palette_pointer, exit_pointer = struct.unpack_from('<HH', row, 10)
    grid = bytearray(WORLD_WIDTH * WORLD_HEIGHT)
    pointers = []
    for cy in range(8):
        for cx in range(8):
            pointer = struct.unpack_from('<H', rom, address(map_bank, map_pointer) + 2 * (cy * 9 + cx))[0]
            chunk, _ = rle(rom, address(map_bank, pointer))
            if len(chunk) != 192:
                raise ValueError(f'Group {group} chunk {cx},{cy}: expected 192 cells, got {len(chunk)}')
            pointers.append(pointer)
            for y in range(12):
                start = (cy * 12 + y) * WORLD_WIDTH + cx * 16
                grid[start:start + 16] = chunk[y * 16:y * 16 + 16]
    pos = address(tile_bank, 0x87B8 if group < 4 else 0x8570)
    planes = []
    for _ in range(4):
        plane, pos = rle(rom, pos)
        planes.append(plane)
    if len(set(map(len, planes))) != 1 or len(planes[0]) % 8:
        raise ValueError('Malformed graphics bitplanes')
    tiles = bytes(b for values in zip(*planes) for b in values)
    palettes = list(rom[palette_pointer:palette_pointer + 17]) + list(rom[0xDA3:0xDA3 + 15])
    uses, definitions = Counter(), {}
    for meta, frequency in Counter(grid).items():
        words = struct.unpack_from('<HHHH', rom, address(tile_bank, 0x8000) + meta * 8)
        definitions[meta] = words
        for word in words:
            uses[word & 0x9FF] += frequency
    collisions = rom[address(3, 0xBC6F if group < 4 else 0xBD6F):
                     address(3, 0xBC6F if group < 4 else 0xBD6F) + 256]
    exits = []
    pos = address(3, exit_pointer)
    while rom[pos] != 0xFF:
        y, x, mode, target, a, b = rom[pos:pos + 6]
        if mode not in (8, 10, 12):
            raise ValueError(f'Unexpected transition mode {mode} at {pos:x}')
        # Keep a/b raw for both maps and dungeons; each target mode interprets
        # them differently. The source X/Y are normalized to actual grid cells.
        exits.append((x % 128, y_linear(y), mode, target, a, b))
        pos += 6
        if len(exits) > 255:
            raise ValueError('Unterminated entrance table')
    return dict(group=group, map_bank=map_bank, map_pointer=map_pointer, tile_bank=tile_bank,
                palette_pointer=palette_pointer, exit_pointer=exit_pointer,
                grid=bytes(grid), source_tiles=tiles, source_palettes=palettes,
                definitions=definitions, uses=uses, collisions=collisions, exits=exits)


def convert_scene(source: dict) -> dict:
    keys = sorted(source['uses'])
    pixels = []
    for key in keys:
        base = 16 if key & 0x800 else 0
        pixels.append(tuple(source['source_palettes'][base + p]
                            for p in decode_tile(source['source_tiles'], key & 511)))
    palettes = choose_palettes([Counter(p) for p in pixels], [source['uses'][k] for k in keys], 7)
    graphics, converted, dedupe = bytearray(), {}, {}
    for key, tile_pixels in zip(keys, pixels):
        tile, palette = convert_tile(tile_pixels, palettes)
        if tile not in dedupe:
            dedupe[tile] = len(dedupe)
            graphics.extend(tile)
        number = dedupe[tile]
        if number >= 448:
            raise ValueError(f'Group {source["group"]} exceeds 448 graphics tiles')
        # Bank1 ids0..63 are reserved for the font. Signed BG128..255 at$8800
        # and BG64..127 at$9400 do not overlap OBJ0..83 at$8000 or the font.
        converted[key] = (number if number < 256 else number - 256 + 64,
                          palette | (8 if number >= 256 else 0))
    metas = bytearray(256 * 8)
    for meta, words in source['definitions'].items():
        for q, word in enumerate(words):
            tile, attrs = converted[word & 0x9FF]
            attrs |= (0x20 if word & 0x200 else 0) | (0x40 if word & 0x400 else 0)
            metas[meta * 8 + q * 2:meta * 8 + q * 2 + 2] = bytes((tile, attrs))
    return {**source, 'graphics': bytes(graphics), 'metatiles': bytes(metas),
            'palettes': palettes, 'tile_count': len(dedupe)}


def write_header(path: Path) -> None:
    path.write_text('''/* Generated by tools/extract_world.py. */
#ifndef PS_WORLD_ASSETS_H
#define PS_WORLD_ASSETS_H
#include <stdint.h>
#define WORLD_GROUP_COUNT 11u
#define WORLD_MAP_COUNT 24u
#define WORLD_META_WIDTH 128u
#define WORLD_META_HEIGHT 96u
#define WORLD_BANK_BASE 32u
/* x/y are normalized source metatile coordinates; source trigger is 2x2.
 * mode8: target=mapID, a=packed SMS targetY, b=targetX.
 * mode10: target=dungeonID, a=packed position, b=facing.
 * mode12: target=interaction type, a/b=unaltered interaction arguments. */
typedef struct WorldExit {
    uint8_t x,y,mode,target,a,b;
} WorldExit;
typedef struct WorldScene {
    uint8_t map_bank, asset_bank;
    uint16_t tile_count;
    const uint8_t *map;
    const uint8_t *metatiles;
    const uint8_t *collision;
    const uint8_t *tiles;
    const uint16_t *palettes;
    const WorldExit *exits;
    uint8_t exit_count;
} WorldScene;
/* Descriptors and ID mapping live in ROM0; pointed data needs bank switching. */
extern const WorldScene world_scenes[WORLD_GROUP_COUNT];
extern const uint8_t world_map_group[WORLD_MAP_COUNT];
extern const uint8_t world_map_music[WORLD_MAP_COUNT];
#endif
''')


def write_group(scene: dict, folder: Path, binary_folder: Path) -> dict:
    g = scene['group']
    prefix = f'world_g{g:02d}'
    map_bank, asset_bank = BASE_BANK + 2 * g, BASE_BANK + 2 * g + 1
    (folder / f'world_assets_{g:02d}_map.c').write_text(
        f'#pragma bank {map_bank}\n#include "world_assets.h"\n\n' + c_array(prefix + '_map', scene['grid']))
    out = f'#pragma bank {asset_bank}\n#include "world_assets.h"\n\n'
    for suffix, data in [('metatiles', scene['metatiles']), ('collision', scene['collisions']), ('tiles', scene['graphics'])]:
        out += c_array(prefix + '_' + suffix, data) + '\n'
    out += c_array(prefix + '_palettes', [gbc_color(c) for p in scene['palettes'] for c in p], 'uint16_t')
    entries = scene['exits'] or [(0, 0, 0, 0, 0, 0)]
    out += f'\nconst WorldExit {prefix}_exits[{len(entries)}] = {{\n'
    out += ',\n'.join('    {' + ','.join(f'0x{v:02x}' for v in item) + '}' for item in entries)
    out += '\n};\n'
    (folder / f'world_assets_{g:02d}_tiles.c').write_text(out)
    for suffix, data in [('map', scene['grid']), ('metatiles', scene['metatiles']),
                         ('collision', scene['collisions']), ('2bpp', scene['graphics'])]:
        (binary_folder / f'{prefix}.{suffix}').write_bytes(data)
    size = len(scene['metatiles']) + 256 + len(scene['graphics']) + 56 + len(entries) * 6
    if size > 16384:
        raise ValueError(f'Group {g} asset bank overflow: {size}')
    return dict(group=g, name=GROUP_NAMES[g], map_bank=map_bank, asset_bank=asset_bank,
                tile_count=scene['tile_count'], asset_bytes=size, map_bytes=len(scene['grid']),
                entrance_count=len(scene['exits']), entrances=scene['exits'],
                source_map_bank=scene['map_bank'], source_map_pointer=f'{scene["map_pointer"]:04X}',
                source_palette_pointer=f'{scene["palette_pointer"]:04X}',
                source_entrance_pointer=f'{scene["exit_pointer"]:04X}',
                palettes_sms_colors=scene['palettes'])


def write_index(rom: bytes, scenes: list[dict], folder: Path) -> None:
    out = '#pragma bank 0\n#include "world_assets.h"\n\n'
    for scene in scenes:
        p = f'world_g{scene["group"]:02d}'
        for suffix in ['map', 'metatiles', 'collision', 'tiles']:
            out += f'extern const uint8_t {p}_{suffix}[];\n'
        out += f'extern const uint16_t {p}_palettes[];\nextern const WorldExit {p}_exits[];\n'
    out += '\n' + c_array('world_map_group', rom[0xDC1:0xDC1 + 24])
    out += '\n' + c_array('world_map_music', rom[0xDD9:0xDD9 + 24])
    out += '\nconst WorldScene world_scenes[WORLD_GROUP_COUNT] = {\n'
    for scene in scenes:
        g, n = scene['group'], scene['tile_count']
        p = f'world_g{g:02d}'
        out += f'    {{{BASE_BANK + 2*g}, {BASE_BANK + 2*g + 1}, {n}, {p}_map, {p}_metatiles, {p}_collision, {p}_tiles, {p}_palettes, {p}_exits, {len(scene["exits"])} }},\n'
    out += '};\n'
    (folder / 'world_assets.c').write_text(out)


def preview(scene: dict, destination: Path) -> None:
    from PIL import Image
    # Build tile images once, apply the original flip attributes at use time.
    tiles = []
    for meta in range(256):
        image = Image.new('RGB', (16, 16))
        for q in range(4):
            tile, attr = scene['metatiles'][meta * 8 + q * 2:meta * 8 + q * 2 + 2]
            number = tile if not attr & 8 else tile - 64 + 256
            raw = scene['graphics'][number * 16:number * 16 + 16]
            colors = [sms_rgb(c) for c in scene['palettes'][attr & 7]]
            for y in range(8):
                for x in range(8):
                    sx, sy = (7-x if attr & 32 else x), (7-y if attr & 64 else y)
                    index = ((raw[sy*2]>>(7-sx))&1) | (((raw[sy*2+1]>>(7-sx))&1)<<1)
                    image.putpixel((q%2*8+x, q//2*8+y), colors[index])
        tiles.append(image)
    canvas = Image.new('RGB', (2048, 1536))
    for i, m in enumerate(scene['grid']):
        canvas.paste(tiles[m], (i%128*16, i//128*16))
    canvas.save(destination)


def legacy_destination_allowed(path: Path) -> bool:
    """Historical static extraction must not replace current world assets."""
    destination = path.resolve()
    protected = (ROOT/'src', ROOT/'assets/world')
    return not any(destination == base.resolve() or base.resolve() in destination.parents
                   or destination in base.resolve().parents
                   for base in protected)


def write_motion_previews(rom_path: Path, output: Path) -> None:
    # Import only when requested: extract_world_motion itself imports the
    # conversion primitives above, and importing this module must stay inert.
    from extract_world_motion import convert_motion_scene
    import world_priority
    rom = rom_path.read_bytes()
    if hashlib.sha256(rom).hexdigest() != SOURCE_SHA256:
        raise ValueError('Unsupported source ROM; hardcoded pointers require the pinned original ROM')
    for group in range(GROUP_COUNT):
        preview(convert_motion_scene(scene_source(rom, group), rom, world_priority),
                output/f'world_g{group:02d}.png')


def main(argv=None) -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--rom', type=Path, default=ROOT/'upstream/ps1disasm/ps1original.sms')
    parser.add_argument('--src', type=Path)
    parser.add_argument('--output', type=Path)
    parser.add_argument('--previews', action='store_true')
    parser.add_argument('--legacy-static', action='store_true',
                        help='Historical static conversion; requires explicit isolated --src and --output')
    args = parser.parse_args(argv)
    if args.legacy_static:
        if args.src is None or args.output is None:
            parser.error('--legacy-static requires explicit isolated --src and --output')
        if not all(legacy_destination_allowed(p) for p in (args.src, args.output)):
            parser.error('--legacy-static requires isolated destinations outside current src/assets and their parent folders')
    else:
        args.src = args.src if args.src is not None else ROOT/'src'
        args.output = args.output if args.output is not None else ROOT/'assets/world'
        subprocess.run([sys.executable, str(ROOT/'tools/extract_world_motion.py'),
                        '--rom', str(args.rom), '--src', str(args.src),
                        '--output', str(args.output),
                        '--priority-helper', str(ROOT/'tools/world_priority.py')], check=True)
        if args.previews:
            write_motion_previews(args.rom, args.output)
        return
    rom = args.rom.read_bytes()
    if hashlib.sha256(rom).hexdigest() != SOURCE_SHA256:
        raise ValueError('Unsupported source ROM; hardcoded pointers require the pinned original ROM')
    args.src.mkdir(parents=True, exist_ok=True)
    args.output.mkdir(parents=True, exist_ok=True)
    write_header(args.src/'world_assets.h')
    scenes, manifests = [], []
    for g in range(GROUP_COUNT):
        scene = convert_scene(scene_source(rom, g))
        scenes.append(scene)
        manifests.append(write_group(scene, args.src, args.output))
        if args.previews:
            preview(scene, args.output/f'world_g{g:02d}.png')
        print(f'Group {g}: {scene["tile_count"]} GBC tiles, {len(scene["exits"])} source entrances', flush=True)
    write_index(rom, scenes, args.src)
    manifest = dict(source_sha256=SOURCE_SHA256, group_count=GROUP_COUNT, map_count=MAP_COUNT,
                    metatile_width=128, metatile_height=96,
                    map_id_to_group=list(rom[0xDC1:0xDC1+24]), groups=manifests,
                    limitations=['Map graphics are static snapshots of original animated tiles.',
                                 'Original event gates and transport requirements are not executed by this data extractor.',
                                 'Original priority bit is omitted; palettes are reduced to GBC limits.'])
    (args.output/'manifest.json').write_text(json.dumps(manifest, indent=2)+'\n')


if __name__ == '__main__':
    main()
