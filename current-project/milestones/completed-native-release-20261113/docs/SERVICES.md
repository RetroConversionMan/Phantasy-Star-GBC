# Original service control flow

Current integration status (2026-11-13): candidate `b72feead6a4a0b9efe779a2a61fbce7e96bd30247e3149b0ce1793dd414d59a1` integrates original service state, menus, dialogue, portraits and sound/wait continuations. All thirteen exact-binary integration suites pass. The complete story and independent clean-power-on replay now pass; historical fixtures below retain their declared scope.

The service/inventory component first verified on `161e252304c875aa64fc34845359dcec2362f3d6b76cb94ae1e47fd8330a0cb7` is now integrated. Its 103 original machine-code cases, 41 native menu cases and six chest cases are frozen in `build/milestones/service-inventory-order-20261113/`. Combined v5 evidence is in `build/milestones/full-final-services-20261113/`; final55 integration suites establish the complete cartridge context.

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

Hospital payment now precedes C1 and recovery beforeB938 (`LABEL_2999`),
including the original wrapped fee. Revival showsB9C4, emitsC5 and runs the
skippable30-frame `LABEL_2D33` wait beforeB9E5 (`LABEL_2A98`). Successful
inventory additions/replacements emit sourceB3; rejected/full/canceled awards
and duplicate-vehicle purchases preserve their distinct branches. These
boundaries have original-machine-code and actual native menu evidence. They
do not by themselves establish complete campaign or physical-hardware proof.
