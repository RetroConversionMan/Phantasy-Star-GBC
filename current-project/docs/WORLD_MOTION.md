# Original world motion and priority

Status: integrated in frozen release v5 (`b72feead…`). Original-source/native comparisons,13 integration suites, a complete earned campaign and an independent clean-power-on replay pass. Earlier isolated/combined milestones below remain their original evidence; the world objects are unchanged from the verified v4 composition.

The preserved earlier v3 ROM has SHA-256
`2e151f71ae14996d5753791d373b6ef9f0d7a27f7f86e3cab3742c39ea19668c`.
The isolated world-motion candidate has SHA-256
`30f09020e57b1f64d71b2cae4d585006abf364531e78febdb435c6f3eef9a92c`.
Its frozen changes are in
`build/source-snapshots/world-motion-files/MANIFEST.json`.

## Source behavior

Original routines `62BC` and `630A` use six slots. Map-group records at `DF1`
enable each slot; the reloads are 31, 15, 15, 3, 15 and 7. A slot decrements
its full byte counter and expires when the result has its sign bit set.
Only the first expired enabled slot updates; the source removes a return
address, so later slots do not even decrement on that tick. The port preserves
that early return and the full-byte phase wrap.

The source pointer tables at `6345` through `6395` select eight pattern phases
from actual ROM bank 14. Their destination tile ranges begin at 4, 16, 19, 23,
29 and 37, with 12, 3, 4, 6, 8 and 16 tiles respectively. Group 0 enables slots
0, 1, 3 and 4; group 1 enables slots 2, 3 and 5. The other nine groups do not
animate. Roads reset all counters/phases and enable only slot 3 with reload 0;
road tags 4 through 6 decrement the phase rather than incrementing it.

The asset extractor reserves distinct native tile identities for changing
source patterns. It chooses one palette for a tile across its initial image
and all eight phases. The other nine groups retain their previous conversion.
The source priority bit is copied to the native tile attribute. For priority
tiles, source color index zero remains native index zero, and every other
source index remains nonzero even when its RGB color matches index zero.
This preserves the original transparency/priority mask under palette reduction.

## Native upload and memory

Runtime state uses 13 bytes: six countdowns, six phases and the road tag.
Code uses bank 21; phase data uses banks 24 and 25. In the combined build,
the 144-byte descriptor tables also occupy bank21 beside their sole consumer;
this avoids ROM0 overflow without changing the algorithm or data. The isolated candidate's
static WRAM ends at `DBA6`, below the test guard at `DBC0`.

The first native implementation produced two mixed completed frames despite
correct final VRAM bytes. The corrected implementation places each phase in a
contiguous, 16-byte-aligned ROM block and transfers at most 256 bytes with CGB
general-purpose DMA during early VBlank. It restores both ROM and VRAM banks.
The timing and alignment constraints follow the hardware description in
[Pan Docs, CGB registers](https://raw.githubusercontent.com/gbdev/pandocs/master/src/CGB_Registers.md).
The failed ordinary-upload evidence is retained as a negative control.

## Verification

| Evidence | Result and scope |
| --- | --- |
| `build/verification/world-motion-source-atomic/report.json` | 535 cases, 12,288 logical ticks and 1,340,768 original VDP payload bytes compared with unmodified original Z80 instructions; all groups, roads, signed counters and phase wrap. |
| `build/verification/world-motion-native-atomic/report.json` | 2,944 requested native steps; 745,472 pattern bytes and 35,328 counter bytes exact; 453 sampled completed frames with zero mixed frames; font/Alis memory, banks, audio cadence and 64-byte stack guard preserved. |
| `build/verification/world-motion-world-logic.json` | Source maps, collision, triggers, tile attributes and priority checked for all groups. |
| `build/verification/world-motion-world-probe/report.json` | 187 native viewports, protected graphics memory and bank restoration checked. |
| `build/verification/world-motion-acceptance.json` | All 13 existing controller/fixture suites passed on the unchanged isolated ROM. |
| `build/milestones/world-priority-20261113/SHA256.json` | Independent source-index priority conversion and native pixel tests, including duplicate RGB colors and the incorrect RGB-only negative control. |

The integration runner initially exposed three test-harness assumptions: two
walkers held a direction until a transient grid boundary, and a battle-return
check read assets from the different canonical cartridge. The corrected
walkers release a direction once the step commits; the return check reads the
tested ROM's table. All original failures and subsequent passing reports are
retained. No game behavior was changed to satisfy those assertions.

These are explicit source and native fixtures, not a fresh campaign, physical
hardware test, or claim of pixel-identical SMS colors on the CGB.

## Combined release evidence

`build/verification/full-presentation-world-source/report.json` repeats the original-machine comparisons after composition. `build/verification/full-presentation-world-native/report.json` passes2,944 native steps and453 completed frames with zero mixed frames, with production audio active. `build/verification/full-presentation-world-logic.json` and `full-presentation-world-probe/report.json` cover the complete maps and187 viewports. All corresponding production objects are unchanged in release v4; the final55b7 full-ROM integration suite passes separately. `full-presentation-probe-layout.json` validates the native probe bank/WRAM layouts.
