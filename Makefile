# De grotten van Oberon: reassembles the game from src/, in three languages.
#
#   make          build/nl.prg, build/de.prg and build/en.prg (load at $0801,
#                 RUN starts them)
#   make nl       one language (also de, en)
#   make check    each build is byte-identical to its original (grotten.prg,
#                 grotten_de.prg, grotten_en.prg) as long as nothing in src/
#                 was changed
#   make release  the builds crunched into one file each:
#                 grotten_van_oberon.prg, grotten_von_oberon.prg,
#                 caves_of_oberon.prg
#   make run      starts the Dutch release in VICE (run-de, run-en)
#   make disasm   runs Deflower on grotten.flo again (writes out/, not src/)
#
# src/grotten.asm is the one source; src/<language>/ holds each language's
# texts and data, found through the include path.

TASS ?= 64tass
DEFLOWER ?= $(HOME)/IdeaProjects/deflower/deflower
PUCRUNCH ?= pucrunch
X64 ?= x64sc
PYTHON ?= python3

LANGUAGES := nl de en

all: $(LANGUAGES)

$(LANGUAGES): %: build/%.prg

# The puzzle banks are text, see tools/puzzles.py
build/%.bin: src/%.txt tools/puzzles.py
	@mkdir -p $(dir $@)
	$(PYTHON) tools/puzzles.py import $< $@

puzzles = $(patsubst src/%.txt,build/%.bin,$(wildcard src/$(1)/puzzles_*.txt))

# .binary and .include look in the language's src/ directory, then in its
# build/ directory (the puzzle banks)
define language
build/$(1).prg: src/grotten.asm $(wildcard src/$(1)/*) $(call puzzles,$(1))
	$$(TASS) -q -I src/$(1) -I build/$(1) -L build/$(1).lst -o $$@ src/grotten.asm
endef
$(foreach l,$(LANGUAGES),$(eval $(call language,$(l))))

check: $(LANGUAGES:%=build/%.prg)
	cmp build/nl.prg grotten.prg && echo "build/nl.prg is identical to grotten.prg"
	cmp build/de.prg grotten_de.prg && echo "build/de.prg is identical to grotten_de.prg"
	cmp build/en.prg grotten_en.prg && echo "build/en.prg is identical to grotten_en.prg"

# Each starts at $1000 once unpacked
release: grotten_van_oberon.prg grotten_von_oberon.prg caves_of_oberon.prg

grotten_van_oberon.prg: build/nl.prg
	$(PUCRUNCH) -c64 -x0x1000 $< $@

grotten_von_oberon.prg: build/de.prg
	$(PUCRUNCH) -c64 -x0x1000 $< $@

caves_of_oberon.prg: build/en.prg
	$(PUCRUNCH) -c64 -x0x1000 $< $@

run: grotten_van_oberon.prg
	$(X64) $<

run-de: grotten_von_oberon.prg
	$(X64) $<

run-en: caves_of_oberon.prg
	$(X64) $<

disasm:
	$(DEFLOWER) --verify grotten.flo

clean:
	rm -rf build

.PHONY: all $(LANGUAGES) check release run run-de run-en disasm clean
