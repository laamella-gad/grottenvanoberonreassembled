# De grotten van Oberon

Radarsoft's 1985 Dutch C64 cave and puzzle game (by C. Kramer), disassembled with
[Deflower](../deflower) into a source that reassembles byte for byte, with its
texts, puzzles, cave, tiles and graphics editable. One source builds all three
versions: Dutch, German (*Die Grotten von Oberon*) and English (*The Caves of
Oberon*, whose engine was sped up).

The versions come from cracks (`GROTTEN.T64`, `GROTTENO.T64`, `CAVESOFO.T64`, not included),
with the cracks' depackers, intros and trainer left out; the Dutch crack's
credits in the status line are still there.

## Building

Needs 64tass, Python 3, and pucrunch for the release.

```
make            # build/nl.prg, build/de.prg, build/en.prg
make check      # compare with the originals
make release    # grotten_van_oberon.prg, grotten_von_oberon.prg, caves_of_oberon.prg, crunched
```

## Editing

Each language has its own files in `src/nl/`, `src/de/` and `src/en/`; the code
is `src/grotten.asm`.

- texts: `src/<language>/text.asm`
- puzzles: `src/<language>/puzzles_*.txt`
- cave and tiles: `tools/playfield.py [de|en] export`, edit `playfield.ctm` in CharPad, `tools/playfield.py [de|en] import`
- sprites: `tools/sprites.py [de|en] export`, edit `sprites.spd` in SpritePad, `tools/sprites.py [de|en] import`
- characters: `src/<language>/charset.bin` (or through the CharPad project)

`NOTES.md` has the memory map, the engine, the rules for each kind of edit and the bugs found.
