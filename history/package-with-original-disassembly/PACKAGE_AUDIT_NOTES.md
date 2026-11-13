# Source package audit notes

Read-only inventory of the accepted working project, 13 November 2026. This file records packaging checks and reproducibility dependencies; the conversion guide is the explanation of the port itself. Counts below describe the original working tree before packaging and may include explicitly excluded caches. No production source, verified baseline, or upstream files were modified for this audit.

## Source and assembly inventory

| Material | Verified contents | Meaning |
| --- | --- | --- |
| `current-project/src/` | 262 C files + 80 headers; 15,014,959 bytes | Complete native production source and generated data |
| Production source plus `Makefile` | 343 files | All 343 hashes match the frozen release-v5 source manifest |
| Authored native inline assembly | `palette_commit.c`, `dungeon_motion_upload.c`, `ending_upload.c` | SM83 hardware-sensitive upload routines embedded in C |
| Standalone native assembly in `src/` | None | This is mainly a C port compiled to SM83, not a handwritten line-for-line Z80 translation |
| `current-project/build/obj/*.asm` | 262 files; 45,115,400 bytes | GBDK/SDCC-generated SM83 assembly, one file per C compilation unit |
| Other final object artifacts | 262 `.lst`, 262 `.sym`, 262 `.o` | Listings, assembler symbols, and relocatable object files |
| Entire final object directory | 1,048 files; 216,130,374 bytes | Include these to make the assembly delivery inspectable and directly relinkable |
| `current-project/upstream/ps1disasm/` | 53 files, including 31 Z80 `.asm` files; 4,461,716 bytes | Original upstream disassembly, reference ROM, notices, and historical Windows tools |

The compiler-generated assembly files have relocatable symbols. The final ROM's `.map` and `.noi` files establish linked bank/address placement. GBDK startup and runtime code is supplied by the bundled toolchain libraries; the generated project assembly is not a separate handwritten copy of those libraries.

## Exact artifacts and provenance

Original disassembly: **https://github.com/sung3r/ps1disasm**, pinned revision **`8efc4110adcf1a81c70d40522016393ba6f6b5ae`**. Preserve `upstream/ps1disasm/README.md` and `docs/UPSTREAM_README.md`; neither ownership of the original game nor a blanket open-source game-assets license should be inferred from the tools' licenses.

| Artifact | Bytes | SHA-256 |
| --- | ---: | --- |
| Accepted `build/phantasy-star-gbc-world.gbc` | 4,194,304 | `b72feead6a4a0b9efe779a2a61fbce7e96bd30247e3149b0ce1793dd414d59a1` |
| Matching `build/phantasy-star-gbc-world.noi` | 232,060 | `233b33a799df57940fb7ffab80bd55a6d87627b48cf1a4ff7b47fe7c6fe6324c` |
| Original `upstream/ps1disasm/ps1original.sms` | 524,288 | `9e324e92bd833b45126861b6f1d2dcbb51251bdf3df6d563ab3a3ff784d8cf88` |
| `build/sms-reference/ps1built.sym` | 60,521 | `78a60bbf982f590f0309bc6c05c9ee26a1bd07ee9baa3ae3aa428168ed28fa71` |
| Verified Camineet baseline ROM | 65,536 | `ffe3d67bb15c3d563f6f9b61e08dc166129818d99500a9af6fd8e9eb7c1b1356` |

The baseline consists of 45 preserved files. Its existing reproduction report states a byte-identical GBDK 4.5.0 rebuild and unchanged baseline. A package rebuild should independently reconfirm the hashes rather than treat that report as a new execution.

## Include to support the documented workflows

| Workflow | Required packaged inputs |
| --- | --- |
| Play | Accepted `.gbc`; clear controls and current completion/coverage status |
| Rebuild the native ROM | All `src/`, original `Makefile`, GBDK 4.5.0, Python 3, `tools/verify_layout.py` |
| Inspect all project assembly | All final `build/obj/` artifacts, linked `.map`/`.noi`, native C/inline assembly, original Z80 source |
| Regenerate assets/research | All 162 Python tool sources, all assets, original reference ROM/disassembly, retained `build/sms-reference/ps1built.sym`, pinned Python requirements |
| Host logic verification | Tests (15 C + one `.inc`), tool sources, host C compiler with address/undefined-behavior sanitizers, required symbols/reference inputs |
| Emulator verification | Python 3.12 environment with pinned PyBoy/Pillow/z80 dependencies, matching `.noi`, relevant source/assets |
| Baseline reproduction | Sibling `verified-baseline/`, original parent `FILE_MANIFEST.json`, `tools/reproduce_baseline.py`, GBDK |
| Full campaign replay | Entire immutable source campaign `build/campaign/release-v5-newgame-b72feead/`, its `CAMPAIGN_CLOSED.json` record, and frozen replay tooling directory `build/source-snapshots/replay-live-tools-20261113/tools/` |
| Inspect terminal proof | Original full-replay evidence, final independent audit, release-v5 source manifest, integration and host-suite reports |

All 14,436 asset files total only 12,299,311 bytes and should be retained. All 22 project documentation files should be retained, including source-specific formulas and edge cases. Exclude interpreter environments, `.pyc`/`__pycache__`, redundant historical whole-project copies, and incidental scratch build outputs. Do not omit proof files that an included immutable `SHA256.json` promises are present.

## Toolchain and environment

The installed GBDK `ChangeLog` identifies **4.5.0**. The supplied `.tools/gbdk/bin/lcc` is **macOS ARM64**, SHA-256 `c610f19ea2c602127c1c23b45f57d15048d7600c40e194bc1b209a2145d57d01`; this toolchain contains 657 files / 15,471,833 bytes. Other operating systems need the corresponding official 4.5.0 binary distribution. Retain all toolchain license notices. `docs/GBDK-LICENSE.txt` includes the library linking exception; upstream `binaries/LICENSE` is a tool license, not a license for Sega game content.

The currently working interpreter is Python **3.12.12**. Recreate the virtual environment rather than copying an existing one. `requirements-lock-macos-arm64.txt` pins numpy 2.5.4, Pillow 13.0.0, PyBoy 2.9.0, PySDL2 0.9.17, pysdl2-dll 2.32.10, and z80 1.2.0. The ordinary native build's layout check uses only Python's standard library. Host tests need a working `cc`/Clang and sanitizers; some focused test scripts explicitly invoke `clang`.

The native link is CGB-only, MBC5 with battery-backed 8 KiB SRAM, and 256 ROM banks (4 MiB). Production compilation enables both `PS_DUNGEON_LEAN` and `PS_DUNGEON_MOTION`. Preserve these settings. The four-bank Makefile in the original transfer is historical, not the accepted final source.

The optional original-SMS rebuild uses WLA-DX. Installed `wla-z80` and `wlalink` are also macOS ARM64. Its complete source and license are useful if this workflow is advertised; native GBC rebuilds do not require WLA-DX. `verify_sms_source.py` changes conflicting dungeon labels only in a temporary source copy and checks original-ROM byte identity.

## Paths and pitfalls to disclose

1. `Makefile` defaults `PYTHON` to `../../.venv-transfer/bin/python`. New-package instructions must explicitly override it with the new environment or system interpreter. GBDK 4.5.0 `lcc` has a fixed path-buffer problem: use the short relative `.tools/gbdk` path rather than a long absolute compiler path.
2. `tools/build_dungeon_motion_wait.py` and `tools/build_dungeon_motion_candidate.py` also contain the old interpreter path. These are historical candidate builders, not the canonical release build. Some old docstrings reference `.tools/venv`.
3. `build/sms-reference/ps1built.sym` is required by extractors and tests including dialogue, enemy/audio/dungeon extraction, integrated battle, and world rules. The native compile alone does not reveal its absence. `verify_sms_source.py` does not export a new symbol file from its temporary build; retain the existing verified symbol table.
4. `campaign_runner.py` needs `build/research/campaign-index.json`. This can be regenerated by its extractor, but including it avoids a hidden prerequisite.
5. Focused historical verification requires small research inputs: `build/research/dark-falz-prelude/source-trace.pkl`, `dark-falz-background/before-32-00-73-source.png`, `boss-motion/source-traces.json`, and `enemy-priority/report.json`. Include the corresponding research directories if promising these helpers work immediately.
6. The frozen full-replay script requires its co-located `FROZEN_TOOLS.json` and matching four tools. Invoke it from the frozen directory, not the unfrozen `tools/replay_campaign_live.py` copy. Immutable proof files deliberately retain historical absolute path strings; those strings are provenance, not portable shell commands.
7. Some focused shared-library tests, including `verify_world_logic.py` and `verify_dungeon_logic.py`, use macOS `-dynamiclib`. Do not promise every test works unchanged on Linux or Windows.
8. `presentation-probe` intentionally substitutes a credits stub that cannot complete. Never package its ROM as the accepted cartridge or count its evidence as a full ending playthrough.
9. `make clean` removes the current native linked outputs and object tree. Perform reproducibility builds in a disposable extracted/copy tree, preserving the delivered artifacts and all original baseline files.

No symlinks were found in the inspected `src`, `tools`, `tests`, `assets`, `upstream`, GBDK, SMS reference, or research trees.

## Immutable proof closure

The following original proof trees were independently checked during packaging preparation: every manifest entry exists with the recorded hash, and there are no unlisted files except the manifest itself.

| Tree, relative to `current-project` | Manifest entries | Payload bytes, excluding manifest |
| --- | ---: | ---: |
| `build/campaign/release-v5-newgame-b72feead` | 443 | 53,764,873 |
| `build/campaign/release-v5-live-replay-b72feead` | 22 | 38,976,130 |
| `build/milestones/release-v5-full-replay-20261113` | 37 | 39,128,216 |
| `milestones/canonical-promotion-v5-20261113` | 2,003 | 279,027,165 |

The final independent audit reads all four complete trees. It also needs the complete frozen v5 production/build snapshot (including `BUILD_PROOF.json` and 262 object files), current native source and object files, the canonical generated `.main.sym`, the accepted convenience ROM at `releases/phantasy-star-gbc/Phantasy-Star-GBC.gbc`, the four frozen replay tools, `build/verification/release-v5-story-independent-audit/report.json`, original reference ROM, sibling baseline, and parent original manifest. Those are real executable dependencies; the earlier source snapshot revisions merely mentioned in historical reports are not dependencies of this final audit.

The earlier story audit additionally reads the held `build/campaign/release-v4-newgame-55b71a17/` and `build/milestones/release-v5-campaign-story-20261113/`. Preserve those if offering to rerun that specific audit. Both audit scripts derive the project root from their own directory depth and intentionally reject an existing `report.json`: copy only `audit.py` to a new sibling folder under `build/verification/` before running it. Do not overwrite the accepted historical reports.

A few immutable milestone manifests include files that normally look disposable, including cached Python bytecode. Preserve every member inside these frozen evidence trees when copying them; cache exclusions are appropriate for the ordinary tool/source directories, not for a hash-closed evidence snapshot.

## Release validation checklist

- Validate every ZIP member CRC, reject absolute/traversal paths and duplicate names, extract to a new directory, and verify the package's SHA-256 manifest including file counts.
- Confirm the accepted ROM, baseline ROM, reference SMS ROM, and `.noi` match the hashes above; confirm all 343 production entries match frozen release v5 and all 262 object units have their assembly/listing/symbol/object companions.
- Verify the baseline against its original manifest before and after any reproduction. Preserve all upstream files and original notices exactly.
- Clean-build in the extracted copy using GBDK 4.5.0 and a short relative toolchain path. Demand the exact accepted ROM hash, run the layout verifier, then run the seven core host logic suites and a native emulator smoke check.
- Check included immutable proof manifests in full. The final accepted proof describes a 3,581,580-frame power-on replay, 484 checkpoints, all 144,464 controller rows (11,721,245 bytes) matching, and the entire earned 8 KiB save matching. Both settled-title comparisons show zero differing pixels. These are stored, validated historical results unless actually rerun during packaging.
- Keep coverage limits explicit: hardware operation, every optional route/input combination, and a complete subjective soundtrack review are not established by the emulator evidence. Preserve documented native visual/audio/timing/RNG adaptations and the campaign driver's recorded assertion/recovery.

Packaging is separate from implementation. A new ZIP, new guide, or another hash audit does not by itself add new gameplay coverage.
