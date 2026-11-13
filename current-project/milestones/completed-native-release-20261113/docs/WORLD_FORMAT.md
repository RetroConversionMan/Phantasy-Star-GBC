# Native world integration

Current integration status (2026-11-13): candidate `b72feead6a4a0b9efe779a2a61fbce7e96bd30247e3149b0ce1793dd414d59a1` integrates all eleven world groups with original world animation, source-index tile priority, events, terrain rules, travel, vehicles, battles and dungeons. All thirteen exact-binary integration suites pass. WORLD_MOTION.md records original-Z80/native pattern, priority and atomic-upload comparisons. The complete story and independent clean-power-on replay now pass; fixture results below retain their coverage limits.

The source of truth is the included SMS ROM, SHA-256
`9e324e92bd833b45126861b6f1d2dcbb51251bdf3df6d563ab3a3ff784d8cf88`,
and its pinned disassembly. `tools/extract_world_motion.py` supplies eleven animated map groups
for the original twenty-four map IDs; `tools/extract_world.py` delegates to it by default and reserves `--legacy-static` for explicit isolated outputs. `src/world.c` now reads those groups and
renders their converted graphics. The earlier world-only milestone did not
establish playable travel, dungeons or story integration. Those systems are now
integrated; the renderer's presentation limits below remain separate.

## Coordinates and graphics

Each group is 128 by 96 metatiles, 16 pixels per metatile: 2048 by 1536 pixels.
The native player coordinates are horizontal centre and feet. The original
Camineet crop starts at group pixels (1280,192), so its tested local start
(408,112) is world (1688,304), map ID 4. The source primary trigger sample is
(player_x-8,player_y-16), with world wrapping. Upstream source coordinates are
camera origins, not player coordinates; mixing these was a previous cause of
incorrect spawn and trigger tests.

Groups live in ROM banks32..53, two banks per group. `WorldScene` descriptors
and map-ID/music mappings are in ROM0. All bank-switched pointers are read
through ROM0 `bank_read8` and `bank_copy`, which restore `CURRENT_BANK` before
returning. Graphics use a ROM0 loading wrapper with the same bank restoration.
The engine itself runs from bank6. No code executing in the switched window
changes its own ROM bank directly.

The renderer uses the hardware's wrapping 32 by 32 BG map and streams 21 by 19
8-pixel tiles. Logical tile coordinates are 16-bit; the world's width of256
tiles and viewport crossing at both world boundaries remain representable.
A discontinuous camera move forces a full redraw, while a one-tile movement
updates the newly visible row and/or column. The renderer does not clamp the
camera, so the caller can wrap its camera at world boundaries.

Patterns0..255 use BG VRAM bank0. Additional patterns use bank1 IDs64..255,
preserving bank1 BG IDs0..63 for the font and OBJ IDs0..83 for Alis. At most448
patterns are available. Attributes preserve palette, bank and tile flips.
Palette7 is reserved for the UI. `world_load_graphics` requires the LCD off.
Original animated patterns now follow the six source countdown/phase slots;
only the first expired slot updates on a logical tick. Road mode retains its
source reset and reversed phases. Source color index zero remains transparent
to priority, while nonzero indices remain opaque even when colors quantize to
the same native value. The renderer preserves priority attributes and uploads
complete phases atomically. WORLD_MOTION.md records the source formulas, bank
layout and comparisons; GBC color/resolution adaptations remain explicit.

## Collision and transitions

`world_step_allowed` ports the on-foot check from `LABEL_74E4`: test the one
leading source metatile before starting a 16-pixel grid step. Facing in the
native engine is down/up/left/right =0/1/2/3. `world_can_stand` preserves the
baseline's four-sample feet collision check as a separate API for placement
validation; it is not a replacement for the original grid movement rule.

`world_check_trigger` corresponds to `LABEL_77AC`. Call it after a completed
step, and suppress repeated evaluation until the next completed step. Original
`C2D5`/`C265` movement latching is a caller responsibility. The primary sample's
bit3 permits entrance lookup; bit2 routes special terrain. A coordinate match
alone does not fire an entrance. Nonzero vehicle modes also inspect the three
additional source samples in order14,12,0A,0C. Vehicle movement now uses the source two-cell leading edge and masks, including
temporary IceDigger terrain changes. Entry/exit and native art evidence are
described below; `game_field.c`, `main.c` and the travel controllers supply the
integrated item/UI and travel responsibilities.

Entrance records preserve mode8 (map),10 (dungeon) or12 (interaction), target,
and the original payload bytes. Map destinations decode packed Y by twelve
rows per chunk, then add the player's feet offset; destination X adds the
player centre offset. Dungeon and interaction payloads remain unmodified for
the corresponding systems.

The extracted normalized entrance coordinates are valid for this pinned data.
The source comparison tests account for source sampling across camera-origin
seams: primary cells X<8 have source X+128; primary cells Y<6 have source Y+96
before packing. Source X comparisons do not mask `entry+1`; source Y increments
apply their packed twelve-row rule. Exhaustive source comparisons cover these
edge cases rather than assuming a generic wrapped rectangle.

Special metatileAD exits a town using the exact twenty triples at source
`LABEL_7AC0+1`, indexed by original map ID minus4. `world_road_destination`
decodes the six authorized road endpoints from source `LABEL_F0C`; index0
means no road. This lookup helper does not animate the road sequence; the
integrated `travel.c`/`game_sequence.c` path does.

Other applicable `LABEL_792A` special tiles return `WORLD_ACTION_SPECIAL` with
metatile, original flags, interaction-type nibble, and vehicle mode. Their
Compass/hovercraft/GasShield checks, C506 dungeon gate, HP damage, binding, and
encounter behavior are supplied by the integrated event/terrain systems. Unrecognized
special tiles return no action as in the original dispatch. This explicit
action boundary preserves the source-specific handling rather than substituting
generic terrain behavior. Earlier notes treating those handlers as future work
describe the historical world-only milestone.

## Verification

`python3 tools/verify_world_logic.py` compiles the real C modules for the host
and independently decodes map chunks, collision flags, entrance records, town
exit records and road endpoints directly from the verified SMS ROM. It checks
all135,168 cells across eleven groups,540,672 tile/attribute pairs,540,672
on-foot movement checks, and294,912 trigger positions across all24 map IDs.
It also demonstrates3,455 coordinate-only entrance matches that must be
suppressed by tile gating. The report is
`build/verification/world-logic-report.json`.

These host results do not establish emulator rendering, actual input-driven
travel, story correctness, dungeons, music, or hardware compatibility.

A separate native emulator harness now passes in PyBoy2.9.0:
`tools/verify_world_emulator.py` builds the actual world modules, checks187
viewports (74,613 visible tile/attribute pairs),30,224 graphics bytes across all
11 groups, and26,048 preserved font/Alis byte comparisons. It exercises the
world boundaries, hardware32x32 map wrapping, diagonal increments, sub-tile
scrolling and discontinuous camera changes. It also verifies ROM0 transfer
helpers restore bank6 when called from bank6, and banked calls return to the
original bank1 caller. Evidence and real screenshots are under
`build/verification/world-probe/`. This remains an isolated world-engine harness,
not an input-driven campaign test or physical cartridge test.


## Original vehicle geometry and sprites

`world_vehicle_use` implements the original7656/76C1/7732 candidate ordering and
22B7 entry gates. Requested modes4,8,12 mean LandRover, Hovercraft and IceDigger.
It returns0 blocked,1 entered/switched,2 exited, and updates native centre/feet
coordinates only on success. Entry needs source interaction type nonzero and
map group below4; IceDigger additionally requires group2. Exiting by selecting
the currently active vehicle bypasses those entry gates, as in PlayerMenu_Item.
Item availability, party selection, messages and vehicle persistence are supplied
by the integrated field/menu/save callers.

Land vehicles search four2x2 footprints with flag mask0D in original order.
Hovercraft searches eight four-cell footprints with mask0A. Its exit searches
eight single land cells, starting at the original vehicle facing index times2,
then wrapping. Native down/up/left/right maps to source facing2/0/3/1. Pixel
shifts include negative offsets and preserve2048x1536 wrapping. Movement uses
source74E4's leading samples. Because the primary cell is the lower-right cell
of a vehicle, up/left test two cells beyond that anchor; the previous helper's
one-cell up/left check has been corrected. Hovercraft masks0A; other legal
modes mask1. IceDigger checks and breaks both leading cells even if the move
ultimately remains blocked.

Ice metatilesD8..DF becomeD7 in original temporary chunk memory. A96-byte bitset
and four bookkeeping bytes represent those edits without allocating a full
12KiB map. `world_terrain_sync` derives original camera-origin chunks from
(nativeX-136,nativeY-112). When either source chunk changes, it clears ALL edits,
matching723D's reload of all four chunks, including still-overlapping chunks.
`world_meta_at`, collision and streamed map drawing see the replacement tile.
A separate `world_vehicle_footprint` implements7602's four-cell initial clearing
for mode12 in group2. Call it after full world load, and call terrain_sync after
position changes before drawing. Full map reload resets changes via world_select;
these temporary edits should not be persisted as permanent world terrain.
`world_ice_changed` reports newly broken cells for the caller's originalB7 sound.

`vehicle_art.c` contains the twelve original directional poses from bank18,
using original layout5 and paletteDB2. Native art preserves32x32 size and the
source anchor: upper-left at(player centreX-24,feetY-32). Color adaptation uses
eight shared three-color OBJ palettes. `vehicle_sprite_load` (LCD off) uploads
a mode/facing pose; `vehicle_sprite_draw` updates sixteen OAM positions each
frame. Data occupies4,608 bytes in bank118. Shared actor buffers avoid extra
WRAM allocation. Vehicle art uses bank1 OBJ84..99 and OAM0..15; it leaves the
interaction-only scene_actor_active flag clear. The caller reloads art after a
facing change or another screen takes VRAM, and calls scene_actor_hide explicitly
to restore Alis palettes on dismount. Original vehicle poses are static; travel
movement cadence and sound are supplied by the integrated main/travel controllers.

`tools/verify_vehicles.py` passes1,081,344 original-priority entry/exit cases,
1,671,168 movement checks,12,288 IceDigger footprints,4,528 changed-cell checks,
1,239 complete chunk-reset cases and5,280 entry/exit gate cases. It reads source
candidate and offset tables independently from the pinned ROM and calls actual
compiled C. Evidence is build/verification/vehicles-report.json.

`tools/verify_vehicles_native.py` separately verifies all twelve directional
poses,192 OAM entries,3,072 pattern bytes and28,416 protected font/Alis bytes in
a real CGB ROM. Seventy-five entry/exit cases and24 IceDigger scenes verify
28,728 rendered tile/attribute pairs, including source chunk reset and native
bank restoration. Evidence is build/verification/vehicles-native/report.json.
This establishes isolated geometry, mutation and sprite behavior, not a complete
input-driven campaign or physical hardware test.

The current world controller also retains a native B-button speed shortcut:
`main.c:move_player` chooses one or two pixels from B rather than original
`LABEL_7143` vehicle state (one pixel/16 ticks on foot, two pixels/8 ticks in a
vehicle). Its native A/Start menu bindings differ from the original two action
buttons, and its no-direction path omits source D6. These are explicit current
control/timing differences, not faithful original movement or hardware limits.
