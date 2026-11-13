# Phantasy Star: Sega Master System to native Game Boy Color

This guide describes the implementation included in this package, how its source and assembly fit together, how to reproduce it, and what the verification establishes. The accepted release is the complete native game through its ending. It includes all eleven world groups, original transitions and story, inventory and services, battles, first-person dungeons, vehicles and interplanetary travel, music/effects, and five named saves. Its full earned campaign and independent replay pass. Physical hardware testing and a complete subjective soundtrack review remain outstanding external validation.

The original transfer began with a verified Camineet exploration ROM and unintegrated world/RPG data. That historical state is preserved; it should not be confused with the accepted release documented here. The frozen [verified baseline](verified-baseline/) remains unchanged. Current implementation and acceptance are recorded in [PROJECT_STATE.json](current-project/PROJECT_STATE.json), [PORT_STATUS.md](current-project/docs/PORT_STATUS.md), and [CAMPAIGN_VERIFICATION.md](current-project/docs/CAMPAIGN_VERIFICATION.md). Some subsystem documents retain earlier milestone descriptions; their final status prefaces and final-release evidence identify what was subsequently integrated.

## 1. Attribution and exact inputs

The original disassembly used for this port is **[sung3r/ps1disasm on GitHub](https://github.com/sung3r/ps1disasm)**, pinned to commit [`8efc4110adcf1a81c70d40522016393ba6f6b5ae`](https://github.com/sung3r/ps1disasm/tree/8efc4110adcf1a81c70d40522016393ba6f6b5ae). Its original Z80 source code is excluded from this revised package. Only the supplied reference ROM and original README/disclaimer remain in [current-project/upstream/ps1disasm](current-project/upstream/ps1disasm/). Credit for the disassembly belongs to its upstream authors and contributors. The included native implementation, conversion tools, generated native assets, and verification work are separate from that upstream work.

Original Phantasy Star content belongs to its respective rights holders. The package retains the [upstream README/disclaimer](current-project/docs/UPSTREAM_README.md) and [GBDK runtime terms](current-project/docs/GBDK-LICENSE.txt). Their inclusion is attribution and preservation of existing terms, not a new ownership or distribution grant. The reference SMS ROM is the supplied project input.

| Artifact | SHA-256 |
| --- | --- |
| Original 524,288-byte SMS ROM, `upstream/ps1disasm/ps1original.sms` | `9e324e92bd833b45126861b6f1d2dcbb51251bdf3df6d563ab3a3ff784d8cf88` |
| Preserved 64 KiB Camineet GBC baseline | `ffe3d67bb15c3d563f6f9b61e08dc166129818d99500a9af6fd8e9eb7c1b1356` |
| Accepted 4 MiB native GBC release v5 | `b72feead6a4a0b9efe779a2a61fbce7e96bd30247e3149b0ce1793dd414d59a1` |

The production cartridge is [current-project/build/phantasy-star-gbc-world.gbc](current-project/build/phantasy-star-gbc-world.gbc). The standalone play copy is [current-project/releases/phantasy-star-gbc/Phantasy-Star-GBC.gbc](current-project/releases/phantasy-star-gbc/Phantasy-Star-GBC.gbc). They contain the same accepted binary.

## 2. What “all the assembly” means here

This is a native reimplementation compiled for the Game Boy Color's SM83 CPU. The cartridge does not run a Master System emulator. Most authored runtime code is C; low-level upload routines contain inline SM83 assembly. GBDK 4.5.0 compiles that code and generated data into native machine code.

| Material | Location | Purpose |
| --- | --- | --- |
| Original Z80 assembly: external reference, excluded from this ZIP | [Pinned upstream revision](https://github.com/sung3r/ps1disasm/tree/8efc4110adcf1a81c70d40522016393ba6f6b5ae) | Reference implementation used during conversion; obtain separately for source-text-dependent work. |
| Native source: 262 C files and 80 headers | [src](current-project/src/) | Runtime implementation and generated native data. |
| Authored inline SM83 | [palette_commit.c](current-project/src/palette_commit.c), [dungeon_motion_upload.c](current-project/src/dungeon_motion_upload.c), [ending_upload.c](current-project/src/ending_upload.c) | Timing-sensitive palette and graphics transfers. |
| Compiler-generated SM83: 262 `.asm` modules | [build/obj](current-project/build/obj/) | Assembly generated from each production C translation unit; accompanying listings, symbols and objects permit inspection. |
| Linker output | [build](current-project/build/) | Final ROM, map and native symbol information. |
| Original assembled symbol map | [ps1built.sym](current-project/build/sms-reference/ps1built.sym) | Resolves source labels for extraction and reference execution. |

There are no authored standalone `.asm` or `.s` files in the production `src` directory. The generated assembly is kept as modules because each has its own code/data sections and bank placement; concatenating it into one assembly file would discard useful build structure. Change the C, inline assembly, or extractor inputs and rebuild rather than editing generated assembly as the primary source.

The CPUs share some ancestry, but changing the original assembler target cannot produce this port. The original uses Z80 IX/IY registers, instructions and flags absent from the SM83, Sega mapper writes at `$FFFC–$FFFF`, an `$8000–$BFFF` switched ROM window, and VDP/PSG port I/O. The native implementation replaces those hardware operations with GBC memory banking, tile maps, palettes, sprites, interrupts and APU writes while preserving source game rules.

## 3. Conversion workflow and reproducible build

The work followed the source-to-data-to-runtime chain below. This describes the conversion history. Repeating the original-source assembly, lexical audit or source-text-dependent extraction steps requires a separate pinned checkout; the native build uses included generated data and remains self-contained with its toolchain.

1. Verify the supplied manifest, source commit and ROM hashes. Preserve `verified-baseline` and reproduce it in a separate sibling directory with GBDK 4.5.0. The Mac rebuild was byte-identical and passed movement/save checks plus 59,451 tile/attribute comparisons.
2. Assemble/inspect the pinned original source and retain its symbol map. Resolve labels to actual addresses and apply the Sega bank mapping before reading the ROM. A hexadecimal suffix in a label is not, by itself, proof of its final assembled address.
3. Decode original maps, metatiles, collision flags, entrances, item/character/enemy tables, event/dialogue records, packed dungeon floors, graphics and score bytecode using the included Python tools.
4. Generate GBC-compatible C arrays: two-bit tiles, palette assignments, native tile maps, bank descriptors and rule tables. Retain source indices and flags needed for behavior and priority; color quantization must not erase their meaning.
5. Implement native state machines and source-specific rules in C, with bank-safe calls and explicit hardware ownership. Integrate them through the field, battle, dungeon, travel and presentation controllers.
6. Compare source execution and data against native logic, test actual GBC binaries, then run the whole earned campaign and independently replay the exact controller stream.

Generated assets are included, so rebuilding the accepted cartridge does not require regenerating them first. The production [Makefile](current-project/Makefile) requests **256 ROM banks**, CGB-only mode, MBC5 and 8 KiB battery RAM. The obsolete four-bank configuration from the original handoff is not the current build configuration.

For the ordinary native build, work in a disposable copy of the extracted package and run this from its root:

```sh
python3 build_rom.py --jobs 4
```

This uses Python's standard library; no virtual environment or Python packages are needed merely to build the included generated assets. The helper forces the production build and checks the accepted ROM hash. [BUILD_AND_TEST.md](BUILD_AND_TEST.md) provides delivery verification, direct build alternatives, optional original-SMS assembly verification, and audit reruns.

To recreate the macOS test environment as well, install the recorded versions:

```sh
python3.12 -m venv .venv
.venv/bin/python -m pip install -r current-project/requirements-lock-macos-arm64.txt
cd current-project
make -B GBDK_HOME=.tools/gbdk PYTHON=../.venv/bin/python
shasum -a 256 build/phantasy-star-gbc-world.gbc
```

Use the **GBDK 4.5.0 binary for the host OS/architecture**. The included installed toolchain is macOS ARM64; it is not a Linux or Windows executable. Keep `GBDK_HOME` short and relative: this Mac `lcc` release has a fixed path-buffer limitation. Recreate the Python environment instead of copying an installed virtual environment from another machine. The explicit `PYTHON` override is necessary in a relocated package because the Makefile's original default refers to the development workspace. Host logic tests additionally need a C compiler with sanitizer support. Some verification helpers currently use macOS-specific `-dynamiclib`, so running every host test unchanged on another OS is not promised.

Useful commands, still from `current-project`:

```sh
make baseline PYTHON=../.venv/bin/python
make verify PYTHON=../.venv/bin/python
make verify-logic PYTHON=../.venv/bin/python
make verify-world PYTHON=../.venv/bin/python
../.venv/bin/python tools/verify_release_candidate.py build/phantasy-star-gbc-world.gbc --output build/verification/local-candidate-new
```

`make baseline` copies/builds the preserved baseline separately and checks it against the package's original `FILE_MANIFEST.json`; keep that manifest and sibling `verified-baseline` layout. It expects the local GBDK installation at `.tools/gbdk`. `make verify` is a boot/cartridge smoke test. The last command runs thirteen integration suites and needs a new output directory. Perform rebuilds/tests in a working copy if you want to preserve every packaged build log unchanged.

`make assets` regenerates its listed world/RPG/dialogue/enemy/font and party/vehicle assets, but the complete target requires the separately obtained original source: for example, `extract_rpg.py` reads original constants and `extract_dialogue.py` parses source text. It does **not** regenerate every cinematic subsystem. Certain focused checks, including `verify_save_slots.py` and `verify_dialogue_stream.py`, also need original source text. [BUILD_AND_TEST.md](BUILD_AND_TEST.md) describes restoring that external checkout only in a disposable copy. Other extractors are retained individually; inspect their arguments and output paths before use. Never run a legacy/experimental extractor over accepted generated files merely because it has a similar name.

| Conversion area | Extractors in `current-project/tools/` | Native entry points / explanation |
| --- | --- | --- |
| Worlds, animation, party, vehicles | `extract_world_motion.py`, `extract_party_world.py`, `extract_vehicle_cycles.py` | `world.c`, `world_motion.c`, `party_world.c`, `vehicle_cycle.c`; [WORLD_FORMAT](current-project/docs/WORLD_FORMAT.md), [WORLD_MOTION](current-project/docs/WORLD_MOTION.md) |
| Rules, text and enemies | `extract_rpg.py`, `extract_dialogue.py`, `extract_enemies.py` | `rpg.c`, `events.c`, `dialogue.c`, `battle.c`; [RPG_RULES](current-project/docs/RPG_RULES.md), [EVENTS](current-project/docs/EVENTS.md), [BATTLE_RULES](current-project/docs/BATTLE_RULES.md) |
| Dungeon geometry and motion | `extract_dungeons.py`, `extract_dungeon_motion.py`, `extract_dungeon_production.py` | `dungeon.c`, `dungeon_play.c`, `dungeon_motion.c`; [DUNGEON_RULES](current-project/docs/DUNGEON_RULES.md), [DUNGEON_MOTION](current-project/docs/DUNGEON_MOTION.md) |
| Scenes and battles | `extract_scenes.py`, `extract_scene_actors.py`, `extract_battle_scenes.py`, weapon/enemy-magic/boss extractors | `scene.c`, `battle_view.c`, `battle_weapon.c`, `enemy_magic.c`; [SCENES](current-project/docs/SCENES.md), [BATTLE_PRESENTATION](current-project/docs/BATTLE_PRESENTATION.md) |
| Travel and story sequences | `extract_travel_graphics.py`, `extract_opening.py`, `extract_myau_flight.py`, `extract_ending_walk.py` | `travel.c`, `opening.c`, `myau_flight.c`, `ending_walk.c`; [TRAVEL](current-project/docs/TRAVEL.md), [CUTSCENES](current-project/docs/CUTSCENES.md), [ENDING_WALK](current-project/docs/ENDING_WALK.md) |
| Audio | `extract_audio.py` | `audio.c`, `audio_irq.c`; [AUDIO_PORT](current-project/docs/AUDIO_PORT.md) |
| Persistence | Explicit native serialization rather than ROM extraction | `save.c`, `save_slots.c`, `save_ui.c`; [SAVE_FORMAT](current-project/docs/SAVE_FORMAT.md) |

## 4. Banking, world graphics and movement

The complete cartridge uses 256 sixteen-KiB ROM banks. Banks 32–53 hold the eleven world groups, two per group. Descriptors and fixed-ROM helpers such as `bank_read8`/`bank_copy` restore the caller's selected bank. Code executing in a switched window must not map its own instructions away. Banked GBDK calls and fixed-ROM transfer wrappers solve that problem; passing a pointer to data in an unmapped bank does not.

Each world group contains 128×96 sixteen-pixel metatiles: 2048×1536 world pixels. Native player coordinates represent horizontal center and feet; the source primary trigger sample is `(x−8, y−16)`, with wrapping. Source camera origins must not be substituted for these coordinates. The verified Camineet position becomes world `(1688,304)`, map 4.

The renderer streams a 21×19 tile viewport into the GBC's wrapping 32×32 background map. Sixteen-bit logical tile coordinates handle the full 256-tile world width. Up to 448 background patterns occupy both VRAM banks while preserving font and sprite allocations. Original flips, palette selection and priority survive conversion. Source color index zero remains zero; nonzero indices remain opaque even when two source colors quantize to the same GBC color.

On-foot movement follows original `LABEL_74E4`: test the leading source metatile before starting a sixteen-pixel step. It is not generic four-corner collision. The separate `world_can_stand` placement helper retains its own baseline checks. Source `LABEL_77AC` gates entrance lookup with tile flags; coordinate equality alone is insufficient. Special town exits use `LABEL_7AC0+1`, and roads use `LABEL_F0C`. Encounters/triggers run at source movement boundaries, not on every animation frame.

Original world animation (`LABEL_62BC`/`LABEL_630A`) has six signed-byte countdown slots. Only the first enabled slot that expires updates; later slots do not even decrement that tick. Roads reset/reverse selected phases. An early ordinary-upload implementation showed partially updated frames; aligned, contiguous VBlank transfers now commit an entire phase atomically. The source/native animation tests preserve this unusual scheduling rather than replacing it with independent generic timers.

Living party members pack in the original Alis → Noah → Odin → Myau display order, with source delayed following and compare/swap ordering. Walking uses sixteen one-pixel ticks; vehicles use eight two-pixel ticks. Vehicles suppress the walking party and retain source color-cycle phase/countdown across boarding, map changes, battles and saves. Landrover/IceDigger cycle while moving; Hovercraft also cycles at rest. The final v5 fix removed a duplicate successful vehicle map reload: a field action already resumed through the loading path, so calling the loader again produced an extra fade/load. Source control-flow and native controller cases now show one successful load and no denied-action load.

## 5. Authentic state, inventory, services and events

The implementation carries source data and arithmetic into native modules rather than replacing them with generic RPG conventions. The following examples explain why apparently minor details matter; full source anchors and checks are in the linked subsystem notes.

| Source behavior | Preserved rule |
| --- | --- |
| `LABEL_5E8`, `UnlockCharacter` | Alis starts at level 1, HP 16, MP 0, with Short Sword/Leather Armor and no inventory or money. |
| `Inventory_RemoveItem2`, `ItemAction_Equip` | Capacity is 24. Removal compacts and clears the last slot. Equipment exchanges the old item into the chosen slot; an empty previous slot removes that inventory entry. Dead members cannot equip. |
| `ItemAction_Drop`, `LABEL_27BC..27D8` | Item flag bit 2 protects both ordinary dropping and full-inventory replacement. |
| `LABEL_2BDC..2C41` | A shop's first record byte is its last valid option, not a count. Full inventory rejects before funds and exits the shop. Buying an already owned vehicle still charges money without adding a duplicate. |
| `LABEL_2999`, `LABEL_2A98` | Hospital missing-HP-plus-MP fee accumulates in **eight bits**, including wrap. Revival costs level×20. Both preserve their original target/funds checks. |
| `AwardEXP`, `CalculateExp` | Each living member gets the full award; a nonzero award grants at most one level. EXP overflow caps at 65535 and returns before checking a level. Zero awards do not level; leveling does not heal. |
| `LABEL_121D..1279`, `LABEL_1579..15C2` | Physical damage separately randomizes attack/defense, preserves the defense-advantage miss case and rejection sampling, then uses player `r+1` or enemy `floor(r/2)+1` where applicable. |

The RNG preserves `UpdateRNGSeed` feedback from old bits 15, 13, 4 and 0, shifts left, and replaces zero with `$733C`. The SMS additionally XORs the low byte with Z80 refresh register R. GBC has no equivalent, so native output uses the feedback low byte with startup input/frame seeding. Identical SMS random sequences are **not** claimed.

All 182 original event IDs are represented: 111 simple two-instruction handlers are generated, and 71 require native branching/runtime requests. The 256 story flags corresponding to `$C500..C5FF` remain separate from the 256 shared object flags corresponding to `$C600..C6FF`. Dialogue decodes 534 records with the original dictionary/control codes. Eighteen-character, two-line presentation retains distinct terminators and waits, one character per VBlank, input latching and scrolling behavior.

Source ordering is observable gameplay. Scion's Secrets counter refuses twice before the charged Roadpass branch; capacity/funds checks precede the denial. Nekise's flag advances only if the Laconia Pot actually enters inventory. Full event inventory offers the original discard/abandon behavior, while a full shop inventory exits. Passport charges before attempting the add. Myau alone cannot perform the source Alsulin/Polymaterial actions. Hospital, revival, guest sleep, Suelo, Governor nightmare/rest and Dr. Mad sacrifice sequences retain their text, sound and state-change order. Equipment/drop presentation stages the temporary inventory state through the original messages and waits; the item-award sound occurs only on successful additions/replacements.

Some narrow helpers return `RPG_NOT_IMPLEMENTED` for actions delegated elsewhere. That is an internal dispatch boundary: field, battle, service and event controllers implement the corresponding player-facing behavior. It is not evidence that those items are missing from the complete cartridge.

## 6. Battles, dungeons and story travel

Battles use all 74 original enemy records and 94 encounter pools, original stats/flags, spells, item behavior, rewards and treasure handling. Group-size rejection sampling uses joined party size, including dead joined members. Source terrain lookup can read beyond its nominal table into adjacent data; the extracted address window preserves that aliasing instead of clamping it into a different encounter distribution.

Examples of deliberately preserved combat edges include player Fire's two hits from source CALL/fall-through (`LABEL_1F16`/`LABEL_1F21`), enemy Fire's two random-target hits, three-hit Wind, per-living-enemy Thunder, and guns' fixed damage. Lassic without Crystal uses the original byte-add/carry behavior, including rare high-HP wrap survival, rather than a fabricated unconditional kill. Medusa's Mirror Shield/Odin branch and the Golden Dragon's special Myau-death handling preserve their source tests. Dark Falz uses the original two separately acting 255-HP records. Trap damage and encounter chance preserve inclusive thresholds and RNG consumption even when a probability appears to be zero.

Battle results are computed before their visible playback. A recorded trace then presents the original hit/state/sound order without consuming extra RNG. This is a declared timing adaptation, separate from the correctness of the underlying calculations and battle outcomes.

Dungeons contain 61 packed floors, 186 objects and 65 transitions. The native kernel ports source `LABEL_65EE..681B`: packed coordinate arithmetic wraps the complete byte; traps/falls can happen before input; different cell types advance different distances; intermediate object checks matter; backward movement is restricted; rotations also have source encounter behavior. Object suppression uses flag value `$FF`, not any nonzero value, and the first matching object record wins even when that choice hides later duplicate records.

The first-person renderer converts original 256×192 composition to a 160×120 scene area. Thirty-eight motion types produce 1,430 source-index images, represented with 14,533 native patterns and shared blocks. Stable slot allocation prevents patterns that coexist in an image from sharing a VRAM location. Double buffering leaves the preceding complete image visible until the next is ready. Fixed-bank inline assembly and DMA perform expansion and transfer while restoring banking and display state. The standing view returns to its designated buffer because actor sprites overlap the alternate buffer; window-map restoration after falls prevents later menu/title corruption.

Road and ship controllers implement six roads and eight ship routes from `LABEL_F0C` and `LABEL_ABF`. They suppress ordinary encounters/triggers while their sequence owns movement and preserve source skip behavior, fractions, endpoint state, fades and music. Ship departure uses its source fixed-point acceleration; arrival includes the zero-speed final update. `WaitForVInt`'s A argument selects a handler, not a frame count—misreading it would distort waits and input timing. Road 3's destination music follows the source map-load branch rather than an earlier incorrect extracted assumption.

Opening, recruitment, Prism, Myau flight, Golden Dragon, ending walk and credits use extracted original scenes/actors and native controllers. Shared palette commits stage 28 background plus 32 object colors atomically; this removed mixed-palette frames while preserving source fade component order. Map music state remains distinct from what the audio driver is currently playing. Title/reset drain pending audio commands, and Continue restores state before the appropriate world/dungeon load. The complete source ending has 3,499 logical frames; native upload costs add physical frames. The production ending finishes and returns to title. The retained `presentation-probe` target intentionally uses a nonfinishing credits stub and is **not** the distributed cartridge or ending proof.

## 7. Audio and saves

The audio port interprets original score/instrument/modulation bytecode in native C; it does not interpret Z80 instructions. It covers twenty music commands, 53 effects and the original control commands, with byte-wrapping transposition, inherited lengths, call/return, loops, jumps, slides, envelopes, drums, priority, overlays and fade/resume. Original low-ROM lookup bytes are retained where modulation behavior aliases outside a nominal table.

`audio_irq.c` schedules one update per displayed frame at scanline zero. Moving work out of the overloaded VBlank path prevented display-off starvation. The source single-byte sound mailbox preserves “later command wins”; vehicle motor ordering has an explicit helper to maintain the source before-score motor command and later command boundary. The GBC APU adapter approximates SMS PSG pitch/volume/noise with different hardware channels. LCD-off pauses the native LCD interrupt, and expensive graphics transfers can extend physical elapsed time; neither cycle-identical SMS audio nor identical acoustics is claimed.

Source-driver comparison covers 218,600 frames and 437,200 assertions, including sound RAM and ordered PSG writes. Native captures include all 73 music/effect commands with non-silent output. These are execution/capture checks, not a claim that someone listened critically to the entire soundtrack.

Native saves use five 1,024-byte slot strides and separate names in the cartridge's 8 KiB SRAM. A v5 record is 628 bytes: explicit party, inventory, money, RNG, flags, object flags, map/dungeon state, vehicle mode and persistent cycle phase/countdown, followed by CRC16-CCITT-FALSE. Serialization names fields rather than copying C structure padding. The signature is invalidated first and written last; the CRC is an integrity check, not security.

Version 4 records validate with their old CRC/layout before missing vehicle-cycle fields initialize to zero. Older incompatible prototype formats are rejected. Source transient opened-door/IceDigger work buffers are not falsely treated as saved state. Native tests derive runtime offsets from compiled layout evidence because adding a C field can shift runtime structures without changing the serialized wire layout. Save names use the native keyboard while retaining source back/end/overwrite semantics; they do not rename party members.

## 8. Verification, acceptance and remaining limits

Evidence is intentionally separated by what it can prove:

| Level | What was tested | What it does not establish alone |
| --- | --- | --- |
| Original reference execution | Unmodified original Z80 routines, banked ROM data and ordered outputs compared with native rules/presentation. | A playable complete GBC cartridge. |
| Host logic | Production C compiled with warnings and sanitizers; independently decoded data and edge-case fixtures. | GBC timing, banking, graphics or input behavior. |
| Native probes/integrations | Actual SM83 binaries in the emulator, with declared fixture setup where used; rendering, banks, interrupts, menus and transitions. | An earned New Game-to-ending route merely because a boss fixture passed. |
| Earned campaign | Accepted ROM from clean power-on, controller input only, no imported SRAM/state or state injection. | Every possible optional route/input combination or physical hardware. |
| Independent replay | A second clean power-on run re-executing the full recorded controller stream, checking every checkpoint and final save/title. | A second independent route or subjective audiovisual review. |

The retained [vehicle-reload-fix-integrations/report.json](current-project/build/verification/vehicle-reload-fix-integrations/report.json) records all thirteen final integration suites passing. Seven core host suites also passed: RPG 68,639 assertions; events 3,168; services 81; story 80; battle 385,470; saves 5,209; world rules 4,370. All seven core and thirteen emulator suites were rerun successfully after excluding the Z80 source, as recorded in [REVISION_VALIDATION/report.json](REVISION_VALIDATION/report.json). Native code/assembly are unchanged; the earlier exact rebuild and whole-campaign results remain historical evidence, and this packaging revision did not rerun the full campaign. The [canonical promotion evidence](current-project/milestones/canonical-promotion-v5-20261113/) establishes exact rebuild/source/object equivalence and preservation. Static WRAM ends at `$DB86`, leaving 1,146 address bytes above it for stack; focused tests also preserve a 64-byte guard at `$DBC0`.

The [final earned campaign](current-project/build/campaign/release-v5-newgame-b72feead/report.json) completed **51 phases, 3,581,580 frames and 484 checkpoints**, followed by the settled title. It includes a natural full-party defeat against Corona and a real native Continue. A separate driver assertion stopped when Fly correctly refused at zero MP; the run resumed from that exact state using the legitimately earned Hovercraft. No ROM change or earlier-state rewind bypassed that condition.

The first 352 checkpoints originated as the pre-vehicle prefix of the preceding v4 campaign. The final v5 run replayed that entire controller prefix from fresh power-on and matched every checkpoint before continuing; it did not import v4 SRAM or a saved emulator state. Historical narrative/encounter annotations are labeled as inherited. Checkpoint snapshots, final SRAM and the remainder of the route were produced by v5 itself.

The [independent replay report](current-project/build/campaign/release-v5-live-replay-b72feead/replay-report.json) verifies all 3,581,580 frames, all 484 ordered checkpoints and expected gameplay keys, final state, and the exact 144,464-row controller log. Both runs independently earned identical 8,192-byte SRAM:

```text
3fd1272237e5779e5be6df1a414f211b810598452679cff04a4dc1a1833dbb60
```

Both ending-title images match separate native boots using their own earned saves: 23,040 pixels compared with zero differences. `CAMPAIGN_CLOSED.json` freezes the closed source run, and the final replay report is authoritative; conservative progress snapshots are not acceptance reports. Despite the tool/directory name “live replay,” this accepted replay began after the source run closed. Append-follow behavior was tested separately.

To repeat the full replay, use the pinned tools with their co-located `FROZEN_TOOLS.json`, as described in [REPRODUCE.txt](current-project/build/campaign/release-v5-live-replay-b72feead/REPRODUCE.txt). With the environment created above and working in `current-project`, the relocated commands are:

```sh
../.venv/bin/python build/source-snapshots/replay-live-tools-20261113/tools/replay_campaign_live.py build/campaign/release-v5-newgame-b72feead --output build/campaign/release-v5-replay-reproduction-new
../.venv/bin/python build/source-snapshots/replay-live-tools-20261113/tools/verify_campaign_title.py build/campaign/release-v5-replay-reproduction-new
```

The [final independent audit](current-project/build/verification/release-v5-final-independent-audit/report.json) checks the release, evidence and preserved artifacts. Failed intermediate builds/probes and earlier candidates remain historical records and are excluded from final acceptance.

The achieved result is native functional completion with source-derived behavior and full earned/replayed campaign evidence. Explicit adaptations remain: 160×144 display and reduced palettes; GBC sound mapping; RNG without the Z80 refresh-register contribution; additional physical frames for expensive uploads; battle outcome calculation before visible playback; and native dialogue-window closure retaining source waits. Physical cartridge testing, complete subjective soundtrack review, and exhaustive coverage of every optional route remain unclaimed.
