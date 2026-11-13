# Dungeon motion profiling and isolated experiments

Current integration status (2026-11-13): the selected removal of the redundant moving-pose caller wait is integrated. PROJECT_STATE.json identifies the current cartridge. Measurements below belong to their named historical probes. Broader native-block and all-waits-removed experiments remain unmerged; their timings are not production performance claims. The complete story and independent clean-power-on replay now pass.

The verified motion implementation was profiled on a separate source copy using
PyBoy's emulated CPU cycle counter. Exported symbols and assembly labels add no
emulated instructions. Production sources and the canonical ROM were preserved.
The fixed-palette test follows40 original Naula forward/back/turn poses with
real score interrupts. Double-speed CPU timing is140,448 cycles per physical
frame. Interrupt work and HBlank DMA stalls remain included in their measured
phase.

| Original native phase | Mean frame equivalents per pose |
| --- | ---: |
| Block expansion | 0.57 |
| Variant conversion | 1.02 |
| Changed-pattern uploads | 1.14 |
| Map packing | 0.51 |
| Map DMA | 0.66 |
| Final VBlank wait | 0.43 |
| Other entry/commit work | 0.05 |

The whole renderer averages4.38 frame equivalents, plus approximately0.98
frame in its caller. Even a warmed identical-image upload averages3.03 frames,
showing that map preparation matters as well as dirty-pattern traffic.
`tools/profile_dungeon_motion.py` records every pose and phase in
`build/verification/dungeon-motion-profile/report.json`.

A native-block experiment combines raw block expansion with palette/slot
conversion. The12 palettes produce21,308 unique16-byte blocks (340,928 bytes)
and53,088 bytes of palette-to-block lookups. It occupies25 freed banks while
retaining the old data for comparison; a production conversion could remove
210,752 bytes of obsolete raw blocks/variant tables. The experiment reuses the
existing scratch area:160-byte input at offset448,434-byte wanted-pattern table
at offset0, then the usual padded maps. It adds no static WRAM.

This experiment passes all17,160 image/palette pairs:5,148,000 map attributes,
46,940,896 pattern bytes and52,715,520 protected font/OBJ bytes. Its40-pose path
takes197 frames rather than209, with40 visible changes, zero unmatched PPU
frames,199 audio ticks including drain, and the guard intact. This modest gain
has not been merged; its extraction/runtime copies and evidence remain under
`build/verification/dungeon-native-blocks`.

An independent caller experiment found a larger unnecessary delay: source6AE5
already waits for its tilemap commit, as does the native uploader. The selected
small change removes the second wait only for nonzero poses and retains it for
frame0. The same path falls from209 to179 frames (14.4% fewer) while preserving
all poses and a visible standing checkpoint before events/battles. A direct
probe confirms16 cached-frame0 calls each wait one VBlank without uploading.
The separate broader experiment that removed every caller wait took173 frames,
and combining that broader schedule with native blocks took162; neither of
those broader variants is the production selection.

`tools/verify_dungeon_native_blocks.py` checks both the exhaustive native matrix
and the visible sequence. `--path-only` labels a timing-only sequence run and
does not claim new exhaustive coverage. `--standing-wait` selects the narrower
40-pose schedule used by the production proposal. All experiments keep the
original source images and pose order. None establishes original60fps timing,
hardware validation, or full campaign completion.
