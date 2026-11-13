# Original interaction graphics

Current integration status (2026-11-13): scene graphics, portraits, retained Dark Falz body/palette and the source reveal/ending portrait are integrated in candidate `2e151f71ae14996d5753791d373b6ef9f0d7a27f7f86e3cab3742c39ea19668c`. Thirteen exact-binary integration suites and 28 travel music cases pass; complete fresh campaign and replay verification remain pending. Earlier asset counts and isolated probe statements below retain their historical scope. The corrected current shared scene pool has 6,620 patterns; BATTLE_PRESENTATION.md records its exact evidence.

The native graphics come from the pinned original ROM, SHA-256
`9e324e92bd833b45126861b6f1d2dcbb51251bdf3df6d563ab3a3ff784d8cf88`.
The extractor reads verified symbol addresses, not numeric label suffixes.

## Static scenes

`tools/extract_scenes.py` composes the original 256×192 background and initial
actor pose before adapting it to 160×120. It decodes four-plane graphics,
both tilemap streams, flips, source palette selection, sprite Y+1 and background
priority. Seven native four-color palettes preserve palette7 for the UI.
The final24 screen rows are reserved for native text.

The 169 scene records cover all raw world entrance pairs, their actual
GameMode_LoadInteraction remapping, backgrounds1–31, blank32, explicit governor
and final-boss preparations, and distinct FF dungeon rooms. Scene6 includes all
ten additional group8 portrait combinations. Raw entrance rows remain covered
for reference; this does not prove all suffix-sharing table entries are reachable.
The original remap uses C308 (group), while C309 retains map ID:

- group0: type5→4;
- group1/7: type1→5;
- group8: every type→6;
- group10: type9→8;
- remaining zero→1.

FF rooms use their bank9 graphics/map and dungeon palette, not scene-table15.
`scene_show_room` selects the relevant lit or unlit variant. Event handlers can
replace the entrance portrait (Luveno, his assistant, Noah). Prepared enemies
use original enemy descriptors, including Dark Falz's retained source background.

There are6,705 deduplicated native patterns in banks97–110 and192.
`scene_show` returns0 without touching VRAM for an unsupported tuple.

## Dungeon actors

`tools/extract_scene_actors.py` supplies all61 NPC initial poses and source
prepared enemies8,22,27,43,46,49,62,71. Enemy BG overlays preserve opaque source
zero pixels using floor palette color5; sprite zeros remain transparent. There
are113 native assets in banks111–114.

Actors use OBJ bank1 tiles84 onward, leaving Alis tiles0–83 intact. The shared
`scene_actor_show_data` upload format is graphics, four-byte sprite records,
then64 palette bytes. Chest and special presentation modules use the same
interface. `scene_actor_hide` clears OAM and restores Alis palettes.

The static scene, actor, recruitment and presentation renderers share104bytes
of scratch space. They must not upload concurrently.

## Verification and limits

`tools/verify_scenes.py` passed169 scene renders,811,200 pattern bytes,
50,700 map/attribute entries and865,280 protected bytes, including bank192 in a
4MiB native ROM. `tools/verify_scene_actors.py` passed113 actors, their patterns,
OAM and palettes, plus protected font/Alis data and palette restoration.
Reports and screenshots are under `build/verification/scene-probe` and
`build/verification/scene-actors`.

These are native banking/graphics probes, not a complete story playthrough.
They compare generated source-derived data with native VRAM/OAM; they do not
claim SMS screenshot or palette identity. Static initial poses are separate
from battle animation, moving vehicles, Myau flight and palette effects.

## Current unfinished outer presentation

The image renderer does not implement the surrounding original transition
sequence. Native `main.c:enter_map` and `game_flow.c:enter_dungeon` currently
reload directly, whereas source `GameMode_LoadMap` and `GameMode_LoadDungeon`
fade out and return through `LABEL_2FD`/`FadeIn2`. Source `GameMode_LoadInteraction`
also emits D6, fades out, chooses music from `LABEL_3D25`, performs an upload
wait and fades in; `LABEL_3BC5` restores audio with D8 when that table entry is
nonzero. Native `show_interaction_scene`, dungeon room event entry, and their
ordinary return paths omit these outer sequences. Types20/21 select8D and
types22..27 select8E. Existing source stairs/passage fades in
`dungeon_present_transition`, pitfalls, travel fades, recruitment and final-boss
sequences are separate implemented paths.

Event57 guest-room sleep still omits source `LABEL_4D7A` fades, A0, the208-frame
wait and C1 around living-party rest. The Governor's initial nightmare stages
still omit source `LABEL_4C70` scene32 fades/palette and A0/208-frame sleep
sequence, including the post-battle fades before text02A2. The later palace29
restoration/fall is implemented and does not cover these earlier boundaries.
These are current unfinished source presentation, not hardware limitations.
