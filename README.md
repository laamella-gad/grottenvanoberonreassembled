# De grotten van Oberon - reassembled

Radarsoft's 1985 Dutch C64 cave and puzzle game (by C. Kramer), disassembled with
[Deflower](https://github.com/laamella-gad/deflower) into a source with its texts, puzzles, cave, tiles and
graphics editable. It reassembled byte for byte up to commit 28b04fd, before some improvements were made. One source builds all four
versions: Dutch, German (*Die Grotten von Oberon*), English (*The Caves of
Oberon*, whose engine was sped up) and Finnish (*Oberonin luolat*), plus a new
French one (*Les Grottes d'Oberon*), machine translated from the English.

The versions come from cracks (`GROTTEN.T64`, `GROTTENO.T64`, `CAVESOFO.T64`, `OBERONIN.T64`, not included),
with the cracks' depackers, intros and trainer left out, and the Dutch crack's
credit in the status line replaced by Radarsoft's again. All five use the English version's
faster engine, and the German and English versions get the Dutch version's cave
wall tile $44, which had a few discolored characters in them.

Each release shows Radarsoft's loading picture in its language before the game
(the French one automatically redrawn from the English); a key or fire starts the game.

Do you know of any other translations? Point me to them and I can include them too.

## How the cave scrolls

The whole screen scrolls smoothly in eight directions, one pixel a frame, on a
1 MHz machine that can't redraw a whole screen in a frame. The engine spreads the
work over an 8-frame cycle with two screens: one is shown while the other is
built one character further on.

| Phase | Work |
|---|---|
| 7 | take the joystick direction for the whole cycle |
| 5 | copy the characters, shifted one character, into the hidden screen |
| 3 | shift the colours into a buffer |
| 1 | draw the new row at the top or bottom |
| 0 | draw the new column at the left or right |
| every frame | fine scroll one pixel |

When the fine scroll wraps, at phase 7, the screens swap and the colour buffer
is copied to colour RAM ahead of the beam. A whole character of movement is
always one cycle, so the direction can only change every 8 frames. That is why
the controls feel a little slow, and why a short push moves the ship 1 or 8
pixels, never in between: after a stop the fine scroll sits at one edge of a
character, with 7 pixels to go the way it came and none the other way.

These builds take the joystick right away when the ship stands still, instead
of waiting for phase 7 (see `NOTES.md`).

## Building

Needs 64tass, Python 3, and pucrunch for the release.

```
make            # build/nl.prg, build/de.prg, build/en.prg, build/fr.prg,
                # build/fi.prg
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
