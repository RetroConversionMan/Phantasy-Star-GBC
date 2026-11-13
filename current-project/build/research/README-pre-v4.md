# Phantasy Star — native Game Boy Color port

**Implementation continues. The frozen Camineet baseline remains unchanged and byte-identically reproduced. The development ROM integrates world exploration, RPG/story systems, battles, dungeons, services, vehicles, audio, saves and the ending. Original world/party presentation and several service, item and scene-transition sequences remain unfinished; final campaign verification is pending.**

The port runs native SM83 code compiled with GBDK 4.5.0. It does not emulate the Master System. Original content comes from the pinned disassembly and reference ROM, with explicit source addresses and tests recorded in the tools and reports.

## Preserved baseline

`../verified-baseline/` remains unchanged. Its 64 KiB ROM SHA-256 is `ffe3d67bb15c3d563f6f9b61e08dc166129818d99500a9af6fd8e9eb7c1b1356`. The rebuilt copy lives in `../baseline-reproduction/`, matches byte for byte, and passes the existing behavior, save, and 59,451 tile/attribute comparisons. `make baseline` reproduces and tests a separate copy and verifies all frozen files against the transfer manifest.

## Current development build

`build/phantasy-star-gbc-world.gbc` is the verified development candidate, a 4 MiB CGB-only MBC5 cartridge with 8 KiB battery RAM. SHA-256:

```text
2e151f71ae14996d5753791d373b6ef9f0d7a27f7f86e3cab3742c39ea19668c
```

It integrates all 11 world groups and 24 map IDs, original RPG/event/service rules, inventory and equipment, battles, first-person dungeons, field actions, vehicles, road/ship travel, native audio, five named saves, opening and full ending. The latest corrections include original boss attacks and palette phases, stable actor priority, Dark Falz's retained body/reveal/music, Governor portraits and fall transition, support-command and victory timing, Torch inventory boundaries, window-map restoration after pitfalls, and the source-correct Paseo road-arrival music.

Thirteen exact-binary integration suites pass. Additional v2 tests (with unchanged corresponding v3 production objects) cover eight Torch cases, 56 support-command cases, five victory cases, four late-story presentation routes, the earned Governor fall/save route and both mandatory pits. Same-session menus, dialogue and title remain intact after each fall; each title is compared across all 23,040 pixels. Thirty-six full-main palette-flash transitions have no mixed frames and retain production audio interrupts. Baseline preservation, source/object attribution and explicit fixture limits are recorded in `PROJECT_STATE.json` and the reports.

Independent source verification also covers all world trigger/step decisions, 534 dialogue records, 385,470 RPG/battle rule assertions, original dungeon geometry and animation traces, inventory/service edge cases, save integrity, and original audio-driver execution. These checks distinguish direct original-machine-code execution, native probes with declared fixtures, and ordinary controller play.

The separate earned campaign defeated Lassic on its frozen earlier ROM, then completed Dark Falz and the entire ending on an explicitly documented cartridge upgrade. Its independent replay preserved the party, inventory, flags, RNG, actual deaths and Continues. That older build had known presentation defects and is retained as historical evidence. A clean-power-on campaign is continuing on the frozen v2 ROM. The final v3 ROM corrects one travel-music byte; its fresh power-on replay will compare every gameplay checkpoint, including RNG, without importing old SRAM or an emulator state. Complete final-ROM campaign verification remains pending. The music correction retains 40 logical fade ticks and adds one measured native frame on road 3; its normal/skipped routes and all other exits pass 28 host and 28 native source-backed tests.

The canonical source snapshot is `build/source-snapshots/release-candidate-v3-20261113`; the evidence is being collected in `milestones/release-v3-20261113`. All older verified milestones remain preserved. Source-visible animation order and tested logical waits are retained, but native asset uploads and some movement/credits run slower than the SMS. GBC colors and audio are hardware adaptations. Battle rule outcomes are precomputed before visible playback. Physical hardware and a complete subjective soundtrack review remain untested.

## Controls

| Button | Development build action |
| --- | --- |
| D-pad | Walk; move menu selection |
| Hold B | Walk faster |
| Start | Begin / open menu / resume |
| A | Choose; advance dialogue; interact or open menu |
| B | Return from menus; confirm highlighted Yes/No answer |
| Select | Save at the end of the current movement step |

The menu provides status, items/equipment, search, save, magic, title and help. Earlier save versions remain separate; the expansion rejects incompatible records and starts a new game.

## Build and verification

The transfer includes the macOS Apple Silicon GBDK 4.5.0 release. The Python environment was recreated at `../../.venv-transfer`; exact installed package versions are in `requirements-lock-macos-arm64.txt`. Do not execute the archived virtual environment. On another OS, use the corresponding GBDK 4.5.0 binary.

From `current-project`:

```sh
make
make baseline
make verify
make verify-logic
make verify-world
```

Keep `GBDK_HOME` short and preferably relative (default `.tools/gbdk`). The included lcc crashes on this Mac with a toolchain path over its fixed path-buffer limit; relative invocation reproduces the baseline correctly. The source snapshot has no upstream Git metadata; the old bootstrap checkout detection should not be used as the build prerequisite.

Generated assets are included. `make assets` regenerates world/RPG/dialogue data and font from the verified original ROM. Verification reports and actual emulator screenshots are under `build/verification/`; `build/baseline-reproduction.json` records the reproduced baseline. Consult `PROJECT_STATE.json` and `docs/PORT_STATUS.md` for scope, and the subsystem documents for exact implemented behavior and gaps.

## Source

Upstream: [sung3r/ps1disasm](https://github.com/sung3r/ps1disasm), commit `8efc4110adcf1a81c70d40522016393ba6f6b5ae`. Reference SMS ROM SHA-256: `9e324e92bd833b45126861b6f1d2dcbb51251bdf3df6d563ab3a3ff784d8cf88`. The transfer's original state files remain a historical handoff; the current-project status is maintained separately.

Original Phantasy Star content belongs to its respective rights holders. The upstream disclaimer is preserved in `docs/UPSTREAM_README.md`; GBDK runtime terms are in `docs/GBDK-LICENSE.txt`. No ownership of original game content is asserted.
