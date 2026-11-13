# Source-derived campaign route plan

Current verification scope (2026-11-13): this remains the source-derived route plan, not evidence by itself. All51 phases have now completed on unchanged release v5, followed by an independent clean-power-on replay of all3,581,580 recorded frames and484 checkpoints. CAMPAIGN_VERIFICATION.md and PROJECT_STATE.json identify the proof. Progress notes below preserve earlier runs, including the failed v2-to-v3 timing probe and the held v4 prefix; they are historical.

This is a plan for an actual controller playthrough, not completed campaign
evidence. It uses the pinned original ROM and native source ports; no external
walkthrough is needed. `tools/extract_campaign_index.py` produces
`build/research/campaign-index.json`: original trigger cells, incoming map
positions, dungeon objects/transitions, shops and raw enemy records.

World coordinates below are zero-based metatile `(x,y)`. Native player position
is `(16*x+8,16*y+16)` with world wrapping. Dungeon positions are hexadecimal
packed YX; floor IDs, event IDs and item IDs are decimal unless prefixed0x.
Directions0/1/2/3 mean north/east/south/west.

Shared world groups contain multiple towns. A raw table entry is not proof of
reachability from every map ID. The index separately records potential trigger
cells and ordinary incoming connected regions. Vehicle/terrain restrictions,
combat and story prerequisites still apply. Dungeon paths must use the native
kernel, including current-cell pitfalls, two-cell stair/door moves and callbacks
before the second fake-wall step.

## Main progression order

| Step | Original target and interaction | Required result / edge cases |
|---|---|---|
|1|Camineet map4, Nekise event2, cells(85,16)/(86,16)|Get Laconia Pot56. C502 is set only if actually obtained; leave capacity. Suelo event1 provides living-only rest.|
|2|Scion map13, tool shop8 at(86,76)/(87,76)|Select Secrets option2 three times with200 Meseta and a free slot. First two requests only incrementC2EC; third charges200 and gives Roadpass51. Buying another item is unnecessary.|
|3|Roadpass gates event11/12 in map4 at(82,24)/(82,26)|Original C309-derived road route enters spaceport map5. Do not substitute a generic teleport for this check.|
|4|Spaceport map5 event29, cells(38,23)/(39,23)|Passport questions: YES, NO, NO, YES. Pay100 before Passport52 addition; full inventory can lose the payment.|
|5|Spaceport gate26 at(21,24)/(22,24), then ordinary boarding179|Present Passport; take original81 route to Motavia/Paseo. Keep Roadpass/Passport until Luveno ship state7; later guards confiscate Passport.|
|6|Paseo map14 event54, cells(27,28)/(28,28)|First price offer:NO. Pot exchange:YES. Pot removed; Myau recruited; Alsulin43 awarded; five narrative records.|
|7|Palma map0 cave entrance(77,64)→floor0/DC/north; Odin objectfloor0/E3|Approach fromE2 facingeast. Use Alsulin with a non-Myau party member having nonzero status. Consume43, recruit Odin, C50A=FF, unlock Compass chestC600,111-frame revival and five narrative records.|
|8|Compass chestfloor0/36, flagC600|Get Compass53 after Odin. It prevents the original lost-woods rejection.|
|9|Event42 map8 at(71,15)/(72,15), then warehousefloor2/17|AnswerYES to enable C604 when Dungeon Key45 absent. Warehouse entrance in Camineet map4 at(108,15)/(109,15)→floor2/5E/north. Get key45; source newgame initially hides this chest.|
|10|Cake seller event124 in floor16 room65|Pay280 with a free inventory slot to obtain Cake54. Original Naula route enters floor19 from Palma(99,10)→13/west; navigate stairs down to16. The other floor19 entrance at(119,55)→DE/north belongs to a disconnected shared region and cannot reach the Cake seller.|
|11|Paseo palace entrances map14(29,19)→floor33/61/south or(33,26)→33/D4/north; guardobject33/94|Event155:YES with Cake. Consume Cake, set C511=FF; rejection retreats. Reach governor in map14(31,15)/(32,15).|
|12|Governor event55 before Lassic flagC516|Obtain Letter55, then original dream Saccubus74 battle and recovery. The nightmare defeat is not normal game over; party status snapshots are restored and living members rest.|
|13|Motavia map1 entrance(54,9)/(55,9)→floor30/69/east; Noah roomfloor29/78|Open ordinary room door, show Letter. Consume55, C506=1, recruit Noah and two narrative records. A valid adjacent approach is29/68 facing south.|
|14|Luveno room event129 floor1/79; Palma entrance(51,80)/(51,81)→1/D2/north|Two initial visits increment C503 to2; third visit gives agreement prompt. YES setsC504=1.|
|15|Assistant event127 roomfloor0/5C; Gothic entrance map7(44,15)/(45,15)→0/2E/south|WithC504=1, assistant setsC504=2. Return to Gothic Luveno event62 at(37,20)/(38,20).|
|16|Luveno event62 construction|Pay1200 withC504=2→3; two further visits advance3→4→5; next advances5→6. Hapsby possession then allows6→7. Preserve exact repeated-visit state.|
|17|Abion map10 tool/food shop19 at(37,66)/(38,66)|Buy Polymaterial44 for1600.|
|18|Bortevo map11 debris event161 at(73,54)/(74,54)|Use Polymaterial. A non-Myau party member must have nonzero status. Consume44; obtain Hapsby50. Return to Luveno to complete C504=7.|
|19|Gothic ship event181 at(17,28)/(18,28)/(17,29)/(18,29)|Use exact source destination prompts/routes83–88. Other ship points:map15(89,23)/(90,23) andmap19(28,19)/(29,19). Same destination only speaks; cancellation changes nothing.|
|20|Casba rumor event85, map17(69,56)/(70,56)|YES setsC508=1. With Hapsby, SEARCH Bortevo debris event162 at(67,57)/(68,57) to obtain Hovercraft34.|
|21|Motavia cave entrance(42,71)/(43,71)→floor36/D9/north; Blue Dragon69 atfloor37/1D|Actual fixed battle awards Amber Eye58 via objectC6CE. Opening the reward chest marksFF, even if an item is later abandoned. Keep capacity.|
|22|Corona tower event156, floor46 room3D|YES with Amber Eye consumes58 and gives Eclipse Torch47. Dezoris entry(52,10)/(53,10)/(52,11)/(53,11)→floor43/D1/north; navigate to46.|
|23|Recover a Laconia Pot through DrMad event22 atfloor21/C8|Decline Myau sacrifice; win DrMad71 and open his overridden reward chest to obtain Pot56 if absent. C518 marks actual opened chest. Entry options include map10(30,58)→21/D8/north and map12(34,27)→21/D1/north.|
|24|Dezoris Laerma tree event175, map2 cell(5,4)|Use Eclipse Torch with Pot. Torch consumed, Nuts49 obtained; one-frame original tree palette change. Without Pot the Torch is retained and no Nuts are obtained. The original reachable terrain route requires Ice Digger35; the controller campaign verified that traversal.|
|25|Dezoris entrance(70,83)/(71,83)→floor58/DD/north; Titan66 at58/79|Fixed battle reward AeroPrism48, objectC6D8. Open/accept the chest.|
|26|Baya Malay crystal sage event142, floor15 roomC5|Five answers:YES,YES,YES,NO,NO. Get Crystal60. It is essential protection against Lassic's source-specific party attack; do not replace that attack with generic damage.|
|27|Baya Malay summit event176, floor15 transition1D|Source entrance is FE; adjacent valid position1C/east. Use AeroPrism first, yielding transient projectionFF and320-frame castle reveal. Then use Nuts with Myau having nonzero status. Leaving/re-entering requires revealing again; projection is not an invented permanent story flag.|
|28|Original Myau flight|Two Laerma narrative records,507-frame outbound flight, Gold Dragon70 battle. Any non-gameover battle return proceeds to map23 at(504,528) pixels. Map23 Nuts use returns via571-frame flight to Palma(1224,784), without repeating Laerma narrative.|
|29|Flying castle map23 entrance(31,17)/(32,17)→floor57/D6/north|Shadow event158/objectfloor53/C2: win, C517=FF. Lassic event159/room57/CB: either answer fights Lassic72; non-gameover return writesC516=1. Retain Crystal.|
|30|Return to governor event55 withC516 nonzero|Dialogue02A6 stages34/E6/north, then original661C falls to33/E6/north. The decrement and outgoing-room fall presentation are required.|
|31|Dark Falz event171, special FC doorfloor31/CE|Use Miracle Key/Open on the magic door; valid approach31/DE/north. Win actual Dark Falz73 battle. If Alis is down, original Nero-voice text precedes final governor scene.|
|32|Final governor choice/event172|Both answers lead to their distinct text then the same source ending:sky, six timed text records, six narrative records, party bitmap and scripted dungeon credits back to title.|

Source route details now established by controller traversal:

- After Noah, Palma spaceport `(18,32)` activates the original special passage
  into floor0/DE north. Traverse to2E north to exit in Gothic; the eastern Palma
  region does not directly connect to Luveno's prison. Gothic's east exit is
  `(47,23)`, reaching western Palma `(56,55)`.
- Western Palma to Bortevo crosses passable lava metatiles5F–63. Original foot
  collision uses bit0; the game applies2HP damage per step. A planner that blocks
  every special tile incorrectly disconnects this route.
- Bortevo north cave enters from Palma `(26,46)` into22/DE north and exits22/21
  north to Palma `(24,36)`. The reverse entrance isPalma `(23,36)` into22/21 south.
  Abion's reachable south exit is `(32,71)/(33,71)`.
- Uzo's Motavia region does not directly reach Casba's town marker. Enter the
  original cave atMotavia `(92,92)/(93,92)` into39/D3 north, traverse its stairs,
  and exit39/DC south toCasba. Casba's return cave is `(83,51)/(84,51)` into39/DC
  north; the Uzo-side exit is39/D3 south.

The frozen controller campaign traversed these routes through Baya Malay,
the flying castle, Shadow and Lassic, then returned to the governor's palace.
Its original stairs and world travel were used throughout. An explicitly
documented cartridge upgrade from that earned save to ROM1bea58bc subsequently
executed the governor fall, both mandatory pits, Dark Falz victory and the
ending return to title. Its independent power-on replay passed all22
checkpoints through384766frames. This establishes an earned-save continuation;
a complete fresh New Game on the final corrected cartridge remains pending.

## Useful original side routes and equipment

- Flash39 costs20 in tool shops. Magic Lamp57 costs1400 in shops5(map6),15(map7)
  and18(map10), or chestfloor9/91 C626. A Lamp lights future dungeon entries.
- Landrover33 costs5200 at shop23/map17(70,62)/(71,62). Ice Digger35 costs12000
  at shop27/map22(18,31)/(19,31). Their geometry checks and retained inventory
  differ from ordinary consumables.
- Gas Shield59 comes from event146, floor21 room3E, for1000. Event93 is an
  alternate source handler, not a confirmed reachable world NPC in the index.
- Event78 atmap15(70,15)/(71,15), answerNO, enables Flute discoveryC507=1.
  SEARCH Gothic map7 cell(30,32) gives Flute38 and setsC507=FF *before* an item
  award attempt. A full-inventory abandonment can therefore permanently lose
  this reward. Flute is a reusable dungeon escape tool.
- Event116 atmap18(117,53)/(118,53), pay400, setsC509=1. SEARCH Motavia map1
  cell(72,36) yields Mirror Shield31 unless owned or already equipped by Odin.
  Odin's equipped Mirror Shield blocks Medusa's petrification special.
- Medusa67 fixed battlefloor10/67 awards Laconian Axe15, C6C5. Red Dragon60 at
  floor27/5A awards Laconian Sword14, C6CB. These are original fixed rewards.
- Tarzimal event157 atfloor34/24 tests Noah alone. Other three status bytes are
  hidden then restored; defeated Noah regains pre-duel HP/status. Win for Frade
  Mantle24. Do not assume normal four-member combat or normal game-over logic.
- Miracle Key62 chestfloor12/11 C631 has trap byteFC. It opens both ordinary
  locked and magic doors; source map Open spell handles only magic doors.

## Execution and evidence requirements

The actual campaign run should keep its natural RNG, money, levels, rewards,
inventory and story flags. Grind through real combat when needed; do not inject
HP, items, positions or outcomes into the campaign save. Separate already-used
UI fixtures remain useful regressions but must never be described as campaign
completion. Keep checkpoint saves before key full-inventory awards and bosses,
record source flags/items after each step, and confirm reloads preserve them.

The frozen campaign ROM uses the earlier single-record quicksave adaptation.
The later integrated five-slot name/overwrite/delete workflows have separate
verification; this frozen campaign does not establish their correctness.


Controller route verification has now reached the original armor/shield chests.
Laconia Armor23 is Odin-only (source equipment flags41), so the actual church
revival preceded his successful equip. Laconia Shield32 equips Alis; her former
Iron Shield27 transferred to Odin. The chest route from52/D3N to47/12W takes156
commands; this is the Laconia Shield cave, despite older checkpoint labels.

For continued long-dungeon travel, the source Wand4 is sold for1200 at Skure
underground shop24 (map21 cells97/98,19). It remains in the inventory when used
in battle and escapes without MP or an escape probability roll, subject to
nonzero source run chance, open retreat geometry, and the selected actor surviving
unbound until their initiative. It is not an immediate out-of-turn escape.
Noah Tele costs4MP and instead accepts enemy flag bitsC0 immediately during
selection preparation; decimal37 is Sphinx and44 is Zombie, not Giant/Reaper.
Tele fails on Zombie30flags; source names/IDs must be read from the table.


Final-route corrections from source and controller verification:

* The Laconia Sword cave at Palma(6/7,41/42) requires the original Hovercraft
  approach/disembark. From23/D7/north, the Red Dragon approach27/59/east is251
  source commands; stop at27/57/east before opening the last door if preparing.
* Tower11/B9/north→Miracle Key approach12/21/north is91 commands. The chest at
  12/11 is C631/item62 with the original party trap. From12/21 to summit15/1C/east
  is247 commands with the key. Use Prism then Nuts within event176 context.
* Flying castle entrance(31/32,17)→57/D6/north. Shadow approach53/B2/south is106
  commands; its rear door blocks escape. Shadow→Lassic57/CC/west is121 commands.
  Open the special magic doorCB with Miracle Key and enter. Both prompt choices
  lead to the original battle. Crystal60 is required for the source protection.
* After Lassic, source Governor55 writes22E6 then invokes661C. The actual entry
  is33/E6/north after the fall decrement. Do not route from34/E6. Mandatory
  pits33/1A→32/1A and32/79→31/79 lead to31/DE/north in158 commands; openCE with
  Miracle Key for Dark Falz. These pitfall edges are actual source geometry,
  not arbitrary floor transitions. The frozen4f4 campaign ROM has a confirmed
  entry defect here; correction/migration must be documented separately.

## Prepared continuation and fresh-cartridge checks

`tools/continue_campaign_save.py` verifies the immutable pre-final-governor
milestone manifest and imports its byte-identical8192-byte earned cartridge
save before power-on. Native Continue must restore the recorded party,
inventory, money, RNG, flags, location and vehicle exactly before the runner
enters event55. Its result is explicitly an earned-save cartridge upgrade,
not a single-cartridge New Game completion. `tools/replay_campaign.py
--earned-save` independently replays this kind of continuation with the same
initial save; the default replay still requires a clean start without SRAM.

`tools/run_campaign_story.py` prepares all51 established source-route phases
for a fresh unchanged-ROM playthrough. Its argument and syntax checks pass;
execution on the final corrected ROM remains pending. Actual earned-money
targets include recovery reserves:800 before Naula,1000 before the Governor
Letter trip,5000 for Lamp/Luveno/Polymaterial,3600 before Gloves and2200 after
Laser Gun for the later Gas Shield/Sopia/recovery costs. Additional funds use
the previously traversed Camineet or Skure encounter routes. No cash, levels,
items, battle outcomes or seeds are patched.

If a church revival changes the post-Prism Fly destination to Aukba, the
driver follows the original west/southwest/south caves back to Skure. It does
not assume the old run's destination or incidental battle income. Natural
defeats are preserved with unique failure states and controller records.
`--resume ... --continue-after-defeat` permits native Continue for established
funds phases, or native Continue/Flute/resupply for the final Baya climb.
Other failed route conditions retain the exact state for investigation.

The earned continuation preserved three real Dark Falz defeats and actual
Continues. One failed strategy selected Noah's Prot menu entry3 while naming
it Wind in the runner; read-only replay exposed the runner error. The source
menu is Fire0,Tele1,Wind2,Prot3,Thun4. The corrected Wind selection is logged
with its ROM-derived source spell ID7. No production spell behavior changed.

The successful preparation phase earned16094Meseta through110 further
encounters in original floor32's pool88, with original Flute returns and
Governor guest-room rest. It bought DiamondArmor22 for15000 at Paseo shop12,
equipped Alis and returned by the original palace stairs. Source floor33 has
zero random-encounter chance; floor32 has25/256. The final party levels were
23/22/22/21 with full HP200/183/169/161 and MP27/47/0/72 before the maze.
This preparation is now phase50 in the fresh driver before the final maze.
Both Wall6 and Prot86 are cancelled by Dark Falz's source flags00 through
12D4/12FA; neither is treated as an invented boss protection strategy.

The continuation's138encounters, three defeats, source SRAM provenance,
controller log and independent replay are in
`build/campaign/final-story-earned-1bea58bc`. ROM1bea58bc still has documented
presentation/support chronology gaps; this evidence does not certify those
subsequent corrections or a single-ROM New Game completion.

The first fresh candidate bae370f7 was held after checkpoint275 when the
ending review exposed a lost window-map selection after dungeon falls. Its
uncompleted input tail remains preserved. The corrected candidate
1b2b41bc independently replayed from clean power-on to frame908977 and matched
all276 committed checkpoints, including RNG, without loading SRAM or a save
state. The resulting new-ROM state is used only to hand the same monotonically
advancing campaign between processes. Evidence is in
`build/campaign/release-v2-newgame-1b2b41bc/PREFIX_REPLAY_PROOF.json`; the
remaining story is running on those unchanged v2 bytes.

Runner preparation explicitly visits Aukba's original church to establish
the Fly destination even if no revival is needed. Funds completion includes
actual church revival costs; equipment preparation checks living recipients.
The final armor purchase makes an inventory slot by using an original Burger
if the24-slot bag is full. Field healing selects living casters. These are
controller choices following the original game rules, not changes to the ROM.
