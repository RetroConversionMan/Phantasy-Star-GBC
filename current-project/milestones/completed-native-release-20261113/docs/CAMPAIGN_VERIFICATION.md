# Controller campaign evidence

The complete original story and its independent clean-power-on replay pass on unchanged native GBC ROM `b72feead6a4a0b9efe779a2a61fbce7e96bd30247e3149b0ce1793dd414d59a1`. Dark Falz is defeated, the full ending/credits finish, and the game returns to a settled title. Final independent acceptance is `../build/verification/release-v5-final-independent-audit/report.json`; release evidence is indexed in PROJECT_STATE.json.

## Completed release v5

- Story: `../build/campaign/release-v5-newgame-b72feead/` — all51 phases,3,581,580 frames,484 checkpoints and a separate final settled-title snapshot.
- Independent replay: `../build/campaign/release-v5-live-replay-b72feead/replay-report.json` — all484 checkpoints and every expected gameplay field, final state,144,464 controller rows/11,721,245 bytes, and freshly generated8 KiB SRAM match.
- Both runs begin from clean power-on with no initial SRAM/emulator-state import or gameplay-memory injection. The campaign's first352 checkpoints were themselves freshly replayed on v5 before continuation; exact current-state resumption is recorded and is independently verified by the complete forward replay.
- One natural full-party defeat is retained, followed by an actual native Continue. A separate driver assertion when zero-MP Fly correctly failed is retained; the run resumed its exact stopped state and used the earned Hovercraft. No earlier-state retry or seed search occurred.
- The1,230 encounter annotations comprise501 inherited v4-prefix annotations and729 fresh continuation annotations. PREFIX_METADATA_PROVENANCE.json distinguishes these annotations from the freshly executed v5 input sequence and checkpoint snapshots; the prefix replay did not independently re-instrument every battle.
- Separate power-on title comparisons use only each completed run's own earned cartridge SRAM. Both compare all23,040 pixels with zero differences. Replayed SRAM is byte-identical to the original earned8 KiB.
- `CAMPAIGN_CLOSED.json` pins the final source report, controller log, ROM, symbols and SRAM after process close. The source443-file and replay22-file manifests are frozen. The replay's final `replay-report.json` and milestone ACCEPTANCE.json are authoritative; its progress.json completion field is deliberately not final acceptance evidence.

The full replay began after the source campaign closed. The follower's partial-publication and mutation checks were tested separately; no claim of simultaneous gameplay/replay is made for this completed run. The frozen reproduction command is in `../build/campaign/release-v5-live-replay-b72feead/REPRODUCE.txt`.

Hardware testing and a complete subjective soundtrack review remain unverified. This evidence establishes native emulator gameplay and declared state/visual/save comparisons, not physical hardware or exact SMS display/timbre identity.

## Preserved earlier campaign evidence

The following original4f4 campaign notes and named continuations are historical. Their in-progress statements, probe ROMs and narrower limits describe those earlier milestones and do not replace the v5 proof above.

The campaign is in progress. This is not a complete-game verification claim.

The campaign began at New Game on the frozen 4 MiB integration probe with SHA256
`4f4a7b6dce593f9e799a6fd4afadd3c927b6a6a182b1b642f664c630e8c0a9e2`.
The unchanged tested ROM and symbols are in `build/campaign/attempt01/campaign.gbc`
and `campaign.noi`. That probe contains a deliberately non-finishing credits
stub and batch-rendered dialogue. Later presentation improvements and the final
credits require verification on their actual integrated ROM; this campaign
cannot establish their correctness.

`tools/campaign_runner.py` reads native state for navigation, decisions and
assertions. It never writes emulator memory. All story flags, inventory, money,
statistics, healing, equipment, battles and actual SRAM saves change through
controller input. The runner keeps natural RNG state; it does not search RNG
seeds or force outcomes. `controller.jsonl` records every button edge and its
emulator frame. Checkpoints contain native SRAM saves, emulator state, a state
summary and screenshot. Pausing/resuming a checkpoint resumes that exact point;
it does not undo an unsuccessful battle.

The run includes three ordinary game overs: the early Scion return and two
Aukba encounter sequences. Each used the game's actual Continue command from
the last native save, and retained the failed route and input in the report. Myau's later individual defeats are retained as well;
Suelo only heals living characters, so the runner paid the original church
revival fees. The governor's Saccubus defeat is a separately identified story
sequence followed by the original recovery, not an ordinary game over.

Verified progression currently includes the opening, Suelo and Nekise, earned
funds, Leather Shield, the third Scion Secrets purchase, Roadpass and Passport,
the original ships and roads, Myau, Odin, Compass, Eppi's Key rumor, Dungeon Key,
the reachable Camineet warehouse treasure, Titanium Sword, Naula's Cake,
Thick Fur for Myau, the palace guard, the governor's Letter/nightmare, Noah's
recruitment, the Magic Lamp, Noah's original spaceport passage, Luveno and his
assistant, the1200Meseta construction sequence, Polymaterial/Hapsby, the
completed ship, Uzo's Flute rumor and Gothic SEARCH reward, and Casba's
Hovercraft rumor and Bortevo SEARCH reward. Later controller checkpoints include
the fixed Blue Dragon and Amber Eye, original four-cave Dezoris route and Corona
Tower exchange for the Eclipse Torch, earned12,000Meseta Ice Digger purchase,
Laconia Armor23 and Laconia Shield32 chests, actual equipment/church recovery,
and Skure's1200Meseta Wand4 purchase.
`report.json` and the numbered checkpoints are authoritative for subsequent
progress, party status, remaining inventory, and any stopped harness operation.

The original shared dungeon floors contain disconnected regions. The route
planner therefore establishes reachability rather than treating a shared floor
ID as one continuous dungeon. Cake is reached from Palma `(99,10)` into
floor19/13 west, followed by three original stairs to floor16/64 east. The other
floor19 entrance at Palma `(119,55)` does not reach the Cake seller. The
Camineet section of floor2 likewise cannot reach the separate Abion treasure
rooms. These corrections changed navigation; they did not change native game
logic or move the party directly.

`tools/verify_campaign_routes.py` compares thirteen planned routes against the
compiled native dungeon kernel, covering842commands, ordinary and Key doors,
two-cell stairs, and the exact Cake and Noah room records. This host geometry
test is separate from campaign progress. The armor route additionally uses a
clearly labeled host fixture for Myau Trap's source floor mutation; the campaign
executes the actual spell and spends its MP through the normal UI.

`tools/replay_campaign.py` independently replays the controller log from a clean
power-on, using no SRAM fixtures and loading no emulator states. The immutable
`through-odin.controller.jsonl`, `through-odin.report.json`, and
`through-odin.replay-report.json` preserve the first replay milestone: all 47
checkpoints through Odin matched their recorded positions, party, money, items,
story flags and RNG over 172,769 frames. The subsequent immutable `build/campaign/milestones/noah` replay also passed:
122 checkpoints and 408,489 frames through all four recruitments, including the
new dungeon and object-flag snapshots. Later checkpoints still require their
own replay milestone.

To continue, use the immutable campaign ROM and the latest appropriate state:

```sh
../../.venv-transfer/bin/python tools/campaign_runner.py \
  build/campaign/attempt01/campaign.gbc \
  --phase noah \
  --resume build/campaign/attempt01/118-24-governor-letter.state
```

The immutable `build/campaign/milestones/luveno-ship` clean-power-on replay
also passed:278checkpoints and878,380frames, with no SRAM fixtures or emulator
state loads. Its controller-log SHA256 is
`09d5920500a3dd8d721d4b365fa9b3a9e87845bf781be4e2d6c70451f865b46e`.

The runner rejects ROM hash mismatches. Harness navigation/selector failures are
recorded separately from progression and can be resumed at the exact failure
state after correcting the controller logic. Existing working ROMs and the
verified baseline are never modified by this workflow.

The armor milestone is frozen in `build/campaign/milestones/ice-digger-laconia-armor`:
350 checkpoints through1,544,763frames. Its independent clean-power-on replay
was started separately; `replay-report.json`, when present with `passed:true`,
is the verification result. Controller log SHA256:
`2f30c6a7aa88a8c3d180a4b27d96fda90976dfddfe6616c35f51c2eb37d83cd3`.

Checkpoint names351–353 contain the mistaken human label “diamond-shield”; the
asserted and acquired item is32, the original **Laconia Shield**. Source IDs,
native inventory and equipment bytes are authoritative. Likewise the reusable
funding phase retains an `ice-digger-funds` label when later invoked to earn
Wand money; it neither buys nor grants an extra Ice Digger. Historic labels are
retained to keep the immutable controller log intact.

The frozen4f4ROM exposed a SELL compiler defect. Its real ShortSword sale
price/prompt and failed confirmation are preserved in `sale-debug.state/json`,
`sale-price.png`, `sale-result.png`, and the input log. The current production
branch fixed it with a materialized RPGState pointer and separately verified
6,048native cases plus actual shop confirmation/cancellation. The campaign
stays on its frozen ROM and discards only deliberately obsolete equipment and
Flash using the actual Drop menu; it receives no money for those discards.

Earlier `report.json` battle records can encompass successive encounters while
the native battle screen remains active. The runner now detects outcome reset
and records chained encounters separately. Historical record counts therefore
must not be described as an exact number of distinct battles. Repeated input,
normal declines, failed equip attempts on dead/ineligible characters and
controller-harness corrections remain in the replay trace.


The continuous controller run subsequently earned the Laconia Pot from Dr.Mad,
Laerma Nuts using the original Torch/tree interaction, and the Aero-Prism from
Titan. It bought and equipped Myau's Gloves and Odin's Laser Gun, crossed the
original Hovercraft route to Tarzimal, and won the Noah-only duel for the Frade
Mantle. The immutable `build/campaign/milestones/prism-tarzimal` log was replayed
from clean power-on with no SRAM fixture/state load: **389 checkpoints and
1,946,043 frames matched**, including party, inventory, flags, position and RNG.
Its controller log SHA256 is
`92667fee96dfb2b564515881e909fda36b2f48b6ddac28c972a0ea65744980da`.

Further earned progress through checkpoint406/frame2,075,425 includes Drasgow's
1000Meseta Gas Shield, Sopia's400Meseta Mirror Shield information and the exact
Motavia SEARCH location, the original Baya prison/tower route and Crystal sage's
YYYNN answers, the Laconia Sword island/Red Dragon reward, and Loar's1620Meseta
Silver Fang. At406 the party is rested in Camineet with eight Burgers. All these
steps remain in the same frozen4f4 controller log; they have not yet received a
separate clean-power-on replay snapshot. The full campaign remains unfinished.
The old checkpoint labels and original failed commands remain unchanged.


The original Miracle Key chestC631 was earned at408. The first Golden Dragon
attempt then caused the fourth ordinary game over: the climb had depleted all
eight Burgers and the party entered at HP38/53/14/2. Checkpoint409's historic
`prepared` label records a bad controller readiness decision, not a verified
safe preparation. The defeat and subsequent real Continue are retained. The
runner returned using the Flute/Fly, rested and bought fresh food. On the second
ascent it escaped ordinary encounters with the actual retained Wand, healed
before the boss, and won Golden Dragon70 with Myau's Help, Alis's Laconia Sword,
Noah's Fire and Odin's Laser. Checkpoint414 records the flying-castle arrival.

Shadow62 and Lassic72 were then defeated with all four party members surviving.
Checkpoint419/frame2,234,181 has C517=FF and C516=1. The immutable milestone is
`build/campaign/milestones/lassic`; its controller log SHA256 is
`6982c98deb08eb32b3aae8795e2e7f13e68068afa7ab262ef9cf244e07ec9a42`.
A separate clean-power-on replay is running; only its eventual
`replay-report.json` with `passed:true` establishes the replay result.

Route auditing uncovered an actual final-story entry defect: the source
Governor handler writes22E6 and calls661C, which decrements the dungeon index
before loading. Therefore the destination is floor33/E6/north, not floor34/E6.
The frozen campaign ROM and then-current production event handler emitted34
directly, a wall with no source route. The integration work owns the correction
and original fall presentation. The controller campaign will not bypass this
by patching its position. From the correct33/E6 entry, the source route is158
commands with required unrecorded pitfalls33/1A→32/1A and32/79→31/79. These,
Miracle Key and castle routes pass the compiled native geometry check in
`verify_campaign_routes.py` (25 routes,2,297 commands); that host fixture test
is separate from real controller progress.
