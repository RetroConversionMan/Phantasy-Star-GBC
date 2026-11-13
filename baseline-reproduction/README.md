# Phantasy Star — native Game Boy Color port

**Status: incomplete, playable Camineet exploration milestone. This is not the complete game.**

The cartridge runs a new native Game Boy Color engine using map, collision, and character graphics extracted from the linked Master System disassembly. It does not emulate the Master System or execute the original Z80 game logic.

Open `build/phantasy-star-gbc-exploration.gbc` in a Game Boy Color emulator. The ROM is 64 KiB, marked CGB-only, and uses MBC5 with 8 KiB battery RAM. Hardware/flash-cartridge testing has not been performed.

## Playable now

- Explore the complete 512×384-pixel Camineet town map with Alis.
- Scroll across the 160×144 display with animated, directional walking.
- Terrain collision uses the original on-foot blocking table.
- Save the walking position and facing direction, restart, and choose Continue Walk.
- Use a title screen, pause menu, and control/help screen.

NPC pictures are retained in the map, but NPCs do not move or interact. Doors and town exits do not change locations. There are no story events, conversations, shops, inventory, combat, other maps, dungeons, music, sound effects, or ending. Position saving is separate from the original game's save format. Graphics use reduced GBC palettes, and SMS background priority is not reproduced.

## Controls

| Button | Action |
| --- | --- |
| D-pad | Walk; move menu selection |
| Hold B | Walk faster |
| Start | Begin / pause / resume |
| A | Choose an option; show controls while walking |
| B | Close a menu or the help screen |
| Select | Save walking position |

## Build

Generated asset sources are included, so rebuilding the ROM needs only GBDK 4.5.0 and Make. All installed tools remain inside `.tools/`.

```sh
python3 tools/bootstrap.py
make
```

For an existing GBDK installation, use `make GBDK_HOME=/path/to/gbdk`.

The bootstrap script obtains the pinned upstream source and the official compiler release. To regenerate the assets and font without image dependencies:

```sh
make assets
make
```

To generate review images and run the emulator checks, use Python 3.12 or another version supported by the pinned packages:

```sh
python3.12 -m venv .tools/venv
.tools/venv/bin/python -m pip install -r requirements-dev.txt
make previews
make verify
```

## Verification

The current build passed in PyBoy 2.9.0 with CGB emulation:

- Cartridge logo, CGB flag, declared ROM size, header checksum, and global checksum.
- Boot, title, movement, menu/help transitions, and movement pausing behind menus.
- Position/facing persistence across a fresh emulator boot, menu saving, New Walk, and rejection of damaged save records.
- 144 map-cell transitions through multiple parts of town, 59,451 visible tile/attribute comparisons, and wall blocking in four directions.

Reports and original-resolution screenshots are in `build/verification/`. These checks cover this exploration milestone, not original-game fidelity or campaign completion.

The original disassembly was also assembled to a byte-identical 524,288-byte SMS reference using WLA-DX. Modern WLA requires conflicting `DungeonID_` labels in bank15 to be renamed in a temporary copy; the upstream checkout is untouched. `build/sms-reference/report.json` records that result.

## Source and continuation

Upstream: [sung3r/ps1disasm](https://github.com/sung3r/ps1disasm), pinned commit `8efc4110adcf1a81c70d40522016393ba6f6b5ae`.

The converter requires the reference ROM SHA-256 `9e324e92bd833b45126861b6f1d2dcbb51251bdf3df6d563ab3a3ff784d8cf88`; it rejects other revisions because the extraction addresses are specific to that source.

| File | Purpose |
| --- | --- |
| `src/main.c` | Native display, camera, movement, menus, and position saving |
| `tools/extract_assets.py` | Original RLE/map/sprite decoding and GBC palette conversion |
| `assets/manifest.json` | Data addresses, format, palette decisions, and conversion metrics |
| `tools/verify_rom.py` | Cartridge, UI, and battery-save verification |
| `tools/verify_world.py` | Source-derived route, collision, and scrolling verification |
| `tools/audit_source.py` | Reproducible assembly inventory |
| `docs/PORT_STATUS.md` | Remaining systems, source entry points, and full-port acceptance criteria |

The next gameplay work is the original town interaction/event system and map transitions, followed by character state, battles, and dungeons. This build deliberately does not substitute invented story or combat logic for those systems.

Original Phantasy Star content belongs to its respective rights holders. The upstream disclaimer is preserved in `docs/UPSTREAM_README.md`; GBDK runtime terms are in `docs/GBDK-LICENSE.txt`. No ownership of original game content is asserted.
