# Native RPG rules status

Current integration status (2026-11-13): candidate `b72feead6a4a0b9efe779a2a61fbce7e96bd30247e3149b0ce1793dd414d59a1` integrates these rules with battles, field actions, services, source inventory presentation, events and saving. All thirteen exact-binary integration suites pass. The complete story and independent clean-power-on replay now pass. Host assertions and declared native fixtures establish their stated cases, not complete campaign coverage.

The source-timed EQUIP/DROP and item-award component first verified on `161e252304c875aa64fc34845359dcec2362f3d6b76cb94ae1e47fd8330a0cb7` is now integrated, preserving the immediate pure-rule API. Native menus verify all four party slots, the temporary empty inventory slot through the equipment panel, original messages/waits, denial/cancel/protected edges and pickup sound boundaries. Component evidence is frozen in `build/milestones/service-inventory-order-20261113/`; combined v5 checks are in `build/milestones/full-final-services-20261113/`.

Implemented in `src/rpg.c`, compiled for GBDK 4.5.0 in ROM bank 4. Generated source tables and code share bank 4; exported operations use GBDK banked calls so callers never read mapped-out table pointers. The earlier standalone-rules milestone did not establish playable combat or UI; current integration is recorded separately from that historical scope.

The verified baseline has not been modified. Rules derive from pinned `upstream/ps1disasm/ps1.asm` and reference ROM SHA-256 `9e324e92bd833b45126861b6f1d2dcbb51251bdf3df6d563ab3a3ff784d8cf88`. Item IDs are decimal C constants representing original bytes; e.g. LaconiaPot `$38` = 56, RoadPass `$33` = 51, Secrets `$40` = 64.

## Implemented behavior and source anchors

| Behavior | Source routine | Preserved details |
| --- | --- | --- |
| Initial state | `LABEL_5E8`, `UnlockCharacter` | Alis level 1, HP 16, MP 0, Short Sword and Leather Armor, zero money/inventory. |
| Recruit mechanics | `UnlockCharacter`, `ItemUse_Alsulin`, `LABEL_4C0D`, `LABEL_516F` | Level 1, living HP/MP filled; Myau no equipment, Odin Iron Axe/Iron Armor, Noah Wood Cane/White Mantle. Story prerequisites belong to events. |
| Stat update | `UpdateCharStats` | Source level table, byte attack/defense sums, resets living member status to 1 and binding to 0; no HP/MP restoration. Dead stats are not recalculated. |
| Inventory | `Inventory_RemoveItem2`, `Inventory_AddItem`, `Inventory_FindFreeSlot` | Capacity 24; removal compacts and clears final slot; find returns slot or `RPG_NO_SLOT` (255). Add returns `RPG_FULL` without mutation so events can present source prompts. |
| Discard/replace | `ItemAction_Drop`, `LABEL_27BC..27D8` | Flag bit 2 protects both dropping and full-inventory replacement. `rpg_replace_item` exchanges in place. Prompts belong to events. |
| Equip | `ItemAction_Equip` | Flags bits 4–7 allow character, low bits choose weapon/armor/shield. Exchanges old equipment into chosen inventory slot; empty old equipment removes that slot. Dead members cannot equip. |
| Buy | `LABEL_2BDC..2C41` | Shop record byte 0 is last valid option, not count. Full inventory rejects before funds check and exits shop; no replacement prompt. Payment precedes adding normal goods. Already-owned vehicles cost money again but do not duplicate. |
| Sell | `LABEL_2CB1`, `LABEL_B03_B82F` | Authentic 64-word sell prices; zero means cannot sell. Removes chosen slot and saturates money. Prices newly extracted from SMS bank 03:$B82F, not estimated. |
| Money | `LABEL_297A` | Saturates at 65535. |
| Food | `ItemUse_Cola`, `ItemUse_Burger`, `LABEL_1E5F` | Heals 10/40 only for living targets; saturates at max HP; consumes even when already full. Dead target leaves item untouched. |
| Free rest | `LABEL_2A6D` | Fills living members only. |
| Hospital | `LABEL_2999` | Missing HP + missing MP **added in an 8-bit accumulator**, then zero-extended for fee; preserves wrap above 255. Checks living target and money, fills after paying. |
| Revival | `LABEL_2A98` | Level × 20, requires joined dead member and funds, restores status 1 and full HP/MP. |
| EXP | `AwardEXP`, `CalculateExp` | Full reward independently to each living member; at most one level per nonzero award; cap 30. **Overflow caps EXP at 65535 and returns before level check.** Zero awards never level. Gains do not heal. |
| Heal/Cure | `LABEL_1E27..1E5F`, `MPCostData`, `BattleMagicList`, `MapMagicList` | Learned spell/context checked; Heal 20/2MP, Cure 80/6MP; living caster/target; no payment on failure; Noah row mapping and Odin's lack of magic. |
| Direct physical damage | `LABEL_121D..1279`, `LABEL_1579..15C2` | Independently scale attack/defense; subtract if attack wins; even defense advantage >=16 misses; otherwise reject `random&31` above relevant level, then player r+1 or enemy floor(r/2)+1. Caller supplies attack after source boost/weak status handling. |

`status & 1` is the source living test. `joined_mask` adds explicit portable membership. Events must keep recruitment consistent with the original story.

## RNG adaptation

`rpg_random` preserves `UpdateRNGSeed` feedback: new bit is XOR of old bits 15, 13, 4, 0; shift left; replace zero with `$733C`. SMS then XORs low byte with Z80 refresh register R, which has no Game Boy equivalent. This port outputs low byte and exposes `rpg_seed_rng` for input/frame timing at startup and deterministic tests. It does not claim identical SMS random sequences or emulate Z80 instruction timing. Seed is serialized by the integration layer. Input/frame mixing belongs in the engine; this module accesses no hardware.

## Module boundaries and historical limitations

- Encounter and battle rules live in `src/battle.c` plus bank-safe table helpers and are integrated through `battle_view.c`. See `docs/BATTLE_RULES.md` for source edge cases, APIs and distinct host/native evidence.
- Secrets 64 never indexes 64-entry flags/boost arrays. `rpg_buy` returns `RPG_NOT_IMPLEMENTED` after source inventory/funds checks. The integrated service dispatcher intercepts Secrets and calls the event implementation of `LABEL_2C46`'s session counter, refusals and eventual RoadPass.
- `rpg_use_item` implements only Cola/Burger; other actions return `RPG_NOT_IMPLEMENTED` without mutation. The integrated field and battle dispatchers route other items to their source-specific handlers; this narrow helper is not an unimplemented player-facing item menu.
- Other learned battle spells, turns, statuses and reward/chest rules belong to the battle module; map-only spells and story wrappers are integrated through `field_actions.c`, `game_field.c` and events.
- Dialogue, prompts, shops UI, persistence and story prerequisites have separate integration evidence. Their absence from the original rules-only milestone is historical; full campaign and independent replay verification now pass separately.

Battle outcomes are computed before their visible playback, while presentation
replays the recorded source order without consuming extra RNG. That timing
boundary, the RNG adaptation above, and native palette/audio/cadence adaptations
are distinct from missing rule implementations.

Equip now displays sourceB2B6 and its character-stat panel/wait, retaining the
temporary empty inventory slot until staged completion. Drop displaysB2C2 or
protected-itemB6DE with the original confirmation and denial branches. The
presentation dispatcher supplies B3 only on successful inventory addition or
replacement across event/shop/chest awards; the pure-rule helper remains
silent. Source and native menu probes verify these boundaries separately from
the host rule assertions below.

## Verification

Run `python3 tools/verify_rpg.py`. It compiles production rules/tables with warnings as errors, AddressSanitizer, UndefinedBehaviorSanitizer, then exercises actual APIs. `build/verification/rpg-report.json` records input hashes and outcome.

Recorded host suite: 68,639 passing assertions covering state/recruitment, protected/full/invalid inventory, equipment swaps, third shop option, funds, vehicle duplicates, sales, money saturation, dead/full-HP targets, spell/context/MP, hospital overflow, revival, threshold/zero/overflow/one-level EXP, 65,535 RNG steps against independently expressed feedback taps, and physical-damage bounds. This is host logic validation; separate native battle-controller probe evidence is documented in `BATTLE_RULES.md`. Production rules/tables also compile with GBDK 4.5.0; integrated build checks banking/link size.
