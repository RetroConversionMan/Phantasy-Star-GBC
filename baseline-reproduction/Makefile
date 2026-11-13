GBDK_HOME ?= $(CURDIR)/.tools/gbdk
PYTHON ?= $(if $(wildcard .tools/venv/bin/python),.tools/venv/bin/python,python3)
LCC := $(GBDK_HOME)/bin/lcc
ROM := build/phantasy-star-gbc-exploration.gbc
SOURCES := $(wildcard src/*.c)

.PHONY: all assets previews audit verify clean
all: $(ROM)
assets:
	$(PYTHON) tools/extract_assets.py --no-preview
	$(PYTHON) tools/make_font.py
previews:
	$(PYTHON) tools/extract_assets.py
$(ROM): $(SOURCES) src/assets.h src/font.h
	mkdir -p build
	$(LCC) -msm83:gb -Wm-yC -Wm-yt0x1b -Wm-yo4 -Wm-ya1 -Wm-ynPSGBC-EXPLORE -Wl-m -Wl-j -o $@ $(SOURCES)
audit:
	$(PYTHON) tools/audit_source.py
verify: all
	$(PYTHON) tools/verify_rom.py $(ROM) --port-suite
	$(PYTHON) tools/verify_world.py $(ROM)
clean:
	$(PYTHON) -c "from pathlib import Path; [p.unlink() for p in Path('build').glob('phantasy-star-gbc-exploration.*') if p.suffix not in ('.sav', '.ram')]"
