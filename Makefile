# De grotten van Oberon: reassembles the game from src/, in five languages.
#
#   make          build/nl.prg, build/de.prg, build/en.prg, build/fr.prg and
#                 build/fi.prg (load at $0801, RUN starts them)
#   make nl       one language (also de, en, fr, fi)
#   make check    build/en.prg is byte-identical to original/grotten_en.prg
#                 as long as nothing in src/ was changed, apart from the fixes
#                 listed (cmp -l) in src/en/fixes.cmp; the Dutch, German and
#                 Finnish builds have the English engine and so can't match
#                 their originals any more, the French version is new
#   make release  the builds with their loading picture, crunched into one
#                 file each, in release/: grotten_van_oberon.prg,
#                 grotten_von_oberon.prg, caves_of_oberon.prg,
#                 grottes_d_oberon.prg, oberonin_luolat.prg
#   make run      starts the Dutch release in VICE (run-de, run-en, run-fr,
#                 run-fi)
#   make disasm   runs Deflower on disasm/grotten.flo again (writes
#                 disasm/out/, not src/)
#
# src/grotten.asm is the one source; src/<language>/ holds each language's
# texts and data, found through the include path.

TASS ?= 64tass
DEFLOWER ?= $(HOME)/IdeaProjects/deflower/deflower
PUCRUNCH ?= pucrunch
X64 ?= x64sc
PYTHON ?= python3

LANGUAGES := nl de en fr fi
# the languages whose build can be compared with an original: the others use
# the English engine
ORIGINALS := en

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

original_en := original/grotten_en.prg

# Differences from the original other than these fixes fail the check
fixes = $(or $(wildcard src/$(1)/fixes.cmp),/dev/null)

check: $(ORIGINALS:%=build/%.prg)
	@$(foreach l,$(ORIGINALS),cmp -l build/$(l).prg $(original_$(l)) | diff $(call fixes,$(l)) - \
		&& echo "build/$(l).prg is identical to $(original_$(l))$(if $(wildcard src/$(l)/fixes.cmp), apart from src/$(l)/fixes.cmp)" &&) true

release: release/grotten_van_oberon.prg release/grotten_von_oberon.prg release/caves_of_oberon.prg release/grottes_d_oberon.prg release/oberonin_luolat.prg

# The game with its loading picture (src/<language>/picture.kla) behind it,
# see src/release.asm. pucrunch unpacks it with all RAM banked in, then starts
# show_picture ($ff40) with $01 = $35 and interrupts off.
build/%_release.prg: build/%.prg src/release.asm src/%/picture.kla
	$(TASS) -q -D 'game="$(notdir $<)"' -I build -I src/$* -o $@ src/release.asm

crunch = $(PUCRUNCH) -c64 -x0xff40 -g0x35 -i0 $< $@

release/grotten_van_oberon.prg: build/nl_release.prg
	$(crunch)

release/grotten_von_oberon.prg: build/de_release.prg
	$(crunch)

release/caves_of_oberon.prg: build/en_release.prg
	$(crunch)

release/grottes_d_oberon.prg: build/fr_release.prg
	$(crunch)

release/oberonin_luolat.prg: build/fi_release.prg
	$(crunch)

run: release/grotten_van_oberon.prg
	$(X64) $<

run-de: release/grotten_von_oberon.prg
	$(X64) $<

run-en: release/caves_of_oberon.prg
	$(X64) $<

run-fr: release/grottes_d_oberon.prg
	$(X64) $<

run-fi: release/oberonin_luolat.prg
	$(X64) $<

disasm:
	$(DEFLOWER) --verify disasm/grotten.flo

clean:
	rm -rf build

.PHONY: all $(LANGUAGES) check release run run-de run-en run-fr run-fi disasm clean
