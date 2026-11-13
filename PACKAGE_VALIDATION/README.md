# Applicability to the revised package

These are historical validation results for the earlier package that included the original Z80 disassembly. This revised package removes that original source, its temporary build copy and original object file, while retaining all native production files, ROMs and verification evidence unchanged. Original-source reassembly and source-text-dependent tools now require obtaining the pinned upstream source separately. See the current root build guide and `../DISASSEMBLY_REMOVAL.json`. The old draft-archive hash does not identify this revised ZIP.

# Fresh source-package validation

These checks ran on 13 November 2026 against a new, disposable extraction of the draft source ZIP. All passed. The final ZIP adds these reports, the independent content audit and packaging documentation/helper refinements; the production source, compiler, generated assembly, ROM and frozen evidence are unchanged.

| Check | Result |
| --- | --- |
| Draft ZIP/extracted integrity | Every payload SHA-256/size checked; ZIP members fully read with CRC verification. |
| Forced GBDK 4.5.0 build | 262 fresh compile calls; accepted ROM SHA-256 `b72feead6a4a0b9efe779a2a61fbce7e96bd30247e3149b0ce1793dd414d59a1`. |
| Exact build identity | All 343 production source/Makefile entries, 262 assembly modules, 262 listings, 262 objects, 262 symbol files, ROM, NOI, IHX, map and main symbols match. |
| Seven host logic suites | RPG 68,639; events 3,168; services 81; story events 80; battle 385,470; save 5,209; world rules 4,370 checks. |
| Thirteen emulator integration suites | All pass on the exact rebuilt ROM; detailed suite reports and images are under `integrations/`. |
| Baseline reproduction | Separate Camineet build matches the preserved baseline; emulator checks pass. |
| Original SMS reproduction | Temporary-copy WLA-DX assembly exactly reproduces the supplied original SMS ROM; original source remains untouched. |
| Retained campaign/evidence audit | Fresh independent audit passes on the extracted proof files, including source/build, input/state/save and settled-title evidence. |
| Packaging helper checks | Corrupt same-length payloads rejected in ordinary and optimized Python; unsafe ZIP paths and unsupported shell-sensitive compiler paths rejected. |

Read [VALIDATION.json](VALIDATION.json), [build-identity.json](build-identity.json), [native-compilation.log](native-compilation.log), [integrations/report.json](integrations/report.json), and [independent-proof-audit.json](independent-proof-audit.json). These are distinct from the earlier full-campaign execution reports retained inside `current-project/`.

The packaging run did **not** replay the entire 3,581,580-frame campaign again. It independently checked that retained campaign/replay proof and reran the thirteen targeted emulator suites. Tests used the already installed Python 3.12.12 development environment; tested code, reference inputs, toolchain and ROM came from the fresh ZIP extraction. The package supplies version pins and instructions for recreating that environment, not a copied virtual environment. Physical hardware, every optional route/input combination and a complete subjective soundtrack review remain outside this evidence.

Absolute temporary paths and the draft-archive hash in logs identify the actual validation run. They are historical provenance, not paths a recipient must reproduce. The final archive has its own adjacent `.sha256` file. Its integrity is checked after these reports are included, avoiding a circular archive hash inside itself.
