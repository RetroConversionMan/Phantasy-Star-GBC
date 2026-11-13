# Native battles and encounters: implementation and verification

Current integration status (2026-11-13): native combat, original enemy/player effects, streamed dialogue, audio and story dispatch are integrated. The current candidate and exact-binary reports are indexed in PROJECT_STATE.json. Rules milestones below retain their narrower coverage; the complete story and independent clean-power-on replay now pass. The nonbattle presentation components documented in the companion subsystem notes are integrated, including the source-verified single field-vehicle reload correction.

`src/battle.c` implements native combat rules in GBC bank 18. Shared tables, RNG, inventory and bank-safe getters remain in bank 4. These modules compile under GBDK 4.5.0 and pass host logic tests. Those original rules-only tests did not establish battle UI, animation, audio or story integration; later native evidence is recorded in BATTLE_PRESENTATION.md.

Source is pinned `upstream/ps1disasm/ps1.asm` and ROM SHA-256 `9e324e92bd833b45126861b6f1d2dcbb51251bdf3df6d563ab3a3ff784d8cf88`. New table addresses were checked in `build/sms-reference/ps1built.sym`; numeric label suffixes are not assumed to be actual addresses.

## Integration contract

- Call `rpg_battle_begin` with original enemy ID. Enemy HP, attack and defense are copied **without scaling** from the source record (`LABEL_6095`); attack calculations perform the random scaling. Group size uses fixed low-nibble count when bit 7 is set, otherwise rejection-samples 1 through `min(record low nibble, twice joined party count)`. Dead joined characters still count.
- Before selecting a dungeon battle's actions, set `battle.escape_blocked` from `LABEL_687A`: escape is blocked if rear and both side cell types are all nonzero. It defaults to clear for world battles. Actual dungeon retreat relocation belongs to the dungeon engine.
- Fill four `RPGAction` entries. `rpg_battle_prepare` validates learned spells, MP, targets and inventory; immediate Run/Talk/Chat/Tele can stop remaining selections. `rpg_battle_step` resolves one actor; `turn_cursor == 12` means another selection round. `rpg_battle_round` is the whole-round convenience wrapper. Check `last_error` for rejected selections. WAIT is an engine/testing action, not an added player command.
- Source attack targets are random living enemies; `RPGAction.target` is used for Heal/Cure/Help. Item actions identify the item byte, re-find its current inventory slot when acting, and food heals the actor. This preserves consumed-before-your-turn behavior.
- `last_actor`/`last_target` use party 0–3, enemies 4–11, 255 for none. `last_damage` is display feedback capped at 255; actual HP changes are per target. `last_effect` describes the resolved action. Presentation can compare HP before/after a multi-target action.
- Victory returns before rewards. `rpg_claim_rewards` awards full EXP to each living member exactly once, refreshes stats and prepares any chest; it does **not** grant money/item. `rpg_battle_open_chest` applies the trap, then money, then item. `RPG_FULL` leaves `item_pending` for original discard/replace prompts; use `rpg_battle_replace_reward`, retry adding after a removal, or decline. Rewards and money are never duplicated on retry.
- `RPGState` and `RPGCharacter` layouts are unchanged. Added `RPGBattle` fields are transient battle state and are not silently included in save serialization.

## Source control flow retained

| Source | Implementation detail |
| --- | --- |
| `LABEL_1022`, `LABEL_18F2` | Initiative starts as 0..11 once per battle, then performs 12 random swaps with rejection above 11 every round. Prior permutation is retained. No speed statistic. |
| `LABEL_1148`, `LABEL_128C` | Binding decays by random 1 or 2; the recovery turn is consumed. Failed Talk/Run suppresses all party actions for that round. |
| `LABEL_121D`, `LABEL_1279`, `LABEL_1579` | Independent attack/defense scaling, miss parity and level rejection fallback; attack boost adds half capped at 255; enemy weakness then subtracts one quarter. |
| `LABEL_12D4`, `LABEL_1305` | Wall/Protection low-seven-bit counter decays 0..3 only for enemies with behavior bit 4, otherwise shatters. Physical attacks respect either barrier. Enemy magic respects only bit 7. Group magic decays Protection before each party slot, including dead slots. |
| `LABEL_12C4` | All eight enemy behavior classes implemented: physical, occasional bind, healing, occasional boost, fire, group thunder, Medusa petrification, Crystal-dependent boss attack. |
| `LABEL_13CC` | Healing enemy heals 80 when HP<30 without a chance roll; otherwise heals with 1/8 chance, and caps at its original max HP. |
| `LABEL_1EA7`, `LABEL_1EB2` | **Player Fire hits twice**, each 7–10 damage with independently random living target. The source calls the next routine and then falls through into it again. This corrects the handoff's one-hit description. |
| `LABEL_1421`, `LABEL_142C` | Enemy fire likewise calls then falls through for **two** random-target 7–10 hits. |
| `LABEL_1F25` | Wind has three random-target hits of 9–12. |
| `LABEL_1EEE` | Thunder gives 25–40 damage per living enemy. Needle/Heat/Laser guns give fixed 5/10/20. Against Dark Falz, stop after first living enemy slot. Dark Falz has two separately acting 255-HP records. |
| `LABEL_1F36`, `LABEL_1FDF` | Rope uses source eligibility bit, Alis attack comparison, optional random strength, and first living unbound target. Terr requires Alis attack >= first enemy attack, a random byte <178, and first not-yet-weakened living enemy. |
| `LABEL_1FC0`, `LABEL_1E90` | Help applies boost to the chosen living member; Wall sets 6 and Protection sets 0x86. Source MP payment ordering preserved. |
| `LABEL_151A` | Any nonzero Odin status with Mirror Shield changes Medusa to physical attack. Otherwise petrification kills a random living target even if a barrier remains. |
| `LABEL_1561`, `LABEL_1505`, `LABEL_15C2` | Without Crystal, Lassic adds a positive random 1..16 byte to HP, then preserves the result only if byte addition carries; this usually kills, but very high HP can wrap and survive. With Crystal, each member receives a physical attack. This deliberately preserves the source arithmetic instead of replacing it with generic instant death. |
| `LABEL_1344` | If Golden Dragon's physical attack kills Myau, all party statuses are cleared (HP bytes of other members remain). |
| `BattleMenu_Talk`, `LABEL_1B17`, `LABEL_1B36` | Talk/Chat/Tele retain distinct flag and Alis attack gates; successful talk selects one of nine human or ten monster responses and ends without rewards. `talk_index` gives the chosen original list slot (human0..8, monster9..18). |
| `BattleMenu_Run`, `LABEL_1F89` | Run compares random byte strictly below run chance, then geometry. Bye/Wand/Escaper need nonzero chance and geometry but no random roll. Escaper is consumed even on failure; Wand is retained. Magic Hat and Sphere consume before their communication attempt. |
| `LABEL_5C63`, `LABEL_2950` | Chest trap chance compares inclusively, values>=240 force a trap, parity selects whole party versus one random slot (possibly dead). Even a zero trap chance consumes the initial random byte. Trap removes floor(current HP/3), preserving nonlethality. |
| `LABEL_1036`, `LABEL_1043` | Pathological entry with no living member, or all HP bytes zero, follows original victory branch; normal engine should never initiate such a battle. |

## Encounter selection and movement timing

`rpg_world_encounter` accepts original map group, native player center/feet X/Y, original metatile at source sample 0x14 (`x-8,y-16`), and vehicle mode. Only groups0..2 roll encounters. Original region is an 8×8 grid of 256×192-pixel areas. Vehicle mode divides encounter chance by four. Chance comparison is strict random `< chance`; a zero chance still consumes a random byte. Encounter pools are **one-based**; zero means none. `rpg_dungeon_encounter` reads one of 61 four-byte floor records at source03:B619; it rolls chance **before** checking that the forward cell's lower three bits are zero.

The original has no additional grace period/cooldown. `C2D2` latches movement and `C265` counts down the grid step: 16 one-pixel ticks on foot or 8 two-pixel ticks in vehicles. The map caller consumes the latch only once the step completes, after transitions. Blocked steps clear it. Dungeon `LABEL_6A58` sets the latch for **rotation as well as movement**; check once after the completed action. These helpers must not run every frame. No invented encounter timer was added to the save format.

The handoff's 223-byte `terrain_encounters` is insufficient as a lookup array: actual planet maps use metatiles224..246, and the SMS indexes adjoining enemy-record bytes. Extraction now also preserves the full 256-byte address lookup at03:85A0 and a 1504-byte address window at03:8470 for the resulting row lookup. This preserves source aliasing without assuming all bytes are an independently defined homogeneous table. For the pinned ROM, row+planet offset is bounded by93 and region columns by15, asserted during extraction. The older raw extraction is retained.

## Integration boundaries and historical limitations

- Environment-dependent items now return `BATTLE_EFFECT_FIELD_ITEM` from the kernel and are completed by the native controller/production field bridge, described below. A rules-only caller must dispatch this effect before stepping another actor; the convenience whole-round helper does not supply world context. Food, Wand, Escaper, Magic Hat and Sphere retain their existing source state effects; their observable dialogue/audio chronology is now checked against original Z80 traces, while persistent action state remains precomputed (see BATTLE_PRESENTATION.md).
- Story wrappers live in the event/controller modules and are verified separately. Core Tarzimal victory deliberately grants no EXP or chest; its wrapper hides allies/restores Noah and handles Frade Mantle. An isolated battle test is not evidence of the complete story.
- The earlier death/victory palette and ordering gaps have separate integrated fixes and evidence in BATTLE_PRESENTATION.md. A full-story playthrough remains under verification. Streamed dialogue, player per-hit effects, sound, chest disarm/search and dungeon escape retain their separate implementation/test evidence.
- RNG retains original LFSR feedback with documented GBC seeding adaptation; it cannot reproduce Z80 refresh-register timing.

## Verification

`python3 tools/verify_battle.py` compiles production C with warnings as errors and Address/UndefinedBehavior sanitizers. It writes `build/verification/battle-report.json`, including input hashes. Current suite passes **385,470 assertions**: all94 pools; all74 enemy records; every cell of all3 planet maps across vehicles/seeds against independently reconstructed SMS register arithmetic; all61 dungeon floors/cell types; exact RNG/initiative/physical/Fire/Wind/Thunder comparisons; all8 enemy behaviors; status/boss/chest edges; and1,184 complete deterministic basic-attack battle simulations.

These are source-derived host rule tests, not emulator visual tests or a completed campaign. The earlier rules milestone used7,276 bytes in battle bank18 and12,646 bytes in shared bank4; those are historical counts. Final integrated linker results remain authoritative.

## Battle controller milestone

`src/battle_view.c/.h` now supplies a native bank30 controller using the shared rules/state, original decoded dialogue and genuine initial enemy artwork loaded by bank31. `battle_view_begin(state,enemy)` returns a rules error code; `battle_view_tick(keys,pressed)` returns `RPG_ONGOING` until resolution messages and chest decisions finish, then the actual outcome. Caller must restore world/dungeon graphics when it returns. Runtime globals are exposed for emulator checks.

Implemented presentation includes five original commands, per-character selection/cancel, learned spell lists and MP costs, living target checks, paged inventory, one resolved actor at a time, source status/death/result dialogue, real damage/HP feedback, level/spell announcements, and chest open/full-inventory/discard/abandon confirmations. Dark Falz's HP remains hidden. UI labels are adapted for the 160×144 display. A bank30 string must be copied to WRAM before calling bank1 `ui_text`; the wrapper does this for every label. Visual QA caught and corrected the initial mapped-out-string error, and native tests assert expected menu font tile IDs.

`tools/verify_battle_view.py` runs222 host controller assertions with memory/UB sanitizers and builds a separate GBC probe containing the production rules, UI, dialogue and art modules. PyBoy verifies banking restoration, Run, rejected dead Heal target without MP use, physical combat victory with EXP/money, and full-inventory chest paths including protected items, cancel/retry, declined abandonment and successful replacement without duplicate money. Real screenshots are in `build/verification/battle-view/`; `report.json` records fixtures, inputs and probe ROM hash. The battle controller probe uses explicitly recorded shortened combat and reward fixtures; it is not evidence of an integrated world encounter or campaign playthrough.

Original initial scenery and battle audio are now integrated and separately verified; see `BATTLE_PRESENTATION.md` and `AUDIO_PORT.md`. Player per-hit magic/gun choreography and original stream timing are implemented with explicit native display overhead; ordinary enemy Fire/Thunder is also verified; Lassic/Dark Falz special motion is verified separately; Golden Dragon palette preparation/tint is source-verified in its dedicated phase and outcome probes. Environment-dependent item actions now use the production bridge below. Closed-chest PlayerMenu/Search/Tele/Trap and opening animation are now integrated through explicit pending-chest APIs; see `BATTLE_PRESENTATION.md`. Opened/declined status remains explicit for event object flags. Story wrappers and world/dungeon entry/return are tested by their integration suites, separately from this probe.

## Closed-chest preparation correction

`rpg_battle_prepare_chest` now ports LABEL5C63 when the closed chest first
appears, before its open question. It consumes exactly one RNG value even when
chance0 or the player later declines. Runtime `chest_visual` stores0unprepared,
3Dsafe,3Epartytrap or43single-target trap. Both battle and standalone dungeon
chest entry call it. Previously the roll lived in `rpg_claim_rewards`, so a
standalone chest bypassed trap preparation. Opening now uses the prepared
visual, with a lazy preparation fallback only for direct rules API callers.
Trap magic can set3D without a reroll. Damage and random single-party target
selection remain at opening. Added tests cover all256 chance bytes and31 seeds,
idempotent preparation, declined chests and disarmed opening. Current battle
logic total:385,469 sanitizer assertions.

## Original battle item context

The former selection rejection for Landrover, Hovercraft, IceDigger, DungeonKey, MiracleKey and Nuts has been removed from both rules and controller. At the actual initiative turn, reviewed context-dependent items emit `BATTLE_EFFECT_FIELD_ITEM`. `game_field_battle_item(item,actor)` supplies the current map, event, projection and dungeon state to `field_use_item`, using `battle_scene_type` for the actual source Interaction_Type rather than an unremapped terrain nibble. The controller streams every original emitted dialogue and sound, then resumes the battle. Flash, Flute, Compass, Alsulin, Polymaterial, Torch, Prism, Hapsby, Transfer and other no-effect items use the same original context messages. This bridge does not create field animations during combat.

The original deferred C2D8 edge is preserved: successful key use writes a request3/4; the eligible Nuts branch writes7. These requests do not mutate the door or start flight in combat. Only field-menu1BE1 reads C2D8, and it first clears it. The native field result remains observable, but the battle controller never executes its OPEN_DOOR/MYAU_FLY kind. Keys and Nuts remain in inventory. On map23 the Nuts branch rejects battle use; elsewhere eventB0/projectionFF and raw nonzero Myau status can still displayB743 while combat continues. Source status2/128 are deliberately not normalized to the alive-bit test.

Vehicle use differs from the field menu: BattleMenu_Item calls ItemAction_Use directly and bypasses PlayerMenu_Item's same-vehicle exit shortcut. Thus using an already boarded vehicle attempts boarding again. The bridge passes a temporary zero vehicle mode to the original geometry helper, commits successful source coordinate/mode writes, retains the existing mode on failure, showsB2AC thenB305/B2E3, and continues combat. It does not reload the battle background or enter a field menu. Later world restoration uses the updated position/mode.

`verify_battle_items.py` builds the production `game_field.c` bridge with the native world/rules modules. Probe SHA `59e89a9077556ea899ef915de32cde459a8cf8189362c31b57b01f00393d8621` passes2,640 fixed world contexts,112 successful boardings,660 same-vehicle cases,512 key/cell cases and64 Nuts contexts. Every case retains inventory/RNG and makes zero unexpected scene/menu calls. The source Z80 handlers execute independently for all576 deferred-item cases; original dialogue addresses and C2D8 requests match, door bytes remain unchanged, and executing1BE1 proves the request is cleared before the menu. Geometry expectations independently read the source footprint tables. These are explicit map/context fixtures, not a campaign route.

The separate controller probe SHA `7fdb9c83ef89bb28392df5bc8d89009e136a0435cb620ec82a9dedd3b21491a9` passes174 sanitizer assertions and ten native item-menu cases, verifying original line sequences, no RNG changes during text, retained inventory/door cells and combat continuation. It also reruns the existing multi-hit, stream, physical battle and chest tests. The production bridge and controller are tested separately; parent integration/campaign suites establish their combined route behavior.
