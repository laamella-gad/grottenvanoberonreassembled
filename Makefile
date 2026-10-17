# De grotten van Oberon: reassembles the game from src/, in four languages.
#
#   make          build/nl.prg, build/de.prg, build/en.prg and build/fr.prg
#                 (load at $0801, RUN starts them)
#   make nl       one language (also de, en, fr)
#   make check    each build is byte-identical to its original (grotten.prg,
#                 grotten_de.prg, grotten_en.prg) as long as nothing in src/
#                 was changed, apart from the fixes listed (cmp -l) in
#                 src/<language>/fixes.cmp; the French version is new and has
#                 no original
#   make release  the builds crunched into one file each:
#                 grotten_van_oberon.prg, grotten_von_oberon.prg,
#                 caves_of_oberon.prg, grottes_d_oberon.prg
#   make run      starts the Dutch release in VICE (run-de, run-en, run-fr)
#   make disasm   runs Deflower on grotten.flo again (writes out/, not src/)
#
# src/grotten.asm is the one source; src/<language>/ holds each language's
# texts and data, found through the include path.

TASS ?= 64tass
DEFLOWER ?= $(HOME)/IdeaProjects/deflower/deflower
PUCRUNCH ?= pucrunch
X64 ?= x64sc
PYTHON ?= python3

LANGUAGES := nl de en fr
# the languages with an original to compare with
ORIGINALS := nl de en

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

original_nl := grotten.prg
original_de := grotten_de.prg
original_en := grotten_en.prg

# Differences from the original other than these fixes fail the check
fixes = $(or $(wildcard src/$(1)/fixes.cmp),/dev/null)

check: $(ORIGINALS:%=build/%.prg)
	@$(foreach l,$(ORIGINALS),cmp -l build/$(l).prg $(original_$(l)) | diff $(call fixes,$(l)) - \
		&& echo "build/$(l).prg is identical to $(original_$(l))$(if $(wildcard src/$(l)/fixes.cmp), apart from src/$(l)/fixes.cmp)" &&) true

# Each starts at $1000 once unpacked
release: grotten_van_oberon.prg grotten_von_oberon.prg caves_of_oberon.prg grottes_d_oberon.prg

grotten_van_oberon.prg: build/nl.prg
	$(PUCRUNCH) -c64 -x0x1000 $< $@

grotten_von_oberon.prg: build/de.prg
	$(PUCRUNCH) -c64 -x0x1000 $< $@

caves_of_oberon.prg: build/en.prg
	$(PUCRUNCH) -c64 -x0x1000 $< $@

grottes_d_oberon.prg: build/fr.prg
	$(PUCRUNCH) -c64 -x0x1000 $< $@

run: grotten_van_oberon.prg
	$(X64) $<

run-de: grotten_von_oberon.prg
	$(X64) $<

run-en: caves_of_oberon.prg
	$(X64) $<

run-fr: grottes_d_oberon.prg
	$(X64) $<

disasm:
	$(DEFLOWER) --verify grotten.flo

clean:
	rm -rf build

.PHONY: all $(LANGUAGES) check release run run-de run-en run-fr disasm clean
