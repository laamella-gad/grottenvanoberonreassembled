# De grotten van Oberon

Radarsoft's 1985 Dutch C64 cave and puzzle game (by C. Kramer), disassembled with
[Deflower](../deflower) into a source that reassembles byte for byte, with its
texts, puzzles, cave, tiles and graphics editable. One source builds all four
versions: Dutch, German (*Die Grotten von Oberon*), English (*The Caves of
Oberon*, whose engine was sped up) and Finnish (*Oberonin luolat*), plus a new
French one (*Les Grottes d'Oberon*), translated from the English.

The versions come from cracks (`GROTTEN.T64`, `GROTTENO.T64`, `CAVESOFO.T64`, `OBERONIN.T64`, not included),
with the cracks' depackers, intros and trainer left out; the Dutch crack's
credits in the status line are still there. All five use the English version's
faster engine, and the German and English versions get the Dutch version's cave
wall tile $44, which had a few stray pixels in them.

Each release shows Radarsoft's loading picture in its language before the game
(the French one redrawn from the English); a key or fire starts the game.

## Building

Needs 64tass, Python 3, and pucrunch for the release.

```
make            # build/nl.prg, build/de.prg, build/en.prg, build/fr.prg,
                # build/fi.prg
make check      # compare the English build with its original (apart from the
                # fixes in NOTES.md)
make release    # release/: grotten_van_oberon.prg, grotten_von_oberon.prg,
                # caves_of_oberon.prg, grottes_d_oberon.prg,
                # oberonin_luolat.prg, crunched
```

## Editing

Each language has its own files in `src/nl/`, `src/de/`, `src/en/`, `src/fr/` and `src/fi/`; the code
is `src/grotten.asm`.

- texts: `src/<language>/text.asm`
- puzzles: `src/<language>/puzzles_*.txt`
- cave and tiles: `tools/playfield.py [de|en|fr|fi] export`, edit `playfield.ctm` in CharPad, `tools/playfield.py [de|en|fr|fi] import`
- sprites: `tools/sprites.py [de|en|fr|fi] export`, edit `sprites.spd` in SpritePad, `tools/sprites.py [de|en|fr|fi] import`
- characters: `src/<language>/charset.bin` (or through the CharPad project)

`NOTES.md` has the memory map, the engine, the rules for each kind of edit and the bugs found.
