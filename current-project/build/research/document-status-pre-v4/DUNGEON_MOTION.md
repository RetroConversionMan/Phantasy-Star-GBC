# Original dungeon motion renderer

Current integration status (2026-11-13): this renderer, source stairs/passage fades, door effects and pitfalls are integrated in candidate `2e151f71ae14996d5753791d373b6ef9f0d7a27f7f86e3cab3742c39ea19668c`. The candidate passes thirteen exact-binary integration suites and 28 travel music cases. Earlier candidate hashes, timing measurements and promotion notes below are historical evidence. General dungeon-entry/room interaction outer fades remain unfinished; complete fresh campaign and replay verification remain pending.

`dungeon_motion.c` and `dungeon_motion_upload.c` render all 38 original dungeon
animation frame types using extracted source art. The production controller now
uses them for forward/backward motion, turns, fake-wall checkpoints, opened
doors, stairs and pitfalls. The isolated native
candidate results below preceded integration; the project state tracks the
current combined ROM. It does not establish a complete campaign playthrough.

The asset compiler follows the pinned SMS ROM's actual symbol addresses,
frame table 705F, layer compositor 6C46, door table 6E75, and original sequences
at 6A76. The same original three-plane artwork used by the research compositor
is scaled from 256×192 to 160×120. Seven four-color GBC palettes retain the
canonical zero/nonzero distinction needed by the original battle flashes.
The eight-pixel font patterns, player OBJ patterns, and UI palette 7 are kept.

There are 1,430 distinct source-index images, 4,022 raw patterns, 2,212 shared
16×16 map blocks, and 14,533 distinct native two-bit patterns across twelve
palettes. A conflict graph assigns native patterns to stable VRAM slots:
patterns that appear together never share a slot. At most 209 patterns appear
in any one image; the largest palette needs 217 stable slots across all images.
Generated asset data totals 672,080 bytes. Code and metadata use bank 77;
assets use banks 209–212 and 214–251. Bank 213 belongs to battle weapons.

Two 217-word caches record the pattern IDs in the inactive/active buffers.
Including counters, pointers and standing-image safety state, the new modules
add 892 bytes of static WRAM. Removing the legacy standing cache flags makes
the production increase 890 bytes.
It reuses the existing 600-byte dungeon map, 56-byte palette buffer, and
1,540-byte shared dungeon scratch area. Scratch first holds block-map input,
then the desired pattern IDs, and finally two aligned 576-byte padded maps.
No additional frame-sized scratch allocation is required.

Pattern buffer A uses BG bank 0 slots 0–216. Buffer B uses BG bank 1 slots
64–255 and BG bank 0 slots 217–241. Maps alternate between 9800 and 9C00 with
the window hidden. ROM0 assembly expands block maps, converts raw patterns
to native slots/attributes, checks the cache, and packs the maps. One-tile
HBlank DMA uploads finish before interrupts resume; map DMA spans 36 scanlines.
Every DMA is complete before a banked caller resumes. The preceding complete
picture remains visible until the new pattern set, map, attributes, and
palette are ready. Only the first invalidated view disables/restarts the LCD.

## API and integration requirements

- `dungeon_motion_scene(state, frame)` returns an image ID for source frame
  0–37, or 65535 for invalid input. Explicit frame 6 reads the unmasked source
  cell so the opened-door bit is retained.
- `dungeon_motion_render(state, frame)` renders that image. Frame 0 also
  restores BG map 9800 **and pattern buffer A** for existing battle, window,
  menu and portrait callers. This is necessary because a large OBJ actor in
  bank 1 overlaps buffer B. Repeated standing calls are cached when safe.
- `dungeon_motion_render_image(image, palette)` is the lower-level renderer.
  It rejects invalid IDs before changing the display.
- `dungeon_motion_home()` restores map 9800 after a lower-level image call.
  It does not move patterns; use frame 0 before displaying an interaction actor.
- `dungeon_motion_sequence_frame(sequence, ordinal)` reads the ten original
  sequences; 255 is the terminator or invalid request.
- `dungeon_motion_turn_sequence(already_rotated_state, right)` implements
  source 67B7/67E2. Rotate the direction before calling it.
- `dungeon_motion_invalidate()` clears this cache. Production builds delegate
  the old standing invalidator to it; research builds separately clear the old
  cache. The conditional wiring prevents recursion. Invalidate after external
  BG pattern uploads, overlapping actor uploads, or shared-scratch use.

Call the renderer from the normal main loop with interrupts enabled. Hide the
window and stale interaction actors before movement. The renderer does not itself
advance dungeon state or execute events. `dungeon_play.c` retains those
responsibilities, and `dungeon_present.c` performs synchronous source-ordered
animation, sounds and fades without allocating a second dungeon state.

Source ordering matters:

| Source routine | Required state and frame order |
| --- | --- |
| 6758 forward | Frames 1,2,3,4,5 at the old position, then advance one cell and draw frame 0. |
| 6792 backward | Move back one cell first, then frames 5,4,3,2,1,0 at that new position. |
| 67B7 left | Decrement direction first; sequence 2 plus 2 if view 13 is solid, plus 1 if front view 1 is solid. |
| 67E2 right | Increment direction first; sequence 6 plus 2 if view 12 is solid, plus 1 if front view 1 is solid. |
| Fake wall 7 | Two forward steps with the original object/event callback checkpoint between them. A callback can change the next position or direction. |
| 6731 stairs/open passage | Source fade-out, two-cell advance, standing view, fade-in; separate from ordinary forward motion. |
| 661C fall / 682F door | Separate source presentations; these are not interchangeable with a forward sequence. |
| 688C retreat | Source optional turns followed by direct backward movement; preserve its collision/checkpoint exceptions. |

For ordinary movement, retain the old position/direction rather than allocating
a second persistent 264-byte dungeon state. A snapshot of the entire state
would consume the remaining production stack margin. Floor replacement and
event callback checkpoints require their own controller treatment.

## Verification and current limits

The preserved native probe is
`build/verification/dungeon-motion/motion-verified-e0b3e83c3872.gbc`, SHA-256
`e0b3e83c387243e9a51053f8bfa946b352f2a46f7cb2139cd318fdc94d46a48c`.
Its adjacent JSON report records:

- 2,145 native image/palette cases, including every distinct image, every
  fixed turn frame in all twelve palettes, and moving geometry samples;
- 643,500 map/attribute pairs and 6,175,632 uploaded pattern bytes compared
  against independently reconstructed source-index images and palette packing;
- 6,589,440 protected font/OBJ VRAM bytes and 120,120 palette bytes checked;
- all 90 original sequence-table bytes, invalid-input behavior, and map-9800
  restoration; the supplemental quick report checks 24 native door selectors,
  including opened-bit and wrapped-position cases;
- a real installed audio IRQ, no audio/DMA faults, and an unchanged 64-byte
  stack guard at DC00 during every render, leaving a tested 1 KiB stack window.

`tools/verify_dungeon_motion_logic.py` separately passes 20,443 source geometry
and frame-selection cases, including wrapped positions/directions, and 1,944
turn-selector comparisons against the actual original Z80 routines. The
original 6A58 animation runner is only replaced by a capture endpoint in that
turn oracle. Its output and direction change must match the native selector.

A free-running native test follows actual Naula floor 19 geometry from
position 13 facing west: forward twice, left, forward, backward, right. These
40 original poses take 209 physical emulator frames in the full run. All 40
image changes reach the PPU in source order, with zero unmatched/partial/blank
frames and no LCD restart. Audio advances 211 times including the two final
PPU drain frames. Cold/varied diagnostic commands take 5–7 frames (mean 5.93);
the actual fixed-palette path uploads a mean 118.25 changed patterns per pose.
Repeated identical images upload no patterns after both buffers are warm,
but still require map preparation and presentation time.

This is substantially faster than the 137-frame research compositor, but it
does **not** reproduce the original one-pose-per-VBlank cadence. Further timing
optimization remains necessary. The old research compositor/probes and standing
renderer remain available as separate targets. Production replaces their raw
art and standing patterns with a 13,072-byte bank-20 package containing only
lookup tables and all twelve flash-aware palettes. Banks 21–29, 64–76 and 78–96
are consequently unlinked from the production dungeon renderer; the original
assets and extraction tools remain intact.

Run `../../.venv-transfer/bin/python tools/verify_dungeon_motion.py` for the
native matrix and visible-frame test, and
`../../.venv-transfer/bin/python tools/verify_dungeon_motion_logic.py` for the
source logic/oracle checks. `--quick` selects eight native images while keeping
the full source-path visibility/audio/stack test; `--skip-build` reuses the
existing probe binary without claiming it reflects later source changes.


## Production controller and visible-frame verification

The isolated integration ROM is `build/motion-integration/motion-integration.gbc`.
`tools/build_dungeon_motion_candidate.py` freezes coherent battle sources and
records every source/header hash. It never replaces the canonical ROM. The
verified candidate `30fcd2fe47b494532202629444ace2aa25cc881fec2ea8273a70258f29bad9f5`
uses 6,894 bytes of fixed WRAM and reserves 1,138 bytes for the stack, including
the shared palette updater's 56-byte staging array.

`tools/verify_dungeon_motion_integration.py` runs actual controller inputs from
explicit original floor/item SRAM fixtures with real audio interrupts. Its
expected pictures come from the independently verified source-index images;
every captured pixel in the 160×120 adapted dungeon viewport must match an
ordered original pose or source fade. The bottom 24 pixels are native UI.

| Presentation | Physical frames | Audio IRQ ticks | Unmatched viewport frames |
| --- | ---: | ---: | ---: |
| Normal door | 32 | 32 | 0 |
| Key door | 33 | 33 | 0 |
| Magic/Miracle door | 33 | 33 | 0 |
| Original stair transition | 119 | 119 | 0 |
| Original automatic pitfall | 49 | 49 | 0 |

The test checks the original BD/C3/C0 sound commands, map 9800 and primary
pattern buffer A after each presentation. Door tests observe all three source
poses. The source fall oracle separately executes original Z80 routine 661C in
five lit/dark/wrapped-floor cases: 150 source frames and 2,880,000 pixels match
its 12 outgoing translations, blank transfer, 12 incoming translations and
five shake positions. Source font C0 is solid black; native spare BG tiles
242/243 reproduce it without substituting the blue UI background.

Two actual fixed battles exercise the actor overlap constraint. A large enemy
and its weapon animation reach OBJ tile 158; GiantFly executes original
physical and offensive-magic attacks. The probe verifies 7,397,224 background,
map and font bytes across 1,657 actor frames, then wins both battles, returns
to the dungeon and completes another turn. The two measured windows have
844/1,057 LCD-active frames and exactly 844/1,057 score interrupts. Existing
battle result/chest setup contributes five LCD-off frames per window; those
are recorded separately, rather than attributed to motion.

A 64-byte diagnostic guard at DBC0–DBFF remains intact throughout motion,
actors, magic, chest handling and post-battle movement. This preserves the
DC00–DFFF 1 KiB stack window. Both audio and DMA fault bytes remain zero.
The ordinary dungeon regression also passes 48 world-controller steps, original
Camineet/Palma entry, darkness/Flash, turns, a battle, chest C602, save/restart,
and the stored-world exit. Those tests use explicit strong-party/item fixtures;
they do not claim earned campaign progression.

Host checks cover 13,895 controller assertions and 162 presentation/callback
ordering assertions with address/undefined-behavior sanitizers. They preserve
fake-wall callbacks that alter position/direction, rear-enemy left turns versus
rear-event right turns, retained traps, and the source rule that an opened
two-cell passage does not set the traversal encounter latch. Floor changes do
not restart dungeon music: the original 661C/6731 paths do not call 6DE2.

Production `PS_DUNGEON_MOTION` routes `dungeon_render`, `dungeon_draw_view` and
legacy invalidation to the new renderer. The ordinary, key and spell door
paths call `dplay_show_opening` after source validation; the helper emits BD
once. These changes keep the original controller's object checks and escape
exceptions while making their presentation source-specific.

## Verified intermediate-wait reduction

A later focused candidate, SHA-256
`79381b87d511fca06692be73cc3fa32193b27fd3b2529b36f62aafffdd23ac56`, changes only
`dungeon_present_frame` and the cartridge title relative to the integration
candidate above. Source6AE5 calls the compositor and then WaitForVInt(0C), which
commits the new tilemap. The native uploader already performs that VBlank
commit, so the extra caller wait is removed for nonzero motion frames.
Frame0 retains its final `vsync`, including cache hits. This allows a complete
standing image to scan out before an immediate object or battle callback can
replace the screen.

The same40-pose Naula path now takes179 physical frames rather than209
(14.4% fewer), with all40 source poses visible in order, zero unmatched frames,
181 audio IRQs including the two drain frames, and the guard intact. This is
still slower than the original game's cadence. The broader experiment that
removed every caller wait is not the selected production change.

The focused production probe additionally captures the exact final standing
PPU image at `battle_view_begin`, before battle setup can disable LCD. Both
large-enemy and offensive-magic fixtures pass that checkpoint. Sixteen direct
cached-frame0 calls perform zero uploads and each waits exactly one VBlank.
Doors and stairs retain their previous measured timings; the pitfall probe
runs48 frames with the same28 visible changes, zero unmatched frames and48
score interrupts. Static WRAM and the1,138-byte stack reserve are unchanged.
Evidence is under `build/verification/dungeon-motion-wait`; the independent
profiling and native-block experiments are described in
`docs/DUNGEON_MOTION_PROFILE.md` and are not linked by the production Makefile.
