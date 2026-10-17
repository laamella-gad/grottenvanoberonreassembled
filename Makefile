# De grotten van Oberon: reassembles the game from src/.
#
#   make          build/grotten.prg, the game (loads at $0801, RUN starts it)
#   make check    the build is byte-identical to grotten.prg (as long as
#                 nothing in src/ was changed)
#   make release  grotten_van_oberon.prg, the build crunched into one file
#   make run      starts the release in VICE
#   make disasm   runs Deflower on grotten.flo again (writes out/, not src/)

TASS ?= 64tass
DEFLOWER ?= $(HOME)/IdeaProjects/deflower/deflower
PUCRUNCH ?= pucrunch
X64 ?= x64sc
PYTHON ?= python3

PUZZLES := $(patsubst src/%.txt,build/%.bin,$(wildcard src/puzzles_*.txt))

all: build/grotten.prg

# The puzzle banks are text, see tools/puzzles.py
build/puzzles_%.bin: src/puzzles_%.txt tools/puzzles.py
	@mkdir -p build
	$(PYTHON) tools/puzzles.py import $< $@

# .binary looks next to the source first, then in build/
build/grotten.prg: src/grotten.asm src/*.bin $(PUZZLES)
	$(TASS) -q -I build -L build/grotten.lst -o $@ src/grotten.asm

check: build/grotten.prg
	cmp $< grotten.prg && echo "build/grotten.prg is identical to grotten.prg"

# Starts at $1000 once unpacked
release: grotten_van_oberon.prg

grotten_van_oberon.prg: build/grotten.prg
	$(PUCRUNCH) -c64 -x0x1000 $< $@

run: grotten_van_oberon.prg
	$(X64) $<

disasm:
	$(DEFLOWER) --verify grotten.flo

clean:
	rm -rf build

.PHONY: all check release run disasm clean
