# Original field spell and item actions

Current integration status (2026-11-13): field menus, context dispatch, original dialogue/audio and the named scene effects, including staged Torch/Nuts behavior, are integrated in candidate `2e151f71ae14996d5753791d373b6ef9f0d7a27f7f86e3cab3742c39ea19668c`. The rules-only and isolated candidate results below retain their original scope. Thirteen exact-binary integration suites and 28 travel music cases pass; complete fresh campaign and replay verification remain pending. General map/dungeon outer transitions and EQUIP/DROP presentation are separate unfinished work, not implied by field-action fixture coverage.

`field_actions.c` is native bank11 code with no static working RAM. It consumes
`FieldContext` and returns a `FieldAction`, leaving rendering and transitions to
the caller. Persistent RPG structs are unchanged.
`tools/verify_field_actions.py` passes50,726 ASan/UBSan assertions;
`build/verification/field-actions-report.json` records inputs and exact scope.
These are rules tests; field menu/scene integration has separate native evidence.

## Context and presentation contract

The caller supplies the real source `Interaction_Type` (0 dungeon, nonzero map
or interaction), event ID, mapID/group, battle flag, C2DC projection state, vehicle
state, and pointers to the shared party/events and current dungeon. An active
closed chest additionally supplies its `RPGBattle` pointer. Passing a dungeon
pointer does not override source Interaction_Type checks. Do not substitute the
last unrelated event for the actual current interaction event ID.

Call `field_cast(context,caster,spell,target,result)` or
`field_use_item(context,inventory_slot,target,result)`. Target255 means the
original target-selection cancel. Result mutations are committed during the
call; the resulting dialogue cannot cancel the already selected action.
Torch is explicitly staged: its inventory changes occur at the original
post-effect and post-close boundaries described below.
Play `sound_start`, then each of up to3 lines' `sound_before`, original dialogue
ID, and `sound_after`, followed by `sound_end`, ignoring zero sound IDs. Use
result.item/character for dialogue substitutions. Then apply result.kind:

- DONE: return to the original menu/context.
- REDRAW: dungeon cell or light changed; refresh the existing scene.
- EXIT_DUNGEON: return to the source saved map entrance, not an invented nearest exit.
- TRANSFER: source last-church destination: target=mapID,a=packedY,b=X. Clear vehicle state as original LABEL1C15 does.
- OPEN_DOOR: outside battle the ahead cell is already marked open; target=cell index,a=source opening type3(key) or4(magic). During battle key use only emits the original deferred request; its cell remains unchanged, and the caller must not perform the field action.
- CHEST_OPEN: Trap has set the existing prepared visual to3D and removed its trap; execute the existing chest open/reward/flag pipeline.
- CHEST_PROMPT: return to the existing chest open question after Tele/Sphere.
- PRISM: projection becomesFF; perform source reveal scene. No map teleport is invented.
- MYAU_FLY: source transformation/travel/battle scene must run; Nuts are not consumed by this item handler.
- TORCH_SCENE: after B458, perform the original tree palette update (LABEL_7CA6, not Alsulin's LABEL_7C85), then call `field_torch_reply`; after its reply and six close VBlanks, call `field_torch_finish` and play its conditional `sound_end`.
- STORY_ITEM: call `event_use_story_item` with target=inventory slot (Alsulin/Polymaterial).
- VEHICLE: pass target=inventory slot to the separately verified map geometry/controller.
- UNIMPLEMENTED: battle-only Hat/Sphere/Wand/Escaper routes belong to the battle controller; no field substitute is performed.

Scene output kinds are explicit integration requests, not implementations of
animation/travel/story wrappers. Only legal last_church indices0–8 are accepted;
a corrupt external context is rejected without reading past the destination table.

## Source rules preserved

Map spell learned lists and costs come from the extracted original RPG tables.
Dead casters, unavailable spells and insufficientMP have original messages.
Heal/Cure cancel or a dead target spends noMP; healing a full living target still
spendsMP. Other spells spendMP before context checks. Rise spends12MP even when
the player cancels target selection or picks a living member; dead targets get
status1 and maximumHP/MP, preserving the original untouched binding byte.

Trap and Tele use LABEL684A's unusual rule: an ahead cell08 is a pit only when
no original object record matches its floor/position. A listed chest/object is
not a pit, even when its persistent flag isFF. All61*256 floor/cell combinations
are checked independently against the extracted original records. Trap clears
an unregistered08cell to0. Tele reports it without mutation. For active chests,
Trap disarms the prepared visual and proceeds directly to opening; Tele merely
reports and returns to the open prompt. Neither rerolls a prepared chest.

DungeonKey opens unopened low-type5 doors. MiracleKey opens5 or6. Open magic
opens only6, after spending4MP. Opened high-bit cells do not open again. Keys
are reusable. Battle key use preserves the original deferredC2D8 request and does not immediately mark/open the cell; see BATTLE_RULES.md.

Flash is consumed only outside battle in an unlit dungeon and refreshes the
original floor lighting/palette. Flute is reusable, playsC2 thenD5, and exits a
dungeon outside battle. Transfer is consumed only outside battle with nonzero
Interaction_Type. Fly has the same source church destination; dungeon failure
still costs8MP. Exit outside a dungeon costs4MP and reports no effect.

MagicHat and Sphere are consumed even when ineffective outside battle. Sphere
uses Tele detection without its initialAC spell sound. Food is consumed even at
fullHP, never for a dead target or cancelled target. Compass shows the exact
four original direction messages only in a dungeon outside battle.

EclipseTorch requires eventAF and a LaconiaPot. On success it consumes the Torch,
keeps the Pot, and grants Nuts only if absent. Without the Pot it leaves the
Torch; the original tree scene still runs. The original order is B458, palette
effect with one VBlank, Pot lookup, selected Torch removal, B471/B49A, six close
VBlanks, then Nuts insertion and B3 only if Nuts were absent. Native candidate
5d8fa587 preserves those inventory/audio boundaries with no added working RAM.
Ten original-Z80 cases and eight actual native menu cases include missing Pot,
existing Nuts, a selected duplicate Torch and full inventory. Evidence is
preserved in `milestones/torch-order-20261113`; this candidate is separate from
the current development ROM. The native five-row window hides at once before
the six close waits; the SMS restores six half-glyph rows progressively.
AeroPrism requires eventB0, outside
battle and projection!=FF. Nuts gates on raw nonzero Myau status, not bit0 alone:
on map23 they require nonzero Interaction_Type and no battle; elsewhere eventB0
plus projectionFF can take the original branch even with the battle flag set.
The item handler does not consume Nuts. Outside battle these branches emit source scene actions. During battle the emitted MYAU_FLY kind is only the original deferredC2D8 request; the battle bridge displays its text and ignores the request, which1BE1 clears on field-menu entry. No generic flying or teleport behavior is invented.

## Native probe

`tools/verify_field_emulator.py` additionally builds a separate GBC ROM and
checks six explicit fixtures on PyBoy: Rise cancellation, reusable MiracleKey,
Flash, an unregistered pit, prepared-chest Trap and church Transfer. Every call
restores bank1 after field11→RPG4/dungeon17/data16/battle18 calls. Evidence is
`build/verification/field/report.json`. These fixtures create a level30 party
and selected inventory/cells in the probe; they are not campaign progress.
