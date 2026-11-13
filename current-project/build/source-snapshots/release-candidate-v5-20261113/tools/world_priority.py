"""Source-index-preserving SMS priority conversion for native CGB backgrounds.

The SMS priority flag affects nonzero source pixels only. CGB BG priority also
lets OBJ pixels through native color zero, so RGB quantization alone is not
enough: a source nonzero index sharing the zero index's RGB must remain opaque.
This helper reserves palette entry zero for the source zero color whenever a
scene contains priority tiles, and constrains those tiles' nonzero indices to
entries 1..3. It does not alter priority-free scenes' existing conversion.

Samples are (indices64, source_palette16, weight, priority_required). Include
every animation phase when choosing scene palettes. One fixed palette can then
be chosen jointly for all phases with choose_world_tile_palette().
"""
from collections import Counter
from extract_assets import DIST, choose_palettes, encode_gb, palette_candidates


def score_world_palette(indices, source_palette, palette, priority_required=False):
    """Weighted squared RGB error, with exact priority transparency semantics."""
    if priority_required and palette[0] != source_palette[0]:
        return 10**30
    counts = Counter(indices)
    return sum(n * (DIST[source_palette[i]][palette[0]] if priority_required and i == 0
                    else min(DIST[source_palette[i]][palette[j]]
                             for j in range(1 if priority_required else 0, 4)))
               for i, n in counts.items())


def choose_world_palettes(samples, count=7):
    """Deterministic weighted greedy selection; no hidden source-index merging."""
    samples = list(samples)
    if not samples:
        raise ValueError('World palette selection needs source samples')
    zeros = {palette[0] for _, palette, _, priority in samples if priority}
    if not zeros:
        return choose_palettes([Counter(palette[i] for i in indices)
                                for indices, palette, _, _ in samples],
                               [weight for _, _, weight, _ in samples], count)
    if len(zeros) != 1:
        raise ValueError('This source scene has multiple priority zero colors')
    zero = next(iter(zeros))
    histograms = []
    for indices, palette, _, priority in samples:
        # Opaque pixels may have the same RGB as the transparent source index.
        # Keep that color eligible in the three opaque native palette entries.
        histograms.append(Counter(palette[i] for i in indices if not priority or i))
    candidates = [(zero,) + p for p in palette_candidates(histograms, 3)]
    scores = [[score_world_palette(indices, palette, candidate, priority)
               for indices, palette, _, priority in samples] for candidate in candidates]
    weights = [weight for _, _, weight, _ in samples]
    best = [10**30] * len(samples)
    selected = []
    for _ in range(count):
        remaining = [i for i in range(len(candidates)) if i not in selected]
        if not remaining:
            break
        index = min(remaining, key=lambda i: sum(weight * min(old, new)
                    for weight, old, new in zip(weights, best, scores[i])))
        selected.append(index)
        best = [min(old, new) for old, new in zip(best, scores[index])]
    result = [candidates[i] for i in selected]
    return result + [result[0]] * (count - len(result))


def choose_world_tile_palette(frames, source_palette, palettes, priority_required=False):
    """Choose one native palette for initial+animated source-index frames."""
    frames = list(frames)
    if not frames:
        raise ValueError('Tile palette selection needs at least one frame')
    return min(range(len(palettes)), key=lambda i:
               sum(score_world_palette(frame, source_palette, palettes[i], priority_required)
                   for frame in frames))


def convert_world_tile(indices, source_palette, palettes, priority_required=False, palette_id=None):
    """Return (2bpp bytes, native palette ID), preserving the source zero mask."""
    if palette_id is None:
        palette_id = choose_world_tile_palette([indices], source_palette, palettes, priority_required)
    palette = palettes[palette_id]
    if priority_required and palette[0] != source_palette[0]:
        raise ValueError('Native entry zero must retain the source zero color')
    if len(indices) != 64 or len(palette) != 4:
        raise ValueError('Expected one 8x8 source tile and a four-color native palette')
    mapping = {i: (0 if priority_required and i == 0 else
                  min(range(1 if priority_required else 0, 4),
                      key=lambda j: DIST[source_palette[i]][palette[j]]))
               for i in set(indices)}
    return encode_gb([mapping[i] for i in indices]), palette_id


def world_attribute(word, attribute):
    """Add original SMS horizontal/vertical flips and nonzero-pixel priority."""
    return (attribute | (0x20 if word & 0x200 else 0)
            | (0x40 if word & 0x400 else 0) | (0x80 if word & 0x1000 else 0))
