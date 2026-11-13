# Phantasy Star — native Game Boy Color source package

**Start playing:** open [ROM/Phantasy-Star-GBC.gbc](ROM/Phantasy-Star-GBC.gbc) in a Game Boy Color emulator. See [controls and saves](ROM/PLAY.txt). This is the accepted 4 MiB native GBC cartridge, with MBC5 and 8 KiB battery-backed save memory.

**Read how it was converted:** [CONVERSION_GUIDE.md](CONVERSION_GUIDE.md) explains the source extraction, hardware changes, game rules, implementation, testing and adaptations. [BUILD_AND_TEST.md](BUILD_AND_TEST.md) gives reproducible commands. [ASSEMBLY_INDEX.md](ASSEMBLY_INDEX.md) links every included native assembly module.

The original disassembly used was **[sung3r/ps1disasm](https://github.com/sung3r/ps1disasm)**, revision [`8efc4110adcf1a81c70d40522016393ba6f6b5ae`](https://github.com/sung3r/ps1disasm/tree/8efc4110adcf1a81c70d40522016393ba6f6b5ae). **Its Z80 source code is excluded from this revised ZIP.** The supplied reference SMS ROM and original README/disclaimer remain. See [ATTRIBUTION.md](ATTRIBUTION.md).

## What is included

| Folder or file | Contents |
| --- | --- |
| `ROM/` | Ready-to-play accepted GBC ROM and controls. |
| `current-project/src/` | All 262 production C files and 80 headers, including generated data and the authored inline SM83 assembly. |
| `current-project/build/obj/` | All 262 generated SM83 `.asm` modules, plus 262 assembly listings, 262 objects and 262 symbol files. |
| `current-project/build/` | Accepted linked ROM, map, NOI, IHX and main symbols; source symbol map; research inputs; selected complete final proof trees. |
| `current-project/upstream/ps1disasm/` | Only the supplied reference SMS ROM and original README/disclaimer; original Z80 source and historical Windows tools are excluded. |
| `current-project/tools/`, `tests/`, `assets/`, `docs/` | Conversion/extraction tools, tests, generated assets, technical research, source formulas, flags and edge cases. |
| `current-project/.tools/` | GBDK 4.5.0 for macOS ARM64 with its libraries/licenses; WLA-DX source and installed macOS ARM64 assembler/linker binaries. |
| `verified-baseline/` | All 45 original verified Camineet baseline files, unchanged. |
| `baseline-reproduction/` | Separate earlier baseline reproduction and evidence. |
| `current-project/build/campaign/` | Final earned campaign, independent complete replay and retained v4-prefix provenance. |
| `current-project/build/source-snapshots/`, `milestones/` | Frozen release-v5 build/source and replay tools; complete manifests and canonical-promotion evidence. |
| `PACKAGE_VALIDATION/` | Historical validation of the preceding package, identified as such. |
| `REVISION_VALIDATION/` | Fresh checks after source removal: all seven core suites and thirteen emulator integrations pass. |
| `DISASSEMBLY_REMOVAL.json`, `REVISION_CONTENT_AUDIT.json` | Removed-file inventory and the revised package's content audit. |
| `PACKAGE_MANIFEST.json`, `verify_package.py` | SHA-256/size manifest and standard-library verifier for the extracted package or ZIP. |

The port is mainly C compiled to native SM83 machine code. Three source files contain authored inline assembly. Both that editable source and every final compiler-generated assembly module are supplied; this was not a line-for-line translation of the Z80 disassembly. Modules remain separate so their symbols, sections and ROM-bank placement remain usable. The machine-readable [assembly index](ASSEMBLY_INDEX.json) records their hashes and source mapping.

## Current status and evidence

The accepted native release implements the original game through its ending. Its recorded earned New Game-to-ending campaign and independent controller replay passed on this exact ROM: **3,581,580 frames, 484 checkpoints, identical controller stream and all 8,192 earned save bytes**. Both settled ending-title images match separate fresh boots using their respective earned save memory. The retained final audit also checks source/build identity and preservation of the original baseline/reference material.

The thirteen exact-ROM integration suites and seven core host logic suites were rerun successfully **after removing the disassembly**, recorded in [REVISION_VALIDATION/report.json](REVISION_VALIDATION/report.json). Native source and generated assembly are unchanged. Earlier exact rebuild, original-SMS assembly and full campaign results remain retained historical evidence; this revision did not rerun the full campaign. Packaging checks do not imply that every optional route or possible input was played. Read [the campaign report](current-project/docs/CAMPAIGN_VERIFICATION.md) and [the final independent audit](current-project/build/verification/release-v5-final-independent-audit/report.json) for scope, the recorded campaign-driver assertion/recovery, and provenance.

Native adaptations are explicit: the smaller display and palettes, GBC sound mapping, RNG without the Z80 refresh-register contribution, slower large graphics transfers, precomputed battle outcomes with source-order playback, and native dialogue-window closure. **Physical hardware testing and a complete subjective soundtrack review are not established.** These limits are described in the conversion guide and current status documents.

Authoritative current status: [PROJECT_STATE.json](current-project/PROJECT_STATE.json), [PORT_STATUS.md](current-project/docs/PORT_STATUS.md), and the final release evidence. Some retained subsystem notes and older reports describe intermediate work as pending; they are historical records. The imported transfer guides under `history/imported-handoff/` describe the initial unintegrated expansion, not this accepted cartridge.

## Verify and rebuild

From the extracted package folder:

```sh
python3 verify_package.py
```

Before rebuilding, make a disposable copy in a short, space-free path. On macOS ARM64, Python 3 and GNU make can rebuild the supplied generated source without installing emulator dependencies:

```sh
python3 build_rom.py --jobs 4
```

The helper force-compiles all native modules, runs the existing layout check and demands the accepted ROM hash. Tests and asset extraction use a recreated Python environment; follow [BUILD_AND_TEST.md](BUILD_AND_TEST.md). Other operating systems require their matching GBDK 4.5.0 distribution. Do not run the bundled macOS binaries on another platform.

Accepted GBC ROM SHA-256:

```text
b72feead6a4a0b9efe779a2a61fbce7e96bd30247e3149b0ce1793dd414d59a1
```

## Package scope

This is the complete accepted **native GBC** source/assembly/ROM release and its conversion materials, with final proof trees for the documented release audit and replay. The original game's Z80 disassembly code and its historical Windows binaries are intentionally excluded. Native ROM compilation uses the included generated data and does not require that source. Reassembling the original SMS program, regenerating source-text-dependent assets, and running certain source-text checks require obtaining the pinned GitHub checkout separately in a disposable working copy; [BUILD_AND_TEST.md](BUILD_AND_TEST.md) explains that optional workflow.

The package also omits redundant obsolete whole-project snapshots, disposable candidate builds, pre-existing ZIP copies, installed Python environments, ordinary source caches and incidental temporary outputs. Files listed by an included immutable evidence manifest are preserved, even when they are cached files. Historical reports describe the files present when they were produced; the revised package manifest describes this ZIP. The historical v4 campaign documents the final campaign's provenance; the playable ROM is the one in `ROM/`.

`FILE_MANIFEST.json` is the **original transfer manifest**, retained for baseline verification. It describes the original larger transfer and is not the inventory of this new ZIP. Use **`PACKAGE_MANIFEST.json`** for this package. Rebuilding or running tests creates/changes files, so verify a pristine extraction first; keep the archive as the immutable delivered copy.
