# De grotten van Oberon

Radarsoft's 1985 Dutch C64 cave and puzzle game (by C. Kramer), disassembled with
[Deflower](../deflower) into a source that reassembles byte for byte, with its
texts, puzzles, cave, tiles and graphics editable.

The source comes from the "ABC" crack on `GROTTEN.T64`, with the crack's
depackers and intro left out; the crack's credits in the status line are still there.

## Building

Needs 64tass, Python 3, and pucrunch for the release.

```
make            # build/grotten.prg
make check      # compare with the original
make release    # grotten_van_oberon.prg, crunched
```

## Editing

- texts: `src/grotten.asm`
- puzzles: `src/puzzles_*.txt`
- cave and tiles: `tools/playfield.py export`, edit `playfield.ctm` in CharPad, `tools/playfield.py import`
- sprites: `tools/sprites.py export`, edit `sprites.spd` in SpritePad, `tools/sprites.py import`
- characters: `src/charset.bin` (or through the CharPad project)

`NOTES.md` has the memory map, the engine, the rules for each kind of edit and the bugs found.
