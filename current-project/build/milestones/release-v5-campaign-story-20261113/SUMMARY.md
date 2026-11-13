# Completed story on the frozen Game Boy Color candidate

The controller campaign completed all 51 planned phases, defeated Dark Falz, played the original ending and credits, and returned to the settled title on unchanged ROM `b72feead6a4a0b9efe779a2a61fbce7e96bd30247e3149b0ce1793dd414d59a1`.

- Final frame: **3,581,580**. The report contains **484 ordered gameplay checkpoints**, followed by a separately recorded final title state.
- Encounter annotations: **1,230** total. **501** annotations originated in the held v4 prefix; **729** were newly collected during b72 continuation.
- The history retains **one natural full-party defeat and one actual in-game Continue**. A separate **runner assertion** occurred when Alis lacked the original 8 MP for Fly after earning the Laconia Sword. That exact latest state was resumed; the party returned by the original Hovercraft route. No game correction or rewind was used.
- The final campaign and every route change used controller input. There were **no initial SRAM or emulator-state imports, and no RNG, item, stat, flag, position or outcome injections**. Process handoffs used only the exact latest states earned on the same b72 cartridge.
- The separate title proof passed: the entire **160 × 144** ending image matched a settled native power-on using this campaign's own earned SRAM, with **zero differing pixels**. Its reference settled after 304 boot frames. The ending title and Governor victory image were also inspected visually.

## Prefix provenance

B72 began at clean power-on and independently re-executed the held v4 controller prefix through frame 1,633,795. All **352** ordered checkpoints and every expected gameplay field matched, including RNG, native event/object flags, vehicle phase/clock, fade clock and map music. There were zero omitted gameplay frames and no old SRAM/state loads. The generated b72 checkpoint state and SRAM then continued forward to the ending.

Narrative, route, battle, death, Continue and failure annotations for that prefix were inherited from v4. Their complete controller sequence was re-executed on b72, but per-battle instrumentation was not independently recollected during the prefix replay. The b72 checkpoint snapshots, final prefix resume state and native SRAM were freshly generated. `PREFIX_METADATA_PROVENANCE.json` records this distinction.

## Frozen evidence and remaining acceptance

The completed run is `build/campaign/release-v5-newgame-b72feead/`. Its `SHA256.json` verifies all 443 story-evidence files, including the closed marker, title proof, initial prefix tools, final driver tools and preserved runner failure. `CAMPAIGN_CLOSED.json` pins the immutable ROM, symbols, controller log, report and final native SRAM. The initial ten prefix tools remain untouched; the nine actual final driver/title helper files are separately frozen in `driver-final/`.

**The independent full controller replay is still pending at the time this story milestone is frozen.** It is owned separately by the replay agent in `build/campaign/release-v5-live-replay-b72feead/`. This milestone establishes completed story play and earned-SRAM title acceptance; final campaign acceptance also requires that independent replay to finish successfully.
