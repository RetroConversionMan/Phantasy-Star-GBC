# Phantasy Star — Game Boy Color

**Box art:** [View or download the full-resolution cover](artwork/Phantasy-Star-GBC-box-art.png).

<img src="artwork/Phantasy-Star-GBC-box-art.png" alt="Phantasy Star Game Boy Color box art" width="420">

A native Game Boy Color port of Phantasy Star, with complete project source, generated SM83 assembly, converted assets, build tools, documentation, and retained development/test evidence.

**Play the corrected game:** [Phantasy Star.gbc](ROM/Phantasy%20Star.gbc) · [Controls](ROM/PLAY.txt)

The cartridge is 4 MiB, requires Game Boy Color, and uses MBC5 with 8 KiB battery-backed RAM. Its filename is now **Phantasy Star.gbc**; renaming does not alter the verified ROM bytes.

## Cutscene text correction

Movie fades cleared the text palette, and loading a portrait restored only the picture palettes. The current source restores palette 7 before showing each narrative record. This fixes the missing text in Nero's opening scene, Myau's transformation, and the final character dialogue.

All six narrative sequences (38 pages), six closing-text screens, recruitment, nightmare/rest, and associated dialogue were checked in PyBoy 2.9.0. All 88 observed dialogue screens are readable, and the ending completes through the credits back to the title. Late-game checks use documented save fixtures; this is not a new full campaign playthrough. The corrected build has not yet been verified on physical hardware.

[Audit and screenshots](verification/cutscene-text/audit-report.json) · [Source change](current-project/src/main.c) · [Regression test](current-project/tools/verify_all_cutscene_text.py)

## Build and verify

On macOS ARM64, with Python 3 and make, from a short path without spaces:

```sh
python3 verify_package.py
python3 build_rom.py --jobs 4
```

The build helper force-builds all 262 native C modules with the bundled GBDK 4.5.0 and checks the corrected ROM hash. Other platforms need their matching GBDK 4.5.0 distribution, supplied with `--gbdk PATH`. Rebuild a disposable copy: compiler output changes the packaged file manifest.

The normal native build uses the included generated C/assets and does not require the original SMS disassembly or reference ROM. Optional extraction and source-comparison tests require those separately obtained inputs; see [BUILD_AND_TEST.md](BUILD_AND_TEST.md).

## Package contents

- `current-project/`: editable C/headers, assets, tests, conversion tools, documentation, native assembly/listings, linked artifacts, and bundled toolchains.
- `verification/cutscene-text/`: current before/after audit and actual emulator screenshots.
- `verified-baseline/`, `baseline-reproduction/`, `history/`, and retained milestones/campaign reports: historical work and verification for the hashes recorded in those files.
- `ASSEMBLY_INDEX.json`: hashes mapping each current production C module to its generated native assembly, listing, object, and symbols.
- `PACKAGE_MANIFEST.json`: complete delivery inventory with SHA-256 hashes and sizes.
- `PUBLICATION_EXCLUSIONS.json`: omitted upstream reference material and host metadata.

Historical reports remain unchanged and describe their recorded ROMs, including the earlier release before this text correction. They do not claim a full campaign replay of the corrected ROM. The current entry point is this README and `ROM/Phantasy Star.gbc`.

## Attribution

Original game and content: **Sega**, with rights belonging to their respective holders. The source/reference disassembly is [sung3r/ps1disasm](https://github.com/sung3r/ps1disasm), pinned to [`8efc4110adcf1a81c70d40522016393ba6f6b5ae`](https://github.com/sung3r/ps1disasm/tree/8efc4110adcf1a81c70d40522016393ba6f6b5ae).

**The original Z80 disassembly and SMS reference ROMs are not included.** Attribution and the upstream README/disclaimer are preserved. The compiler-generated SM83 assembly belongs to this native port and is included. See [ATTRIBUTION.md](ATTRIBUTION.md) for retained tool notices and content provenance. No blanket license over Sega content or the combined game is asserted.

Corrected ROM SHA-256:

```text
0b9cee5c4cf9dca47887436237cf34ba19e76a26c79714bc64430d3f923e1133
```
