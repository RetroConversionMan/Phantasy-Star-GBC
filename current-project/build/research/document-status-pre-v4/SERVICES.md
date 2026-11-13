# Original service control flow

Current candidate `2e151f71ae14996d5753791d373b6ef9f0d7a27f7f86e3cab3742c39ea19668c` integrates services with the native menus, original dialogue, portraits and shared RPG state. Thirteen exact-binary integration suites and 28 travel music cases pass. The fresh full campaign and independent replay remain pending; the focused service tests below retain their original fixture and coverage limits. Service sound/wait omissions remain unfinished as listed below.

A separately frozen service/inventory candidate `161e252304c875aa64fc34845359dcec2362f3d6b76cb94ae1e47fd8330a0cb7` now implements the missing C1/C5, revival/input waits and successful-purchase B3 boundaries. Evidence is in `build/milestones/service-inventory-order-20261113/`: 103 original machine-code cases, 41 actual native menu cases, six chest cases and focused regressions pass. It has not yet been merged into the candidate named above; combined transition integration and fresh campaign verification remain pending.

`services.c` in GBC bank19 ports the source branches at `LABEL_298D..LABEL_2D0F` into explicit dialogue, question and selection actions. It shares the single `RPGState` through `EventState`; service state is transient. Church entry stores the original rawC2DB value in persistent `last_church`/C317 before asking any question.

## Interface

`service_begin`, `service_advance`, `service_respond` and `service_select` return a `ServiceAction`. Dialogue IDs are original bank12 addresses. `number`, `item` and `character` supply dynamic text substitutions. Selection actions may carry a prompt dialogue; the UI displays it and then opens the selector without calling advance. Selection255 is cancel. Secondhand selection0 means buy and1 means sell.

Purchasing an option is the original purchase confirmation. There is no invented additional BUY prompt. A successful purchase shows the original another-purchase question; declining or canceling shows the original farewell. Full-inventory and insufficient-money outcomes exit. Food stores have their distinct greeting. Scion Secrets delegates to the source-specific three-request event logic.

## Preserved service branches

- Hospital: solo Alis is selected automatically; larger parties receive the original character question. Dead targets, already-full targets, declined fees, successful treatment, repeated treatment and insufficient-money exits follow the original labels. The fee preserves the source8-bit addition of HP/MP deficits. Treatment mutates HP/MP/money only after the quoted-fee confirmation.
- Church: living targets receive the source living-character response. Revival quotes level×20, then displays the spell text before attempting payment. Insufficient money produces the original failed-incantation message and another-character prompt. Exit shows the blessing, then EXP-to-next guidance for each living member; level30 receives its separate message. The next-level subtraction preserves uint16 wrapping.
- Secondhand store: original buy/sell menu, item selection, protected-item response, quoted-price confirmation, removal/money saturation and another-sale question. Declined sales do not mutate inventory or funds.

## Recorded subsystem evidence and current limits

`tools/verify_services.py` passes81 assertions with address/undefined-behavior sanitizers. It covers the source branches above, including8-bit fee overflow, casting before payment, maximum level, capacity checks, protected sales and Secrets requests.

`tools/verify_services_emulator.py` independently walked99 controller-input grid steps through Camineet, Palma and Parolit. It verified armory welcome/decline/insufficient-funds/purchase/repeat prompts, churchC317 and its blessing/EXP finale, quoted hospital treatment and the already-healed solo branch. Its only injected fixtures were money30 for a shield purchase and HP1/money15 for treatment; it did not inject travel or claim battle rewards. The report records the tested ROM hash and stores real screenshots under `build/verification/services-emulator/`.

Native testing exposed an incorrect nested pointer load generated for a tiny register-argument helper in GBDK4.5.0. The helper now uses the banked stack ABI; the previously failing solo-hospital branch passes on the emulator.

The service state machine emits actions rather than rendering portraits or
typing text. Those responsibilities are now integrated through the scene,
dialogue and main modules; their earlier state-machine-only limitation is
historical. The native display retains its adapted window layout.

Current source presentation is still missing hospital recovery soundC1
(`LABEL_2999`, beforeB938), and revival soundC5 followed by the skippable30-frame
`LABEL_2D33` wait (`LABEL_2A98`, afterB9C4). Native `services.c` currently advances
directly through those text actions; `ServiceAction` and the main service
dispatcher provide no sound/wait continuation. Ordinary successful purchases
also omit the B3 emitted by source `Inventory_AddItem`. These are unfinished
hooks, distinct from GBC sound/palette/upload adaptations. The recorded service
tests establish their state and dialogue branches, not those omitted hooks,
full campaign completion or physical hardware behavior.
