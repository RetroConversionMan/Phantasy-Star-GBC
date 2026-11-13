# Original narrative and presentation sequences

Current integration status (2026-11-13): opening, recruitment, field presentation, Myau flight, ending narratives and real final credits are connected to the production dispatchers. General interaction transitions and guest/Governor sleep presentation are integrated as documented in SCENES.md and AUDIO_PORT.md. Caller-owned below describes an API boundary. Exact current ROM and reports are indexed in PROJECT_STATE.json; fixtures and integration suites do not establish a completed fresh campaign. The separate complete story and independent clean-power-on replay now pass.

These modules preserve original text, speaker order, palettes, source actor
movement and explicit VBlank counters. The original `WaitForVInt` A argument
selects a handler; it is never a duration. Source delays come from counters.

## Recruitment and large portraits

`cutscene.c` emits exact narrative actions for Myau, Odin and Noah. Myau's
five exchanges follow the Alsulin award even when an ultimately abandoned full
inventory award returns; Odin's five exchanges follow revival; Noah's two
exchanges choose the first speaker from living Alis, then Odin, then Myau.
`EVENT_CUTSCENE` connects these actions to the event dispatcher.

The same controller has the three introductory records, two Laerma Nut records
and six closing records. These are narrative portions; their surrounding
pan/flight/ending sequences belong to the main sequence dispatcher.

`tools/extract_cutscenes.py` extracts all nine larger original portraits, frame,
palettes and maps into banks116–117. The23 direct bank2 narrative texts use
IDs `C000+(source_address-8000)`, keeping source controls and dictionary text.
The normal dialogue cursor remains two lines; a separate38-byte lower buffer
supports original four-line narrative pages.

`verify_cutscenes.py` passed110 host assertions, nine native portraits,
13,728 pattern bytes,2,700 map/attribute entries, and38 narrative pages containing
2,736 character positions. The tests cover controller/data behavior; root's
integrated UI routing is tested separately.

## Palette effects

`presentation.c` and bank128 retain source palette-index identity across all
frames, including visually equal colors which later diverge to reveal the
hidden castle. Native palette selection optimizes the whole sequence.

| Effect | Source | Logical frames | Follow-up |
|---|---|---:|---|
| Odin revival |7C85 / B03_BE1D|111|Wait for A/B, then Odin narrative/music8A|
| Eclipse Torch tree |7CA6 / B03_BE4D|1|State mutations belong to field actions|
| AeroPrism |7CBB / B03_BE52,BE82|320|C2DC flag belongs to field actions|
| Ending sky |7CE4 / B03_BED0|216|Six standard closing text records|

`presentation_begin` requires LCD off; `presentation_tick` advances one logical
VBlank. These effects do not accept skips. `verify_presentation.py` passed four
effects,648 ticks,37,176 palette bytes and9,680 pattern bytes on a4MiB native
probe, including bank128 access and font/Alis preservation.

## Opening and final bitmap

`opening.c` reproduces42AC/43AA's224-tick planet pan. Source graphics contain98
tiles. Initial stars repeat across28 rows; the first scroll wrap replaces only
WRAM rows0–11 with planet data. Source73D0 progressively copies rows into VRAM.
The native renderer uses an absolute position128–352 and streams a32-row GBC
ring without an erroneous224-pixel scroll reset. The160×144 viewport is a
centered original-pixel crop; source artwork and source row timing are retained.

`opening_tick` accepts original A/B skip edges. A completed pan is followed by
an180-frame skippable hold; a skipped pan bypasses that hold. The caller owns
fades. `movie_scene_show(1)` provides original uncaptioned city background8. After fade-in,
`movie_city_caption()` patches the exact
five-row caption (“SPACE CENTURY342. / CAMINEET ON PALMA”). After another
180-frame skippable hold, the three introductory narrative records follow.
`movie_scene_show(2)` provides454E's final party bitmap, followed by208
unskippable frames before the original dungeon credits sequence.

`verify_opening.py` passed224 ticks and85,500 streamed tile cells against a
separate direct simulation of source WRAM/VRAM, five skip boundaries, three
static images, caption patch,7,520 pattern bytes and preserved font/Alis data. The original title is available as `movie_scene_show(3)`. Art is in
banks129–130; opening/flight code and descriptors share bank132. Probe cadence is logical; the integrated outer sequence must call
exactly once per VBlank and preserve source delays.

## Myau flight

`myau_flight.c` follows original actor15/16,5D30/5D5B. Bank131 stores eight
source poses84–8B,22 deduplicated native tiles. The outbound trajectory starts
at source X208/Y136 and decreases both on64 pose updates. The return route
(map23) starts X80/Y48, increases Y72 times and decreases X at intermediate
multiples of eight. The terminating Y120 branch intentionally skips the last
X decrement. Pose changes occur every eight frames;18B9 adds a final VBlank.
Total durations are507 outbound and571 return. Neither route accepts skips.

`verify_myau_flight.py` passed both routes,1,078 source ticks,138 pose updates
and4,312 OAM records. `myau_battle_palette` provides the all-blue source30
prelude and original low-eight-color restoration.

The caller plays soundB9 at the first actor tick, owns fades and preserves the
source branch: return map0 packed40/4C; outbound scene14,30-frame skippable
hold, Gold Dragon70 battle, then map23 packed28/1F unless defeat returns to title.
The two Laerma narratives/music8A occur only outbound. Native actor anchors and
fixed pose artwork are scaled5/8; pixel-phase differences are an explicit
resolution adaptation.

## Remaining verification boundary

Native graphics/controller probes establish extracted data, palette changes,
source sequencing and banking. They do not establish a full original campaign
playthrough. Integration, save continuity, ending credits, all event routes and
source audio must retain separate completion evidence in project status.
