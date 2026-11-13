# Phantasy Star — native Game Boy Color port

**The current native game build is frozen and undergoing a fresh complete campaign. All 13 integration suites and the focused source/native checks pass. Full-game completion is not yet claimed: the unchanged-ROM campaign, independent controller replay and final title comparison remain in progress.**

This is native SM83 code built with GBDK 4.5.0, using the pinned original disassembly and ROM data. It does not emulate the Master System. Source formulas, flags, dialogue, maps and edge cases are documented in the subsystem notes and comparison tools.

## Current candidate

Frozen source and ROM: `build/source-snapshots/release-candidate-v4-20261113/`.
The cartridge is `build/phantasy-star-gbc-world.gbc` within that snapshot: 4 MiB, CGB-only, MBC5 with 8 KiB battery RAM. The canonical working build is being reproduced from this snapshot. Its expected SHA-256 is:

```text
55b71a1732aa2fb20214ed27b04fc2d5a655e80940648f4e3ad9f66b8cae2e12
```

The build integrates all 11 world groups and 24 map IDs, original transitions, RPG rules, story events, inventory/equipment, shops/services, battles, first-person dungeons, field magic/items, vehicles, roads/ships, native music/effects, five named saves, opening and ending. The latest integrated work adds original world animation and tile priority, living-party followers and movement controls, vehicle color cycles and motor timing, source service/Equip/Drop presentation, shared scene fades/music state, title/Continue transitions and rest/sleep/sacrifice sequences.

Verification separates unmodified original Z80 execution, native probes with declared fixtures, full-cartridge controller tests, and earned gameplay. The current 13-suite report is `build/verification/full-v5-integrations-verified/report.json`. Focused evidence is indexed in `PROJECT_STATE.json`; source and object hashes are frozen with each milestone. Invalid intermediate builds and failed test attempts are retained and explicitly excluded from acceptance.

The fresh campaign is `build/campaign/release-v4-newgame-55b71a17/`. It starts from power-on without imported SRAM or emulator state, uses only controller input, and records checkpoints, party/inventory/flags/RNG, source fade/music state and vehicle phase. Earlier campaigns and the documented earned-save cartridge upgrade remain historical evidence, separate from this final-ROM test.

## Preserved baseline

`../verified-baseline/` remains unchanged. Its 64 KiB Camineet ROM SHA-256 is `ffe3d67bb15c3d563f6f9b61e08dc166129818d99500a9af6fd8e9eb7c1b1356`. GBDK 4.5.0 on this Mac reproduced it byte for byte in `../baseline-reproduction/`, with movement/save tests and 59,451 tile/attribute comparisons. `make baseline` works on a separate copy and verifies the frozen files against the transfer manifest.

Earlier working ROMs, sources and reports remain in their original milestone folders, including release v3. The transfer's original state files remain historical handoff records; this directory maintains the continuing project state.

## Controls and saves

| Button | Action |
| --- | --- |
| D-pad | Walk; move menu selection |
| A / B while exploring | Open the field menu at a completed movement boundary |
| A | Choose; advance dialogue |
| B | Return from menus; confirm the highlighted Yes/No answer |
| Start | Begin; menu/resume shortcut |
| Select | Save after the current movement step |

B uses the original action-button behavior; walking and vehicle speeds follow the source. The menu provides status, items/equipment, search, save, magic, title and help.

Save version 5 stores 628-byte records in five 1,024-byte slots. It adds the original persistent vehicle phase/countdown. Version 4 saves load with those previously absent fields initialized to zero; older incompatible formats are rejected. See `docs/SAVE_FORMAT.md` for the exact wire layout and migration tests.

## Build and verification

The local toolchain is macOS Apple Silicon GBDK 4.5.0. The recreated Python environment is `../../.venv-transfer`; package versions are recorded in `requirements-lock-macos-arm64.txt`. On another operating system, use its matching GBDK 4.5.0 binary and recreate the environment rather than executing the archived one.

From `current-project`:

```sh
make
make baseline
make verify
make verify-logic
make verify-world
../../.venv-transfer/bin/python tools/verify_release_candidate.py build/phantasy-star-gbc-world.gbc --output build/verification/local-candidate
```

`make verify` is a cartridge/boot smoke check. The final command runs the 13 integration suites and requires a new output directory. Fixtures in those suites are explicitly labeled; they do not substitute for a complete campaign. Keep `GBDK_HOME` short and relative (default `.tools/gbdk`): this lcc release has a fixed path-buffer limit on the Mac.

Generated assets are included. `make assets` rebuilds the listed world/RPG/dialogue/enemy/font assets and party/vehicle graphics from the pinned ROM. Other cinematic extractors and their generated data are retained in the package. See `PROJECT_STATE.json`, `docs/PORT_STATUS.md` and the subsystem documents for source addresses, formulas and evidence.

Native adaptations remain explicit: 160×144 resolution and reduced palettes; GBC sound-channel mapping; source RNG feedback without the unavailable Z80 refresh-register contribution; extra physical frames for expensive uploads; battle outcomes computed before their visible playback; and a native dialogue-window close retaining the source waits. Physical hardware and a complete subjective soundtrack review remain untested.

## Source

Upstream: [sung3r/ps1disasm](https://github.com/sung3r/ps1disasm), commit `8efc4110adcf1a81c70d40522016393ba6f6b5ae`. Reference SMS ROM SHA-256: `9e324e92bd833b45126861b6f1d2dcbb51251bdf3df6d563ab3a3ff784d8cf88`.

Original Phantasy Star content belongs to its respective rights holders. The upstream disclaimer is preserved in `docs/UPSTREAM_README.md`; GBDK runtime terms are in `docs/GBDK-LICENSE.txt`. No ownership of original game content is asserted.
