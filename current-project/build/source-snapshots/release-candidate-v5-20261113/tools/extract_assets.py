#!/usr/bin/env python3
"""Extract the original Camineet and Alis assets for the incomplete native GBC port.

This is an asset converter, not a Z80-to-SM83 game converter. It uses the original
ROM included in sung3r/ps1disasm. Locations are checked against that disassembly:
  ps1.asm LABEL_5E8, LABEL_DF1, LABEL_3FA/407, LABEL_723D, LABEL_744B,
  LABEL_74E4/7764, LABEL_621F/6229 and LABEL_5A13/5A17.
All map/collision data comes from the source game; no replacement map is drawn.
Pillow is used only to render review images of the extracted and converted data.
"""
from __future__ import annotations

import argparse
import hashlib
import itertools
import json
import struct
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
MAP_W, MAP_H = 32, 24
ROM_SIZE = 524288
ROM_SHA256 = '9e324e92bd833b45126861b6f1d2dcbb51251bdf3df6d563ab3a3ff784d8cf88'
FRAME_ORDER = [0, 2, 4, 1, 5, 7, 9, 8, 10, 12, 11, 13]


def address(bank: int, cpu: int) -> int:
    if not 0x8000 <= cpu <= 0xBFFF:
        raise ValueError(f"Banked address outside SMS window: {cpu:04x}")
    return bank * 0x4000 + cpu - 0x8000


def rle(rom: bytes, pos: int) -> tuple[bytes, int]:
    """Zero ends stream; 1..127 repeat next byte; 128..255 copy low7 bytes."""
    out = bytearray()
    while True:
        control = rom[pos]
        pos += 1
        if control == 0:
            return bytes(out), pos
        count = control & 0x7F
        if not count:
            raise ValueError("Unexpected zero-length RLE block")
        if control & 0x80:
            out.extend(rom[pos:pos + count])
            pos += count
        else:
            out.extend([rom[pos]] * count)
            pos += 1
        if len(out) > 0x4000:
            raise ValueError("Malformed RLE stream")


def sms_rgb(color: int) -> tuple[int, int, int]:
    return ((color & 3) * 85, ((color >> 2) & 3) * 85, ((color >> 4) & 3) * 85)


def color_distance(a: int, b: int) -> int:
    ar, ag, ab = sms_rgb(a)
    br, bg, bb = sms_rgb(b)
    return 2 * (ar - br) ** 2 + 4 * (ag - bg) ** 2 + 3 * (ab - bb) ** 2


DIST = [[color_distance(a, b) for b in range(64)] for a in range(64)]


def decode_tile(raw: bytes, index: int) -> tuple[int, ...]:
    start = index * 32
    if start + 32 > len(raw):
        raise ValueError(f"Tile {index} exceeds graphics stream")
    return tuple(sum(((raw[start + y * 4 + plane] >> (7 - x)) & 1) << plane
                     for plane in range(4)) for y in range(8) for x in range(8))


def palette_candidates(histograms: list[Counter], size: int) -> list[tuple[int, ...]]:
    candidates = set()
    for hist in histograms:
        frequent = [color for color, _ in hist.most_common(size + 2)] or [0]
        if len(frequent) <= size:
            candidate = tuple(sorted(frequent))
            candidates.add(candidate + (candidate[0],) * (size - len(candidate)))
        else:
            candidates.update(tuple(sorted(c)) for c in itertools.combinations(frequent, size))
    return sorted(candidates)


def choose_palettes(histograms: list[Counter], weights: list[int], count: int,
                    size: int = 4) -> list[tuple[int, ...]]:
    """Deterministic weighted greedy palettes, optimized across all used tiles."""
    candidates = palette_candidates(histograms, size)
    scores = [[sum(n * min(DIST[c][p] for p in palette) for c, n in hist.items())
               for hist in histograms] for palette in candidates]
    best = [10 ** 20] * len(histograms)
    selected = []
    for _ in range(count):
        remaining = [i for i in range(len(candidates)) if i not in selected]
        if not remaining:
            break
        index = min(remaining, key=lambda i: sum(w * min(prev, new)
                    for w, prev, new in zip(weights, best, scores[i])))
        selected.append(index)
        best = [min(prev, new) for prev, new in zip(best, scores[index])]
    result = [candidates[i] for i in selected]
    return result + [result[0]] * (count - len(result))


def encode_gb(pixels: list[int] | tuple[int, ...]) -> bytes:
    out = bytearray()
    for y in range(8):
        out.extend(sum(((pixels[y * 8 + x] >> plane) & 1) << (7 - x)
                       for x in range(8)) for plane in range(2))
    return bytes(out)


def convert_tile(pixels: tuple[int, ...], palettes: list[tuple[int, ...]]) -> tuple[bytes, int]:
    histogram = Counter(pixels)
    palette_id = min(range(len(palettes)), key=lambda i:
                     sum(n * min(DIST[c][p] for p in palettes[i]) for c, n in histogram.items()))
    palette = palettes[palette_id]
    mapping = {c: min(range(4), key=lambda j: DIST[c][palette[j]]) for c in histogram}
    return encode_gb([mapping[c] for c in pixels]), palette_id


def gbc_color(color: int) -> int:
    r, g, b = sms_rgb(color)
    return round(r * 31 / 255) | round(g * 31 / 255) << 5 | round(b * 31 / 255) << 10


def c_array(name: str, data, kind: str = "uint8_t") -> str:
    width, per_line = (4, 8) if kind == "uint16_t" else (2, 16)
    values = list(data)
    rows = ["    " + ",".join(f"0x{v:0{width}x}" for v in values[i:i + per_line])
            for i in range(0, len(values), per_line)]
    return f"const {kind} {name}[{len(values)}] = {{\n" + ",\n".join(rows) + "\n};\n"


def extract(rom: bytes) -> dict:
    if len(rom) != ROM_SIZE:
        raise ValueError(f"Expected 512 KiB original SMS ROM, got {len(rom)} bytes")
    if hashlib.sha256(rom).hexdigest() != ROM_SHA256:
        raise ValueError('ROM hash does not match the pinned reference; fixed addresses cannot safely be used.')
    # The table is 9x9: its final row and column repeat the wrapping map edge.
    metatiles = bytearray(MAP_W * MAP_H)
    for chunk_y in range(2):
        for chunk_x in range(2):
            pointer = address(24, 0x8000) + 2 * ((chunk_y + 1) * 9 + chunk_x + 5)
            compressed = address(24, struct.unpack_from("<H", rom, pointer)[0])
            chunk, _ = rle(rom, compressed)
            if len(chunk) != 16 * 12:
                raise ValueError(f"Map chunk has {len(chunk)} metatiles, expected 192")
            for y in range(12):
                start = (chunk_y * 12 + y) * MAP_W + chunk_x * 16
                metatiles[start:start + 16] = chunk[y * 16:y * 16 + 16]

    # LABEL_3FA writes four sequential RLE streams into interleaved bitplanes.
    pos = address(22, 0x8570)
    planes = []
    for _ in range(4):
        plane, pos = rle(rom, pos)
        planes.append(plane)
    if len(set(map(len, planes))) != 1 or len(planes[0]) % 8:
        raise ValueError("Graphics bitplanes have inconsistent sizes")
    sms_tiles = bytes(value for row in zip(*planes) for value in row)
    # 17 bytes contain BG colors 0..15, then sprite color0; sprite15 follows.
    sms_palettes = list(rom[0x0D1E:0x0D1E + 17]) + list(rom[0x0DA3:0x0DA3 + 15])
    words = []
    for y in range(MAP_H * 2):
        for x in range(MAP_W * 2):
            meta = metatiles[(y // 2) * MAP_W + x // 2]
            quarter = (y & 1) * 2 + (x & 1)
            word = struct.unpack_from("<H", rom, address(22, 0x8000) + meta * 8 + quarter * 2)[0]
            words.append(word)
    uses = Counter(word & 0x09FF for word in words)
    source_ids = sorted(uses)
    source_pixels = []
    for key in source_ids:
        palette = 16 if key & 0x800 else 0
        source_pixels.append(tuple(sms_palettes[palette + p] for p in decode_tile(sms_tiles, key & 0x1FF)))
    palettes = choose_palettes([Counter(p) for p in source_pixels], [uses[k] for k in source_ids], 7)
    converted = {}
    graphics = bytearray()
    dedupe = {}
    for key, pixels in zip(source_ids, source_pixels):
        tile, palette_id = convert_tile(pixels, palettes)
        if tile not in dedupe:
            dedupe[tile] = len(dedupe)
            graphics.extend(tile)
        converted[key] = (dedupe[tile], palette_id)
    if len(dedupe) > 256:
        raise ValueError(f"Camineet needs {len(dedupe)} GBC tiles; maximum is 256")
    tilemap, attributes = bytearray(), bytearray()
    for word in words:
        tile, pal = converted[word & 0x09FF]
        tilemap.append(tile)
        # SMS H/V bits 9/10 become CGB bits5/6. SMS priority is not copied;
        # original foot collision prevents walking through map scenery here.
        attributes.append(pal | (0x20 if word & 0x200 else 0) | (0x40 if word & 0x400 else 0))
    collision = bytes(rom[address(3, 0xBD6F) + m] & 1 for m in metatiles)
    # Source Alis is 14 frames, six 8x8 tiles each. Palette index0 is transparent.
    sprite_raw = rom[address(28, 0x8000):address(28, 0x8000) + 14 * 192]
    sprite_indices = [decode_tile(sprite_raw, i) for i in range(14 * 6)]
    sprite_histograms = [Counter(sms_palettes[16 + c] for c in tile if c)
                         for tile in sprite_indices]
    opaque_palettes = choose_palettes(sprite_histograms, [1] * len(sprite_indices), 8, 3)
    sprite_palettes = [(0,) + p for p in opaque_palettes]
    sprite_tiles, sprite_attrs = bytearray(), bytearray()
    sprite_errors = []
    for tile, histogram in zip(sprite_indices, sprite_histograms):
        pid = min(range(len(opaque_palettes)), key=lambda i:
                  sum(n * min(DIST[c][q] for q in opaque_palettes[i]) for c, n in histogram.items()))
        palette = opaque_palettes[pid]
        pixels = [0 if c == 0 else 1 + min(range(3), key=lambda j:
                  DIST[sms_palettes[16 + c]][palette[j]]) for c in tile]
        sprite_tiles.extend(encode_gb(pixels))
        sprite_attrs.append(pid)
        sprite_errors.extend((sms_palettes[16 + c], palette[p - 1])
                             for c, p in zip(tile, pixels) if c)
    background_errors = []
    for key, pixels in zip(source_ids, source_pixels):
        _, pid = converted[key]
        palette = palettes[pid]
        for color in pixels:
            match = min(palette, key=lambda c: DIST[color][c])
            background_errors.extend([(color, match)] * uses[key])
    def metrics(pairs):
        total = len(pairs)
        squared = sum(sum((a - b) ** 2 for a, b in zip(sms_rgb(c), sms_rgb(q))) for c, q in pairs)
        return {"pixels": total, "exact_color_fraction": round(sum(c == q for c, q in pairs) / total, 6),
                "rgb_rmse_0_255": round((squared / (total * 3)) ** 0.5, 3)}

    return dict(metatiles=bytes(metatiles), source_words=words, source_tiles=sms_tiles,
                source_palettes=sms_palettes, tiles=bytes(graphics), tilemap=bytes(tilemap),
                attributes=bytes(attributes), palettes=palettes, collision=collision,
                sprite_raw=sprite_raw, sprite_tiles=bytes(sprite_tiles), sprite_palettes=sprite_palettes,
                sprite_attrs=bytes(sprite_attrs), quantization={"background": metrics(background_errors),
                "sprites_opaque": metrics(sprite_errors)})


def draw_reviews(data: dict, output: Path) -> None:
    from PIL import Image, ImageDraw
    source = Image.new("RGB", (512, 384))
    converted = Image.new("RGB", source.size)
    for index, word in enumerate(data["source_words"]):
        ox, oy = index % 64 * 8, index // 64 * 8
        pixels = decode_tile(data["source_tiles"], word & 511)
        tile_id, attr = data["tilemap"][index], data["attributes"][index]
        tile = data["tiles"][tile_id * 16:tile_id * 16 + 16]
        for y in range(8):
            for x in range(8):
                sx, sy = (7 - x if word & 0x200 else x), (7 - y if word & 0x400 else y)
                color = data["source_palettes"][(16 if word & 0x800 else 0) + pixels[sy * 8 + sx]]
                source.putpixel((ox + x, oy + y), sms_rgb(color))
                p = ((tile[sy * 2] >> (7 - sx)) & 1) | (((tile[sy * 2 + 1] >> (7 - sx)) & 1) << 1)
                converted.putpixel((ox + x, oy + y), sms_rgb(data["palettes"][attr & 7][p]))
    source.save(output / "camineet-source.png")
    converted.save(output / "camineet-gbc.png")
    coll = converted.copy()
    draw = ImageDraw.Draw(coll, "RGBA")
    for i, blocked in enumerate(data["collision"]):
        if blocked:
            x, y = i % MAP_W * 16, i // MAP_W * 16
            draw.rectangle((x, y, x + 15, y + 15), fill=(255, 0, 0, 70))
    draw.ellipse((404, 108, 412, 116), fill=(255, 255, 0, 255))
    coll.save(output / "camineet-collision.png")
    sheet = Image.new("RGBA", (14 * 20, 56), (80, 88, 96, 255))
    for frame in range(14):
        for q in range(6):
            orig = decode_tile(data["sprite_raw"], frame * 6 + q)
            tile = data["sprite_tiles"][(frame * 6 + q) * 16:(frame * 6 + q + 1) * 16]
            for y in range(8):
                for x in range(8):
                    sx, sy = frame * 20 + q % 2 * 8 + x, q // 2 * 8 + y
                    if orig[y * 8 + x]:
                        rgb = sms_rgb(data["source_palettes"][16 + orig[y * 8 + x]])
                        sheet.putpixel((sx, sy), rgb + (255,))
                    p = ((tile[y * 2] >> (7 - x)) & 1) | (((tile[y * 2 + 1] >> (7 - x)) & 1) << 1)
                    if p:
                        sheet.putpixel((sx, sy + 28), sms_rgb(data["sprite_palettes"][data["sprite_attrs"][frame * 6 + q]][p]) + (255,))
    sheet.resize((840, 168), Image.Resampling.NEAREST).save(output / "alis-source-and-gbc.png")


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--rom", type=Path, default=ROOT / "upstream/ps1disasm/ps1original.sms")
    parser.add_argument("--output", type=Path, default=ROOT / "assets")
    parser.add_argument("--src", type=Path, default=ROOT / "src")
    parser.add_argument("--no-preview", action="store_true")
    args = parser.parse_args()
    rom = args.rom.read_bytes()
    data = extract(rom)
    args.output.mkdir(parents=True, exist_ok=True)
    args.src.mkdir(parents=True, exist_ok=True)
    bg_count, alis_count = len(data["tiles"]) // 16, len(data["sprite_tiles"]) // 16
    header = f'''/* Generated by tools/extract_assets.py. Do not edit by hand. */
#ifndef PS_GBC_ASSETS_H
#define PS_GBC_ASSETS_H
#include <stdint.h>
#define CAMINEET_WIDTH 64u
#define CAMINEET_HEIGHT 48u
#define START_X 408u
#define START_Y 112u
#define BG_TILE_COUNT {bg_count}u
#define ALIS_TILE_COUNT {alis_count}u
#define ALIS_PALETTE_COUNT 8u
/* Assets below are in ROM bank2. Sprite graphics/palette are in ROM bank3. */
extern const uint8_t camineet_map[3072];
extern const uint8_t camineet_attrs[3072];
extern const uint8_t camineet_collision[768];
extern const uint8_t bg_tiles[{len(data['tiles'])}];
extern const uint16_t bg_palettes[28];
extern const uint8_t alis_frame_order[12];
extern const uint8_t alis_attrs[{alis_count}];
extern const uint8_t alis_tiles[{len(data['sprite_tiles'])}];
extern const uint16_t alis_palettes[32];
#endif
'''
    (args.src / "assets.h").write_text(header)
    c = '#pragma bank 2\n#include "assets.h"\n\n'
    for name, values in [("camineet_map", data["tilemap"]), ("camineet_attrs", data["attributes"]),
                         ("camineet_collision", data["collision"]), ("bg_tiles", data["tiles"]),
                         ("alis_frame_order", FRAME_ORDER), ("alis_attrs", data["sprite_attrs"])]:
        c += c_array(name, values) + "\n"
    c += c_array("bg_palettes", [gbc_color(c) for p in data["palettes"] for c in p], "uint16_t")
    (args.src / "assets.c").write_text(c)
    c = '#pragma bank 3\n#include "assets.h"\n\n' + c_array("alis_tiles", data["sprite_tiles"])
    c += c_array("alis_palettes", [gbc_color(c) for p in data["sprite_palettes"] for c in p], "uint16_t")
    (args.src / "assets_sprites.c").write_text(c)
    for name, key in [("camineet.map", "tilemap"), ("camineet.attr", "attributes"),
                      ("camineet.collision", "collision"), ("camineet.2bpp", "tiles"),
                      ("alis.2bpp", "sprite_tiles"), ("alis.attr", "sprite_attrs")]:
        (args.output / name).write_bytes(data[key])
    metadata = {
        "source_repository": "https://github.com/sung3r/ps1disasm",
        "source_rom_sha256": hashlib.sha256(rom).hexdigest(),
        "status": "Assets only; the original RPG engine is not converted",
        "map": {"name": "Camineet", "width_tiles": 64, "height_tiles": 48,
                "source_chunk_x": [5, 6], "source_chunk_y": [1, 2], "source_map_bank": 24,
                "metatile_bank": 22, "graphics_address": "22:8570",
                "collision_address": "03:BD6F", "collision_mask": 1,
                "start_x": 408, "start_y": 112},
        "bg_tile_count": bg_count, "bg_palettes_sms_colors": data["palettes"],
        "sprite_tile_count": alis_count, "sprite_palettes_sms_colors": data["sprite_palettes"],
        "quantization": data["quantization"],
        "conversion_notes": ["SMS 4bpp pixels are reduced to 2bpp with seven BG palettes and eight per-tile OBJ palettes.",
                             "Map tile flip flags are preserved. Static priority is omitted; source collisions prevent crossing scenery.",
                             "Original NPC art is retained in the map; NPC interactions and animation are not implemented." ],
        "sprite_source": "28:8000, 14 frames of 6 tiles in row-major 16x24 layout",
        "sprite_frame_order_down_up_left_right": FRAME_ORDER,
        "rom_bank_2_bytes": len(data["tilemap"]) + len(data["attributes"]) + len(data["collision"]) + len(data["tiles"]) + 56 + 12 + len(data["sprite_attrs"]),
        "rom_bank_3_bytes": len(data["sprite_tiles"]) + 64,
    }
    (args.output / "manifest.json").write_text(json.dumps(metadata, indent=2) + "\n")
    if not args.no_preview:
        draw_reviews(data, args.output)
    assert metadata["rom_bank_2_bytes"] < 16384
    assert max(data["tilemap"]) < bg_count
    assert all(a & 7 < 7 for a in data["attributes"])
    assert len(data["collision"]) == 32 * 24
    print(json.dumps({k: metadata[k] for k in ["bg_tile_count", "sprite_tile_count", "rom_bank_2_bytes", "rom_bank_3_bytes"]}))


if __name__ == "__main__":
    main()
