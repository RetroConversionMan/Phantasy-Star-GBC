# Dungeon data and traversal kernel

## Current integrated implementation

The current 4 MiB ROM integrates dungeon traversal, original motion frames, encounters, darkness and light items, objects/chests, dialogue, doors, stairs, falls, audio, saves and the ending overlay. The shared fall renderer restores the window map after the Governor transition and both mandatory pits; native checks exercise subsequent menu, Search dialogue and the title in the same session. The full story and independent clean-power-on replay now pass, including the original final maze and ending.

Current motion data occupies banks 209–212 and 214–251, with code in bank 77 and tables in bank 20. Earlier allocations and the slow scanline experiment below are preserved research, not the selected production renderer. Current memory use is 6,886 WRAM bytes with 1,146 address bytes reserved above it. Native asset uploads and motion cadence remain slower than SMS in documented cases; physical hardware is untested.

See `../PROJECT_STATE.json` for the current exact-ROM verification reports. The release-v2 reports retain their historical scope. The remaining sections are development history and source-specific behavior. Their statements that integration, motion or ending work remains are historical and are superseded by this current summary.

## Original extraction and kernel milestone

`tools/extract_dungeons.py` reads the hash-verified original ROM. Bank16 holds
61 packed floors (128 bytes each),186 seven-byte object records,65 five-byte
transition records, the original direction/view offsets, floor encounter and
palette/music records, and the six naturally lit floor IDs. Bank17 implements
the native traversal kernel in `dungeon.c`; it is not yet a playable dungeon.

The position is the original packed YX byte. Arithmetic wraps over the byte,
not independently over the X and Y nibbles. `dungeon_sample` preserves the source
16 relative view offsets per direction, masking runtime door bit7 exactly like
`LABEL_6BE9`. `dungeon_load_floor` expands high nibble then low nibble and clears
runtime opened-door bits by reloading original data, as in `LABEL_6D56`.

The command kernel ports `LABEL_65EE..681B`: trap/fall checks occur before input;
forward type0 advances one cell, type7 advances two cells, ordinary stairs
change the floor and advance two cells, and opened doors advance two cells.
Special stairs/doors dispatch the original transition table. Closed doors
block; only an ordinary type4 door opens from the action button. An already
opened door or another action enters the menu. Backward movement only accepts
rear geometry type0. Left/right rotate; direction order remains north/east/
south/west. Native bounds guards reject invalid floor/direction inputs rather
than reading unrelated ROM. This guard does not replace any known valid source
transition.

`DungeonAction` preserves mode, source target and payload bytes, and moved
positions. These are traversal results, not completed chest, battle, event, or
animation effects. Caller integration must process the source's object checks
at their proper points: fake walls have two sequential forward checks, stairs
and opened doors check after the two-cell move, backward checks ahead and
behind, and rotations check ahead. The current geometry kernel is insufficient
by itself to run those interactions in order; the caller must retain the
intermediate position while processing each checkpoint.

Object records retain their C500/C600 flag address, type and two payload bytes.
A flag suppresses its object only when equal toFF; values1..FE do not suppress
it. The original first matching record wins. Ten later records duplicate an
earlier floor/coordinate and remain unreachable through this lookup, even if
the first record's flag isFF. Five first-match records are on cells that are
not type08 and remain dormant. Current-cell trap detection checks whether an
object record exists at all, independent of its flag. These quirks are kept.

Transitions with targets below80 return original map triples. FF, FE and FD
select interaction contexts0F,0D and1E respectively; FC preserves the existing
interaction context. Missing special-cell records return to the stored outside
map position. One extracted transition is dormant because the source cell lacks
bit3; the record cannot override that check. Original dialogue portraits and
special room scenes remain rendering/event work.

Lighting follows `LABEL_6D7F`: the original light state or one of six naturally
lit floors enables that floor's palette; otherwise palette index0 is dark.
The kernel exposes original encounter rate/pool and music IDs. Flash/Magic Lamp
item use, timers, encounter rolls and audio playback are not implemented here.

`tools/verify_dungeon_logic.py` compiles the actual C kernel and compares it with
ROM-derived expectations:15,616 expanded cells,999,424 relative samples,
374,784 command cases,580 opened-door cases,61 runtime-bit reset checks,
64 active plus1 dormant transitions,171 active plus5 dormant first-match
objects, and855 flag-value cases pass. `build/verification/dungeon-logic-report.json`
is host logic evidence, not emulator or campaign evidence.

## Original-art native renderer

`tools/extract_dungeon_graphics.py` follows the verified assembled symbols and
pointer bytes, not numerical text inside labels. It preserves all38 source
perspective/motion frames (22 distinct graphic streams and35 tilemaps), the
original bank6 wall/door layer data, and twelve source floor palettes. The
three-plane decoder reproduces the original OR-derived fourth plane's color
indices. Original artwork is scaled uniformly from256 by192 to160 by120,
leaving24 pixels for the native UI. Seven four-color GBC palettes adapt each
source floor palette. These resolution/color adaptations are explicit; no
replacement walls or raycaster art are used.

The native bank17 compositor ports `LABEL_6AED`, `6C46..6D45` and `6E38..6E64`.
The source layer logic has243 distinct standing-view combinations. The fast
renderer precomputes all of them from original bytes, sharing743 distinct
indexed8x8 patterns. A scene needs69..201 patterns. It caches up to255 native
patterns in VRAM bank0, preserves those still needed when changing views, and
uploads only new patterns. Palette changes invalidate the cache. The cache and
slow scanline renderer share a WRAM scratch union; they never run concurrently.

Call `dungeon_render(state,0)` for the verified standing path. Call
`dungeon_invalidate_view_cache()` after another system overwrites BG pattern
VRAM, including world and battle screens. The renderer preserves bank1 font
and Alis data and leaves palette7 for the UI. It returns the selected ROM bank
to its caller. Cached rendering reuses `dungeon_render_map` as a native pattern
ID buffer, so that buffer contains an original SMS tilemap only after an
explicit `dungeon_compose` call or slow motion frame.

The original motion frames remain available through nonzero frame arguments,
but their current scanline conversion is too slow for gameplay. The optional
source dynamic overlay at `LABEL_6E04` remains unimplemented. Movement and door
animation timing, sound, special room presentations, and interaction dispatch
are separate remaining work. Standing updates currently disable the LCD during
transfer; this can produce a short blank interval on real hardware and needs
further presentation work.

Data allocation is bank16 for dungeon rules data, bank17 for traversal and
composition, banks20..29 and64..76 for original graphics/motion data, and
banks78..96 for the prepared standing views. The cartridge now needs128 banks
(2MiB). Descriptors and safe VRAM transfer helpers are in ROM0.

`tools/verify_dungeon_render.py` verifies62,616 host source compositions,
including every floor/position/direction standing case and all38 frame choices.
A separate real CGB ROM then passes301 emulator scenes,90,300 native pattern
comparisons and5,779,200 pixel-index comparisons, including every standing
geometry, cache reuse/eviction, palette changes, and the original motion frame
fallback. Font/OBJ preservation and bank restoration also pass. The double-speed
CGB harness measures10..17 emulator ticks for standing commands (including
floor setup), and137..138 ticks for the slow motion path. The latter must not
be treated as a playable animation implementation.

Evidence is `build/verification/dungeon-render/report.json`, with actual emulator
screenshots and corresponding independently generated expected images. This
isolated renderer test does not establish story, battle, object, save, audio,
or end-to-end dungeon gameplay correctness, and physical hardware is untested.

## Ordered dungeon play controller

`dungeon_play.c` now implements the source checkpoint/continuation order around
traversal. Its returned actions still require the main game to perform chest,
battle, event and menu effects. `dplay_enter` takes the retained original C2E0
trap byte as its last argument. The caller must copy `retained_trap` back after
every step/resume, including calls returning a plain view: inspecting an item
chest behind the party changes C2E0 without displaying a chest prompt. Money
chests retain that byte and return its resolved value in action.a. Flags are
written only when the caller accepts the relevant original object outcome.

Forward fake-wall movement pauses after the first cell's object callback, then
moves using the callback's current position and direction before its second
check. Backward movement checks ahead, then behind; rear enemy/NPC objects turn
the party around. Entry checks its object before testing darkness. A dark entry
returns a dark-menu action; resuming unlit returns to the saved outside position,
and resuming lit restores the floor palette. The initial caller-owned darkness
menu and light-item effect remain separate from the pure controller.

Encounter RNG is consumed only at the original latch point after pending
checkpoints. A fixed enemy with ID0 still sets that latch; blocked movement and
ordinary menu/door prompts do not. Source `LABEL_688C` escape directly moves
backward after its left/right decision, bypassing the normal current-cell trap
and backward-collision checks. The separate escape-blocked predicate is exposed
for the caller. Special interaction actions retain raw FF/FE/FD/FC in action.b,
so an FF dungeon room can be distinguished from world scene15.

`tools/verify_dungeon_play.py` compiles the actual controller and related logic
with address/undefined-behavior sanitizers. It passes13,895 assertions covering
all reachable first-match object records, suppression flags, fixed payloads,
retained-trap inheritance, callbacks, darkness, all transition records, encounter
RNG and1,024 escape direction/RNG cases. Evidence is
`build/verification/dungeon-play-report.json`. This is pure logic evidence;
it does not establish the main game's asynchronous callback, save or presentation
integration. Replacing the whole controller during a callback replaces its
pending continuation; caller transitions must deliberately choose that behavior.

The optional renderer overlay controlled by C2F5 (`LABEL_6E04`) belongs to the
original ending sequence, where `LABEL_454E` sets and clears that byte. Ordinary
chests and dungeon NPCs use sprite actors (`LABEL_16B2` and `LABEL_617D`), so that
ending overlay must not be used as a substitute for object artwork.

Original chest actor poses are now extracted from bank20 graphics/palette and
the bank3 sprite-layout table using verified symbol addresses. `chest_show`
accepts source indices3A..46: closed3A, open3D, party-trap3E..42 and single-trap
43..46. Position comes from `LABEL_5C63` (X60,Y58 with the SMS one-line sprite
Y offset), then the whole source image is scaled5/8. Eight native OBJ palettes
quantize each tile to three visible colors. All13 poses use12..20 native sprites,
well below both40 total and ten per scanline. Data occupies4,392 bytes in bank115.

The chest shares `scene_actor_show_data`, OAM0..39, bank1 tiles84+ and all OBJ
palettes with NPC/enemy actors. The public `scene_actor_active` byte covers all
these overlays. `scene_actor_hide` clears their OAM and restores Alis palettes.
The caller disables the LCD before showing a pose. No extra WRAM image buffer
is allocated. This is original pose rendering; the source one-VBlank update cadence,
opening counter delays, screen shake, audio and gameplay rewards are separate.

`tools/verify_chest_art.py` passes all13 native poses and178 OAM entries,2,848
pattern bytes,832 palette bytes and203,814 protected VRAM bytes, including nested
ROM bank restoration, invalid-pose no-mutation checks and Alis palette restore.
It regenerates the source images for638,976 source-pixel comparisons and retains
actual emulator images beside expected overlays. Evidence is
`build/verification/chest-art/report.json`; this standalone probe does not prove
integrated chest animation or dungeon/battle presentation.
