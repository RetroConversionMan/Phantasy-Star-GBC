# Dialogue and event implementation status

The current development ROM integrates dialogue decoding and native dispatch for all 182 original event IDs with the battle, dungeon, scene, travel, ending and game-over systems. Invalid IDs return `EVENT_UNIMPLEMENTED`; this is a guarded error path. The full unchanged-ROM campaign and an independent clean-power-on replay now pass through the ending and settled title. Current evidence is indexed in `../PROJECT_STATE.json`, including `../build/verification/vehicle-reload-fix-integrations/report.json`; earlier release-v2 reports remain historical evidence.

The sections below retain the implementation history and source-specific rules. Statements about work remaining at an earlier milestone describe that milestone; later integrated verification supersedes those limits. In particular, gradual text, original road/ship sequences, interaction scenes, full ending and runtime dispatch are now integrated.

## Extraction and text

`tools/extract_dialogue.py` verifies the exact reference ROM SHA-256, reconstructs the contiguous bank2 pointer/text/dictionary directives and text directives in bank12, and compares 19,916 bytes with the ROM. It generates all 341 bank2 story references and170 bank12 service/battle/item text references, plus23 direct bank2 narrative records (534 total). Dictionary tokens expand to original bytes; source controls and dynamic substitutions remain explicit. Fall-through text is decoded until the actual terminator, not the next label. The expanded 29,200 bytes occupy GBC banks9 and10; references, item names and the reader occupy bank8.

`dialogue_open` accepts the original even bank2 index or a bank12 CPU address. `dialogue_next_page` renders the original 18-character width and two-line scrolling state into `DialogueCursor.lines`. Apostrophe byte40 becomes ASCII apostrophe. Current character, enemy, item and number substitutions use caller-provided cursor values. Terminators62/63/64/65 remain distinguishable in the cursor. Source terminator timing is implemented and separately tested: normal63 waits30 frames with action-button skip,64 waits208 frames, and65 waits for input; narrative63 waits208 frames. The frozen4f4 campaign probe displays each page at once. That historical probe does not establish character-by-character reveal. The source reveal is now integrated and source/native-verified in the gradual-text section below and the current dialogue/story integration suites. Original interaction backgrounds and portraits now have a separately verified native renderer; integration status is tracked in docs/SCENES.md. Recruitment narratives use their original four-line reader and large portraits; docs/CUTSCENES.md records the separate presentation evidence.

## Native handlers

The original event dispatch at `LABEL_4773` contains182 entries.111 exact two-instruction `ld hl,dialogue; jp ShowDialogue_B2` handlers are generated directly from assembly.71 additional IDs now have native branches or explicit runtime requests, for182 dispatched IDs total. Initial native branches included:

- 1: Suelo introduction flagC501, repeated resting text, living-member healing after dialogue.
- 2: Nekise introduction, Laconian Pot addition, C502 set only if the pot is actually present after the attempt.
- 8: yes/no response and numeric substitution3.
- 11/12: Roadpass guards; C2E9 index comes from original map context C309, **not facing**.
- 19/20/26: Passport guards. C504>=7 confiscates Passport after019E and then shows01A0. Earlier state prompts for Passport and grants the original road/direct-map transition.
- 27/28: additional Roadpass road transitions4/5.
- 29: Passport questionnaire, disqualifying answers, missing-money message, cost100 charged before attempted addition, no duplicate Passport if already held.
- 30/31: party-size conditional dialogue.
- 43/67: source yes/no dialogue branches.
- 54: Myau exchange. The first offer's yes answer only shows0094; declining then accepting the Laconian Pot exchange removes the pot, shows009A, recruits Myau and adds Alsulin.
- 57: rest followed by00B8.
- 60/61: Cola gift prompts, remove one Cola only on accepted possession, and distinct response texts.

Bank7 event code calls bank4 RPG rules through banked calls and uses the same `RPGState`. C500..C5FF are stored as `flags[256]`. No second party/inventory exists. `map_id` retains sourceC309; caller supplies packed_y/sourceC305 for event26. `EVENT_TRANSITION.target` is originalC2E9 road index. The runtime now connects this request to the original road walking cinematic through `game_sequence`/`TRAVEL_ROAD`, including living-party following; TRAVEL.md records source and native route evidence.

`event_buy_secret` handles Scion shop8 option2 through the original `LABEL_2C46` logic. `secrets_requests` corresponds toC2EC and must persist across visits and saves. Capacity and funds checks happen even before a refusal. The first two eligible requests show0142/0144 without charging. The third resets the counter, charges200 and adds Roadpass; already owning Roadpass restarts the refusal sequence without a charge or duplicate.

## Full inventory

Event item awards implement `Inventory_AddItem`'s two questions: B671 asks to discard; declining asks B6C1 to leave the offered item. Declining the second question opens replacement selection. Canceling selection returns to the first question. Protected items showB6DE and re-open selection. Successful selection first shows the old item discarded, then overwrites that exact slot, preserves count/order, and shows the new item obtained. Failed Nekise addition cannot lose the progression opportunity. Shop purchases use the different source rule: full inventory exits without replacement.

## Verification and remaining work

`tools/verify_events.py` compiles with Clang address/undefined-behavior sanitizers. It exercises3,165 assertions and renders all534 records/1,012 regular two-line pages. Fixtures cover living-only rest, Nekise repeat/full/protected/cancel/preexisting-pot cases, gates, confiscation, questionnaire failures and payment ordering, Myau exchange, and Secrets repeat/capacity/funds/duplicate behavior. It confirms the original `TODIE` byte sequence wraps into `TO` / `DIE` at the original width. These are host logic tests, not a campaign playthrough. `tools/verify_expansion.py` separately walks actual controller-input routes to Suelo and Nekise, verifies the Pot/flags and repeat visits, opens status/inventory, power-cycles a saved game, and walks the original Camineet exit to Palma at(1368,736). The single injected fixture damages Alis HP to1 solely to verify Suelo recovery; it is clearly labeled and is not a battle test. Real screenshots and the tested ROM hash are in `build/verification/expansion/`. The native test caught a GBDK4.5.0 incorrect pointer load in the register-argument inventory lookup helper; using the banked stack ABI fixed it, and the native Nekise award/flag checks passed.

The added branch suite covers Luveno's trust/assistant/payment/construction/Hapsby progression, Noah's Letter recruitment, rumor/search flags, Gas Shield/Cake/Torch trades, the Crystal questionnaire, and item handlers for Alsulin/Odin and Polymaterial/Hapsby. `object_flags[256]` shares originalC600..C6FF with the dungeon kernel; new game initializes entries0 and4 toFF. Event42 enables the Dungeon Key object only if the key is absent. Search preserves the original early Flute-discovery flag write even when a full-inventory award is subsequently abandoned.

`event_use_story_item` requires the actual current interaction context. Myau alone cannot open Alsulin/Polymaterial bottles: the original test ORs Alis/Odin/Noah status bytes. Successful Alsulin use at eventA3 consumes it, recruits Odin with Iron Axe/Iron Armor, clearsC600 and setsC50A=FF. Polymaterial atA1 consumes the item and awards Hapsby, with the original already-owned branch retained.

`event_battle_result` resumes explicit battle actions. DrMad's optional Myau sacrifice occurs after the death text; his Laconian Pot override targetsC518. Chest flags write only when the battle UI reports an actually opened chest, including a subsequently abandoned item. Tarzimal hides the other three party status bytes and restores them afterward; defeated Noah regains his pre-duel HP/status. Governor's nightmare preserves the original three status bytes and later restores living members. Shadow/Lassic progression writes occur after a non-gameover battle return. Deterministic callback tests exercise these branches; they are not simulated campaign victories.

The travel workflow preserves originalC2E9 values81..88, including same-destination dialogue and cancellation. `EVENT_SCENE`, `EVENT_DUNGEON`, `EVENT_DUNGEON_BACK`, `EVENT_TRAVEL`, `EVENT_ENDING` and `EVENT_GAME_OVER` are explicit runtime requests. Event166 emits EVENT_DUNGEON_CELL for sourceCBC3 before its dialogue; the dungeon caller applies that current-floor mutation. Rendering/audio, full campaign integration and start-to-ending validation are not established by the event tests.

The earlier host milestone recorded3,165 dialogue/core-event assertions,76 additional story/item/search assertions and291 battle/scene/travel orchestration assertions. The current canonical core-event suite passes3,168 assertions, adding explicit C1-before-heal Suelo staging; its source and output are frozen in `../milestones/canonical-promotion-v4-20261113/`. The latter explicitly inject battle outcomes to test event resumptions; the battle engine has its own tests.

## Gradual text output (integrated milestone d1341b)

`dialogue_stream_next` emits one original character per VBlank and preserves the
original eight-frame two-line scroll interval. The older batch readers remain
available for reference tests. Native glyphs are8px high, so the original SMS
half-glyph scroll pictures are represented by one row shift with the same total
delay. Typing and scrolling freeze the input latch, as source WaitForVInt0A does
not read the controller. Terminator waits start only after the final glyph.

`verify_dialogue_stream.py` executes the original Z80 interpreter and compares
all534 records,27,730 glyph/frame positions and34,234 glyph/scroll frames, plus
numeric boundaries. The native banked probe checks those same records and
1,088,712 visible window cells; representative free-running dialogue and
narrative segments preserve every glyph; banked newline/panel work can add
measured display frames. A post-draw LCD clock gate prevents multiple glyphs
from being emitted in one physical frame. This fixes
record01E2, whose first of three lines was lost by the old instantaneous batch
display. The separate production-main input test passes actual Suelo typing,
release/hold edge cases, and both-button Yes/No confirmation without fixtures.
All focused story scenes through the full ending also pass on milestone d1341b.

The new source also corrects general Yes/No confirmation: both A and B confirm
the highlighted choice, matching ShowYesNoPrompt→CheckOptionSelect. Older
preserved development cartridges used B as a No shortcut. The native horizontal
layout accepts Left/Right in addition to the original Up/Down selection.
