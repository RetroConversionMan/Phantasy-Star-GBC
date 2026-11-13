# Validation after removing the original disassembly

All 343 native production source/Makefile files and all 262 generated native assembly modules remain byte-for-byte unchanged. Both original Z80 source copies and the original assembled object have been excluded; no source was restored for these tests.

The seven host logic suites and thirteen emulator integration suites passed in the earlier clean-build extraction after applying the same removal list. Read [report.json](report.json) and [integrations/report.json](integrations/report.json). The earlier byte-identical native rebuild and full campaign evidence remain valid for the unchanged native code/ROM and are retained separately.

Source-text-dependent extraction, original-SMS reassembly and lexical source audits now require obtaining the pinned upstream checkout separately. The native cartridge build uses the included generated C/data and does not require that checkout. The current build guide explains the distinction.

The first emulator attempt used the base Python interpreter by mistake and could not import PyBoy. The corrected virtual-environment invocation passed all thirteen suites; the brief initial log is retained, and no game/test code was changed.
