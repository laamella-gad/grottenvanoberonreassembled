#!/usr/bin/env python3
"""Converts a puzzle bank to and from text.

    tools/puzzles.py export src/puzzles_easy.bin puzzles/easy.txt
    tools/puzzles.py import puzzles/easy.txt src/puzzles_easy.bin

A bank is $c00 bytes: puzzles of 14 screen codes each, a 0 byte after the last
one, then free space. Bit 7 of a screen code marks a character the player has to
find; the terminal shows it as '?'.

In the text file each puzzle is two lines between bars: the 14 characters, and
under them a '^' for each hidden character:

    |  2 + 2 = 4   |
    |          ^   |

Lines starting with '#' are comments. Import fills the rest of the bank with
zeros; export ignores what's there.

A bank holds at most 219 puzzles. The game picks the next puzzle by skipping 1
to 8 of them and starts again at the first after the last, so any number works.
Characters are screen codes $01-$3f: A-Z, digits, space and !"#$%&'()*+,-./:;<=>?
plus [ ] £ ↑ ←. '@' (screen code 0) can't start a puzzle: it ends the bank.
Later in a puzzle the game reads it as the end too and shows the first puzzle's
character in that place instead (the original English F3 bank's QWERTYUIOP@*
did); the font has no @ anyway.
"""
import sys

BANK_SIZE = 0xc00
LENGTH = 14
MAX_PUZZLES = (BANK_SIZE - 1) // LENGTH

# Screen codes $00-$3f
CHARS = '@ABCDEFGHIJKLMNOPQRSTUVWXYZ[£]↑← !"#$%&\'()*+,-./0123456789:;<=>?'


def export(bin_path, txt_path):
    data = open(bin_path, 'rb').read()
    if len(data) != BANK_SIZE:
        sys.exit(f'puzzles: {bin_path} is {len(data)} bytes, not {BANK_SIZE}')
    lines = [f'# {LENGTH} characters a puzzle, ^ marks a hidden one; see tools/puzzles.py', '']
    pos = 0
    while data[pos]:
        puzzle = data[pos:pos + LENGTH]
        if 0 in puzzle:
            print(f'puzzles: puzzle at ${pos:03x} holds an @: the game shows the first puzzle\'s character there')
        if any(c & 0x40 for c in puzzle):
            sys.exit(f'puzzles: puzzle at ${pos:03x} holds a screen code past $3f')
        lines.append('|' + ''.join(CHARS[c & 0x3f] for c in puzzle) + '|')
        lines.append('|' + ''.join('^' if c & 0x80 else ' ' for c in puzzle) + '|')
        pos += LENGTH
    open(txt_path, 'w', encoding='utf-8').write('\n'.join(lines) + '\n')
    print(f'{txt_path}: {pos // LENGTH} puzzles')


def import_(txt_path, bin_path):
    rows = []
    for number, line in enumerate(open(txt_path, encoding='utf-8'), 1):
        line = line.rstrip('\n')
        if not line.strip() or line.startswith('#'):
            continue
        if len(line) != LENGTH + 2 or line[0] != '|' or line[-1] != '|':
            sys.exit(f'{txt_path}:{number}: expected |{LENGTH} characters|')
        rows.append((number, line[1:-1]))
    if len(rows) % 2:
        sys.exit(f'{txt_path}: the last puzzle has no ^ line')

    data = bytearray()
    for (number, text), (marks_number, marks) in zip(rows[::2], rows[1::2]):
        for column, (char, mark) in enumerate(zip(text, marks)):
            if char not in CHARS[column == 0:]:
                sys.exit(f'{txt_path}:{number}: no screen code for {char!r}')
            if mark not in ' ^':
                sys.exit(f'{txt_path}:{marks_number}: only ^ or a space under a character')
            data.append(CHARS.index(char) | (0x80 if mark == '^' else 0))
    count = len(data) // LENGTH
    if count == 0 or count > MAX_PUZZLES:
        sys.exit(f'{txt_path}: {count} puzzles, a bank holds 1 to {MAX_PUZZLES}')
    data.append(0)
    data += bytes(BANK_SIZE - len(data))
    open(bin_path, 'wb').write(data)
    print(f'{bin_path}: {count} puzzles')


if __name__ == '__main__':
    if len(sys.argv) == 4 and sys.argv[1] == 'export':
        export(sys.argv[2], sys.argv[3])
    elif len(sys.argv) == 4 and sys.argv[1] == 'import':
        import_(sys.argv[2], sys.argv[3])
    else:
        sys.exit(__doc__)
