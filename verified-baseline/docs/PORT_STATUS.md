# Phantasy Star → Game Boy Color: port status

**The complete game has not been ported.** A native exploration build is an initial milestone. It does not establish compatibility with the original battle system, story progression, dungeon renderer, audio, or save format. Consult the project README and emulator test results for the exact behavior of the current ROM.

The current 64 KiB GBC build supports Camineet exploration, original terrain collision, animated Alis, scrolling, menus, and position/facing saving. Emulator checks passed for boot, input, UI, save/reload, damaged-save handling, 144 map-cell transitions, 59,451 visible tile/attribute comparisons, and blocking in four directions. Regenerating the assets and rebuilding produced an identical ROM. Physical hardware is untested.

The pinned SMS disassembly was also rebuilt byte-identically. Modern WLA-DX rejects 57 bank15 labels whose `DungeonID_` names collide with constants; renaming those labels to `Dungeon_` in a separate verification copy resolves this without changing ROM bytes. The upstream checkout is untouched. Reproduce with `python3 tools/verify_sms_source.py --wla-bin /path/to/wla/binaries`.

## Pinned source and reproducible inventory

Source: [sung3r/ps1disasm](https://github.com/sung3r/ps1disasm), commit `8efc4110adcf1a81c70d40522016393ba6f6b5ae`.

Run from the project root:

```sh
python3 tools/audit_source.py
```

This writes `build/source_audit.json`. It records each source file's hash, byte size, physical line count, instruction frequencies, porting hazards, address references, and key entry points. It also hashes the included reference ROM. No assembler, emulator, or network connection is required after obtaining the source.

| Inventory | Count |
| --- | ---: |
| Assembly files | 31 |
| Assembly bytes | 2,915,252 |
| Physical source lines | 85,794 |
| Data directive lines | 64,028 |
| Recognized instruction lines | 14,069 |
| Named labels | 2,669 |
| Reference SMS ROM bytes | 524,288 |
| Instructions with unsupported Z80 mnemonics | 482 |
| Instructions using IX/IY registers | 503 |
| Port I/O instructions | 145 |
| Branches using unsupported condition flags | 55 |
| Absolute 16-bit load forms needing adaptation | 198 |
| 16-bit ADC/SBC operations needing adaptation | 40 |

These are lexical counts, not a completion estimate or runtime profile. Categories overlap. Numeric operands can be constants rather than addresses. The script does not resolve macros or expressions, so this is a lower-level source inventory rather than proof that every incompatibility has been found. In particular, instructions present on both CPUs can still differ in flags, timing, or surrounding memory assumptions.

Reference ROM SHA-256:

```text
9e324e92bd833b45126861b6f1d2dcbb51251bdf3df6d563ab3a3ff784d8cf88
```

The original [build script](../upstream/ps1disasm/build.bat) targets WLA-Z80 and WLALINK. Changing that target alone cannot produce a GBC port. The original code writes Sega mapper registers at `$FFFC–$FFFF`, uses VDP/PSG I/O ports, and assumes a ROM window at `$8000–$BFFF`. Those assumptions conflict with Game Boy hardware. Graphics also need conversion to GBC tile/palette constraints and layouts appropriate for 160×144 pixels. Hardware references: [CPU differences](https://raw.githubusercontent.com/gbdev/pandocs/master/src/CPU_Comparison_with_Z80.md), [memory layout](https://raw.githubusercontent.com/gbdev/pandocs/master/src/Memory_Map.md), [tile format](https://raw.githubusercontent.com/gbdev/pandocs/master/src/Tile_Data.md).

## Source map and remaining work

Line numbers below refer to the pinned local source. The generated audit provides machine-readable locations.

| System | Source entry points | Required implementation and acceptance criteria |
| --- | --- | --- |
| Boot, frame timing, input, bank management | `ps1.asm`: `_START` (37), `MainSetup` (122), `MainGameLoop` (147), `VInt` (201), `ReadJoypad` (508) | Native boot/header, cartridge banking, input edge/repeat handling, VRAM-safe updates, and interrupt ownership. Verify reset/boot, sustained movement, and bank transitions without corruption on a GBC emulator; hardware testing remains a separate gate. |
| Overworld/towns | `GameMode_Map` (1661), `GameMode_LoadMap` (1709), `LABEL_576A` (11927), `LABEL_77AC` (16532) | Decode every map, metatile, collision table, sprite set, and entrance; port NPC/event behavior and scrolling. Compare sampled map coordinates and transitions to the SMS reference, including boundary and blocked movement cases. A map viewer alone does not satisfy this gate. |
| Story interactions, shops, and progression | `GameMode_Interaction` (8363), `GameMode_LoadInteraction` (8461); `banks/bank03.asm`: `B03_ObjectData` (3323), `B03_ShopData` (4399) | Preserve event prerequisites, inventory changes, party recruitment, purchases, and progression flags. Verify both successful and denied actions and complete all required story routes. Do not replace script logic with invented dialogue or events. |
| Dialogue and menus | `ShowDialogue_B12` (7000), `LABEL_31D4` (7004), `ShowDialogue_B2` (11916), `DialogueBlock` (17498); `PlayerMenu_OptionTbl` (4020) | Decode the original control codes, word substitutions, and prompts. Reflow text for the smaller display while retaining semantics. Verify every branch/prompt and menu action; check clipping and pagination. |
| Battles, encounters, character state | `LABEL_100F` (2168), `UnlockCharacter` (3155), `BattleMenu_OptionTbl` (3479), `BattleMenu_Attack` (3487), `BattleMenu_Talk` (3496), `BattleMenu_Run` (3557), `BattleMenu_Magic` (3589), `BattleMenu_Item` (3882), `Map_RunRandomBattles` (12891), `Dungeon_GetEncounter` (12963); `banks/bank03.asm`: level tables (4699–4804) | Port initiative, damage, status, spells, items, rewards, level progression, enemy behavior, and encounter selection. Use deterministic RNG fixtures to compare resulting game state with the reference. Test defeat, escape, full inventory, and final bosses. |
| First-person dungeons | `GameMode_Dungeon` (2068), `GameMode_LoadDungeon` (2102); `banks/bank03.asm`: `B03_DungeonEntrancePoints` (3091), `B03_DungeonTransitionData` (4271); `banks/bank15.asm`: dungeon data | Build a GBC renderer and port facing/movement, floors, stairs, traps, doors, treasure, lighting, and transitions. Validate every floor layout and traversal state against the reference; ensure rendering updates fit frame limits. |
| Ships, roads, title, endings, name entry | `GameMode_InitIntro` (1062), `GameMode_Intro` (1067), `GameMode_LoadIntro` (1244), `GameMode_Ship` (1350), `GameMode_LoadShip` (1591), `GameMode_Road` (1992), `GameMode_LoadRoad` (2030), `GameMode_NameInput` (8720), `GameMode_LoadNameInput` (8948) | Adapt presentation and transitions while preserving game state. Verify all interplanetary routes, title/new/load behavior, name entry, and ending sequence. |
| Save/load | `LABEL_634` (1105), `LABEL_73A` (1232), `PlayerMenu_Save` (4069) | Define and version a native cartridge-RAM layout. The SMS save routine copies a 1,024-byte state block beginning at `$C300`; its mapper operations cannot be reused unchanged. Verify round trips after combat, quests, travel, and dungeon changes, including reset and invalid/empty saves. A position-only prototype save is not full-game save support. |
| Music and sound effects | `CallSndUpdate` (456), `CallSndInit` (461), `CallSndMute` (466); `sound/sound_driver.asm`: `Snd_InitDriver` (1), `Snd_SilencePSG` (25), `Snd_UpdateAll` (49) | Decode the score/event format and arrange it for the GBC sound channels. Replace PSG output and account for tempo, looping, envelopes, and effect priority. Compare track lengths and event timing; listen to every track/effect. |

## Completion gate

A faithful full-game release requires all systems above, all maps and story content, a complete start-to-ending playthrough, save/reload testing across the full campaign, and visual/audio checks. A ROM that boots, displays converted graphics, or permits exploration meets only that stated milestone. Record missing features explicitly until each gate passes.

Keep the upstream README and attribution with the source; this inventory does not change the upstream project's terms.
