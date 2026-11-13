# Phantasy Star Game Boy Color transfer

This package preserves the working exploration ROM, its verified source, the newer unfinished expansion, original disassembly, installed development tools, test evidence, and research needed to continue in another chat.

**The full game has not been converted.** The user tested the Camineet exploration ROM and reported that it worked great. They then requested the rest of the game. Work on that expansion was interrupted by usage limits; it did not produce a new playable ROM.

## What is in the package

| Location | Contents and status |
| --- | --- |
| `verified-baseline/` | Exact source and artifacts from the delivered, tested Camineet milestone. Start here to reproduce the working version. |
| `current-project/` | Snapshot of all current project work, including original SMS source/ROM, generated world/RPG data, installed tools, build intermediates, and reports. New world/RPG data is not integrated. |
| `KNOWLEDGE_AND_NEXT_STEPS.md` | Technical handoff: formats, source addresses, mechanics, architectural decisions, unresolved work, and continuation order. |
| `NEXT_CHAT_PROMPT.txt` | Ready-to-paste instructions for the new chat. |
| `PROJECT_STATE.json` | Machine-readable status, source revisions, hashes, and bank reservations. |
| `FILE_MANIFEST.json` | Per-file byte sizes and SHA-256 hashes, plus archived symbolic-link targets. |
| `verify_bundle.py` | Standard-library integrity checker for the ZIP or an extracted copy. |
| `history/` | The earlier source ZIP delivered with the playable ROM. |

Git internals, Python bytecode caches, macOS metadata, and account/configuration directories are omitted. No game source, generated asset, test, project report, original ROM, or research note is intentionally omitted. Installed compiler and emulator dependencies are included for completeness; machine-specific environments should be recreated on the destination.

## What works

`verified-baseline/build/phantasy-star-gbc-exploration.gbc` is a native 64 KiB CGB-only MBC5 ROM with 8 KiB battery RAM. It contains the complete 512×384-pixel Camineet map, animated Alis, scrolling, original on-foot collision data, title/menu/help screens, and saved walking position/facing.

Controls: D-pad walks, holding B walks faster, Start begins/pauses, A chooses or opens help, B closes menus, and Select saves position.

The ROM passed emulator checks for header/checksums, boot, movement, menus, save/reload, damaged-save rejection, 144 map-cell transitions, 59,451 visible tile/attribute comparisons, and walls in all four directions. Regenerating the assets and rebuilding produced the same ROM bytes. Physical hardware was not tested.

ROM SHA-256: `ffe3d67bb15c3d563f6f9b61e08dc166129818d99500a9af6fd8e9eb7c1b1356`.

## What was added afterward

- Original data for all 11 world/town map groups covering 24 original map IDs, including graphics, metatiles, collision flags, entrance records, and preview images. Extraction succeeded; gameplay integration and emulator verification are unfinished.
- Authentic level, enemy, shop, equipment, spell-cost, and encounter tables. Extraction succeeded. `src/rpg.h` is an API draft; **there is no `src/rpg.c`, and none of its functions are implemented**.
- Detailed research into dialogue decoding, early NPC events, shops, combat formulas, and dungeon movement. Dialogue/event/dungeon code was not saved. The handoff preserves this research.

**Do not run the current-project Makefile expecting a working expanded game.** It includes all `src/*.c` but still requests four ROM banks. The new world files reserve banks 32–53. Keep the baseline intact and make integration changes in the current project.

## Resume in the new chat

1. Provide the ZIP and paste `NEXT_CHAT_PROMPT.txt` into the new chat.
2. Have the assistant read this guide and `KNOWLEDGE_AND_NEXT_STEPS.md` before changing files.
3. Verify the bundle and baseline ROM, then rebuild the baseline in a suitable local/code-execution environment.
4. Continue the expansion from `current-project/`, with separate tested milestones and accurate status reporting.

This is a project handoff, not an account or conversation migration. The package supplies the needed working context in files; account settings, tool access, and credentials are not transferred.

## Build the verified baseline

From the extracted transfer directory, on macOS Apple Silicon:

```sh
make -C verified-baseline GBDK_HOME="$PWD/current-project/.tools/gbdk" PYTHON=python3
```

On other systems, obtain GBDK 4.5.0 for that system and set `GBDK_HOME` accordingly. The included GBDK binary release is macOS ARM64. If extraction loses executable permissions, restore them for the compiler tools before building.

Recreate the Python environment instead of using the archived virtual environment's absolute paths:

```sh
python3.12 -m venv .venv-transfer
.venv-transfer/bin/python -m pip install -r verified-baseline/requirements-dev.txt
make -C verified-baseline verify GBDK_HOME="$PWD/current-project/.tools/gbdk" PYTHON="$PWD/.venv-transfer/bin/python"
```

`make verify` in the baseline checks both behavior and world scrolling. The archived upstream folders contain source snapshots without `.git`; therefore the old bootstrap script's existing-checkout `git rev-parse` check needs adaptation if it is used. The shipped sources and compiler avoid needing bootstrap on the original platform.

Preserve the original-game attribution and upstream disclaimer in the documentation. The package makes no claim of ownership of the original content.
