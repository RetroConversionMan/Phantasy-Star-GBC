# Original interaction graphics

Current integration status (2026-11-13): candidate `b72feead6a4a0b9efe779a2a61fbce7e96bd30247e3149b0ce1793dd414d59a1` integrates scene graphics, portraits, retained Dark Falz body/palette, source reveal/ending portrait, outer scene fades and rest/sleep/sacrifice sequences. Thirteen exact-binary integration suites and focused final-presentation checks pass; the complete story and independent clean-power-on replay now pass. Earlier asset counts and isolated probes below retain their scope. The corrected shared scene pool has6,620 patterns; BATTLE_PRESENTATION.md records its evidence.

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

The current pool has6,620 deduplicated native patterns in13 banks97–109;
additional banks110 and192 hold scene maps.
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

## Integrated outer presentation

Map and dungeon loads now follow source FadeOut2, load/upload, LABEL_2FD and
FadeIn2. The shared C21D signed phase advances on source Wait16 boundaries;
the C2F4 map-music latch remains distinct from the audio driver music state.
Interaction entry issues D6, fades out, selects table3D25 music, uploads and
fades in. Return issues D8 only when the table entry is nonzero: types20/21
select8D and22..27 select8E. Dungeon rooms253/254/255 retain their source
no-D6/no-music branch. Existing stairs, pitfalls, travel, recruitment and boss
sequences share the source phase at their traced boundaries.

Guest event57 retains the source A0/208-frame sleep, C1 and living-party heal.
The Governor nightmare includes scene32, A0/208-frame sleep, post-battle return
and healing after the room load. Suelo C1 precedes healing; Dr. Mad AE precedes
the sacrifice death text. Native dialogue-window closure remains an explicit
adaptation, retaining the six original close waits.

The initial source/native component evidence is frozen in
`build/milestones/interaction-presentation-20261113/`. Combined evidence is in
`build/milestones/full-final-verifiers-20261113/`, including22 native requests,
shared-phase title/guest cases and four final-story full-ROM presentation cases.
These controlled fixtures establish their boundaries, not a complete campaign.
