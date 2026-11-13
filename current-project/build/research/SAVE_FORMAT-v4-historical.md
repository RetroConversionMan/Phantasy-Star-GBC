# Native save version 4

Current candidate `2e151f71ae14996d5753791d373b6ef9f0d7a27f7f86e3cab3742c39ea19668c` integrates the five-file save UI and this format. Thirteen exact-binary integration suites and 28 travel music cases pass. Fresh full-campaign save continuity and the independent controller replay remain pending. The isolated corruption and controller fixtures below are separate from that campaign proof; physical cartridge testing is also unverified.

This format covers the integrated world, RPG, event, dungeon and vehicle state. Saving is available during exploration and menus, not in the middle of battles or timed travel/ending sequences. Baseline PSW version1 and expansion PSG versions1–3 are rejected and never converted silently. A full campaign save/reload walkthrough is still required.

The integrated game supports the original five game files. Each 626-byte record starts at MBC5 bank0 SRAM `A000 + 1024*slot`, for zero-based slots0–4. Slot0 is byte-compatible with the prior single-file version4 cartridge. All words are little-endian. Signature byte0 is invalidated first and written last, so an interrupted write normally fails signature or CRC validation. A CRC is for corruption detection, not security.

| Offset | Bytes | Value |
| --- | ---: | --- |
| 0 | 3 | ASCII PSG |
| 3 | 1 | Version4 |
| 4 | 1 | Original map ID0..23 |
| 5 | 1 | Native facing0down,1up,2left,3right |
| 6 | 2 | World X0..2047 |
| 8 | 2 | World feet Y0..1535 |
| 10 | 64 | Four explicit16-byte character records |
| 74 | 24 | Inventory item IDs; unused slots zero |
| 98 | 1 | Inventory count0..24 |
| 99 | 1 | Joined bitmask; Alis must be present |
| 100 | 2 | Money |
| 102 | 2 | RNG state |
| 104 | 256 | Source event flags C500..C5FF |
| 360 | 1 | Scion Secrets request counter, source C2EC |
| 361 | 1 | Last church, source C317 |
| 362 | 256 | Source object flags C600..C6FF |
| 618 | 1 | Dungeon active0/1 |
| 619 | 1 | Original dungeon floor |
| 620 | 1 | Dungeon cell position |
| 621 | 1 | Dungeon facing0..3 |
| 622 | 1 | Dungeon light state |
| 623 | 1 | Vehicle0/on-foot,4/Landrover,8/Hovercraft,12/IceDigger |
| 624 | 2 | CRC-16/CCITT-FALSE over bytes0..623 |

Each character record stores status, HP, MP, EXP word, level, max HP, max MP, attack, defense, weapon, armor, shield, bound, battle spell count, map spell count, in that order. It is never copied from a compiler struct. Joined levels, HP/MP bounds, inventory IDs/count/padding, equipment IDs and spell counts are validated on load.

Opened door bits in the working dungeon layout and temporary IceDigger terrain are not persisted: the original SRAM copy excludes both working buffers. Reloading a map/floor rebuilds them from original data. Persistent chest/object flags are saved separately. Encoding/decoding supports the overlapping working buffer used to reduce native RAM usage, without serializing compiler padding.

`tools/verify_save.py` runs host code under memory and undefined-behavior sanitizers (5,118 checks). It verifies round trips, the wire layout, all24 map IDs, every single-bit corruption, impossible field values, output bounds and older-version rejection. Integrated cartridge tests separately verify power cycles after story events, combat, dungeon treasure and vehicle entry.

## Five-file directory and names

The native name directory occupies40 bytes at `B400`. Each8-byte entry contains five original-repertoire characters, marker`A5`, and a little-endian CRC-16/CCITT-FALSE over the first six bytes. Invalid/missing names appear blank and never invalidate an otherwise valid game. Deletion invalidates only the selected record signature and name marker. Overwriting an existing file retains its name.

The original name editor labels save files; it does not rename party members. The native editor preserves the five-character limit, uppercase/punctuation repertoire, advance/back/end commands, erasing the current cell before backing up, and the final-cell overwrite behavior. The smaller display uses a six-column keyboard. A new menu save enters naming; existing files do not. Select remains a native quick-save shortcut to the active file. After a reset, Continue offers load/delete and file selection; earlier unnamed slot0 records remain usable.

`tools/verify_save_slots.py` passes3,582 helper checks, including360 editor actions against original Z80 machine code and every single-bit label corruption. `tools/verify_save_ui.py` uses actual controller input to create all five files at distinct positions, name them, power-cycle/load each, delete one, overwrite another, preserve untouched records, and reject isolated record corruption. Its only memory corruption is an explicitly labeled diagnostic in a temporary emulator save. The five-slot UI also passes the world, dungeon, battle, field, travel, audio and post-chest-menu save regressions.
