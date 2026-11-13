> Current delivery: the cutscene-text-corrected ROM is `ROM/Phantasy Star.gbc`. Original SMS ROMs and Z80 disassembly are excluded. Optional reference-based tests require separately obtained inputs; retained older test results describe their recorded ROM hashes. See [README.md](README.md).

# Building and testing the delivered ROM

The packaged ROM is already playable. Rebuilding it requires Python 3, `make`, and **GBDK 4.5.0**. Python packages and a virtual environment are needed for emulator/asset tests, not for the ordinary native ROM build. The supplied GBDK and optional WLA-DX executables are **macOS ARM64** binaries.

The expected native ROM is 4,194,304 bytes, CGB-only, with 256 ROM banks, MBC5 and 8 KiB battery RAM:

```text
0b9cee5c4cf9dca47887436237cf34ba19e76a26c79714bc64430d3f923e1133
```

See [CONVERSION_GUIDE.md](CONVERSION_GUIDE.md) for the implementation, attribution and verification boundaries. This revised package excludes the original Z80 disassembly and SMS reference ROMs, while retaining all native source/generated data and the original README/disclaimer. Native compilation does not need the excluded source. Commands below assume an extracted directory named `phantasy-star-gbc-native-source-package`; adjust that directory name if needed.

## 1. Check the delivery, then use a working copy

From the extracted package root:

```sh
python3 verify_package.py
```

To verify the ZIP itself without extracting it again, provide its path:

```sh
python3 verify_package.py ../Phantasy-Star-GBC-Complete-Source-and-ROM.zip
```

The package verifier uses the new `PACKAGE_MANIFEST.json`. The separate original `FILE_MANIFEST.json` is the historical transfer manifest and remains necessary for baseline preservation checks. Do not substitute one manifest for the other.

Builds and tests write outputs. Preserve the delivered tree by creating a disposable copy before proceeding. From the directory containing the extracted package:

```sh
cp -R phantasy-star-gbc-native-source-package phantasy-star-gbc-work
cd phantasy-star-gbc-work
```

All remaining commands operate in this working copy. Never build inside `verified-baseline` or write into an immutable campaign/evidence snapshot. Keep preserved notices unchanged; obtain any optional reference ROM separately. `make clean` removes current linked outputs and the generated object/assembly tree; it is unnecessary for the forced build below.

## 2. Build with Python's standard library only

From the working copy's package root:

```sh
python3 build_rom.py --jobs 4
```

This helper forces compilation of all 262 production translation units and checks the resulting cartridge against the accepted hash. The result is `current-project/build/phantasy-star-gbc-world.gbc`; the generated SM83 assembly, listings, symbols and objects are in `current-project/build/obj/`.

The helper accepts `--gbdk PATH` if the toolchain is installed elsewhere. Use the matching GBDK **4.5.0** distribution. The supplied `.tools/gbdk` location is preferred on macOS ARM64. GBDK's Mac `lcc` has a fixed path-buffer limitation, so keep the compiler path short and relative when using `make` directly.

The package, compiler and Python interpreter paths must be short and space-free. The helper rejects whitespace and shell-sensitive characters because the preserved Makefile expands those paths in its recipes. Use a simple working path such as `/tmp/psgbc-work` when necessary.

Equivalent direct commands, from the package root:

```sh
cd current-project
make -B -j4 GBDK_HOME=.tools/gbdk PYTHON=python3
python3 tools/verify_layout.py build/phantasy-star-gbc-world.gbc
shasum -a 256 build/phantasy-star-gbc-world.gbc
cd ..
```

The explicit `PYTHON` override is important. The unmodified historical Makefile default points to `../../.venv-transfer/bin/python`, which belongs to the original development workspace. Neither this direct build nor `build_rom.py` requires PyBoy, NumPy, Pillow, z80, WLA-DX, the excluded original Z80 source, or asset regeneration. Included generated assets are the production inputs. The optional complete `make assets` target needs the separately obtained original source described in section 7; it regenerates only its listed extractors, not every cinematic asset.

## 3. Recreate the test environment

The recorded working interpreter was Python **3.12.12**. Use Python 3.12 for the pinned test environment. From the working copy's package root:

```sh
python3.12 -m venv .venv
.venv/bin/python -m pip install -r current-project/requirements-lock-macos-arm64.txt
```

The lock file pins NumPy 2.5.4, Pillow 13.0.0, PyBoy 2.9.0, PySDL2 0.9.17, pysdl2-dll 2.32.10, and z80 1.2.0. Installing these dependencies may require network access; the source package does not contain a portable installed Python environment. Do not copy a virtual environment from another OS or machine.

Host logic checks require working `cc`/Clang executables and AddressSanitizer/UndefinedBehaviorSanitizer support. On macOS, these are supplied by Apple's developer command-line tools; install them if missing. The optional original-SMS rebuild uses the packaged WLA-DX tools and an external pinned source checkout, independently of GBDK.

For the following sections, change into `current-project`:

```sh
cd current-project
```

The interpreter path is now `../.venv/bin/python`.

## 4. Run the seven core logic suites

Run the production Makefile target:

```sh
make verify-logic PYTHON=../.venv/bin/python
```

It runs these seven commands in order; they can also be invoked individually:

```sh
../.venv/bin/python tools/verify_rpg.py
../.venv/bin/python tools/verify_events.py
../.venv/bin/python tools/verify_services.py
../.venv/bin/python tools/verify_story_events.py
../.venv/bin/python tools/verify_battle.py
../.venv/bin/python tools/verify_save.py
../.venv/bin/python tools/verify_world_rules.py
```

The accepted recorded counts are respectively 68,639; 3,168; 81; 80; 385,470; 5,209; and 4,370 assertions. Results are written under `build/verification/`. These seven checks use production C and retained ROM/symbol inputs, rather than the excluded disassembly text. Their pass establishes the covered rules/edge cases; it does not alone prove native hardware timing or a complete campaign.

## 5. Run native emulator checks

A quick cartridge/boot check:

```sh
make verify PYTHON=../.venv/bin/python
```

World data, collision/transitions and isolated native rendering checks:

```sh
make verify-world PYTHON=../.venv/bin/python
```

Run all thirteen final integration suites against the accepted ROM and matching `.noi` symbols:

```sh
../.venv/bin/python tools/verify_release_candidate.py build/phantasy-star-gbc-world.gbc --output build/verification/local-candidate-new --jobs 4
```

Choose a fresh output directory for each attempt. The suites cover expansion, dungeons, battles, field actions, travel, chests, save UI, audio, story/ending presentation, dialogue, services, battle vehicles and enemy magic. Each retained report must name the exact tested ROM hash. The runner leaves `report.json`, per-suite logs/results and accepted evidence under the requested directory. It also invokes individual tools that write their conventional locations in `build/verification/`; run it in the disposable copy and do not launch competing full runners in the same tree.

These thirteen suites use the included native binaries, ROM data and symbol inputs. Their enemy-magic check imports ROM-reading helpers from `extract_rpg.py` without invoking its source-text-dependent generation command. Separate focused checks such as `verify_save_slots.py` and `verify_dialogue_stream.py` do require excluded text and need section 7's optional checkout. The suites include explicitly declared fixtures alongside controller-driven checks and do not replace the clean-power-on campaign/replay. The historical `presentation-probe` target deliberately substitutes a nonfinishing credits stub; it is not the release build or proof of ending completion.

## 6. Reproduce the preserved baseline

Still from `current-project`:

```sh
make baseline PYTHON=../.venv/bin/python
```

The script checks all preserved baseline files against the original parent `FILE_MANIFEST.json`, copies/builds in the sibling `baseline-reproduction` directory, runs the baseline emulator checks, and rechecks preservation. It expects GBDK at `current-project/.tools/gbdk`. If using another toolchain location for the main build, also provide the matching 4.5.0 installation at this expected location in the disposable copy.

The expected baseline ROM hash is:

```text
ffe3d67bb15c3d563f6f9b61e08dc166129818d99500a9af6fd8e9eb7c1b1356
```

The new result is recorded in `build/baseline-reproduction.json`. Existing delivered evidence describes the earlier byte-identical reproduction and 59,451 tile/attribute comparisons; a successful local rerun provides fresh evidence for this machine.

## 7. Optional original-source research and regeneration

The original Z80 source and SMS reference ROMs are intentionally excluded. The ordinary native build does not need them. Many rule/emulator suites read original SMS bytes even when they do not read assembly text. Obtain their reference ROM separately before rerunning those suites. Reassembling the SMS program, running `audit_source.py`, the full `make assets` target, and source-text-dependent tools such as `extract_rpg.py`, `extract_dialogue.py`, `verify_save_slots.py` and `verify_dialogue_stream.py` also require the assembly source.

Only if you want those workflows, obtain [sung3r/ps1disasm](https://github.com/sung3r/ps1disasm) at the exact pinned commit and restore its assembly files in your **disposable working copy**. From `current-project`, with Git and network access:

```sh
git clone --no-checkout https://github.com/sung3r/ps1disasm.git build/ps1disasm-reference-checkout
git -C build/ps1disasm-reference-checkout checkout --detach 8efc4110adcf1a81c70d40522016393ba6f6b5ae
cp build/ps1disasm-reference-checkout/ps1.asm build/ps1disasm-reference-checkout/ps1.constants.asm upstream/ps1disasm/
cp -R build/ps1disasm-reference-checkout/banks build/ps1disasm-reference-checkout/sound upstream/ps1disasm/
cp build/ps1disasm-reference-checkout/ps1original.sms upstream/ps1disasm/
```

This restores optional research inputs in your working copy and preserves the attributed README. It intentionally changes the working copy from the delivered package inventory. Do not add those files back to the revised delivery ZIP.

Once restored, original-SMS assembly verification uses the bundled macOS ARM64 WLA-DX binaries:

```sh
python3 tools/verify_sms_source.py
```

Use `--wla-bin /path/to/wla-dx/binaries` for another installation. The script makes a temporary source copy, renames conflicting bank-15 `DungeonID_` labels only there, assembles/links, and demands byte identity with the separately obtained reference ROM. It writes `build/sms-reference/report.json` and reference symbols needed by some comparisons. The expected SMS hash is:

```text
9e324e92bd833b45126861b6f1d2dcbb51251bdf3df6d563ab3a3ff784d8cf88
```

Keep the supplied `build/sms-reference/ps1built.sym`: extractors and reference tests use it, and this verifier does not export a replacement symbol file from its temporary build. After restoring the source, regenerate its lexical inventory with:

```sh
python3 tools/audit_source.py --output build/verification/local-source-inventory.json
```

That inventories source hashes, labels, instruction forms and porting hazards; it is neither a correctness test nor an automatic translator. Without restoring the source, the retained older inventory/SMS-assembly reports remain historical evidence, not fresh checks of this revised package.

## 8. Repeat the full campaign replay

The original full run and independent replay already included in the package cover 3,581,580 frames, 51 phases and 484 checkpoints, followed by the settled title. Replaying all of that is substantially longer than a smoke check. It starts from clean power-on without imported SRAM/state or memory injection and checks the recorded inputs/state; it is not a new independent gameplay route.

Read [the frozen reproduction instructions](current-project/build/campaign/release-v5-live-replay-b72feead/REPRODUCE.txt). Their historical interpreter path is provenance; use the relocated interpreter below, still from `current-project`:

```sh
../.venv/bin/python build/source-snapshots/replay-live-tools-20261113/tools/replay_campaign_live.py build/campaign/release-v5-newgame-b72feead --output build/campaign/release-v5-replay-reproduction-new
../.venv/bin/python build/source-snapshots/replay-live-tools-20261113/tools/verify_campaign_title.py build/campaign/release-v5-replay-reproduction-new
```

The output directory must not exist before the replay starts. Run the title comparison only after replay success. Keep the frozen tools alongside their `FROZEN_TOOLS.json`; invoking the ordinary `tools/replay_campaign_live.py` copy without that frozen manifest is not the documented workflow. Do not alter the immutable source campaign to accommodate a failure.

Acceptance is the new terminal `replay-report.json` plus the title-comparison result. A progress snapshot is not a final completion report. The recorded accepted replay matches all expected gameplay keys/checkpoints, final state, controller bytes, and all 8,192 earned SRAM bytes. Both recorded ending titles match native boots using their own earned SRAM with zero differing pixels.

## 9. Rerun the final evidence audit without overwriting it

The supplied final audit checks frozen manifests, source/object/ROM equivalence, campaign/replay records, save bytes, title pixels and baseline preservation. It does not rerun the emulator campaign. Its script intentionally refuses to overwrite its accepted report and derives the project root from its directory depth.

Copy **only the script** into a new sibling directory at the same depth, then execute it. From `current-project`:

```sh
mkdir build/verification/local-final-independent-audit
cp build/verification/release-v5-final-independent-audit/audit.py build/verification/local-final-independent-audit/audit.py
../.venv/bin/python build/verification/local-final-independent-audit/audit.py
```

Use another fresh sibling name on a subsequent attempt. The result and manifest are written in that new directory. Run this on an unmodified release working copy, or after a byte-identical rebuild; a deliberately changed source/ROM is supposed to fail the release-equivalence checks. It reads the retained earlier story-audit report as one frozen input, rather than silently regenerating historical evidence.

`verify_package.py` is the delivery-integrity audit; the final audit above is the release/evidence audit. The original `PACKAGE_VALIDATION` reports describe the preceding package. [REVISION_VALIDATION/report.json](REVISION_VALIDATION/report.json) records the revised package's fresh checks: all seven core suites and thirteen emulator integrations passed with the disassembly removed. This revision did not rerun the full earned campaign. The native source and generated assembly remain unchanged, and the earlier exact build/campaign evidence remains explicitly historical. After installing a virtual environment, restoring optional source or generating reports, your working directory is intentionally different from the pristine delivery; retain the original extraction/ZIP for package-manifest checks.

## Platform and coverage limits

The recorded reproducible setup is macOS ARM64 with GBDK 4.5.0 and Python 3.12.12. For another OS/CPU, install its matching GBDK 4.5.0 and WLA-DX binaries rather than executing the archived Mac versions. Recreate Python dependencies on that platform. Some tests explicitly invoke Clang and use macOS `-dynamiclib` options, including world/shared-library checks; the full host verification suite is not promised to run unchanged on Linux or Windows. Preserve the original sources and adapt a separate working copy where platform changes are needed.

The build and emulator evidence do not establish operation on physical Game Boy Color hardware, every optional route/input combination, or a complete subjective soundtrack review. Native resolution/palette/audio/RNG/timing adaptations are documented in [CONVERSION_GUIDE.md](CONVERSION_GUIDE.md) and the subsystem notes.
