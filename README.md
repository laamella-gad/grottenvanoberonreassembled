# De grotten van Oberon

Radarsoft's 1985 Dutch C64 cave and puzzle game (by C. Kramer), disassembled with
[Deflower](../deflower) into a source that reassembles byte for byte, with its
texts, puzzles, cave, tiles and graphics editable. One source builds all three
versions: Dutch, German (*Die Grotten von Oberon*) and English (*The Caves of
Oberon*, whose engine was sped up), plus a new French one (*Les Grottes
d'Oberon*), translated from the English.

The versions come from cracks (`GROTTEN.T64`, `GROTTENO.T64`, `CAVESOFO.T64`, not included),
with the cracks' depackers, intros and trainer left out; the Dutch crack's
credits in the status line are still there. The German and English versions
get the Dutch version's cave wall tile $44, which had a few stray pixels in them.

## Building

Needs 64tass, Python 3, and pucrunch for the release.

```
make            # build/nl.prg, build/de.prg, build/en.prg, build/fr.prg
make check      # compare with the originals (apart from the fixes in NOTES.md)
make release    # grotten_van_oberon.prg, grotten_von_oberon.prg, caves_of_oberon.prg,
                # grottes_d_oberon.prg, crunched
```

## Editing

Each language has its own files in `src/nl/`, `src/de/`, `src/en/` and `src/fr/`; the code
is `src/grotten.asm`.

- texts: `src/<language>/text.asm`
- puzzles: `src/<language>/puzzles_*.txt`
- cave and tiles: `tools/playfield.py [de|en|fr] export`, edit `playfield.ctm` in CharPad, `tools/playfield.py [de|en|fr] import`
- sprites: `tools/sprites.py [de|en|fr] export`, edit `sprites.spd` in SpritePad, `tools/sprites.py [de|en|fr] import`
- characters: `src/<language>/charset.bin` (or through the CharPad project)

`NOTES.md` has the memory map, the engine, the rules for each kind of edit and the bugs found.
