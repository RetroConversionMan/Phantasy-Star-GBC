# Original roads and space travel

Current integration status (2026-11-13): all six road and eight ship routes, including normal/skipped endpoint music, are integrated in candidate `2e151f71ae14996d5753791d373b6ef9f0d7a27f7f86e3cab3742c39ea19668c`. Thirteen exact-binary integration suites and 28 source-backed travel music cases pass. The road3 arrival now uses original DD9 command87; its arrival fade takes one additional native audio-clock frame in the recorded comparison, so old controller logs are not assumed frame-compatible. Living-party leader/follower sprites remain unfinished in this candidate, and complete fresh campaign and replay verification remain pending.

`travel.c` is a source-derived once-per-frame controller for six roads (F0C)
and eight ship routes (ABF). `travel_begin` accepts tags1..6 or81..88 and returns
world-load, audio, palette and redraw flags. Its state exposes native centre/feet
coordinates, original map ID, direction, ship visual mode and music command.
The caller owns the initial fade-out into travel; begin starts with the original
departure's fade-in. `travel_step` returns explicit presentation changes and
TRAVEL_DONE only after the final endpoint fade-in. It never dispatches encounters
or accidental map triggers during these controlled sequences.

Roads walk in their original direction at one source pixel per logical frame,
with sixteen frames per completed step and original lengths4,11 or12. Either
action-button edge skips to the same source endpoint. The nonzero original road
tag bypasses collision and stops the usual walk-frame animation; the presenter
uses the original standing directional pose while moving. Party follower sprites
remain caller work; the current native presenter draws Alis.

Ship departure scroll uses the original8.8 subtraction and224-pixel VDP scroll
wrap while its speed increases by8 for256 updates. Palette fade-out begins only
at speed-high-byte7. The remaining source fade completes before space artwork
loads. Space scroll subtracts two pixels per update and starts at scroll0 with
counter8. Its first update wraps immediately, so the complete leg is785 logical
frames, not896. Counter2→1 changes the planet colors and first twelve WRAM rows.
The original VBlank routine uploads only the current physical row; the controller
retains separate updated-row and arrival-row masks to preserve that progression.
The visible VDP source row is(screenY+scroll)%224, consistent with MAME's
[315_5124 implementation](https://github.com/mamedev/mame/blob/master/src/devices/video/315_5124.cpp).

Arrival loads its distinct route triple and starts at speed0800. It performs257
subtractions, including the zero-speed update, before the final endpoint. The
original C307 byte is retained when the space phase is skipped; it becomes the
arrival fractional scroll byte. Each flight movement phase can be skipped
independently. Source9-step fade-out and10-counter-tick fade-in use the original
four-frame divider and RGB component update order. Native asset transfer time
is separate from these logical source frame counts.

`WaitForVInt`'s A argument is a handler-table offset, not a number of frames.
The caller should compute action-button edges with the original sampling rules:
only road/departure/space/arrival movement handlers read joypad state, while
palette-fade handlers do not. A button held through a fade can therefore become
a new edge when movement resumes. The controller accepts an already computed
edge and does not invent a separate input latch.

`travel_render.c` owns travel BG/OBJ presentation and shares existing scene
buffers. Original bank23 graphics, bank28 space layouts and three planet palette
variants occupy12,552 bytes in native bank120, together with both source ship
poses from bank18. Code is in119. The native space viewport crops160x144 pixels
from original source offset(56,32), matching the world's native centre/feet
anchor without scaling the art. Seven four-color BG palettes and eight OBJ
palettes explicitly adapt the original colors. Font/Alis graphics are preserved.
The presenter streams a new row when required, rebuilds at the source224-pixel
wrap, and reloads native quantized graphics when the planet palette changes.
It emits no audio itself: the caller dispatches state.music on TRAVEL_AUDIO.

`tools/verify_travel.py` executes original Z80 machine code7143,998,9E9,73D0 and
7B40. Only unrelated world graphics callbacks723D/72A6/733A are replaced with
returns in coordinate tests. All fourteen routes pass864 road movement frames,
4,104 ship movement frames,6,280 space frames,11,239,424 source VDP tilemap bytes,
1,280 palette cases and120 skip cases. Evidence is
build/verification/travel/report.json.

`tools/verify_travel_native.py` passes all fourteen full routes in a real CGB
ROM:13,544 logical updates,460,496 state-byte comparisons,572 viewports,
223,364 tile/attribute pairs,37,408 palette bytes and33,152 protected font/Alis
bytes. Actual emulator screenshots are retained beside the report. Probe command
round trips include its VBlank wait and palette readback: mean2.65 emulator ticks
for world updates and2.07 for space, with scene loads11..37 ticks. These are not
isolated presenter benchmarks and do not establish exact hardware-frame cadence
in the main game. Evidence is build/verification/travel-native/report.json.
Input-driven story integration and physical hardware remain separately unverified.

The shared fade entry points are also native-tested. `travel_fade_current()`
performs one original7B40 fade-out step on BG palettes0..6 and OBJ palettes0..7.
`scene_fade_begin(in)` captures the current60 colors; inward mode immediately
blacks them. `scene_fade_step(step,in)` reconstructs the source component-order
fade from the captured colors. Callers retain the four-VBlank cadence and
nine-out/ten-counter-in behavior. UI BG palette7 is preserved. The latest native
probe checks3,600 additional palette bytes for these entry points.


## Atomic movie and travel fades

The verified source candidate `5d298e3647515398844606873b4255b721448bf1e328063b95a2c09c3ffc1221` fixes partial-frame palette writes in `travel_render.c`. It stages all28 BG colors and32 OBJ colors before waiting for VBlank, then writes120 palette bytes in one short interrupt-protected transfer. The BG staging array adds56 static WRAM bytes; UI palette7 is untouched. Source component order and logical fade counters are unchanged. Native preparation/display overhead remains separate from original timing.

`tools/verify_scene_fades.py` checks every actual PPU frame with all seven BG and eight OBJ palettes visible and the production score interrupt running. The original helper produced72 mixed-color frames; staging with the standard palette setters still produced28. The final transfer produces zero mixed-color frames across252 frames, exact60-color readbacks at every source step, intact64-byte stack guard, and continuous score updates while the LCD is on. Two explicit LCD-off fixture resets explain the aggregate22-frame score pause.

All14 original travel routes still pass13,544 native state updates,223,364 tile/attribute comparisons and37,408 palette-byte comparisons. The combined candidate passes actual travel, all opening/recruitment/flight/ending scenarios, and integrated audio including the ending stack/score guard. Evidence and the source snapshot are preserved in `milestones/scene-fades-20261112` and `build/source-snapshots/scene-fade-candidate`. The focused candidate is preserved unchanged. Its updater was subsequently shared through `palette_commit.c`; all 169 scene assets and source flash masks still pass. The shared module is integrated in canonical `dedacde4`, whose thirteen combined suites pass. Boss/combat-flash extensions were separate work at that historical milestone; their later integrated implementation and evidence are recorded in BATTLE_PRESENTATION.md.
