# Original ending dungeon walk and credits

Current integration status (2026-11-13): the real ending walk/credits, outer story, Governor portrait, final bitmap, holds and title return are integrated. PROJECT_STATE.json identifies the current cartridge and exact-binary evidence. Caller-owned below describes the module boundary. The non-finishing credits stub belongs only to the historical4f4 probe. A complete earned campaign and independent clean-power-on replay now pass; the earlier ending fixtures alone did not prove earned progression.

The native ending tail is implemented in `src/ending_walk.c`, with generated
source artwork and a fixed-register CGB DMA uploader. It is a native GBC
sequence; the original Z80 runs only in the extraction/verification tools.
The separate outer ending story, portraits and final bitmap are caller-owned.

`ending_walk_begin(light)` follows the caller's208-frame final-bitmap hold.
Pass the retained original C315 lighting value. Then call `ending_walk_tick()`
once per native VBlank; it returns nonzero after the whole sequence, including
the final180-frame hold. The caller enters the original title/load-intro mode2.
There is no action-button skip in this source tail. `ending_walk_frame` exposes
the logical source frame for integration diagnostics. The module owns the seven
source sound commands and hides world sprites/window during its presentation.

The original literal `LABEL_3DF6+1` is the word3DF7: positionF7 and floor61,
immediately decremented by661C to floor60. The script also traverses floor59.
C2F5 is the ending-credit overlay index. It starts at1 and source6E04 draws
fourteen pages by incrementing before looking up the bank20 record. Only source
text bytes whose value plus80 reachesC0 replace the low tilemap byte; high tile
attributes and nonletter spaces remain unchanged. Font graphics come from
bank15 BDEE and the movement script from BF80. The final page is the source
“PRESENTED BY SEGA”; the module does not invent an additional ending message.

`tools/ending_reference.py` executes the original hash-pinned machine code,
including movement, floor changes, original graphics decompression, wall/door
composition, credit text overlays and the selected VBlank VDP handlers. The
sound engine is stubbed and its command writes are recorded. Real ReadJoypad
executes against released controller ports. WaitForVInt is a host boundary;
its return A/flags and C208 clearing are preserved. Mapper writes atFFFF select
the actual source ROM bank. This is a logical-VBlank reference, not a complete
SMS CPU/PPU cycle timing emulator.

Both lit and unlit traces contain3,499 logical VBlanks and4,898,480 VDP writes.
There are511 lit and389 unlit distinct VRAM/CRAM/register snapshots. Original
sound commands occur at these logical frames:

| Frame | Command |
| --- | --- |
| 0 | C0 |
| 30 | 91 |
| 1096 | C0 |
| 2038 | C3 |
| 2353 | C0 |
| 3051 | C3 |
| 3319 | D7 |

The source-index image is scaled256x192 to160x120 and adapted to seven GBC
four-color palettes. The retained unlit C315 edge case is preserved, including
its dark floor colors. The generated data has334 images,6,745 shared patterns,
24 palette states and679 timeline runs. Patterns are ordered by their complete
image-presence signatures, which places co-occurring patterns together. The
runtime uploads contiguous groups with one CGB DMA setup each: mean25.4 and
maximum57 groups per image, with at most209 simultaneous unique patterns.
Tile attributes are run-length-encoded. This preserves the original movement
frames without the slow per-pixel native compositor.

Code occupies bank136; graphics/maps occupy137..139 and193..208.
The runtime stages two padded576-byte maps and at most342 command bytes in
existing aligned dungeon scratch memory, with the existing600-byte map buffer
as preparation space. No extra frame-sized WRAM allocation is introduced.

The display remains enabled throughout motion. Inactive patterns alternate
between bank0 slots0..208 and bank1 slots64..255 plus bank0 slots209..225.
The maps alternate9800/9C00 while the window is hidden. Source order is retained:
the previous complete image stays visible until all new patterns/maps are ready,
then the palette and map switch at VBlank. `ending_walk_busy` exposes preparation;
logical source time does not advance while the next image is loading.

ROM reads during HBlank DMA require the source bank to remain selected. Each
synchronous DMA chunk masks interrupts temporarily, restores the source mapping,
and then lets queued audio/VBlank interrupts resume. Pattern chunks span at most
16 scanlines; map chunks36. No DMA remains active when the helper returns. These
bounds keep each critical interval shorter than one frame. Initial loading while
the caller has the display off uses general DMA. The normal LCD restart blank
frame is avoided during motion; see the [LCD control reference](https://raw.githubusercontent.com/gbdev/pandocs/master/src/LCDC.md).

Font/OBJ VRAM, UI palette7 and the caller's ROM bank are preserved. The final
image is copied to map9800 before returning, and the ordinary dungeon cache is
invalidated. DMA source alignment is checked from native linker symbols.

Native evidence is `build/verification/ending-walk/report.json`. The probe runs
both complete lighting paths, checks6,998 logical frames,3,352,832 pattern
bytes,388,800 map/attribute pairs,391,888 palette bytes,3,981,312 preserved VRAM
bytes, and all14 sound-command deliveries. Emulator screenshots are stored next
to the report. Main-game story triggering, the actual APU interpretation and
physical hardware are separate integration checks. Native elapsed timing is
reported separately from logical source VBlanks; it must not be described as
cycle-identical to the original SMS presentation.

The optimized verified free-running native probe takes6,253 emulator frames for3,499 source
logical VBlanks. All334 adapted images reach actual PPU output, with zero
unmatched display frames and no LCD restart during motion. This favors complete,
flicker-free source frames over an unverified60fps claim. The earlier uploader took8,257frames. Short DMA chunks now continue without
an artificial yield after64patterns, and fixed-bank native loops pack the maps.
No additional WRAM or artwork changes are introduced.

The focused integrated ending-speed milestone26362dd9 passes an actualDarkFalz
fixture through title with the real audio interrupt. During the active credits,
6,794nativeframes and6,795scoreupdates differ by one frame at the emulator
sampling boundary; audio_fault remains0. A64-byte guard below the1KiB stack
window survives the battle and whole ending. The LCD-off title upload is
excluded from that score-cadence measurement, matching the documented
scheduler pause. This focused binary is preserved separately; canonical build
status is inPROJECT_STATE.json. Physical-hardware timing remains untested.
