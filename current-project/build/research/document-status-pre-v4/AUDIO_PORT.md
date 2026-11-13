# Native original-score audio

Current candidate `2e151f71ae14996d5753791d373b6ef9f0d7a27f7f86e3cab3742c39ea19668c`
integrates this driver and its implemented gameplay hooks. Thirteen exact-binary integration
suites and 28 source-backed travel music cases pass. The fresh full campaign and
its independent replay remain pending; isolated driver and fixture tests below
are separate evidence. Hardware sound differences, LCD-off timing and the lack
of a complete subjective listening review remain explicit limits. Missing
service/item-award hooks listed below are unfinished source presentation, not
hardware limitations.

A separately verified service/inventory patch (`161e252304c875aa64fc34845359dcec2362f3d6b76cb94ae1e47fd8330a0cb7`) supplies hospital C1, revival C5 with the original skippable wait, and B3 on actual awards/purchases/replacements. Its source and native chronology evidence is frozen in `build/milestones/service-inventory-order-20261113/`. These fixes are awaiting combined integration. Vehicle motor scheduling also remains active integration work: `build/milestones/vehicle-motor-source-20261113/` verifies original7C18→score→7143 order over 12,288 source state cases and 1,152 source score frames; this source oracle alone does not establish a native fix.

Implemented in `src/audio.c` (bank15), with a small fixed-bank interrupt entry in
`audio_irq.c`. The cartridge executes native GBC C code, not a Z80 emulator.
The original bank12 bytecode, headers, instruments and modulation data retain
their source addresses in bank61. Original fixed-ROM banks0/1 are copied as
read-only lookup bytes in banks62/63: some original SFX modulation indices walk
past the nominal five-pointer table and read fixed-ROM addresses. These aliases
are real source behavior and are preserved.

`tools/extract_audio.py` checks the pinned source ROM SHA and resolved symbols.
It also generates nearest GBC frequency/noise conversion tables in bank15.
`audio_init`, `audio_command(source_id)`, `audio_tick` and `audio_stop` are banked.
`audio_install` is called once during startup. Main code sends commands through
a single-byte mailbox, just like source C004. A later command before the next
sound tick replaces the earlier one.

## Verified score behavior

All20 original music commands81–94,53 effect commandsA0–D4, and controlsD5–D9
are interpreted. This includes byte-wrapped durations/transposition, inherited
note lengths, calls/returns, counted loops/jumps, raw pitch and slides, separate
volume/pitch envelopes, drums, secondary music overlays, effect channel
priority, fade-out/fade-in, suspended background resumption and channel cleanup.

`tools/verify_audio.py` runs the actual original ROM's Z80 driver, independently
of the C translation, using the isolated environment's `z80==1.2.0` package.
Every ordered PSG write and all512 bytes of source sound RAM are compared on
every frame:218,600 frames,437,200 assertions. Each music track runs7200 frames;
every effect and control is also exercised over music, with overlapping
priority/fade/reset sequences. The reference maps original fixed banks0/1 as
well as bank12, so malformed-looking modulation pointer aliases are checked.
Additional701,056 ASan/UBSan logic checks cover every APU divider/noise mapping,
attenuation, all commands and long mixed-command sequences.

`tools/verify_audio_emulator.py` builds a separate native GBC probe. It compares
2400 native driver updates against the same original Z80 RAM, checks real
non-silent APU PCM, and stress-tests1200 frame interrupts during continuous
bank61/62/63 copies with caller bank1 restored. Evidence is in
`build/verification/audio/reference-report.json` and `native-report.json`.
A native excerpt is `build/verification/audio/source-track-85-native.wav`.
The installed Z80 test emulator is test tooling only. On this Mac its build
needed `CXXFLAGS='-DNDEBUG -I/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/c++/v1'`.

## Frame scheduling and hardware adaptation

The native scheduler uses STAT's LY==LYC comparison with LYC0, exactly once per
display frame. This reserves the LCD comparison interrupt. A full score update
can exceed VBlank's ten scanlines; doing it directly in VBlank starved GBDK's
`DISPLAY_OFF` wait. The scanline0 scheduler keeps VBlank available and is tested
with real battle graphics loads and controller flow. CPU fast mode is enabled
in the integrated game and probes. The ISR uses GBDK's banked trampoline; its
ROM0 wrapper and bank readers restore the interrupted bank.

LCD-off intervals pause the score because the Game Boy stops LCD interrupts.
This differs from SMS hardware, whose video interrupt can continue with its
display disabled. Game Boy frame cadence is also slightly different from the
NTSC SMS. Eliminating those timing differences would require a separately
calibrated timer scheduler and validation with all display/load paths.

The three PSG square tones map to GBC pulse1, pulse2, and a square-wave pattern
in channel3. Original2dB attenuation is rounded to native amplitude levels;
source divider frequencies use nearest native APU periods. Channel4 approximates
SN noise with the nearest native clock and GBC noise width. SMS/GBC noise
polynomials, periodic-noise behavior, volume resolution and channel phase
behavior differ; this is an audible hardware adaptation, not sample-identical
SMS output. Changing native pulse/wave volume retriggers the channel, unlike a
PSG volume write. Source noise-control writes retrigger the native noise unit.
FM arrangements are not synthesized: the supplied source driver is PSG.

## Integrated game hooks and presentation limits

Source map tracks use bank0 LABEL_DD9's24-entry mapID table, exposed by
`audio_map_track`. Source C30E is vehicle/transport state:0 uses the map track,
1–15 uses8F,16+ usesB8. It is not an interior type.
The current travel music correction also compares all 14 road/ship exits,
with and without skips, against the actual `LABEL_DD9` bytes. It corrects the
earlier travel-table map14 entry from88 to87; those 28 cases do not constitute
a full campaign or a subjective soundtrack review.
`audio_battle_track` gives89 for ordinary battles,92 for Lassic and0 to preserve
the existing DarkFalz track. `audio_enemy_effect` copies byte23 of each original
24-byte visual record at its resolved03:8FDF address.

Battle controller hooks implement original entry, escape, defeat and victory
commands, the one-VBlank victory upload beforeD8 (181 ticks including the explicit180-frame Lassic/DarkFalz wait),
Tarzimal/Saccubus exceptions, level soundBA, and direct physical/status sounds.
Player weapon, gun, Fire, Wind and Thunder effects now emit their original actor11/12 sound at each traced hit, followed by impactAD or missBB. Ordinary enemy physical motion emits its descriptor sound and impactAE/missBB; chest opening/traps retainB0/B1/B2 at their source phases. Ordinary enemy Fire/Thunder now emits actor17/18 A8/A9 and per-hit blockedBB/impactAE through the source-verified controller timeline described in BATTLE_PRESENTATION.md. Core food/escape/talk item prefixes and C1/BC/monster-only AC/D5 now follow source-executed chronology, including six source close waits before D8; persistent action state remains precomputed. Lassic/Dark Falz target-specific actor sequences now issue their source descriptor sound and AE/BB at verified impact markers; Golden Dragon source14 preparation and blue outcomes are now checked independently, including89/AF/D8 victory and89/94 defeat order. Remaining presentation timing adaptations and full-main integration evidence are recorded separately.

Map, dungeon, field item/spell, story scene and travel controllers issue their implemented source commands through the same mailbox. Field emitted lines preserve before/after sound ordering; source FluteC2/D5 and context-dependent battle items use this path. Source intro/recruitment/flight/ending sequences have their own verified timing and audio hooks in the sequence/movie modules. These hooks are integrated; the standalone audio driver probe alone does not establish a complete campaign or exact presentation for every branch.

Current source presentation omissions remain in the service and general item
award paths. Original hospital `LABEL_2999` writesC1 before its recovery text;
revival `LABEL_2A98` writesC5 afterB9C4 and then calls the skippable30-frame
`LABEL_2D33` wait. `services.c` and the main service dispatcher do not yet emit
those sounds or that extra wait. Original `Inventory_AddItem` writesB3 on an
ordinary successful addition; native `rpg_add_item` is silent, and event awards,
shop purchases and chest awards do not supply a general B3 hook. The separately
verified Torch/Nuts continuation does emit its B3. These omissions are separate
from the driver's command support and the GBC timbre/cadence adaptations.

Timing correction: source `WaitForVInt` stores its A argument as a handler selector inC208; it is not a frame count. The `$10` call at15FC invokes one full-map/palette VBlank. ExplicitB-counted loops such as2D49 provide multi-frame waits. The earlier native16-frame victory delay was corrected to1. Enemy attack effects now index each original enemy record's visual descriptor byte19 before reading descriptor byte23; enemy IDs and descriptor IDs are not interchangeable.

## Recorded complete command capture set

`tools/render_audio_review.py` captures all20music commands81–94 and53effect
commandsA0–D4 using the production scanline0 scheduler and actual native GBC
APU. The73WAV clips and `report.json` are in
`build/verification/audio-review/`. Music excerpts last600nativeframes and
effect excerpts180frames, with source track85 underneath each effect.
All21,540frames pass continuing score-update checks, non-silent PCM and
zero driver faults. Every source file and capture is hashed in the report.
This supplies complete command coverage for listening; it does not establish
subjective sound quality, effect identity from the waveform alone, or physical
hardware behavior. The independent original-Z80 driver comparison establishes
score/effect identity and ordering. No listening review is claimed.

Additional current integration gaps found by the source-callsite audit:
Suelo event1 omits C1 after text0006 and before living-party rest (`48DF`);
guest-room event57 omits A0/208-frame sleep/C1 (`4D7A`); the Governor nightmare
prelude omits A0/208-frame sleep (`4C70`); and Dr. Mad's accepted sacrifice
omits AE before Myau's death textB728 (`49E6`). General interaction entry/exit
also omit D6, table3D25 music8D/8E and conditional D8 (`GameMode_LoadInteraction`,
`3BC5`). Source map movement's no-direction branch writes D6 (`7143`); the
native movement early-return path does not. These unfinished hooks are separate
from the implemented audio interpreter and its command-level verification.
SCENES.md records the associated missing outer fades.
