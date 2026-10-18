# De grotten van Oberon: notes

Radarsoft, 1985, by C. Kramer. A Dutch puzzle adventure: fly a probe ship through
a scrolling cave, open doors by solving puzzles at computer terminals, refuel at
tanks, find the way out before the fuel runs out or the damage reaches 100 %.

## Files

| File | What |
| --- | --- |
| `GROTTEN.T64` | the Dutch tape image, not in the repository like the others (one file, "OBERON", the "ABC" crack) |
| `GROTTENO.T64` | the German version, "GROTTEN V.OBERON" (and "PIC", its loading picture) |
| `CAVESOFO.T64` | the English version, "CAVES OF OBERON+" (and "CAVES OF OB. DOX", the instructions) |
| `OBERONIN.T64` | the Finnish version, "OBERONIN LUOLAT" (and "OBERONIN L. PIC", its loading picture) |
| `original/oberon_packed.prg` | the Dutch file, $0801-$b2cf, packed |
| `original/grotten_unpacked.prg` | memory after both depackers, $0801-$cfff, at the jump to $1000 |
| `disasm/grotten.prg` | the same with the crack's leftovers at $0801-$0bff replaced by `10 SYS4096`: the Deflower input |
| `original/grotten_de.prg`, `original/grotten_en.prg`, `original/grotten_fi.prg` | the German, English and Finnish games made the same way: memory at the jump to $1000, $0801-$0bff replaced by the same `10 SYS4096` |
| `original/english_version_bitmap.vsf` | a VICE snapshot of the English version's loading picture, not in the repository |
| `disasm/grotten.flo` | the Deflower annotations (Dutch version): every routine, variable and table |
| `release/` | the crunched releases (`make release`), one file per language |
| `disasm/out/` | Deflower's output (`make disasm`), not edited by hand |
| `src/grotten.asm` | the source of all five versions, from `disasm/out/grotten.asm`: edit code here |
| `src/release.asm` | the release image: a build plus its loading picture and the code that shows it |
| `src/nl/`, `src/de/`, `src/en/`, `src/fr/`, `src/fi/` | each language's files, see below |
| `tools/puzzles.py` | puzzle bank <-> text |
| `tools/playfield.py` | cave <-> CharPad project, and a picture of the cave |
| `tools/sprites.py` | sprites <-> SpritePad project |

Each language directory holds:

| File | What |
| --- | --- |
| `text.asm` | `language = "nl"` (`"de"`, `"en"`, `"fr"`, `"fi"`) and all texts, as `.segment`s that `grotten.asm` puts in place |
| `sprites.bin`, `charset.bin`, `map.bin`, `tile_chars.bin`, `tile_colours.bin` | the graphics and the cave |
| `puzzles_*.txt` | the four puzzle banks as text |
| `picture.kla` | the loading picture, a Koala file (any Koala paint program edits it) |

`src/grotten.asm` was copied from `disasm/out/` once and has since been changed for
the languages (texts moved out) and the English engine (see below). Running
Deflower again doesn't touch it; copy over by hand only what changed in the
annotations, or edits get lost.

## Building

```
make            # build/nl.prg, build/de.prg, build/en.prg, build/fr.prg,
                # build/fi.prg: load at $0801, RUN starts them
make en         # one of them
make release    # release/: grotten_van_oberon.prg, grotten_von_oberon.prg,
                # caves_of_oberon.prg, grottes_d_oberon.prg,
                # oberonin_luolat.prg: each build
                # with its loading picture, crunched with pucrunch
make disasm     # Deflower: 0 differ, 0 gaps
```

64tass, no illegal opcodes (no `-i` needed). The Makefile picks the language
with the include path: `-I src/<language> -I build/<language>`, so
`.include "text.asm"` and `.binary "map.bin"` find that language's files, and
the puzzle banks made from its text files.

The builds no longer match their originals: they share the English engine,
and what the game never uses was taken out (see "Differences from the
original"). The source was last checked byte-identical in git history: the
English build in 28b04fd (`make check`, allowing the tile $44 fix), the Dutch
and German builds with their own engine in b4ae29c, and the Finnish one by
adding it to b4ae29c's source.

The unpacked build fills $0801-$cfff, which the KERNAL loads fine; the crunched
release is one file that unpacks itself and shows the loading picture first.

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
"GEKRAAKT IN 1985 DOOR ABC", now restored, see "Differences from the
original"); nothing else in the game was found changed.

The German and English files are other cracks, unpacked the same way up to the
game's `jmp $1000`. The German one keeps Radarsoft's credit in the status line.
The English one unpacks to a second intro at $1000 ("FILTERMEZZO! BY ZYRON"),
then a trainer menu at $0800 (cursor keys and RETURN); its options poke the
`jsr counter_increment` of the damage ($20ec) and the `jsr counter_decrement`
of the fuel ($2112). `original/grotten_en.prg` is taken with the options off, so those
are the original `jsr`s.

The Finnish file is a fourth crack: `SYS 2061` copies a depacker to the
stack page, which unpacks $0801-$cfff and jumps to $1000 straight away, no
intro or trainer, and the game's own credit stays in the status line. Its
"PIC" file is packed the same way; it shows the picture until space and then
resets the C64 (`jmp $fce2`), for the game to be loaded after it.

## The versions

`src/grotten.asm` builds all five, all with the English engine.

- Dutch and German: the same code. Only the texts and the data differ, and the texts' addresses follow from their lengths (all pointers to
  them are labels).
- English: the same game code ($1000 on), but its engine was sped up. The
  source now only has this engine; the Dutch and German originals had:
  - `start` writes 1000 `lda $ccxx / sta $d8xx` pairs and an `rts` to $6000,
    over the map image it just copied (`colour_copy_write`). `show_screen`
    jumps there; the originals ran a copy loop.
  - `scroll_shift_screen`'s loop is unrolled to the 4 parts at once
    (`scroll_shift_up` / `scroll_shift_down` set up parts 2-4);
    `scroll_carry_opcode` holds 0 instead of `clc` for up.
  - `scroll_shift_colours` shifts the colour RAM into the colour buffer
    instead of the buffer into itself.
  - The barrier animation (the same code) sits after the game code ($23ef)
    instead of at the end of the engine.
- French: new, not from Radarsoft. Made from the English version (its
  engine, graphics, cave and start values); `text.asm`, the puzzle banks and
  the texts in the cave tiles (title, subtitle, credits, congratulations,
  the unused "FAUSSE ROUTE!" sign) are translated. No accents: the fonts have
  none. Words in the puzzles are translated, sums and number rows kept, and
  the keyboard rows (QWERTY..., the C64's own keyboard) too.
- Finnish: a translation of the Dutch version (by whom, the tape doesn't say),
  "Oberonin luolat": the Dutch engine and code, with the texts,
  puzzles and cave tile texts in Finnish. Its character set has Ä on `[` and
  Ö on `\` (`text.asm` writes them that way). It was saved from a fresh
  start. Its `src/fi/` was extracted from the unpacked memory and checked
  byte-identical with the old engine (see Building).

## The loading picture

Each original showed Radarsoft's loading picture, a multicolour bitmap of the
probe ship over the "OBERON" logo, with the title and "C.Kramer" in the
language. The cracks show it in different ways, and the builds left it out;
the releases have it again. The pictures are Koala files, `src/<language>/picture.kla`:

- Dutch: from the crack intro (stage 3 above), which shows it until a key:
  bitmap, screen and colours taken from the unpacked stage. "De Grotten van" /
  "door C.Kramer".
- German: the tape's separate "PIC" file, unpacked in the 6502 emulator.
  "die Grotten von" / "von C.Kramer".
- English: from a VICE snapshot of the picture on screen
  (`original/english_version_bitmap.vsf`): bitmap $e000, screen $cc00, the
  colour RAM from the VIC-II module. "the Caves of" / "by C.Kramer".
- French: new, the English picture with "les Grottes d'" / "par C.Kramer"
  drawn in its two fonts (the l, G, r, d and the p made after the letters
  there).
- Finnish: the tape's "OBERONIN L. PIC" file, unpacked in the 6502 emulator
  (bitmap $6000, screen $5c00, colours $5800, background black). No title
  above the logo, "©1985" / "tekijä C.Kramer" below it.

The first four differ only in those text cells (rows 11-13 and 22-24).

`src/release.asm` puts a build ($0801-$cfff, ending exactly at $d000) and the
picture in one image, in the RAM under the I/O and the KERNAL, so the game
itself doesn't change:

| Address | What |
| --- | --- |
| $d000-$d3e7 | the picture's colours, copied to the colour RAM ($01 switched between $34 and $35 per byte) |
| $d400-$d7e7 | its screen |
| $e000-$ff3f | its bitmap |
| $ff40 | `show_picture` |
| $fffa | NMI, reset and IRQ vectors (`rti`, `show_picture`, `rti`) |

pucrunch unpacks with all RAM banked in (`-g0x35 -i0`: $01 = $35, interrupts
off) and jumps to `show_picture` (`-x0xff40`). It sets VIC bank 3, $d018 = $58,
multicolour bitmap mode, border $0b, then waits for nothing pressed (the RETURN
of RUN), a key or fire on joystick 2, and its release. The last step, $01 =
$37 and `jmp $1000`, runs from the tape buffer ($033c): banking the KERNAL in
from $ff40 would put the ROM under the running code (that crashed: a JAM at
$6c07). The game sets up the VIC itself and copies its map image over
$e000-$ffff at the start; $d000-$dfff is the I/O from then on, so nothing of
the picture stays in use.

## Memory map

| Range | What |
| --- | --- |
| $0400 / $0800 | the two screens, swapped (`$d018` eor $30) when the scroll wraps; sprite pointers at $07f8 / $0bf8 |
| $0c00-$0fff | 16 sprites, pointers $30-$3f (`sprites.bin`) |
| $1000-$26dd | game: title, puzzles, terminals, main loop, status line, texts, barrier animation (Dutch; the others end elsewhere), then zeros |
| $2800-$2fff | charset (`charset.bin`), `$d018` = $1a |
| $3000-$5fff | four puzzle banks of $c00 |
| $6000-$7fff | the map image, copied to $e000-$ffff (RAM under the KERNAL) at the start |
| $8000-$9fff | tile characters (`tile_chars.bin`) |
| $a000-$bfff | tile colours (`tile_colours.bin`) |
| $c000-$c947 | the engine: scrolling, drawing, raster IRQ, frame handler, barriers (then zeros) |
| $cc00-$cfe7 | colour buffer, copied to $d800 when the screens swap (zeros in the file) |
| $fd30-$fd43 | scroll copy tables (copied from `scroll_copy_start_init` at the start) |

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
  (the credits). `message_fuel_low` is shown when the fuel counts down to
  `fuel_low_level` (new, see "Differences from the original").
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
tools/playfield.py en export  # the same for another language (de, en, fr)
```

CharPad colours per character but the game per tile cell, so characters in
more than one colour get copies after 255 (see the tool's help). Characters
$00-$7f are drawn by the game, import ignores them. The ship starts at map
position $e432 (`engine_init`): tile row 8, column 50.

### Sprites

```
tools/sprites.py export     # sprites.spd, a SpritePad 1.8 project
tools/sprites.py import     # back into src/nl/sprites.bin
tools/sprites.py de export  # another language (de, en, fr)
```

16 sprites from $0c00, pointers $30-$3f: $30-$34 the ship (multicolour, $34
is sprite 4's other frame), $35/$36 the status line (rows 6-12 are the
scrolled text, drawn at run time), $37/$38 and $39/$3a the probe arm, $3b an
unused probe frame, $3c-$3f the guardian (a big screw, 4 frames of it turning). The colours and modes are set by the
code (`sprite_colours_init`, `engine_init_sprites`); export shows them in the
project, import only takes the pixels.

## Differences from the original

- The Dutch, German and Finnish versions use the English version's faster engine (see
  "The versions"): the colour copy written out as `lda`/`sta` pairs, the
  unrolled screen shift, the barrier animation after the game code. The faster
  colour copy stays well ahead of the beam; the old loop only just did, with
  less margin on NTSC (shorter border).

- The releases show the loading picture before the game (see "The loading
  picture"): the cracks' intros showed it or left it out, the builds don't
  have it. The French picture is new.

- Tile $44 (a piece of cave wall, used all over the cave): in the German and
  English versions two cells of its row 6 hold characters $31 $30 in colour 0
  instead of spaces in colour $0a, a few stray pixels. They now hold what the
  Dutch version has (`tile_chars.bin` and `tile_colours.bin`, offsets
  $1624/$1625).

- What the game never uses is gone, so the code and data after it moved:
  - `unused_getin`, a `jsr getin` before `title_wait_key` that nothing
    called;
  - three engine bytes nothing read ($c084, $c088, $c08a);
  - `puzzles_test`, a small puzzle list `puzzle_bank` pointed to before a
    difficulty was chosen (it's always set before it's read);
  - the leftovers of an earlier memory image after the game code
    ($2441-$27ff in Dutch) and after the engine ($cb7f-$cbff), the bytes
    after the puzzles in each puzzle bank, and the colour buffer's contents
    in the file (the screen when the version was saved): now zeros;
  - what the variables held when the cracked versions were saved (the
    status scroller's position, a sound effect still running, the fuel
    timer, scroller and answer workspaces): now the values of a fresh start,
    which the German, English and Finnish versions had already.
- The fuel warning (`message_fuel_low`, "MACHINEKAMER MELDT: DE BRANDSTOF
  RAAKT OP" and its translations) was in every version, but no code showed
  it. `update_fuel` now shows it, in red, each time the fuel counts down to
  `fuel_low_level`, "0100": about a minute of fuel left, the fuel counting
  down one every 30 frames (0.6 s). Also after refuelling and running low
  again.
- The Dutch version was saved with the switch (char $ed, which toggles chars
  $fe/$ff) set. It now starts with it off like the other versions
  (`switch_state` 0, chars $fe/$ff in `charset.bin` as in the others).
- The Dutch crack put its own credit in the status line ("GEKRAAKT IN 1985
  DOOR ABC"). It has the game's credit again, as in the other versions:
  "COPYRIGHT 1985 RADARSOFT DOOR C.KRAMER" (`status_message` and
  `message_default`), "DOOR" as on the title screen.
- Every wrong answer at a terminal costs a try, whichever side the guardian
  comes from (`puzzle_wrong`); after three the terminal gets another puzzle.
  The original only counted them when it came from the left, so from the right
  a player could stay stuck on one puzzle.
- The English F3 bank's "QWERTYUIOP@*" is now "QWERTYUIOP" (`@*` left out,
  the rest moved one to the right, still guessing the U). The game can't show
  an `@` in a puzzle: it reads a 0 as the end of the bank, and the font has
  no `@` (it would be a black square).
- When the damage is repaired (one down every 1024 frames from 10 % up),
  `damage_repair` puts the new digits in the status line only while it shows
  the damage. The original always wrote them over the first two characters
  of `status_message`, so another message could show up as "05OMPUTER
  CONTROL ...".
- A new game sets the switch back to off (`switch_state` 0, chars $fe/$ff),
  in `new_game` with the doors. The original kept it as the last game left
  it.
- From standstill the joystick is taken within a frame or two. The scroll
  takes a new direction only at phase 7 of its 8-frame cycle
  (`scroll_latch_direction`), so the original could wait up to 8 frames
  (0.16 s), and a short push could get lost. Now, while the ship stands
  still, `scroll_fine` restarts the cycle at phase 7 as soon as the joystick
  is pushed; nothing is half-shifted then, so it is the same as pushing just
  before phase 7. Changing direction while moving still waits for phase 7.

  This only makes the start quick in the direction the ship last moved. A
  stop leaves the fine scroll at that direction's far edge (`scroll_y` 7
  after moving down, 0 after moving up), so it has 7 pixels to go before the
  screen swap at phase 7: 8 pixels a cycle. The opposite way it is already
  at the edge: it waits about 7 frames while the other screen is prepared,
  and the swap moves it 1 pixel. So a short push moves the ship 1 or 8
  pixels, never in between, as in the original.
- Small clean-ups that change nothing a player sees:
  - `damage_message_shown`, written but never read, is gone;
  - the VIC collision registers ($d01e/$d01f) were written, which does
    nothing (reading clears them): `frame_collisions` only reads them, and
    `new_game_reset` reads both to clear what's left from the last game;
  - `new_game_reset` set the NMI vector twice, `engine_init` cleared
    `barrier_closing` twice, and a few `lda` loads were overwritten before
    use;
  - at top speed (`engine_noise_rate` $10) `frame_joystick` jumped into
    `frame_engine_up` with the noise rate in A, setting the engine pitch's
    low byte to $15 each frame (it is about $02 when the top speed is
    reached); it now leaves the pitch alone.

## Bugs found

All are fixed, see "Differences from the original".

- `puzzle_wrong`: when the guardian comes from the right, `puzzle_tries`
  isn't counted down, so in that case a wrong answer never moves on to another
  puzzle.
- The English F3 bank has a puzzle "QWERTYUIOP@*" (the keyboard's top row)
  with `@` (screen code 0) in it. A 0 makes `puzzle_char` go back to the start
  of the bank, so the game shows the first puzzle's character in that place.
  Showing it as `@` doesn't help either: the font's char for screen code 0 is
  a black square.
- `damage_repair` writes the repaired damage over the first two characters
  of whatever message is showing.
- A new game keeps the switch as the last game left it.
