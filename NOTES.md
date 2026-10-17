# De grotten van Oberon: notes

Radarsoft, 1985, by C. Kramer. A Dutch puzzle adventure: fly a probe ship through
a scrolling cave, open doors by solving puzzles at computer terminals, refuel at
tanks, find the way out before the fuel runs out or the damage reaches 100 %.

## Files

| File | What |
| --- | --- |
| `GROTTEN.T64` | the Dutch tape image, not in the repository like the other two (one file, "OBERON", the "ABC" crack) |
| `GROTTENO.T64` | the German version, "GROTTEN V.OBERON" (and a picture file) |
| `CAVESOFO.T64` | the English version, "CAVES OF OBERON+" (and "CAVES OF OB. DOX", the instructions) |
| `original/oberon_packed.prg` | the Dutch file, $0801-$b2cf, packed |
| `original/grotten_unpacked.prg` | memory after both depackers, $0801-$cfff, at the jump to $1000 |
| `grotten.prg` | the same with the crack's leftovers at $0801-$0bff replaced by `10 SYS4096`: the Deflower input and the reference for `make check` |
| `grotten_de.prg`, `grotten_en.prg` | the German and English games made the same way: memory at the jump to $1000, $0801-$0bff replaced by the same `10 SYS4096` |
| `grotten.flo` | the Deflower annotations (Dutch version): every routine, variable and table |
| `out/` | Deflower's output (`make disasm`), not edited by hand |
| `src/grotten.asm` | the source of all three versions, from `out/grotten.asm`: edit code here |
| `src/nl/`, `src/de/`, `src/en/` | each language's files, see below |
| `tools/puzzles.py` | puzzle bank <-> text |
| `tools/playfield.py` | cave <-> CharPad project, and a picture of the cave |
| `tools/sprites.py` | sprites <-> SpritePad project |

Each language directory holds:

| File | What |
| --- | --- |
| `text.asm` | `language = "nl"` (`"de"`, `"en"`) and all texts, as `.segment`s that `grotten.asm` puts in place |
| `saved.asm` | what some variables held when the version was saved (see below) |
| `sprites.bin`, `charset.bin`, `map.bin`, `tile_chars.bin`, `tile_colours.bin` | the graphics and the cave |
| `puzzles_*.txt` | the four puzzle banks as text |
| `leftovers_1.bin`, `leftovers_2.bin`, `colour_buffer.bin` | what was in memory after the game code, the engine, and in the colour buffer |
| `fixes.cmp` | (de, en) the bytes the fixes below change, as `cmp -l` lists them: `make check` allows those differences and no others |

`src/grotten.asm` was copied from `out/` once and has since been changed for
the three languages (texts moved out, `.if language == "en"` blocks). Running
Deflower again doesn't touch it; copy over by hand only what changed in the
annotations, or edits get lost.

## Building

```
make            # build/nl.prg, build/de.prg, build/en.prg: load at $0801, RUN starts them
make en         # one of them
make check      # each byte-identical to its original while src/ is unchanged,
                # apart from the fixes in src/<language>/fixes.cmp
make release    # grotten_van_oberon.prg, grotten_von_oberon.prg, caves_of_oberon.prg,
                # crunched with pucrunch (start $1000)
make disasm     # Deflower: 0 differ, 0 gaps
```

64tass, no illegal opcodes (no `-i` needed). The Makefile picks the language
with the include path: `-I src/<language> -I build/<language>`, so
`.include "text.asm"` and `.binary "map.bin"` find that language's files, and
the puzzle banks made from its text files.

The unpacked build fills $0801-$cfff, which the KERNAL loads fine; the crunched
release is one file that unpacks itself.

## Depack stages (the crack)

1. `OBERON` loads at $0801-$b2cf: BASIC `SYS 2065`. $0811 is `nop #$30` (an
   illegal NOP) then `jmp $0816`: `lda #$36; sta $01; jmp $b22a`.
2. $b22a is RLE depacker 1 (escape byte $9e). It moves itself to $0334, unpacks,
   puts a BASIC line "SYS 2065 REX" back at $0801 and jumps to BASIC RUN ($a8bc).
3. That SYS calls $9be5, the crack intro (a picture at $e000/$c800, waits for a
   key), then `lda #$36; sta $01; jmp $9b49`.
4. $9b49 is RLE depacker 2 (escape $9c, $01 = $34), writes $0801-$cfff and ends
   with `lda #$37; sta $01; cli; jmp $1000`.

These were run in a small 6502 emulator instead of VICE to get the image at
$1000. The crack also changed the status line's text (`message_default`:
"GEKRAAKT IN 1985 DOOR ABC"); nothing else in the game was found changed.

The German and English files are other cracks, unpacked the same way up to the
game's `jmp $1000`. The German one keeps Radarsoft's credit in the status line.
The English one unpacks to a second intro at $1000 ("FILTERMEZZO! BY ZYRON"),
then a trainer menu at $0800 (cursor keys and RETURN); its options poke the
`jsr counter_increment` of the damage ($20ec) and the `jsr counter_decrement`
of the fuel ($2112). `grotten_en.prg` is taken with the options off, so those
are the original `jsr`s.

## The three versions

`src/grotten.asm` builds all three; `make check` compares each with its
original.

- Dutch and German: the same code. Only the texts, the data and the leftovers
  differ, and the texts' addresses follow from their lengths (all pointers to
  them are labels).
- English: the same game code ($1000 on), but its engine was sped up, in
  `.if language == "en"` blocks:
  - `start` writes 1000 `lda $ccxx / sta $d8xx` pairs and an `rts` to $6000,
    over the map image it just copied (`colour_copy_write`). `show_screen`
    jumps there instead of running its copy loop.
  - `scroll_shift_screen`'s loop is unrolled to the 4 parts at once
    (`scroll_shift_up` / `scroll_shift_down` set up parts 2-4);
    `scroll_carry_opcode` holds 0 instead of `clc` for up.
  - `scroll_shift_colours` shifts the colour RAM into the colour buffer
    instead of the buffer into itself.
  - The barrier animation (`barrier_code`, the same code) sits after the game
    code ($23ef) instead of at the end of the engine.
- What some variables held when the version was saved differs too (the status
  scroller's position, the sound effect, the switch, ...): `saved.asm` starts
  them with those values, so each build is identical.

## Memory map

| Range | What |
| --- | --- |
| $0400 / $0800 | the two screens, swapped (`$d018` eor $30) when the scroll wraps; sprite pointers at $07f8 / $0bf8 |
| $0c00-$0fff | 16 sprites, pointers $30-$3f (`sprites.bin`) |
| $1000-$2440 | game: title, puzzles, terminals, main loop, status line, texts (Dutch; the others end elsewhere) |
| $2441-$27ff | leftovers (English: the barrier animation first) |
| $2800-$2fff | charset (`charset.bin`), `$d018` = $1a |
| $3000-$5fff | four puzzle banks of $c00 |
| $6000-$7fff | the map image, copied to $e000-$ffff (RAM under the KERNAL) at the start |
| $8000-$9fff | tile characters (`tile_chars.bin`) |
| $a000-$bfff | tile colours (`tile_colours.bin`) |
| $c000-$cb7e | the engine: scrolling, drawing, raster IRQ, frame handler, barriers (then leftovers up to $cbff) |
| $cc00-$cfe7 | colour buffer, copied to $d800 when the screens swap |
| $fd30-$fd43 | scroll copy tables (copied from $13ad at the start) |

Sprites: 0/1 the status line scroller (sprite data $0d40/$0d80), 2-5 the ship
(multicolour), 6 the probe arm, 7 the guardian (expanded).

Charset: $00-$7f barrier characters, set up and animated by the engine
(`engine_init_barrier`, `animate_barrier`); $80-$bf the font in screen code
order (also the scrollers' and the puzzle display's font); $c0-$ff cave
graphics. Chars $db-$e8 are the puzzle display (14 characters wide), drawn into
at run time; $ee the doors, $f3 the switch light, $fe/$ff the switch.

## Engine

- Two raster IRQs (lines $fa and $ff) set the fine scroll and background. Every
  frame the scroll phase `frame_counter` counts 8..1 and spreads the work of one
  character step over the frames: latch direction (7), shift the hidden screen
  (5, `scroll_shift_screen`, a self-modified copy loop), shift the colour buffer
  (3), draw the new row (1) and column (0). Then the screens swap.
- The map is 128 x 64 tiles, $80 bytes a row, at $e000. A map byte's bits 0-6
  are the tile; bit 7 isn't used (21 cells have it set). Tile t is 8 x 8
  characters: character (x, y) is at `$8000 + ((t >> 5) * 8 + y) * 256 + (t & 31) * 8 + x`,
  its colour $2000 further. Colours >= 8 are multicolour ($d022 = 15, $d023 = 7).
- The IRQ chains to `frame_handler` ($c78a): engine sound, collisions (damage),
  joystick, barrier animation; it ends at `frame_done` (`jmp $ea31`).
- The main loop ($1e85) runs once per frame: guardian, voice 2 sound effect,
  door timer, damage repair, probe, terminals, clock, fuel, messages, status
  scroller.
- The probe (fire + direction) reads the character at its tip: $ed switch,
  $ec door (opens for a while), $eb puzzle terminal, $ef fuel tank, $f0 radar,
  $c0 the way out (won).
- The clock digits are also written into a tile ($9de1-$9de6), and the
  difficulty digit ($9ee3/$9ee4), so they show in the cave.

## Editing

### Texts

In `src/<language>/text.asm`, as `.text` lines (PETSCII; upper case letters).
Any length, unless said otherwise: the code points at them by label, and the
code after them moves along (up to $2800).

- `text_title`, `text_won`: printed with CHROUT, control codes as bytes, end with 0.
- `text_status`: the status line; fuel, time and damage digits are written
  into it by the game, `status_message` (54 characters) holds the message shown.
- `text_messages`: the status messages. `show_message` copies 54 characters
  from the start of one, so a shorter message shows the start of the next one
  after it (the Dutch `message_damage_bottom` and `message_radar` are 53, so
  the originals do this too). `damage` + `message_default` is the normal status
  (the credits). `message_fuel_low` is never shown.
- `text_intro`: the introduction, scrolled through the puzzle display, ends with 0.
- `text_fuel_full`: "VOL!", exactly 4 characters.

The status line's font is chars $80-$bf (screen codes), so the scrolled text
can only use screen codes $00-$3f: upper case, digits, punctuation.

### Puzzles

`src/<language>/puzzles_easy.txt` (F1), `_normal` (F3), `_tough` (F5), `_hard`
(F7). Each puzzle is 14 characters with a `^` line under the characters to
guess, up to 219 per bank; see `tools/puzzles.py`. `make` converts them.

### Cave, tiles and characters

```
tools/playfield.py export     # playfield.ctm + playfield_copies.txt for CharPad
tools/playfield.py import     # back into src/nl/map.bin, tile_chars.bin, tile_colours.bin, charset.bin
tools/playfield.py png        # cave.png, the whole cave (8192 x 4096)
tools/playfield.py en export  # the same for another language (de, en)
```

CharPad colours per character but the game per tile cell, so characters in
more than one colour get copies after 255 (see the tool's help). Characters
$00-$7f are drawn by the game, import ignores them. The ship starts at map
position $e432 (`engine_init`): tile row 8, column 50.

### Sprites

```
tools/sprites.py export     # sprites.spd, a SpritePad 1.8 project
tools/sprites.py import     # back into src/nl/sprites.bin
tools/sprites.py de export  # another language (de, en)
```

16 sprites from $0c00, pointers $30-$3f: $30-$34 the ship (multicolour, $34
is sprite 4's other frame), $35/$36 the status line (rows 6-12 are the
scrolled text, drawn at run time), $37/$38 and $39/$3a the probe arm, $3b an
unused probe frame, $3c-$3f the guardian (a big screw, 4 frames of it turning). The colours and modes are set by the
code (`sprite_colours_init`, `engine_init_sprites`); export shows them in the
project, import only takes the pixels.

## Differences from the original

- Tile $44 (a piece of cave wall, used all over the cave): in the German and
  English versions two cells of its row 6 hold characters $31 $30 in colour 0
  instead of spaces in colour $0a, a few stray pixels. They now hold what the
  Dutch version has (`tile_chars.bin` and `tile_colours.bin`, offsets
  $1624/$1625).

When changing a language's build on purpose, write its new differences to
`fixes.cmp`: `cmp -l build/de.prg grotten_de.prg > src/de/fixes.cmp`.

## Bugs and leftovers found

- `puzzle_wrong`: when the guardian comes from the right, `puzzle_tries`
  isn't counted down, so in that case a wrong answer never moves on to another
  puzzle.
- `message_fuel_low` ("MACHINEKAMER MELDT: DE BRANDSTOF RAAKT OP") is never shown.
- `unused_getin` ($10b4) is never called.
- `puzzles_test` ($1d1c) is a small puzzle list `puzzle_bank` points to before a
  difficulty is chosen.
- $2441-$27ff and $cb7f-$cbff hold leftovers of an earlier memory image
  (`leftovers_1.bin`, `leftovers_2.bin`; the build pads with zeros if the code
  grows into them, and stops if it outgrows them).
- The English F3 bank has a puzzle "QWERTYUIOP@*" with `@` (screen code 0) in
  it. A 0 makes `puzzle_char` go back to the start of the bank, so the game
  shows the first puzzle's character in that place. `tools/puzzles.py` takes
  `@` after a puzzle's first character for that.
