# Phantasy Star port knowledge and remaining work

## Objective and actual state

The user supplied https://github.com/sung3r/ps1disasm and requested a Game Boy Color ROM of the full game. A native Camineet exploration milestone was delivered and the user confirmed it worked. The subsequent request was to implement the rest. The latest request pauses implementation in favor of transferring all work and knowledge to another account.

The verified ROM remains the original exploration build. New world/RPG extraction files are saved, but no expanded ROM was built. Do not conflate generated assets, drafted APIs, researched routines, and executable gameplay. Repeated tool/agent usage-limit interruptions caused some researched code to never be written; the absent files are identified below.

## Source and tools

- Upstream commit: `8efc4110adcf1a81c70d40522016393ba6f6b5ae`.
- SMS reference: `upstream/ps1disasm/ps1original.sms`, 524,288 bytes, SHA-256 `9e324e92bd833b45126861b6f1d2dcbb51251bdf3df6d563ab3a3ff784d8cf88`.
- GBDK 4.5.0, macOS ARM64 release. Download archive SHA-256 `289ee60e46c5a2785a21e35533f84a5131ed4a063b21b0dbdedc9a10af15bf78`.
- PyBoy 2.9.0 and Pillow 13.0.0 in the project-only Python 3.12 virtual environment. Recreate this environment after transfer; its interpreter link points to the original Homebrew installation.
- WLA-DX source commit `fceeb84ab70d52d48d0ae3f876e9d915c8eb1002`; built assembler/linker in `.tools/wla-dx-build/binaries`. CMake 4.4.4 was installed into the local environment.
- No root project files were committed to Git; its tracked-file list was empty. Source snapshots and hashes are the record of work.

`tools/audit_source.py` inventories the original 31 assembly files: 85,794 physical lines, 14,069 recognized instruction lines, 482 unsupported mnemonic uses, 503 IX/IY uses, and 145 port-I/O instructions. Categories overlap. This cannot be ported by simply changing assembler targets.

### Original build verification

Modern WLA rejects 57 bank15 labels named `DungeonID_*` because constants use the same names. `tools/verify_sms_source.py` renames only those labels to `Dungeon_*` in a temporary copy, assembles with `wla-z80 -o ps1.o ps1.asm`, and links using separate `-r -s` flags. Its output matches the reference ROM byte-for-byte. The original checkout was not changed. A combined `-rs` option with the current linker printed help and misleadingly returned success; use the separate flags and assert output existence/hash.

The verified rebuild, symbols, logs, scratch source, and report are preserved under `build/sms-reference/`. `ps1built.sym` gives exact bank/address labels and is useful for further extraction. The reproducible verifier uses a temporary directory instead of the earlier scratch copy.

## Verified native exploration engine

The tested ROM is 65,536 bytes, CGB flag `$C0`, MBC5+RAM+battery type `$1B`, 8 KiB RAM. It is native SM83 code generated from C, not an SMS emulator or automatic Z80 translation. The last verified ROM SHA is `ffe3d67bb15c3d563f6f9b61e08dc166129818d99500a9af6fd8e9eb7c1b1356`.

`src/main.c` implements title, map walk, pause menu, help, camera streaming, sprite animation, and position saving. Exported symbols include `player_x`, `player_y`, `camera_x`, `camera_y`, `screen_state`, `facing`, and `saved_position_valid`. Screen states are 0 title, 1 walk, 2 menu, 3 help.

Coordinates: player X is horizontal center; player Y is feet/bottom. The 16×24 Alis sprite top-left is `(x-8,y-24)`. The correct Camineet start is `(408,112)`. The earlier `(400,96)` start was a sampling-origin mistake and trapped the player against collision. Four collision samples use x−5/x+4 and y−7/y−2.

The camera streams 21×19 tiles into the hardware's wrapping 32×32 map. Row/column writes split at the wrap boundary. The viewport is 160×144. Current camera tile variables are 8-bit and need widening when integrating maps with 256-tile dimensions and wrap cases.

### Original Camineet extraction

- Source group4: SMS bank24 `$8000` is a 9×9 chunk pointer table. Its final row/column repeats wrapping edges. Each chunk RLE-decodes to 16×12 metatiles.
- Camineet is chunks X5–6, Y1–2: 32×24 metatiles / 64×48 8-pixel tiles / 512×384 pixels.
- Town metatile definitions: bank22 `$8000`, 8 bytes per metatile, four little-endian SMS tilemap words in TL/TR/BL/BR order.
- Town graphics: bank22 `$8570`; four RLE streams are interleaved as bitplanes. A zero terminates each stream; controls1–127 repeat the next byte; controls128–255 copy low7 literal bytes.
- Original on-foot collision: bank03 `$BD6F + metatileID`, bit0 blocks.
- Alis: bank28 `$8000`, 14 raw frames ×192 bytes, six 8×8 4bpp tiles per frame in row-major 16×24 order.
- Frame sequences down/up/left/right: `[0,2,4, 1,5,7, 9,8,10, 12,11,13]`.
- Original metasprite anchor offsets at bank03 `$980C` establish the correct feet coordinate. Palette source is identified in `extract_assets.py`.

The converter verifies the exact reference-ROM hash. It produces150 BG tiles,84 sprite tiles,7 BG palettes,8 per-tile OBJ palettes, original collision bytes, review PNGs, and a manifest. Colors are reduced from SMS4bpp to GBC2bpp. Reported exact-color fractions compare chosen SMS colors before RGB15 rounding: background96.9518%, opaque sprite pixels81.0963%. Background priority is omitted; original collision keeps scenery blocking. NPC pictures are baked into the map, without NPC behavior.

### Memory and banking constraints

- Baseline ROM bank2 holds map, attributes, collision, BG graphics/palettes, Alis frame-order and attribute tables. Bank3 holds sprite pixels/palettes. ROM0 holds engine/font.
- GBDK signed BG tiles0–127 address `$9000`; BG128–255 address `$8800`. OBJ tiles0–127 address `$8000`, so they do not overlap BG0–127.
- Font: VRAM bank1 BG IDs0–63. Alis: VRAM bank1 OBJ IDs0–83. World BG can use bank0 IDs0–255 plus bank1 IDs64–255:448 patterns, while preserving font/OBJ allocation.
- Cache Alis frame/attribute metadata in WRAM before changing active world banks, or use explicit bank-safe reads. Reading a bank2 pointer while some other bank is mapped returns unrelated data.
- Never call `SWITCH_ROM` from code executing in the switched window unless returning through a carefully designed trampoline. Planned `bank_read8(bank,pointer)` and `bank_copy(dst,bank,pointer,len)` helpers must execute `NONBANKED` in ROM0 and restore `CURRENT_BANK`.
- **`bank_io.h` and `bank_io.c` were not created.** The write attempt failed automatic approval review because of a usage limit; this was not a safety rejection. The helpers remain a plan.

### Position save and verification

The existing save record is12 bytes at SRAM `$A000`: magic `PSW`, version1, little-endian X and Y, facing, reserved byte, and checksum. It saves position only. The first magic byte is written last; invalid signature/checksum/coordinates are rejected. A complete save needs a new version covering party, inventory, event flags, map/dungeon/travel state and RNG. Define an explicit serialized format; do not write raw compiler structs without a layout contract.

The parent completed successful tests after subagents' earlier failed spawn tests. Authoritative evidence is the saved reports, not early agent messages saying they had not observed a pass:

- `build/verification/report.json`: header/boot/input/UI/save/reload/corrupt-save tests passed.
- `build/verification/world-report.json`: source-derived walking routes,144 cell transitions,59,451 visible tile+attribute comparisons, and four-direction collision passed.
- `tools/verify_world.py` was written by the parent and is present, despite one agent's older note that its proposed version was never written.
- `build/verification/*.png`: real emulator screenshots, not mockups. `build/preview.png` is a nearest-neighbor enlarged screenshot.

## Saved world expansion

Files present: `tools/extract_world.py`, `src/world_assets.h`, ROM0 descriptor file `src/world_assets.c`,22 per-group map/asset C files, and `assets/world/` binary data, full-map PNGs, and manifest. `docs/WORLD_FORMAT.md` was planned but not written; this section replaces those missing notes.

All11 groups generated successfully. No new world C compilation/linking, emulator integration, transition traversal, or complete visual review occurred.

| Group | Description | Map/asset banks | Tiles | Entrance records |
| --- | --- | --- | ---: | ---: |
| 0 | Palma | 32/33 | 317 | 46 |
| 1 | Motavia | 34/35 | 188 | 24 |
| 2 | Dezolis | 36/37 | 120 | 17 |
| 3 | Dezolis shared map | 38/39 | 120 | 0 |
| 4 | Camineet / Parolit / Spaceport | 40/41 | 227 | 96 |
| 5 | Palma town group2 | 42/43 | 154 | 47 |
| 6 | Palma town group3 | 44/45 | 126 | 120 |
| 7 | Town group4 | 46/47 | 333 | 102 |
| 8 | Town group5 | 48/49 | 52 | 42 |
| 9 | Town group6 | 50/51 | 186 | 39 |
| 10 | Town group7 | 52/53 | 66 | 6 |

`world_map_group[24]` maps original IDs to groups: `[0,1,2,3,4,4,4,5,5,5,5,5,6,6,7,7,7,7,7,8,8,9,9,10]`. `world_map_music[24]` retains original music IDs. Descriptors are ROM0; pointed data requires bank selection.

Each map is128×96 one-byte 16×16 metatile IDs, row-major,12,288 bytes. Each asset bank contains256×8-byte metatile definitions (four `[tile,attr]` pairs in TL/TR/BL/BR order),256 complete collision flag bytes,2bpp graphics,7 RGB15 palettes, and entrances. On-foot blocker is `flags & 1`; do not throw away the remaining flags needed for triggers/terrain/vehicles.

Load the first256 tile patterns into BG VRAM bank0 IDs0–255. Load remaining patterns into bank1 IDs64 onward. Attributes contain palette0–6, VRAM-bank bit3, horizontal flip bit5, vertical flip bit6. Each asset bank fits16 KiB; each group uses at most448 patterns.

`WorldExit` is six bytes `{x,y,mode,target,a,b}`. Source trigger X/Y are normalized metatile coordinates and cover2×2 cells with wrapping over128×96. Mode8 means map transition: target is original map ID, `a` is packed destination Y, `b` is destination X. DecodeY=`((a>>4)*12+(a&15))%96`; centerX=`b*16+8`, feetY=`decodeY(a)*16+16`, with world wrapping. Mode10 enters dungeon: target is dungeon ID, `a` packed YX position, `b` facing. Mode12 begins interaction: target is interaction type, a/b remain the original arguments.

**Some source entrance tables share suffixes into later groups. Matching coordinates alone can fire unrelated events.** Integrate original tile flags and event conditions (`LABEL_77AC`, `LABEL_7764`, `LABEL_78BD`, `LABEL_792A`), not an unconditional rectangle lookup. Generated graphics are static snapshots; animated tiles, vehicle palettes, story gates, and SMS priority remain incomplete.

The current Makefile uses `$(wildcard src/*.c)` with `-Wm-yo4`. Those settings cannot hold banks32–53. Update the expansion build to at least64 ROM banks and separate baseline versus expansion targets before attempting a build. Preserve the existing verified ROM.

## Saved RPG data and unimplemented rules

Files present: `tools/extract_rpg.py`, `src/rpg.h`, `src/rpg_data.h`, `src/rpg_data.c`, `build/rpg_extraction.json`. There is no `src/rpg.c`; all declared functions are unimplemented. `docs/RPG_RULES.md` was not written. Extraction validated the exact ROM SHA and Alis/Sworm sentinel data. No RPG C compilation, rule tests, banking tests, or emulator combat tests occurred.

| Table | SMS bank:address | Bytes |
| --- | --- | ---: |
| Four 30-level character tables | 03:B8AF | 960 |
| 75 enemy records | 03:867F | 2400 |
| 29 shop records | 03:B70D | 290 |
| Equipment bonuses | 00:183A | 64 |
| Item flags | 01:7FAB | 64 |
| Spell MP costs | 00:1DDC | 19 |
| Battle spell lists | 00:1A57 | 15 |
| Map spell lists | 00:1DEF | 15 |
| 94 eight-entry encounter pools | 03:8180 | 752 |
| Map encounter lists | 03:8470 | 304 |
| Raw region after LABEL_B03_85A0 | 03:85A0 | 223 |
| World encounter regions | 03:8000 | 384 |

The223-byte `terrain_encounters` region is preserved raw; its full internal structure is not classified. Do not assume all bytes form one homogeneous table.

`rpg.h` proposes `RPGState` with four characters,24 inventory slots, joined mask, money and RNG; `RPGBattle` holds eight enemies, turn state, rewards and outcome. The APIs are host-compatible through `RPG_BANKED`, mapping to `__banked` under SDCC. Generated tables use bank4. Tables plus names consume about6,165 bytes, leaving about10 KiB for bank4 code; complete rules may need another bank and safe getters.

### Source-derived rules to preserve

- Initial Alis: level1, HP16, MP0, base attack/defense8/8. Short Sword adds4 attack, Leather Armor adds5 defense. Initial money/inventory are zero.
- Equipment type is flags bits0–1; bit2 prevents discarding; bits4–7 allow Alis/Myau/Odin/Noah. Equipping exchanges the selected inventory item with old equipment; if the old slot was empty, remove that inventory entry. Inventory capacity24.
- ItemID Secrets64 is special shop/story behavior and is outside the64-entry item-flags/equipment arrays. Guard indexing.
- Shop record is10 bytes: **last option index**, followed by three `(item,16-bit price)` entries. A leading2 means three options; the source comment saying count is misleading.
- Cola heals10; Burger40. Heal restores20 for2MP; Cure80 for6MP. Saturate HP and require a living target. Free rest restores living members only.
- Hospital cost is missing HP plus missing MP; revival cost is level×20.
- EXP reward is given in full to each living party member, capped65,535. At most one level per reward call; cap30. Level gains do not heal. Money additions cap65,535.
- Normal stat scaling (`LABEL_1279`) is `floor(v/2)+floor(v/4)+floor(random_byte*floor(v/4)/256)`.
- Physical damage independently scales attack and defense, then subtracts if attack wins. Otherwise, defense−attack≥16 and even gives a miss. Other cases rejection-sample r in0..relevant level: player fallback r+1; enemy fallback floor(r/2)+1.
- Attack-boost status bit7 adds half, capped255. Enemy weak bit6 then subtracts one quarter.
- Turn order is12 slots (four party, eight enemies) with12 random swaps at `LABEL_18F2`; it is not speed-based initiative.
- Enemy record offsets: name0–7, palette8–15, graphics bank16, pointer17–18, visual descriptor19, group size20, HP21, attack22, defense23, item24, money25–26, trap27, EXP28–29, behavior30, run chance31.
- Enemy group-size byte bit7 means fixed low-nibble count; otherwise choose1..min(low nibble,2×joined party size).
- Fire:7–10 damage to a random living enemy. Thunder:25–40 to each living enemy, with Dark Falz handling. Wind:three random-target hits of9–12.
- Needle/Heat/Laser guns apply fixed5/10/20 across enemies via `LABEL_1EEE`, with Dark Falz handling.
- Enemy `flags & 7` selects physical attack, occasional binding, healing, occasional boost, occasional fire, occasional group thunder, petrification/Mirror Shield behavior, or a Crystal-dependent boss attack. Complete their original control flow.
- Wall/protection counters, bindings, run restrictions, talk outcomes, special bosses, rewards and chest traps require full porting. Do not substitute generic RPG behavior.
- Original `UpdateRNGSeed` combines an LFSR with Z80 refresh register R. GBC lacks R; define and document an input/frame-timing entropy strategy. No RNG was implemented. The API draft exposes `rpg_seed_rng` for reproducible tests.

## Dialogue and events research only

No `extract_dialogue.py`, generated dialogue C files, `events.c/.h`, or `docs/EVENTS.md` exists. The following notes preserve work that was interrupted before file creation.

### Decoding text

SMS bank2 `DialogueBlock` begins at CPU `$8000`. There are341 pointer entries for even dialogue indices `$0002..$02AA`. `ShowDialogue_B2` at `$575B` uses `DialogueBlock-2+index`, loads the pointer, then calls `LABEL_31D4`. Dictionary table `DialogueWordBlock` has128 pointers named `Dialogue_Word_Index_00..7F`.

Bytes `$80..FF` expand dictionary entry `byte&$7F`. `$40` is apostrophe; `$5B` current character, `$5C` enemy, `$5D` item, `$5E` number. `$5F` clears text, `$60` newline, `$61` wait/next page. `$62` returns for caller-controlled prompt; `$63/$64` use special return/wait behavior; `$65` waits for a button and ends. Source wraps at18 characters. Some words are intentionally concatenated across that width; a naïve concatenation makes errors such as `TODIE`.

A label does not mark the string's end: index0002 falls through0004 to a terminator;0008 continues through000A/000C/000E. Decode from the selected pointer through the first terminator. Bank2 data can be reconstructed with a `.db/.dw` parser resolving constants, then compared against the reference bytes.

Additional messages occur in SMS bank12 (`sound/sound_driver.asm`), with the same dictionary/controls. Useful addresses: B592 found-item, B671 inventory-full, B7C7 shop-welcome, B7E3 farewell, B7F5 item-selection, B807 another-purchase, B813 purchase-inventory-full, B8C8 hospital-greeting, BD57 insufficient-money.

### Dispatch and early event logic

These are native Z80 handlers, not an existing event bytecode VM. `LABEL_78BD` mode0C stores Interaction_Type and arguments C2DB/C2DC. C2DB is usually event/shop ID; C2DC goes to `LABEL_617D` for portrait. `LABEL_474B` dispatches nonzero event IDs through `LABEL_4773-2`, two bytes per ID.

Interaction types12/13 hospital,14/15 church,16/17 shop,18/19 food,1A/1B selling; ordinary types use the event table. Shops use `C2DB & 1F`.

| Event | Handler | Original behavior |
| --- | --- | --- |
| 1 Suelo | 48DF | If C501=0, set1 and show0002. Always show0006, then restore living members' HP/MP. |
| 2 Nekise | 48FC | If C502=0, show0008, attempt Laconian Pot38, set flag only if item is present; finish0010. |
| 3–7 | 4922..493A | Show0012,0014,0016,0018,001A respectively. |
| 8 | 4940 | Ask0062; yes→0060; no→number3 and0064. |
| 9–10 | 495A,4960 | Show001C,001E. |
| 11 | 4966 | Roadpass33 gate; missing→0020; present→0024 plus transition. |
| 12 | 4973 | Same gate, missing dialogue0022. |
| 13–18 | 4991..49AF | Show0026,0028,002A (continues002C),002E,0030,0032. |
| 19/20 | 49B5 | Passport gate if C504<7: ask0070; no→0020; yes without Passport34→00CE; possession→transition6 and0024. Flag≥7 branch4A8C remains undecoded. |

Roadpass success sets `C2E9=(((C309>>1)-1)&3)`. `Inventory_FindFreeSlot` actually searches for a specified item, returning Z when found. Full-inventory addition invokes discard/replace prompts. Preserve that behavior when porting Nekise; setting the flag despite failing to receive the pot would break progression.

Shop1 Camineet armory: Leather Shield30, Iron Shield520, Ceramic Shield1400. Shop2 supplies: Flash20, Escaper10, Transfer48. Shop3 food: Cola10, Burger40. Shop4 Parolit armory: Iron Sword75, Titanium Sword320, Ceramic Sword1120. Shop5 supplies: Flash20, Escaper10, Magic Lamp1400. Shop6 food: Cola10, Burger40. Shop8 Scion has Secrets40 priced200; handler2C46 implements repeated requests leading to Roadpass and remains unported.

Planned interface: bank8 `DialogueRef {bank,text pointer,length,terminator}`, indexed by original dialogue index/2 (342 entries including empty0); text banks9–15 with expanded words and dynamic tokens; bank7 native events using `EventState {flags[256],RPGState *rpg}`. `event_begin/advance/respond` return explicit dialogue/prompt/shop/transition actions. Reuse the same RPG state, not a second inventory/party copy. These bank assignments are reservations, not implemented code.

## Dungeon research only

No native dungeon code or generated dungeon asset files were created. Original routines and layouts remain available for direct work:

- `B15_DungeonLayouts` is SMS bank15 `$9F6E`.61 floors occupy `$9F6E..$BDED` (128 bytes/floor); each byte expands high nibble then low nibble into a16×16 cell grid. The next label is B15_BDEE. This count was checked from the assembled symbol addresses during transfer preparation. `LABEL_6D56` performs expansion.
- Dungeon position is packed YX at C30C, index C30D, direction C30A. Directions0/1/2/3 are north/east/south/west, offsets−16,+1,+16,−1 (`LABEL_6C06`). Coordinates use byte arithmetic; preserve intended wrapping/transition behavior.
- `LABEL_6BE9` reads the cell ahead; lower3 bits classify geometry, bit3 marks special transitions, and runtime bit7 marks opened doors. `LABEL_6BCA` returns lower3 bits.
- Forward: cell type0 moves normally; type7 invokes movement twice. Types2/3 are stairs: if not special, change floor +1/−1 and advance two cells. Types4–6 require opened runtime bit7 before advancing; special bit3 uses transition lookup. Type1 blocks. Confirm complete original branches before implementing.
- Backward only moves when the rear lower3 bits are zero. Left/right rotate. Button action opens an ordinary type4 door by setting runtime bit7; other actions enter the original menu.
- A current cell08 without a matching object triggers a trap/fall path, including floor decrement with zero clamp. Objects and transition semantics must be ported rather than treating every nonwall cell as ordinary floor.
- `B03_ObjectData` at03:AF5C is7 bytes/entry: floor, packed coordinate, 16-bit flag address, type, two payload bytes. Type0 item+trap,1 money word,2 fixed battle+drop,3 dialogue. FlagFF suppresses the object. Dialogue flags start C500, object/event flags C600.
- `B03_DungeonTransitionData` at03:B473 has5-byte records: floor, coordinate, target-kind/map, a,b, terminatedFF. Targets<80 go to maps; FF runs interaction/dialogue; FE/FD have special interaction setup. Missing records return to the stored outside map position. Preserve remaining branch details from LABEL_68BC onward.
- Floor encounter/palette/music records start03:B619,4 bytes per floor. LABEL_6D7F loads encounter settings and palette according to light state; LABEL_6DE2 selects music. Flash, Magic Lamp, dark floors, exits, traps and progression matter.
- The original first-person renderer uses LABEL_6AE5/6AED, graphics stream selection at705F, two RLE tilemap streams at6B62, three-plane compressed graphics expanded with OR fourth plane at6B8E, and layered wall/door overlays from bank6 via6C46..6E64. A GBC renderer still needs implementation and visual validation. No placeholder raycaster or replacement dungeon art was created.

## Integration reservations and continuation order

| GBC ROM bank | Intended use | Status |
| --- | --- | --- |
| 0 | Core/native helpers and descriptors | Existing engine; helpers still absent |
| 2–3 | Verified Camineet/Alis assets | Implemented/tested baseline |
| 4 | RPG tables and possible rules code | Tables saved, rules absent |
| 5 | Extra RPG space if required | Proposed only |
| 6 | Possible world engine | Proposed only |
| 7 | Native event handlers | Proposed only |
| 8 | Dialogue references | Proposed only |
| 9–15 | Dialogue text | Proposed only |
| 16–17 | Possible dungeon data/code | Proposed only |
| 32–53 | World groups | Data generated, not integrated |

Recommended next concrete work:

1. Verify the frozen baseline, then create separate baseline/expansion build targets. Increase expansion ROM bank count and add ROM0 bank-copy helpers.
2. Generalize rendering to WorldScene descriptors,128×96 metatile maps, wider coordinates,448-tile VRAM layout, and cached Alis metadata. Verify each map and actual entrance/gating behavior.
3. Implement shared RPG state and explicit versioned save format. Test initialization, inventory bounds, equipment exchanges, purchases, healing, and persistence before connecting story effects.
4. Decode original dialogue and implement native event handlers, starting with Suelo/Nekise/Camineet/Parolit and progressing through every original handler. Validate inventory-full, prompt, prerequisite, and repeated-interaction branches.
5. Implement and test original encounter/battle rules, rewards, spells, status and bosses. Use deterministic RNG fixtures and source comparisons. Add original enemy presentation and adapted battle UI.
6. Port dungeon traversal/rendering, all object/transition/light/trap logic, travel/vehicles, recruitment, key items, story gates, final bosses, and ending.
7. Port music/effects from the PSG event data to GBC sound channels. No audio work beyond source inspection exists.
8. Complete start-to-ending playthroughs, save/reload across systems, graphics/audio checks, and physical GBC/flash-cartridge testing before calling the full game complete.

The existing `docs/PORT_STATUS.md` gives additional routine locations and acceptance gates. Its opening describes the verified exploration milestone, not the newer saved extraction data. Keep the distinction clear.

## Environment history

The original project path was under a Documents symlink to OneDrive. The normal command runner failed because symlinked writable roots were unsupported; local commands worked with reviewed escalation. This is an environment issue, not a required project setting. Use the destination environment's normal execution path instead of copying that workaround blindly. Automatic approval review and agents later hit usage limits; the unfinished modules were not abandoned due to technical completion or a safety refusal.

The user supplied an unrelated local instruction: when using DDIT MCP catalog search, use CatalogStreamSearch rather than CatalogSearch unless explicitly requested. No DDIT tools were used for this game project. It does not affect the port.
