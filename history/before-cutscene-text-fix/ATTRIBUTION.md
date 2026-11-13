# Attribution and preserved notices

## Original game and disassembly

Original game: **Phantasy Star for the Sega Master System**, by Sega. Original game code, text, artwork, music and other content belong to their respective rights holders.

Original disassembly used as the source/reference for this port: **[sung3r/ps1disasm on GitHub](https://github.com/sung3r/ps1disasm)**.

Pinned source revision: [`8efc4110adcf1a81c70d40522016393ba6f6b5ae`](https://github.com/sung3r/ps1disasm/tree/8efc4110adcf1a81c70d40522016393ba6f6b5ae).

Credit for the original disassembly goes to the upstream authors and contributors. The original Z80 source is **not included** in this revised package; obtain it from the pinned GitHub revision above if needed. The [original README and disclaimer](current-project/upstream/ps1disasm/README.md) is preserved, with a documentation copy at [docs/UPSTREAM_README.md](current-project/docs/UPSTREAM_README.md).

The supplied reference ROM is `current-project/upstream/ps1disasm/ps1original.sms`, SHA-256 `9e324e92bd833b45126861b6f1d2dcbb51251bdf3df6d563ab3a3ff784d8cf88`. Its inclusion preserves the provided project input. The original upstream README's ownership and usage statements remain in force; this package does not grant a new license over Sega content.

## Native port and conversion work

The native Game Boy Color implementation, source-data extractors, asset conversion, native hardware adaptation, test harnesses, source comparisons and campaign verification were developed in this project with the user's direction and testing. They are distinct from the upstream Z80 disassembly. The supplied C and inline SM83 routines compile to the included 262 native assembly modules; generated artwork, music data and rule tables derive from the original game.

The conversion guide explains what changed and what was preserved. No blanket open-source license is asserted over the combined game, derived assets or toolchain.

## Tools and dependencies

| Tool | Role and source | Preserved terms |
| --- | --- | --- |
| GBDK-2020 4.5.0 | Native SM83 compiler driver, SDCC-based compiler/assembler/linker, libraries and ROM utilities; [official release](https://github.com/gbdk-2020/gbdk-2020/releases/tag/4.5.0). | Complete bundled distribution under `current-project/.tools/gbdk/`; [GBDK license notice](current-project/docs/GBDK-LICENSE.txt), including its existing library-linking terms. |
| SDCC and related components | Compiler, assembler and linker components supplied with GBDK. | Existing notices in the GBDK distribution; no replacement license is supplied by this project. |
| WLA-DX | Assembles an externally obtained original reference checkout for optional byte-identity checks; [upstream project](https://github.com/vhelin/wla-dx). | Native tool source and [license](current-project/.tools/wla-dx/LICENSE) retained under `current-project/.tools/wla-dx/`. Historical Windows tools from the game disassembly are excluded. |
| PyBoy | Native GBC emulator used for automated input, memory, frame and audio tests; [project](https://github.com/Baekalfen/PyBoy). | Installed separately through the supplied pinned requirements; its own package terms apply. |
| z80, Pillow, NumPy, PySDL2 and SDL2 | Reference Z80 execution, image/data processing and emulator dependencies. | Version pins are retained; recreate the environment to obtain each package with its own notices. Installed Python environments are not copied into this ZIP. |

The bundled executable toolchain was tested on macOS ARM64. Other host platforms should use the matching official releases. Tool licenses do not replace the original game's rights or the upstream disassembly's notices.
