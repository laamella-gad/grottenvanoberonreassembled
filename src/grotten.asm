; the language's texts (src/nl, src/de, src/en or src/fr, chosen by the
; Makefile)
		.include "text.asm"
; the English engine (sped up, see NOTES.md) or the Dutch and German one; the
; French version, made later, uses the English engine
fast_engine = language in ["en", "fr"]
; what some variables held when the version was saved (kept, so that each
; build is identical to its original)
		.include "saved.asm"

; CINT after the VIC: screen editor variables, clear screen
; called by: reset_system
kernal_init_editor = $e51b

; the second half of CINT's VIC set up: the VIC registers from the KERNAL's table
; called by: reset_system
kernal_init_vic = $e5aa

; the KERNAL interrupt handler: cursor, jiffy clock, keyboard
; jumped to by: frame_done, scroll_phase_done
kernal_irq = $ea31

; part of UDTIM: reads the keyboard row of the STOP key into STKEY ($91)
; called by: nmi_restore_game
kernal_scan_stop = $f6bc

; ---------------------------------------------------------------- ROM
; IOINIT: CIA set up, SID volume off
; called by: reset_system
kernal_ioinit = $fda3

; the end of the KERNAL's NMI handler: restore the registers, rti
; jumped to by: nmi_kernal
kernal_nmi_return = $fe72

; called by: reset_system, print_text_char
chrout = $ffd2

; called by: nmi_restore_game
stop = $ffe1

; called by: unused_getin, title_wait_key, game_won_loop
getin = $ffe4

.virtual $0001
; which ROMs and I/O are banked in
; read by: draw_screen, draw_screen_call, scroll_shift_screen, scroll_draw_rows, scroll_draw_rows_done, scroll_draw_columns, scroll_draw_columns_done
; written by: draw_screen, draw_screen_call, scroll_shift_screen, scroll_draw_rows, scroll_draw_rows_done, scroll_draw_columns, scroll_draw_columns_done
cpu_port:		.byte	?
.endv

.virtual $0099
; written by: reset_system
input_device:		.byte	?
; current device number and input device, set like the KERNAL's reset does
; written by: reset_system
output_device:		.byte	?
.endv

.virtual $009d
; KERNAL message mode: 0 = no messages
; written by: reset_system
kernal_message_mode:		.byte	?
.endv

.virtual $00fb
; ---------------------------------------------------------------- zero page and system
; pointer to the digits of a counter (counter_increment, counter_decrement)
; read by: counter_increment_digit, counter_increment_done, counter_decrement_digit, counter_decrement_done
; written by: counter_increment, counter_decrement
counter_ptr:		.word	?
.endv

.virtual $0291
; SHFLAG mode: $80 = shift/commodore doesn't switch character sets
; written by: new_game_reset
shift_mode:		.byte	?
.endv

.virtual $0314
; written by: reset_system, draw_screen
irq_vector:		.addr	?
.endv

.virtual $0318
; written by: title, new_game_reset
nmi_vector:		.addr	?
.endv

.virtual $0328
; written by: title, engine_init
stop_vector:		.addr	?
.endv

.virtual $0400
; written by: clear_screen_black_loop, engine_clear_screens
screen_ram:
		.fill	1000
.endv

.virtual $07f8
; read by: main_loop, guardian_right, probe_active, animate_barrier
; written by: guardian_animate, probe_active, probe_up, probe_left, probe_right, engine_init_sprites, animate_barrier
sprite_pointers:
		.fill	8
.endv
; written by: engine_clear_screens
screen_2 = $0800
*=$0801

; ---------------------------------------------------------------- sprites and second screen
; The BASIC line that starts the game: 10 SYS4096
basic_sys:
		.byte	$0b, $08, $0a, $00, $9e, $34, $30, $39, $36, $00, $00, $00
; written by: engine_clear_screens
screen_2_unused:
		.byte	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte	$00, $00, $00
; VIC: screen 1 at $0400, screen 2 at $0800 (double buffered scrolling), charset $2800.
; The sprite pointers on screen 2 are written next to those on screen 1.
; written by: engine_init_sprites
screen_2_sprite_pointers = $0bf8
; written by: animate_barrier
screen_2_sprite_4 = $0bfc
; written by: probe_active, probe_up, probe_left, probe_right
screen_2_sprite_6 = $0bfe
; written by: guardian_animate
screen_2_sprite_7 = $0bff

; 16 sprites, pointers $30-$3f:
;   $30-$33 ship hull (sprites 2-5, multicolour), $34/$35 status-line scroller
;   halves (sprites 0/1, the text is shifted into rows 6-12 of $35 and $36),
;   $37-$3a probe arm (sprite 6) frames, $3c-$3f guardian (sprite 7) frames.
; modified by: status_shift_loop
sprites:
		.binary	"sprites.bin"
; the status line's text is rotated through rows 6-12 of sprites $35 and $36
; written by: status_sprites_clear_loop
status_sprites = $0d40
; modified by: status_shift_loop
status_sprite_left_row_6 = $0d52
; modified by: status_shift_loop
status_sprite_right_row_6 = $0d92

; ---------------------------------------------------------------- start and title
; Entry point: copies the map to the RAM under the KERNAL, hides the scroll
; tables there too, then shows the title.
start:
		jsr reset_system
		ldy #$00
		ldx #$20
; jumped to by: start_copy_store
; modified by: start_copy_store
start_copy_loop:
		lda map_image, y	; operand set by start_copy_store
start_copy_store:
		sta map, y	; operand set by start_copy_store
		dey 
		bne start_copy_loop
		inc start_copy_loop + 2
		inc start_copy_store + 2
		dex
		bne start_copy_loop
.if fast_engine
; The English version writes the colour copy out as 1000 lda/sta pairs, then
; rts, over the map image (copied already); show_screen jumps to it. Faster
; than show_screen's loop.
colour_copy_write:
		lda #$ad	; lda abs
		jsr colour_copy_put
		lda colour_copy_low
		jsr colour_copy_put
		lda colour_copy_source
		jsr colour_copy_put
		lda #$8d	; sta abs
		jsr colour_copy_put
		lda colour_copy_low
		jsr colour_copy_put
		lda colour_copy_dest
		jsr colour_copy_put
		inc colour_copy_low
		bne colour_copy_count_down
		inc colour_copy_source
		inc colour_copy_dest
colour_copy_count_down:
		lda colour_copy_count
		bne +
		dec colour_copy_count + $1
+		dec colour_copy_count
		lda colour_copy_count
		ora colour_copy_count + $1
		bne colour_copy_write
		lda #$60	; rts
		jsr colour_copy_put
		jmp start_tables

; stores a byte of the colour copy
colour_copy_put:
		sta map_image	; operand counted up
		inc colour_copy_put + $1
		bne +
		inc colour_copy_put + $2
+		rts

colour_copy_source:
		.byte	>colour_buffer
colour_copy_dest:
		.byte	>color_ram
colour_copy_count:
		.word	1000
colour_copy_low:
		.byte	$00
start_tables:
colour_copy = map_image
.endif
		ldy #$13
start_copy_tables:
		lda scroll_copy_start_init, y
		sta scroll_copy_start, y
		lda #$00
		sta scroll_copy_start_init, y
		dey 
		bpl start_copy_tables
; jumped to by: game_won_loop, nmi_restore_game
restart:
		jmp title

; resets the KERNAL I/O, VIC and screen editor, puts back the KERNAL IRQ,
; silences the SID; charset: upper/lower case
; called by: start, title, game_won
reset_system:
		lda #$93
		jsr chrout
		sei 
		jsr kernal_ioinit
		lda #$03
		sta output_device
		lda #$00
		sta input_device
		ldx #$20
		jsr kernal_init_vic
		jsr kernal_init_editor
		lda #<kernal_irq
		sta irq_vector
		lda #>kernal_irq
		sta irq_vector + $1
		cli 
		lda #$00
		sta kernal_message_mode
		lda #$15
		sta vic_memory_setup
		lda #$08
		jsr chrout
		ldx #$18
		lda #$00
reset_system_sid:
		sta voice1_frequency, x
		dex 
		bpl reset_system_sid
		rts 

; title screen: no RUN/STOP, RESTORE goes back to the title
; jumped to by: restart
title:
		lda #$e6
		sta stop_vector
		jsr reset_system
		sei 
		lda #<nmi_rti
		sta nmi_vector
		lda #>nmi_rti
		sta nmi_vector + $1
		cli 
		jsr clear_screen_black
		lda #<title_text
		sta print_text + 1
		lda #>title_text
		sta print_text + 2
		jsr print_text
		jmp title_wait_key

; prints the text at print_text + 1 up to a 0 byte via CHROUT
; called by: title, game_won
; jumped to by: print_text_char
; written by: title, game_won
; modified by: print_text_char
print_text:
		lda $ffff	; operand set by title, print_text_char, game_won
		bne print_text_char
		rts 

; jumped to by: print_text
print_text_char:
		jsr chrout
		inc print_text + 1
		bne print_text
		inc print_text + 2
		jmp print_text

; next background colour of the title's colour cycle
; called by: title_wait_key, game_won_loop
cycle_background:
		inc title_colour_index
		lda title_colour_index
		and #$07
		tax 
		lda title_colours, x
		sta background_color
		rts 

; never called: a GETIN left over
unused_getin:
		jsr getin
; waits for F1, F3, F5 or F7
; jumped to by: title
title_wait_key:
		jsr cycle_background
		jsr getin
		beq title_wait_key
		cmp #$85
		beq title_f1
		cmp #$86
		beq title_f3
		cmp #$87
		beq title_f5
		cmp #$88
		beq title_f7
		jmp title_wait_key

; jumped to by: title_wait_key
title_f1:
		lda #$00
		ldx #$30
		ldy #$b1
		jmp start_difficulty

; jumped to by: title_wait_key
title_f3:
		lda #$00
		ldx #$3c
		ldy #$b2
		jmp start_difficulty

; jumped to by: title_wait_key
title_f5:
		lda #$00
		ldx #$48
		ldy #$b3
		jmp start_difficulty

; jumped to by: title_wait_key
title_f7:
		lda #$00
		ldx #$54
		ldy #$b4
; A/X: puzzle bank, Y: the difficulty digit (reversed '1'-'4') shown in the cave
; jumped to by: title_f1, title_f3, title_f5
start_difficulty:
		sta puzzle_bank
		stx puzzle_bank + $1
		sta puzzle_char + 1
		stx puzzle_char + 2
		sty difficulty_tile
		sty difficulty_tile_2
		jmp engine_start

; read by: cycle_background
title_colours:
		.byte	$01, $02, $03, $04, $05, $07, $0a, $0f
; read by: cycle_background
; modified by: cycle_background
title_colour_index:		.byte	$00

; title text, PETSCII: clear, upper/lower case off, colours, F-keys menu
title_text:
		#text_title

; ---------------------------------------------------------------- end of game: won
; "proficiat": the end text and a random beeping tune until a key is pressed
; jumped to by: probe_goal
game_won:
		jsr reset_system
		jsr clear_screen_black
		lda #<won_text
		sta print_text + 1
		lda #>won_text
		sta print_text + 2
		jsr print_text
		lda #$32
		sta voice3_frequency
		lda #$10
		sta voice3_control
		lda #$01
		sta voice1_pulse_width + $1
		lda #$8f
		sta sid_vol_filter
		lda #$f0
		sta voice1_sustain_release
		lda #$41
		sta voice1_control
game_won_loop:
		jsr cycle_background
		lda voice3_oscillator
		sta won_tone
		lda #$00
		sta won_tone + $1
		asl won_tone
		rol won_tone + $1
		asl won_tone
		rol won_tone + $1
		clc 
		lda won_tone
		adc #$28
		sta voice1_frequency
		lda won_tone + $1
		adc #$23
		sta voice1_frequency + $1
		jsr getin
		beq game_won_loop
		jmp restart

; read by: game_won_loop
; written by: game_won_loop
; modified by: game_won_loop
won_tone:
		.word	$0000

; black screen of reversed spaces in black
; called by: title, game_won
clear_screen_black:
		lda #$00
		sta border_color
		sta background_color
		ldy #$00
clear_screen_black_loop:
		lda #$00
		sta color_ram, y
		sta color_ram + $100, y
		sta color_ram + $200, y
		sta color_ram + $300, y
		lda #$a0
		sta screen_ram, y
		sta screen_ram + $100, y
		sta screen_ram + $200, y
		sta screen_ram + $300, y
		dey 
		bne clear_screen_black_loop
		rts 

won_text:
		#text_won

; Copied to $fd30 (RAM under the KERNAL) at the start and cleared here, read by
; scroll_shift_screen: per scroll direction the start index and the low byte
; of the source of the 4 x 250 byte screen copy.
; read by: start_copy_tables
; written by: start_copy_tables
scroll_copy_start_init:
		.byte	$00, $f9, $00, $01, $00, $f9, $f9, $01, $00, $f9
scroll_copy_source_init:
		.byte	$29, $c7, $01, $01, $28, $c6, $ee, $01, $28, $c6

; ---------------------------------------------------------------- puzzle terminal
; The probe touched a terminal (char $eb): solve the puzzle. puzzle_state:
; 1 = wait for the fire button to be pressed, 2 = edit (left/right move the
; cursor, up/down change a hidden character), fire again = check.
; jumped to by: probe_active
puzzle_terminal:
		lda puzzle_state
		cmp #$01
		bne puzzle_terminal_edit
		lda cia1_port_a
		and #$10
		beq puzzle_terminal_reset_cursor
		inc puzzle_state
; jumped to by: puzzle_terminal
puzzle_terminal_reset_cursor:
		lda #$00
		sta puzzle_cursor
		sta puzzle_cursor_old
		jmp update_status

; jumped to by: puzzle_terminal
puzzle_terminal_edit:
		cmp #$02
		beq puzzle_terminal_editing
		jmp puzzle_terminal_check

; jumped to by: puzzle_terminal_edit
puzzle_terminal_editing:
		lda cia1_port_a
		and #$10
		bne puzzle_terminal_cursor_wait
		inc puzzle_state
		jmp update_status

; jumped to by: puzzle_terminal_editing
puzzle_terminal_cursor_wait:
		dec cursor_delay
		beq puzzle_terminal_move
		jmp update_status

; jumped to by: puzzle_terminal_cursor_wait
puzzle_terminal_move:
		lda #$04
		sta cursor_delay
		lda cia1_port_a
		and #$08
		bne puzzle_terminal_left
		inc puzzle_cursor
		lda puzzle_cursor
		cmp #$0e
		bne puzzle_cursor_moved_right
		lda #$00
		sta puzzle_cursor
; jumped to by: puzzle_terminal_move
puzzle_cursor_moved_right:
		jmp puzzle_draw_cursor

; jumped to by: puzzle_terminal_move
puzzle_terminal_left:
		lda cia1_port_a
		and #$04
		bne puzzle_terminal_change
		dec puzzle_cursor
		bpl puzzle_cursor_moved_left
		lda #$0d
		sta puzzle_cursor
; jumped to by: puzzle_terminal_left
puzzle_cursor_moved_left:
		jmp puzzle_draw_cursor

; read by: puzzle_wrap
; written by: start_difficulty
puzzle_bank:
		.word	puzzles_test

; written by: puzzle_next
; modified by: puzzle_next_check
puzzle_skip:
		.byte	$00
; wrong answers left before the next puzzle
; written by: puzzle_next_check
; modified by: puzzle_wrong
puzzle_tries:		.byte	$02

; A = character Y of the current puzzle; the pointer wraps to puzzle_bank at a 0
; called by: puzzle_terminal_change, puzzle_check_loop, puzzle_next_check, puzzle_show_loop
; jumped to by: puzzle_wrap
; read by: puzzle_next_loop
; written by: start_difficulty, puzzle_wrap, puzzle_next_loop
; modified by: puzzle_next_loop
puzzle_char:
		lda $ffff, y	; operand set by start_difficulty, puzzle_wrap, puzzle_next_loop
		beq puzzle_wrap
		rts 

; jumped to by: puzzle_char
puzzle_wrap:
		lda puzzle_bank
		sta puzzle_char + 1
		lda puzzle_bank + $1
		sta puzzle_char + 2
		jmp puzzle_char

; up/down only change a hidden character
; jumped to by: puzzle_terminal_left
puzzle_terminal_change:
		ldy puzzle_cursor
		jsr puzzle_char
		and #$80
		bne puzzle_letter_previous
		jmp puzzle_terminal_done

; joystick down: the previous letter
; jumped to by: puzzle_terminal_change
puzzle_letter_previous:
		lda cia1_port_a
		and #$02
		bne puzzle_letter_next
		ldy puzzle_cursor
		sec 
		lda answer, y
		sbc #$01
		and #$3f
		bne puzzle_letter_previous_set
		lda #$3f
; jumped to by: puzzle_letter_previous
puzzle_letter_previous_set:
		sta answer, y
		jmp puzzle_draw_changed

; joystick up: the next letter
; jumped to by: puzzle_letter_previous
puzzle_letter_next:
		lda cia1_port_a
		and #$01
		bne puzzle_terminal_done
		ldy puzzle_cursor
		clc 
		lda answer, y
		adc #$01
		and #$3f
		bne puzzle_letter_next_set
		lda #$01
; jumped to by: puzzle_letter_next
puzzle_letter_next_set:
		sta answer, y
		jmp puzzle_draw_changed

; jumped to by: puzzle_cursor_moved_right, puzzle_cursor_moved_left
puzzle_draw_cursor:
		ldy puzzle_cursor_old
		lda #$00
		sta glyph_reverse
		lda answer, y
		jsr puzzle_draw_char
		ldy puzzle_cursor
		sty puzzle_cursor_old
; jumped to by: puzzle_letter_previous_set, puzzle_letter_next_set
puzzle_draw_changed:
		lda #$ff
		sta glyph_reverse
		lda answer, y
		jsr puzzle_draw_char
		lda #$81
		sta voice2_control
		lda #$01
		sta sfx_time
		lda #$00
		sta sfx_time + $1
		sta sfx_frequency
		lda #$30
		sta sfx_frequency + $1
; jumped to by: puzzle_terminal_change, puzzle_letter_next
puzzle_terminal_done:
		jmp update_status

; jumped to by: puzzle_terminal_edit
puzzle_terminal_check:
		lda cia1_port_a
		and #$10
		bne puzzle_terminal_compare
		jmp update_status

; jumped to by: puzzle_terminal_check
puzzle_terminal_compare:
		lda #$00
		sta puzzle_state
		ldy #$0d
puzzle_check_loop:
		sec 
		jsr puzzle_char
		sbc answer, y
		and #$3f
		bne puzzle_wrong
		dey 
		bpl puzzle_check_loop
		jsr puzzle_next
		jmp puzzle_solved

; skips 1-8 puzzles (a random count from the TOD clock's tenths) and gives 3 tries
; called by: puzzle_check_loop, puzzle_wrong, new_game_reset
puzzle_next:
		lda cia1_tod_tenths
		and #$07
		sta puzzle_skip
; jumped to by: puzzle_next_check
puzzle_next_loop:
		clc 
		lda puzzle_char + 1
		adc #$0e
		sta puzzle_char + 1
		bcc puzzle_next_check
		inc puzzle_char + 2
; jumped to by: puzzle_next_loop
puzzle_next_check:
		ldy #$00
		jsr puzzle_char
		dec puzzle_skip
		bpl puzzle_next_loop
		lda #$02
		sta puzzle_tries
		rts 

; right: the door opens for a while
; jumped to by: puzzle_check_loop
puzzle_solved:
		jsr status_sprites_clear
		lda #$00
		ldx #<message_solved
		ldy #>message_solved
		jsr show_message
		jsr sound_solved
		lda #$ff
		sta door_timer_count
		lda #$00
		ldy #$07
puzzle_solved_open_door:
		sta door_char, y
		dey 
		bpl puzzle_solved_open_door
; jumped to by: puzzle_wrong, guardian_start
puzzle_terminal_exit:
		jsr puzzle_display_clear
		jmp update_status

; wrong: unless it is already there, the guardian (sprite 7) comes in from the
; left or the right, chosen by bit 0 of the map position. Only coming from the
; left costs a try: from the right puzzle_tries isn't counted down (a bug?).
; jumped to by: puzzle_check_loop
puzzle_wrong:
		lda vic_sprite_enable
		and #$80
		bne puzzle_terminal_exit
		lda map_position
		and #$01
		beq guardian_from_right
		lda #$00
		sta vic_sprite_x_high_bits
		sta guardian_left
		sta vic_sprite_coords + $e
		dec puzzle_tries
		bpl guardian_start
		jsr puzzle_next
		jmp guardian_start

; jumped to by: puzzle_wrong
guardian_from_right:
		lda #$01
		sta guardian_left
		lda #$80
		sta vic_sprite_x_high_bits
		lda #$8c
		sta vic_sprite_coords + $e
; jumped to by: puzzle_wrong
guardian_start:
		lda #$00
		sta sfx_step
		sta sfx_time + $1
		sta sfx_frequency
		lda #$be
		sta sfx_frequency + $1
		lda #$11
		sta voice2_control
		lda #$b4
		sta sfx_time
		lda #$ff
		sta sfx_step + $1
		lda #$7d
		sta vic_sprite_coords + $f
		lda #$bf
		sta vic_sprite_enable
		jmp puzzle_terminal_exit

; clears the puzzle display (chars $db-$e8) and the switch char $f3
; called by: puzzle_terminal_exit, fuel_tank, radar, new_game_reset
puzzle_display_clear:
		lda #$00
		ldy #$07
puzzle_display_clear_light:
		sta switch_light_char, y
		dey 
		bpl puzzle_display_clear_light
		ldy #$6f
puzzle_display_clear_loop:
		sta puzzle_display, y
		dey 
		bpl puzzle_display_clear_loop
		rts 

; ---------------------------------------------------------------- fuel tank
; The probe touched a fuel tank (char $ef): while the fire button is held, the
; fuel goes up by one and the tank counter is shown in the puzzle display.
; jumped to by: probe_check_fuel_tank
fuel_tank:
		lda cia1_port_a
		and #$10
		beq fuel_tank_fill
		lda #$00
		sta fuel_tank_active
		jsr puzzle_display_clear
		jmp update_status

; jumped to by: fuel_tank
fuel_tank_fill:
		lda #$03
		ldx #<tank_counter
		ldy #>tank_counter
		jsr counter_increment
		lda #$ff
		sta glyph_reverse
		lda #$03
		ldx #<status_fuel
		ldy #>status_fuel
		jsr counter_increment
		lda status_fuel
		cmp #$31
		beq fuel_tank_full
		lda tank_counter + $2
		cmp tank_last_digit
		beq fuel_tank_show
		sta tank_last_digit
		lda #$00
		sta sfx_time + $1
		sta sfx_step + $1
		sta sfx_frequency
		lda #$03
		sta sfx_step
		sta sfx_time
		lda #$11
		sta voice2_control
		lda #$30
		sta sfx_frequency + $1
; jumped to by: fuel_tank_fill
fuel_tank_show:
		ldy #$03
fuel_tank_show_loop:
		lda tank_counter, y
		jsr puzzle_draw_char
		dey 
		bpl fuel_tank_show_loop
		jmp update_status

; fuel 1000 or more: show "VOL!" and set the fuel to 1000
; jumped to by: fuel_tank_fill
fuel_tank_full:
		ldy #$03
fuel_tank_full_loop:
		lda fuel_full_text, y
		jsr puzzle_draw_char
		dey 
		bpl fuel_tank_full_loop
		lda #$30
		sta status_fuel + $1
		sta status_fuel + $2
		sta status_fuel + $3
		jmp update_status

; ---------------------------------------------------------------- radar
; The probe touched a radar screen (char $f0): while fire is held, the ship's
; position on the map blinks as a dot in the puzzle display.
; jumped to by: probe_check_radar
radar:
		lda cia1_port_a
		and #$10
		beq radar_blink
		lda #$00
		sta radar_active
		jsr puzzle_display_clear
		jmp update_status

; jumped to by: radar
radar_blink:
		ldy radar_offset
		dec radar_blink_timer
		bne radar_done
		lda #$10
		sta radar_blink_timer
		lda puzzle_display, y
		eor radar_mask
		sta puzzle_display, y
		beq radar_done
		lda #$00
		sta sfx_frequency
		lda #$80
		sta sfx_frequency + $1
		lda #$11
		sta voice2_control
		lda #$00
		sta sfx_step
		sta sfx_step + $1
		sta sfx_time + $1
		lda #$04
		sta sfx_time
; jumped to by: radar_blink
radar_done:
		jmp update_status

; ---------------------------------------------------------------- ship destroyed
; frame handler after the end of the game: ship explosion, then a new game
; jumped to by: frame_destroyed
ship_explode:
		lda #$ff
		sta destroyed_timer
		lda #$80
		sta voice1_control
		lda explode_step
		cmp #$41
		bne ship_explode_step
		jmp engine_start

; jumped to by: ship_explode
ship_explode_step:
		inc explode_step
		lda #$00
		sta vic_sprite_priority
		lda vic_sprite_enable
		and #$bc
		sta vic_sprite_enable
		inc vic_sprite_colors + $2
		inc vic_sprite_colors + $3
		inc vic_sprite_colors + $4
		inc vic_sprite_colors + $5
		inc vic_sprite_coords + $b
		inc vic_sprite_coords + $b
		dec vic_sprite_coords + $9
		dec vic_sprite_coords + $9
		dec vic_sprite_coords + $4
		dec vic_sprite_coords + $4
		inc vic_sprite_coords + $6
		bne ship_explode_move
		lda vic_sprite_x_high_bits
		ora #$08
		sta vic_sprite_x_high_bits
; jumped to by: ship_explode_step
ship_explode_move:
		inc vic_sprite_coords + $6
		bne ship_explode_done
		lda vic_sprite_x_high_bits
		ora #$08
		sta vic_sprite_x_high_bits
; jumped to by: ship_explode_move
ship_explode_done:
		jmp animate

; ---------------------------------------------------------------- game variables and status line
; the tank counter's last digit when the fill sound was last started
; read by: fuel_tank_fill
; written by: fuel_tank_fill
tank_last_digit:
		.byte	$00
; written by: radar_blink
; modified by: radar_blink
radar_blink_timer:		.byte	$08
; 1 while the probe is out
; read by: probe_direction
; written by: probe_extend, probe_retract
probe_out:		.byte	$00
; the cursor in the puzzle (0-13) and where it was
; read by: puzzle_terminal_move, puzzle_terminal_change, puzzle_letter_previous, puzzle_letter_next, puzzle_draw_cursor
; written by: puzzle_terminal_reset_cursor, puzzle_terminal_move, puzzle_terminal_left
; modified by: puzzle_terminal_move, puzzle_terminal_left
puzzle_cursor:		.byte	$00
; read by: puzzle_draw_cursor
; written by: puzzle_terminal_reset_cursor, puzzle_draw_cursor
puzzle_cursor_old:		.byte	$00
; eor between the probe's two animation frames
; read by: probe_active
; written by: probe_up, probe_left, probe_right
probe_frame_eor:		.byte	$00
; high byte of the font address for puzzle_draw_char (0: chars $80-$bf)
; read by: puzzle_draw_char
; written by: puzzle_show_light
glyph_high:		.byte	$00
; $ff draws the character reversed (the cursor)
; read by: puzzle_draw_char_loop
; written by: puzzle_draw_cursor, puzzle_draw_changed, fuel_tank_fill, puzzle_show_light
glyph_reverse:		.byte	$00

; The status line, 91 characters scrolled through the status sprites:
; fuel, time, damage, then the current message (54 characters, damage first).
; read by: status_next_glyph
status_line:
		#text_status
status_line_end:
		.cerror status_line_end - status_message != 54, "status_message must be 54 characters"
		.cerror status_line_end - status_line > 255, "the status line is too long"

; pixel column (7-0) of the status scroller and its character index (0-$5a)
; written by: intro_frame, status_scroll, show_message
; modified by: intro_frame, status_scroll
status_pixel:
		.byte	saved_status_pixel
; read by: status_scroll
; written by: new_game_reset, show_default_message, show_message
; modified by: status_scroll
status_index:		.byte	saved_status_index

; The messages, 54 characters each, copied to status_message by show_message.
; The first is the normal status: the damage in two digits (counted here) and
; the crack's credits.
; read by: damage_repair
; written by: new_game_reset
		#text_messages
		.cerror message_fuel_low - damage < 54, "message_default must be at least 52 characters"
		.cerror fuel_full_text - message_destroyed != 54, "message_destroyed must be 54 characters"
; shown in the puzzle display when the fuel is 1000 or more
; read by: fuel_tank_full_loop
fuel_full_text:
		#text_fuel_full
		.cerror * - fuel_full_text != 4, "fuel_full_text must be 4 characters"
; the introduction, scrolled through the puzzle display until fire is pressed
; read by: intro_next_char
intro_text:
		#text_intro

; read by: intro_frame, main_loop
; written by: intro_frame, main_loop
last_frame:
		.byte	saved_last_frame
; damage bits seen ($c781 bits 2-5) and 1 when its message is shown
; read by: update_damage_message
; written by: update_damage_message, show_default_message
damage_seen:		.byte	$00
; written by: show_damage_message, show_default_message
damage_message_shown:		.byte	$00
; a character's glyph while it is shifted into the scroller
; written by: intro_copy_glyph, status_copy_glyph
; modified by: intro_shift_loop, status_shift_loop
glyph_buffer:
		.byte	saved_glyph_buffer
		.cerror	* - glyph_buffer != 20
; the player's answer, 14 screen codes
; read by: puzzle_letter_previous, puzzle_letter_next, puzzle_draw_cursor, puzzle_draw_changed, puzzle_check_loop
; written by: puzzle_letter_previous_set, puzzle_letter_next_set, puzzle_show_hidden
answer:
		.byte	saved_answer
		.cerror	* - answer != 14
; a test bank of puzzles, puzzle_bank's value before a difficulty is chosen
puzzles_test:
		.byte	$20, $31, $2b, $32, $2b, $33, $2b, $34, $2b, $b2, $3d, $31, $32, $20, $20, $32
		.byte	$20, $20, $35, $20, $20, $b8, $20, $31, $31, $20, $31, $34, $20, $31, $30, $32
		.byte	$20, $58, $20, $b5, $20, $3d, $20, $35, $31, $30, $31, $4b, $57, $41, $52, $54
		.byte	$4a, $45, $3d, $30, $2c, $b2, $b5, $00

; ---------------------------------------------------------------- new game
; From the engine set up: reset the clock, fuel 1000, damage 0, first puzzle.
; The first time the introduction scrolls through the puzzle display.
; jumped to by: engine_init_barrier
new_game:
		lda #$00
		sta intro_shown
		lda #$ff
		ldy #$07
new_game_close_door:
		sta door_char, y
		dey 
		bpl new_game_close_door
; jumped to by: intro_loop
new_game_reset:
		sei 
		lda cia1_timer_b_control
		and #$7f
		sta cia1_timer_b_control
		lda #<nmi_restore_game
		sta nmi_vector
		lda #>nmi_restore_game
		sta nmi_vector + $1
		lda #$80
		sta shift_mode
		lda #$00
		sta cia1_tod_hours
		sta cia1_tod_minutes
		sta cia1_tod_seconds
		sta cia1_tod_tenths
		cli 
		sta vic_background_collision
		sta collisions
		jsr status_sprites_clear
		lda #$00
		sta status_index
		lda #$30
		sta status_fuel + $1
		sta status_fuel + $2
		sta status_fuel + $3
		sta damage
		sta damage + $1
		lda #$31
		sta status_fuel
		lda #$00
		sta puzzle_state
		sta fuel_tank_active
		sta radar_active
		jsr puzzle_display_clear
		jsr show_default_message
		jsr puzzle_next
		lda intro_shown
		beq intro
		lda #<nmi_restore_game
		sta nmi_vector
		lda #>nmi_restore_game
		sta nmi_vector + $1
		jmp main_loop

; read by: new_game_reset
; written by: new_game, intro
intro_shown:
		.byte	$00

; jumped to by: new_game_reset
intro:
		lda #<intro_text
		sta intro_next_char + 1
		lda #>intro_text
		sta intro_next_char + 2
		lda #$01
		sta intro_shown
; jumped to by: intro_frame, intro_shift_loop
intro_loop:
		lda cia1_port_a
		and #$10
		bne intro_frame
		jmp new_game_reset

; jumped to by: intro_loop
intro_frame:
		lda frame_counter
		cmp last_frame
		beq intro_loop
		sta last_frame
		dec status_pixel
		bpl intro_shift
		lda #$07
		sta status_pixel
; written by: intro
; modified by: intro_glyph
intro_next_char:
		lda intro_text	; operand set by intro, intro_next_char, intro_glyph
		bne intro_glyph
		lda #<intro_text
		sta intro_next_char + 1
		lda #>intro_text
		sta intro_next_char + 2
		jmp intro_next_char

; jumped to by: intro_next_char
intro_glyph:
		inc intro_next_char + 1
		bne intro_glyph_address
		inc intro_next_char + 2
; jumped to by: intro_glyph
intro_glyph_address:
		sta intro_copy_glyph + 1
		lda #$00
		sta intro_copy_glyph + 2
		asl intro_copy_glyph + 1
		rol intro_copy_glyph + 2
		asl intro_copy_glyph + 1
		rol intro_copy_glyph + 2
		asl intro_copy_glyph + 1
		rol intro_copy_glyph + 2
		lda intro_copy_glyph + 2
		and #$01
		ora #$2c
		sta intro_copy_glyph + 2
		ldx #$07
; read by: intro_glyph_address
; written by: intro_glyph_address
; modified by: intro_glyph_address
intro_copy_glyph:
		lda $ffff, x	; operand set by intro_glyph_address
		eor #$ff
		sta glyph_buffer, x
		dex 
		bpl intro_copy_glyph
; rotates the glyph into the puzzle display, chars $db-$e8
; jumped to by: intro_frame
intro_shift:
		ldx #$07
intro_shift_loop:
		asl glyph_buffer, x
		rol charset + $740, x
		rol charset + $738, x
		rol charset + $730, x
		rol charset + $728, x
		rol charset + $720, x
		rol charset + $718, x
		rol charset + $710, x
		rol charset + $708, x
		rol charset + $700, x
		rol charset + $6f8, x
		rol charset + $6f0, x
		rol charset + $6e8, x
		rol charset + $6e0, x
		rol puzzle_display, x
		dex 
		bpl intro_shift_loop
		jmp intro_loop

; frames until the next repair
; written by: damage_repair
; modified by: damage_repair
repair_delay:
		.word	$0200

; ---------------------------------------------------------------- main loop
; Once a frame (frame_counter changes): the guardian, the sound effect, the
; door timer, the damage, the probe and the terminals, the clock, fuel and damage,
; the messages and the status scroller.
; jumped to by: new_game_reset, status_shift_loop
main_loop:
		lda frame_counter
		cmp last_frame
		beq main_loop
		sta last_frame
		lda guardian_left
		beq guardian_right
		jsr guardian_move_left
		lda frame_counter
		and #$01
		bne guardian_follow_scroll
		ldy sprite_pointers + $7
		dey 
		jmp guardian_animate

; jumped to by: main_loop
guardian_right:
		jsr guardian_move_right
		lda frame_counter
		and #$01
		bne guardian_follow_scroll
		ldy sprite_pointers + $7
		iny 
; jumped to by: main_loop
guardian_animate:
		tya 
		and #$03
		ora #$3c
		sta sprite_pointers + $7
		sta screen_2_sprite_7
; jumped to by: main_loop, guardian_right
guardian_follow_scroll:
		lda guardian_follow
		cmp #$01
		bne guardian_follow_right
		jsr guardian_move_left
; jumped to by: guardian_follow_scroll
guardian_follow_right:
		lda guardian_follow
		cmp #$02
		bne sound_effect
		jsr guardian_move_right
; jumped to by: guardian_follow_right
sound_effect:
		lda #$00
		sta guardian_follow
		lda sfx_time
		ora sfx_time + $1
		beq sound_effect_off
		lda sfx_time
		bne sound_effect_step
		dec sfx_time + $1
; jumped to by: sound_effect
sound_effect_step:
		dec sfx_time
		clc 
		lda sfx_frequency
		adc sfx_step
		sta sfx_frequency
		sta voice2_frequency
		lda sfx_frequency + $1
		adc sfx_step + $1
		sta sfx_frequency + $1
		sta voice2_frequency + $1
		jmp door_timer

; jumped to by: sound_effect
sound_effect_off:
		lda #$00
		sta voice2_frequency
		sta voice2_frequency + $1
; jumped to by: sound_effect_step
door_timer:
		lda door_timer_count
		beq damage_repair
		dec door_timer_count
		bne damage_repair
		ldy #$07
		lda #$ff
door_close_loop:
		sta door_char, y
		dey 
		bpl door_close_loop
; every 1024 frames the damage goes down by one, while it is 10 % or more
; jumped to by: door_timer
damage_repair:
		lda damage
		cmp #$30
		beq probe
		dec repair_delay
		bne probe
		dec repair_delay + $1
		bne probe
		lda #$04
		sta repair_delay + $1
		ldx #<damage
		ldy #>damage
		lda #$01
		jsr counter_decrement
		lda damage
		sta status_message
		lda damage + $1
		sta status_message + $1
; jumped to by: damage_repair
probe:
		lda puzzle_state
		bne probe_active
		lda fuel_tank_active
		bne probe_active
		lda radar_active
		bne probe_active
		lda cia1_port_a
		and #$10
		beq probe_direction
		jmp probe_retract

; jumped to by: probe
probe_direction:
		lda probe_out
		bne probe_active
		lda cia1_port_a
		and #$02
		bne probe_check_left
		jmp probe_up

; jumped to by: probe_direction
probe_check_left:
		lda cia1_port_a
		and #$04
		bne probe_check_right
		jmp probe_left

; jumped to by: probe_check_left
probe_check_right:
		lda cia1_port_a
		and #$08
		bne probe_none
		jmp probe_right

; jumped to by: probe_check_right
probe_none:
		jmp update_status

; NMI (RESTORE): RUN/STOP + RESTORE goes back to the title
nmi_restore_game:
		pha 
		txa 
		pha 
		tya 
		pha 
		lda #$7f
		sta cia2_irq_control
		ldy cia2_irq_control
		jsr kernal_scan_stop
		jsr stop
		bne nmi_kernal
		jmp restart

; jumped to by: nmi_restore_game
nmi_kernal:
		jmp kernal_nmi_return

nmi_rti:
		rti 

; jumped to by: probe, probe_direction, probe_extend
probe_active:
		lda sprite_pointers + $6
		eor probe_frame_eor
		sta sprite_pointers + $6
		sta screen_2_sprite_6
		inc vic_sprite_colors + $6
		lda puzzle_state
		beq probe_check_fuel_tank
		jmp puzzle_terminal

; jumped to by: probe_active
probe_check_fuel_tank:
		lda fuel_tank_active
		beq probe_check_radar
		jmp fuel_tank

; jumped to by: probe_check_fuel_tank
probe_check_radar:
		lda radar_active
		beq probe_check_touch
		jmp radar

; jumped to by: probe_check_radar
probe_check_touch:
		lda probe_handled
		beq probe_touch
		jmp probe_check_goal

; reads the character at the probe's tip (screen position probe_screen_pos)
; jumped to by: probe_check_touch
probe_touch:
		lda #$01
		sta probe_handled
		lda probe_read_char + 2
		and #$03
		sta probe_read_char + 2
		lda vic_memory_setup
		ror 
		ror 
		and #$0c
		ora probe_read_char + 2
		sta probe_read_char + 2
; read by: probe_touch
; written by: probe_touch, probe_extend
probe_read_char:
		lda $cfff	; operand set by probe_touch, probe_extend
		sta probe_char
		cmp #$ed
		bne probe_check_terminal
		lda switch_state
		beq switch_on
		lda #$00
		sta sfx_frequency
		lda #$18
		sta sfx_frequency + $1
		lda #$c0
		sta sfx_step
		lda #$ff
		sta sfx_step + $1
		lda #$ff
		ldx #$00
		beq switch_set
; the switch (char $ed) toggles the chars $fe/$ff: open or closed
; jumped to by: probe_read_char
switch_on:
		lda #$00
		sta sfx_frequency
		lda #$10
		sta sfx_frequency + $1
		lda #$40
		sta sfx_step
		lda #$00
		sta sfx_step + $1
		lda #$00
		ldx #$ff
; jumped to by: probe_read_char
switch_set:
		ldy #$07
switch_set_open:
		sta switch_chars, y
		dey 
		bpl switch_set_open
		ldy #$07
		txa 
switch_set_closed:
		sta charset + $7f8, y
		dey 
		bpl switch_set_closed
		lda #$11
		sta voice2_control
		lda #$20
		sta sfx_time
		lda #$00
		sta sfx_time + $1
		lda switch_state
		eor #$01
		sta switch_state
		jmp update_status

; jumped to by: probe_read_char
probe_check_terminal:
		cmp #$eb
		bne probe_check_tank
		lda #$01
		sta puzzle_state
		jmp puzzle_show

; jumped to by: probe_check_terminal
probe_check_tank:
		cmp #$ef
		bne probe_check_radar_screen
		lda #$01
		sta fuel_tank_active
		jmp fuel_tank_start

; jumped to by: probe_check_tank
probe_check_radar_screen:
		cmp #$f0
		bne probe_check_goal
		lda #$01
		sta radar_active
		jmp radar_start

; char $c0: the way out of the caves
; jumped to by: probe_check_touch, probe_check_radar_screen
probe_check_goal:
		cmp #$c0
		beq probe_goal
		jmp update_status

; jumped to by: probe_check_goal
probe_goal:
		jmp game_won

; the sound effect on voice 2: frequency, step per frame, frames left
; read by: sound_effect_step
; written by: puzzle_draw_changed, guardian_start, fuel_tank_fill, radar_blink, sound_effect_step, probe_read_char, switch_on, sound_solved
sfx_frequency:
		.word	saved_sfx_frequency
; read by: sound_effect_step
; written by: guardian_start, fuel_tank_fill, radar_blink, probe_read_char, switch_on, sound_solved
sfx_step:		.word	saved_sfx_step
; read by: sound_effect
; written by: puzzle_draw_changed, guardian_start, fuel_tank_fill, radar_blink, switch_set_closed, sound_solved
; modified by: sound_effect, sound_effect_step
sfx_time:		.word	saved_sfx_time

; written by: update_fuel
; modified by: update_fuel
fuel_timer:
		.byte	saved_fuel_timer
; written by: update_status
; modified by: update_status
damage_timer:		.byte	$0a

; a rising tone
; called by: puzzle_solved, probe_open_door
sound_solved:
		lda #$00
		sta sfx_frequency
		sta sfx_step + $1
		sta sfx_time
		lda #$01
		sta sfx_time + $1
		lda #$21
		sta voice2_control
		lda #$80
		sta sfx_step
		lda #$30
		sta sfx_frequency + $1
		rts 

; A/Y: screen position of the probe's tip
; jumped to by: probe_up, probe_left, probe_right
probe_extend:
		sta probe_read_char + 1
		sty probe_read_char + 2
		lda #$01
		sta probe_out
		lda vic_sprite_enable
		ora #$40
		sta vic_sprite_enable
		jmp probe_active

; jumped to by: probe
probe_retract:
		lda vic_sprite_enable
		and #$bf
		sta vic_sprite_enable
		lda #$00
		sta probe_out
		sta probe_handled
; the clock (also drawn in the cave's tiles), fuel, damage and messages
; jumped to by: puzzle_terminal_reset_cursor, puzzle_terminal_editing, puzzle_terminal_cursor_wait, puzzle_terminal_done, puzzle_terminal_check, puzzle_terminal_exit, fuel_tank, fuel_tank_show_loop, fuel_tank_full_loop, radar, radar_done, probe_none, switch_set_closed, probe_check_goal
update_status:
		lda cia1_tod_hours
		and #$1f
		jsr bcd_to_digits
		stx status_hours + $1
		txa 
		ora #$80
		sta clock_tile_hours_2
		sty status_hours
		tya 
		ora #$80
		sta clock_tile_hours
		lda cia1_tod_minutes
		jsr bcd_to_digits
		stx status_minutes + $1
		txa 
		ora #$80
		sta clock_tile_minutes_2
		sty status_minutes
		tya 
		ora #$80
		sta clock_tile_minutes
		lda cia1_tod_seconds
		jsr bcd_to_digits
		stx status_seconds + $1
		txa 
		ora #$80
		sta clock_tile_seconds_2
		sty status_seconds
		tya 
		ora #$80
		sta clock_tile_seconds
		lda cia1_tod_tenths
		lda collisions
		and #$3c
		beq update_fuel
		dec damage_timer
		bne update_fuel
		lda #$02
		sta damage_timer
		ldx #<damage
		ldy #>damage
		lda #$01
		jsr counter_increment
		bcc update_fuel
		lda #$01
		sta game_over
		jsr status_sprites_clear
		lda #$09
		ldx #<message_destroyed
		ldy #>message_destroyed
		jsr show_message
; jumped to by: update_status
update_fuel:
		dec fuel_timer
		bne update_damage_message
		lda #$1e
		sta fuel_timer
		ldx #<status_fuel
		ldy #>status_fuel
		lda #$03
		jsr counter_decrement
		bcc update_damage_message
		lda #$01
		sta game_over
		jsr status_sprites_clear
		lda #$09
		ldx #<message_out_of_fuel
		ldy #>message_out_of_fuel
		jsr show_message
; jumped to by: update_fuel
update_damage_message:
		lda collisions
		and #$3c
		beq probe_message
		ora damage_seen
		sta damage_seen
		cmp #$10
		bne damage_message_bottom
		ldx #<message_damage_top
		ldy #>message_damage_top
; jumped to by: damage_message_bottom, damage_message_right, damage_message_left, damage_message_all
show_damage_message:
		lda #$02
		jsr show_message
		jsr status_sprites_clear
		lda #$01
		sta damage_message_shown
		jmp probe_message

; jumped to by: update_damage_message
damage_message_bottom:
		cmp #$20
		bne damage_message_right
		ldx #<message_damage_bottom
		ldy #>message_damage_bottom
		jmp show_damage_message

; jumped to by: damage_message_bottom
damage_message_right:
		cmp #$08
		bne damage_message_left
		ldx #<message_damage_right
		ldy #>message_damage_right
		jmp show_damage_message

; jumped to by: damage_message_right
damage_message_left:
		cmp #$04
		bne damage_message_all
		ldx #<message_damage_left
		ldy #>message_damage_left
		jmp show_damage_message

; jumped to by: damage_message_left
damage_message_all:
		ldx #<message_damage_all
		ldy #>message_damage_all
		jmp show_damage_message

; jumped to by: update_damage_message, show_damage_message
probe_message:
		lda probe_handled
		beq status_scroll
		lda probe_char
		cmp #$ed
		bne probe_check_door
		jsr status_sprites_clear
		ldx #<message_switch
		ldy #>message_switch
		lda #$00
		jsr show_message
		jmp status_scroll

; jumped to by: probe_message
probe_check_door:
		cmp #$ec
		bne status_scroll
		jsr status_sprites_clear
		lda #$00
		ldx #<message_door_open
		ldy #>message_door_open
		jsr show_message
		ldy #$07
		lda #$00
probe_open_door:
		sta door_char, y
		dey 
		bpl probe_open_door
		jsr sound_solved
		lda #$ff
		sta door_timer_count
; jumped to by: probe_message, probe_check_door, puzzle_show_hidden, fuel_tank_start, radar_add_column
status_scroll:
		dec status_pixel
		bpl status_shift
		lda #$07
		sta status_pixel
		inc status_index
		lda status_index
		cmp #status_line_end - status_line
		bne status_scroll_char
		jsr show_default_message
; jumped to by: status_scroll
status_scroll_char:
		jmp status_next_glyph

; back to the normal status message
; called by: new_game_reset, status_scroll
show_default_message:
		ldx #<damage
		ldy #>damage
		lda #$06
		jsr show_message
		lda #$00
		sta damage_message_shown
		sta status_index
		sta damage_seen
		rts 

; jumped to by: status_scroll_char
status_next_glyph:
		tax 
		lda status_line, x
		sta status_copy_glyph + 1
		lda #$00
		sta status_copy_glyph + 2
		asl status_copy_glyph + 1
		rol status_copy_glyph + 2
		asl status_copy_glyph + 1
		rol status_copy_glyph + 2
		asl status_copy_glyph + 1
		rol status_copy_glyph + 2
		lda status_copy_glyph + 2
		and #$01
		ora #$2c
		sta status_copy_glyph + 2
		ldx #$06
		ldy #$12
; read by: status_next_glyph
; written by: status_next_glyph
; modified by: status_next_glyph
status_copy_glyph:
		lda saved_status_glyph, x	; operand set by status_next_glyph
		eor #$ff
		sta glyph_buffer, y
		dey 
		dey 
		dey 
		dex 
		bpl status_copy_glyph
; jumped to by: status_scroll
status_shift:
		ldx #$12
status_shift_loop:
		asl glyph_buffer, x
		rol sprites + $194, x
		rol sprites + $193, x
		rol status_sprite_right_row_6, x
		rol sprites + $154, x
		rol sprites + $153, x
		rol status_sprite_left_row_6, x
		dex 
		dex 
		dex 
		bpl status_shift_loop
		jmp main_loop

; jumped to by: probe_direction
probe_up:
		lda #$39
		sta sprite_pointers + $6
		sta screen_2_sprite_6
		eor #$3a
		sta probe_frame_eor
		lda #$a0
		sta vic_sprite_coords + $c
		lda #$96
		sta vic_sprite_coords + $d
		lda #$42
		ldy #$06
		jmp probe_extend

; jumped to by: probe_check_left
probe_left:
		lda #$37
		sta sprite_pointers + $6
		sta screen_2_sprite_6
		eor #$38
		sta probe_frame_eor
		lda #$70
		sta vic_sprite_coords + $c
		lda #$83
		sta vic_sprite_coords + $d
		lda #$c3
		ldy #$05
		jmp probe_extend

; jumped to by: probe_check_right
probe_right:
		lda #$37
		sta sprite_pointers + $6
		sta screen_2_sprite_6
		eor #$38
		sta probe_frame_eor
		lda #$ca
		sta vic_sprite_coords + $c
		lda #$83
		sta vic_sprite_coords + $d
		lda #$d0
		ldy #$05
		jmp probe_extend

; the end of the frame handler
; jumped to by: animate, barrier_close, barrier_close_done, barrier_open_next, barrier_open_done
frame_done:
		jmp kernal_irq

; read by: probe_message
; written by: probe_read_char
probe_char:
		.byte	$00
; read by: probe_read_char, switch_set_closed
; written by: switch_set_closed
switch_state:		.byte	saved_switch_state
; 1 when the probe's character was handled
; read by: probe_check_touch, probe_message
; written by: probe_touch, probe_retract
probe_handled:		.byte	$00
; frames until the door closes again
; read by: door_timer
; written by: puzzle_solved, probe_open_door
; modified by: door_timer
door_timer_count:		.byte	$00
; the terminal modes: puzzle (1, 2), fuel tank and radar
; read by: puzzle_terminal, probe, probe_active, frame_joystick
; written by: puzzle_terminal_compare, new_game_reset, probe_check_terminal
; modified by: puzzle_terminal, puzzle_terminal_editing
puzzle_state:		.byte	$00
; read by: probe, probe_check_fuel_tank
; written by: fuel_tank, new_game_reset, probe_check_tank
fuel_tank_active:		.byte	$00
; read by: probe, probe_check_radar
; written by: radar, new_game_reset, probe_check_radar_screen
radar_active:		.byte	$00
; written by: puzzle_terminal_move
; modified by: puzzle_terminal_cursor_wait
cursor_delay:		.byte	$04

; X/Y: the message, A: its colour (sprites 0 and 1)
; called by: puzzle_solved, update_status, update_fuel, show_damage_message, probe_message, probe_check_door, show_default_message, puzzle_show, fuel_tank_start, radar_start
show_message:
		stx show_message_copy + 1
		sty show_message_copy + 2
		sta vic_sprite_colors
		sta vic_sprite_colors + $1
		lda #$00
		sta status_pixel
		lda #status_message - status_line
		sta status_index
		ldx #$35
; written by: show_message
show_message_copy:
		lda $ffff, x	; operand set by show_message
		sta status_message, x
		dex 
		bpl show_message_copy
		rts 

; called by: puzzle_solved, new_game_reset, update_status, update_fuel, show_damage_message, probe_message, probe_check_door, puzzle_show, fuel_tank_start, radar_start
status_sprites_clear:
		lda #$00
		ldx #$7f
status_sprites_clear_loop:
		sta status_sprites, x
		dex 
		bpl status_sprites_clear_loop
		rts 

; A (BCD) -> X ones digit, Y tens digit, as PETSCII
; called by: update_status
bcd_to_digits:
		pha 
		and #$0f
		clc 
		adc #$30
		tax 
		pla 
		ror 
		ror 
		ror 
		ror 
		and #$07
		clc 
		adc #$30
		tay 
		rts 

; adds one to the decimal counter at (counter_ptr) + A; carry set on overflow
; called by: fuel_tank_fill, update_status
counter_increment:
		stx counter_ptr
		sty counter_ptr + $1
		tay 
counter_increment_digit:
		lda (counter_ptr), y
		cmp #$39
		bne counter_increment_done
		lda #$30
		sta (counter_ptr), y
		dey 
		bpl counter_increment_digit
		sec 
		rts 

; jumped to by: counter_increment_digit
counter_increment_done:
		clc 
		adc #$01
		sta (counter_ptr), y
		clc 
		rts 

; subtracts one; carry set on underflow
; called by: damage_repair, update_fuel
counter_decrement:
		stx counter_ptr
		sty counter_ptr + $1
		tay 
counter_decrement_digit:
		lda (counter_ptr), y
		cmp #$30
		bne counter_decrement_done
		lda #$39
		sta (counter_ptr), y
		dey 
		bpl counter_decrement_digit
		sec 
		rts 

; jumped to by: counter_decrement_digit
counter_decrement_done:
		sec 
		sbc #$01
		sta (counter_ptr), y
		clc 
		rts 

; puzzle terminal: show the puzzle with '?' for the hidden characters
; jumped to by: probe_check_terminal
puzzle_show:
		jsr status_sprites_clear
		lda #$00
		ldx #<message_puzzle
		ldy #>message_puzzle
		jsr show_message
		ldy #$07
		lda #$ff
puzzle_show_light:
		sta switch_light_char, y
		dey 
		bpl puzzle_show_light
		lda #$00
		sta glyph_high
		sta glyph_reverse
		ldy #$0d
; jumped to by: puzzle_show_hidden
puzzle_show_loop:
		jsr puzzle_char
		and #$80
		bne puzzle_show_hidden
		jsr puzzle_char

; the bit $xxxx trick: $2c hides the lda #'?' below when the character isn't hidden
bit_skip_2391:
		.byte	$2c

; jumped to by: puzzle_show_loop
puzzle_show_hidden:
		lda #$3f
		sta answer, y
		jsr puzzle_draw_char
		dey 
		bpl puzzle_show_loop
		jmp status_scroll

; draws character A (screen code) at position Y of the puzzle display:
; the font glyph eor glyph_reverse into chars $db-$e8
; called by: puzzle_draw_cursor, puzzle_draw_changed, fuel_tank_show_loop, fuel_tank_full_loop, puzzle_show_hidden
puzzle_draw_char:
		sta puzzle_draw_char_loop + 1
		tya 
		asl 
		asl 
		asl 
		clc 
		adc #$d8
		sta puzzle_glyph_store + 1
		lda #$2e
		adc #$00
		sta puzzle_glyph_store + 2
		lda glyph_high
		sta puzzle_draw_char_loop + 2
		asl puzzle_draw_char_loop + 1
		rol puzzle_draw_char_loop + 2
		asl puzzle_draw_char_loop + 1
		rol puzzle_draw_char_loop + 2
		asl puzzle_draw_char_loop + 1
		rol puzzle_draw_char_loop + 2
		lda puzzle_draw_char_loop + 2
		and #$01
		ora #$2c
		sta puzzle_draw_char_loop + 2
		ldx #$07
; jumped to by: puzzle_glyph_store
; read by: puzzle_draw_char
; written by: puzzle_draw_char
; modified by: puzzle_draw_char
puzzle_draw_char_loop:
		lda $ffff, x	; operand set by puzzle_draw_char
		eor glyph_reverse
; written by: puzzle_draw_char
puzzle_glyph_store:
		sta $ffff, x	; operand set by puzzle_draw_char
		dex 
		bpl puzzle_draw_char_loop
		rts 

; jumped to by: probe_check_tank
fuel_tank_start:
		jsr status_sprites_clear
		lda #$00
		ldx #<message_fuel_tank
		ldy #>message_fuel_tank
		jsr show_message
		lda #$30
		sta tank_counter
		sta tank_counter + $1
		sta tank_counter + $2
		sta tank_counter + $3
		jmp status_scroll

; read by: fuel_tank_fill, fuel_tank_show_loop
; written by: fuel_tank_start
tank_counter:
		.text	"0000"

; jumped to by: probe_check_radar_screen
radar_start:
		jsr status_sprites_clear
		lda #$00
		ldx #<message_radar
		ldy #>message_radar
		jsr show_message
		lda map_position
		ror 
		and #$30
		sta radar_add_column + 1
		lda map_position + $1
		ror 
		and #$0f
; written by: radar_start
radar_add_column:
		ora #$00	; operand set by radar_start
		sta radar_offset
		lda map_position
		ror 
		ror 
		and #$07
		tay 
		lda bit_masks, y
		sta radar_mask
		jmp status_scroll

; offset of the radar dot in the puzzle display's chars and its bit
; read by: radar_blink
; written by: radar_add_column
radar_offset:
		.byte	$00
; read by: radar_blink
; written by: radar_add_column
radar_mask:		.byte	$00
; read by: radar_add_column
bit_masks:
		.byte	$80, $40, $20, $10, $08, $04, $02, $01
.if fast_engine
; the English version has the barrier animation here, after the game
		#barrier_code
.endif
; leftovers of an earlier memory image: the language's leftovers_1.bin, cut
; or padded to fit
leftovers_1:
		.binary	"leftovers_1.bin", 0, $2800 - *
		.fill	$2800 - *, 0
		.cerror	* != $2800, "the code and texts don't fit below the character set"

; the barrier animation and its variables: at the end of the engine, or (the
; English version) after the game
barrier_code .segment
; every other frame: flame animation (sprite 4) and the barrier animation
; jumped to by: ship_explode_done, frame_destroyed_sound, frame_joystick_done
animate:
		lda frame_counter
		and #$01
		bne animate_barrier
		jmp frame_done

; jumped to by: animate
animate_barrier:
		lda sprite_pointers + $4
		eor #$04
		sta sprite_pointers + $4
		sta screen_2_sprite_4
		sei 
		lda barrier_closing
		bne barrier_close
		jmp barrier_open

; jumped to by: animate_barrier
barrier_close:
		ldx barrier_left
		ldy barrier_right
		lda #$ff
		sta charset, x
		sta charset + $80, x
		sta charset + $40, y
		sta charset + $c0, y
		lda #$00
		sta charset + $200, x
		sta charset + $280, x
		sta charset + $240, y
		sta charset + $2c0, y
		ldy barrier_mask_index
		ldx barrier_right_char
		lda barrier_right_masks, y
		sta charset + $100, x
		sta charset + $101, x
		sta charset + $102, x
		sta charset + $103, x
		sta charset + $104, x
		sta charset + $105, x
		sta charset + $106, x
		sta charset + $107, x
		sta charset + $180, x
		sta charset + $181, x
		sta charset + $182, x
		sta charset + $183, x
		sta charset + $184, x
		sta charset + $185, x
		sta charset + $186, x
		sta charset + $187, x
		lda barrier_left_masks, y
		ldx barrier_left_char
		eor #$ff
		sta charset + $340, x
		sta charset + $341, x
		sta charset + $342, x
		sta charset + $343, x
		sta charset + $344, x
		sta charset + $345, x
		sta charset + $346, x
		sta charset + $347, x
		sta charset + $3c0, x
		sta charset + $3c1, x
		sta charset + $3c2, x
		sta charset + $3c3, x
		sta charset + $3c4, x
		sta charset + $3c5, x
		sta charset + $3c6, x
		sta charset + $3c7, x
		lda barrier_left_masks, y
		sta charset + $140, x
		sta charset + $141, x
		sta charset + $142, x
		sta charset + $143, x
		sta charset + $144, x
		sta charset + $145, x
		sta charset + $146, x
		sta charset + $147, x
		sta charset + $1c0, x
		sta charset + $1c1, x
		sta charset + $1c2, x
		sta charset + $1c3, x
		sta charset + $1c4, x
		sta charset + $1c5, x
		sta charset + $1c6, x
		sta charset + $1c7, x
		lda barrier_right_masks, y
		ldx barrier_right_char
		eor #$ff
		sta charset + $300, x
		sta charset + $301, x
		sta charset + $302, x
		sta charset + $303, x
		sta charset + $304, x
		sta charset + $305, x
		sta charset + $306, x
		sta charset + $307, x
		sta charset + $380, x
		sta charset + $381, x
		sta charset + $382, x
		sta charset + $383, x
		sta charset + $384, x
		sta charset + $385, x
		sta charset + $386, x
		sta charset + $387, x
		lda barrier_right
		bne barrier_close_next
		lda #$00
		sta barrier_closing
		jmp frame_done

; jumped to by: barrier_close
barrier_close_next:
		inc barrier_left
		dec barrier_right
		dec barrier_mask_index
		bpl barrier_close_done
		lda #$07
		sta barrier_mask_index
		clc 
		lda barrier_left_char
		adc #$08
		and #$38
		sta barrier_left_char
		sec 
		lda barrier_right_char
		sbc #$08
		and #$38
		sta barrier_right_char
; jumped to by: barrier_close_next
barrier_close_done:
		jmp frame_done

; jumped to by: barrier_open
barrier_open_next:
		lda barrier_left
		bne barrier_open_step
		lda #$01
		sta barrier_closing
		jmp frame_done

; jumped to by: barrier_open_next
barrier_open_step:
		inc barrier_right
		dec barrier_left
		inc barrier_mask_index
		lda barrier_mask_index
		cmp #$08
		bne barrier_open_done
		lda #$00
		sta barrier_mask_index
		sec 
		lda barrier_left_char
		sbc #$08
		and #$38
		sta barrier_left_char
		clc 
		lda barrier_right_char
		adc #$08
		and #$38
		sta barrier_right_char
; jumped to by: barrier_open_step
barrier_open_done:
		jmp frame_done

; jumped to by: animate_barrier
barrier_open:
		ldx barrier_left
		ldy barrier_right
		lda #$00
		sta charset, y
		sta charset + $80, x
		sta charset + $40, x
		sta charset + $c0, y
		lda #$ff
		sta charset + $200, y
		sta charset + $280, x
		sta charset + $240, x
		sta charset + $2c0, y
		ldy barrier_mask_index
		ldx barrier_right_char
		lda barrier_right_masks_open, y
		sta charset + $140, x
		sta charset + $141, x
		sta charset + $142, x
		sta charset + $143, x
		sta charset + $144, x
		sta charset + $145, x
		sta charset + $146, x
		sta charset + $147, x
		sta charset + $100, x
		sta charset + $101, x
		sta charset + $102, x
		sta charset + $103, x
		sta charset + $104, x
		sta charset + $105, x
		sta charset + $106, x
		sta charset + $107, x
		lda barrier_left_masks_open, y
		ldx barrier_left_char
		eor #$ff
		sta charset + $380, x
		sta charset + $381, x
		sta charset + $382, x
		sta charset + $383, x
		sta charset + $384, x
		sta charset + $385, x
		sta charset + $386, x
		sta charset + $387, x
		sta charset + $3c0, x
		sta charset + $3c1, x
		sta charset + $3c2, x
		sta charset + $3c3, x
		sta charset + $3c4, x
		sta charset + $3c5, x
		sta charset + $3c6, x
		sta charset + $3c7, x
		lda barrier_left_masks_open, y
		sta charset + $1c0, x
		sta charset + $1c1, x
		sta charset + $1c2, x
		sta charset + $1c3, x
		sta charset + $1c4, x
		sta charset + $1c5, x
		sta charset + $1c6, x
		sta charset + $1c7, x
		sta charset + $180, x
		sta charset + $181, x
		sta charset + $182, x
		sta charset + $183, x
		sta charset + $184, x
		sta charset + $185, x
		sta charset + $186, x
		sta charset + $187, x
		lda barrier_right_masks_open, y
		ldx barrier_right_char
		eor #$ff
		sta charset + $340, x
		sta charset + $341, x
		sta charset + $342, x
		sta charset + $343, x
		sta charset + $344, x
		sta charset + $345, x
		sta charset + $346, x
		sta charset + $347, x
		sta charset + $300, x
		sta charset + $301, x
		sta charset + $302, x
		sta charset + $303, x
		sta charset + $304, x
		sta charset + $305, x
		sta charset + $306, x
		sta charset + $307, x
		jmp barrier_open_next

; read by: barrier_close
barrier_left_masks:
		.byte	$00, $01, $03, $07, $0f, $1f, $3f, $7f, $ff
; read by: barrier_open
barrier_left_masks_open:
		.byte	$01, $03, $07, $0f, $1f, $3f, $7f, $ff
; read by: barrier_close
barrier_right_masks:
		.byte	$00, $80, $c0, $e0, $f0, $f8, $fc, $fe
; read by: barrier_open
barrier_right_masks_open:
		.byte	$80, $c0, $e0, $f0, $f8, $fc, $fe, $ff
; read by: barrier_close, barrier_open_next, barrier_open
; written by: engine_init_barrier
; modified by: barrier_close_next, barrier_open_step
barrier_left:		.byte	$00
; read by: barrier_close, barrier_open
; written by: engine_init_barrier
; modified by: barrier_close_next, barrier_open_step
barrier_right:		.byte	$3f
; read by: barrier_close, barrier_close_next, barrier_open_step, barrier_open
; written by: engine_init_barrier, barrier_close_next, barrier_open_step
barrier_left_char:		.byte	$00
; read by: barrier_close, barrier_close_next, barrier_open_step, barrier_open
; written by: engine_init_barrier, barrier_close_next, barrier_open_step
barrier_right_char:		.byte	$38
; 1 while the barrier closes
; read by: animate_barrier
; written by: engine_init, engine_init_barrier, barrier_close, barrier_open_next
barrier_closing:		.byte	$00
; read by: barrier_close, barrier_open_step, barrier_open
; written by: engine_init_barrier, barrier_close_next, barrier_open_step
; modified by: barrier_close_next, barrier_open_step
barrier_mask_index:		.byte	$07
.endsegment

; ---------------------------------------------------------------- character set
; $2800-$2bff, chars $00-$7f: barrier characters, set up and animated at run time
; $2c00-$2dff, chars $80-$bf: the font (screen code order), also used by the
; scrollers; $2e00-$2fff, chars $c0-$ff: cave graphics. Chars $db-$e8 are the
; puzzle display, $ee the door, $f3 the switch light, $fe/$ff the switch.
; written by: switch_set_closed, engine_init_barrier, barrier_close, barrier_open
; modified by: intro_shift_loop
charset:
		.binary	"charset.bin"
; read by: status_copy_glyph
font = $2c00
; read by: radar_blink
; written by: puzzle_display_clear_loop, radar_blink
; modified by: intro_shift_loop
puzzle_display = $2ed8
; written by: puzzle_solved_open_door, new_game_close_door, door_close_loop, probe_open_door
door_char = $2f70
; written by: puzzle_display_clear_light, puzzle_show_light
switch_light_char = $2f98
; written by: switch_set_open
switch_chars = $2ff0

; ---------------------------------------------------------------- puzzles
; Four banks of up to 219 puzzles of 14 screen codes, ended by a 0. Bit 7
; marks a character the player has to find. See tools/puzzles.py.
; F1 eenvoudige (easy), F3 normale, F5 pittige (tough), F7 moeilijke (hard)
puzzles_easy:
		.binary	"puzzles_easy.bin"

puzzles_normal:
		.binary	"puzzles_normal.bin"

puzzles_tough:
		.binary	"puzzles_tough.bin"

puzzles_hard:
		.binary	"puzzles_hard.bin"

; ---------------------------------------------------------------- playfield
; The map: 128 x 64 tiles, a byte each (bits 0-6: the tile). Copied to $e000.
; read by: start_copy_loop
map_image:
		.binary	"map.bin"

; 128 tiles of 8 x 8 characters: character (x, y) of tile t is at
; $8000 + ((t >> 5) * 8 + y) * 256 + (t & 31) * 8 + x, its colour at $2000 more.
tile_chars:
		.binary	"tile_chars.bin"
; the clock's digits (reversed) in a tile
; written by: update_status
clock_tile_hours = $9de1
; written by: update_status
clock_tile_hours_2 = $9de2
; written by: update_status
clock_tile_minutes = $9de3
; written by: update_status
clock_tile_minutes_2 = $9de4
; written by: update_status
clock_tile_seconds = $9de5
; written by: update_status
clock_tile_seconds_2 = $9de6
; the difficulty digit (reversed) in a tile
; written by: start_difficulty
difficulty_tile = $9ee3
; written by: start_difficulty
difficulty_tile_2 = $9ee4

tile_colours:
		.binary	"tile_colours.bin"

; ---------------------------------------------------------------- engine
; jumped to by: start_difficulty, ship_explode
engine_start:
		jmp engine_init

; draws the whole screen (25 rows) from the map, with the KERNAL banked out,
; then shows it; also starts the raster IRQ
; called by: engine_init_barrier
draw_screen:
		sei 
		lda #<raster_irq
		sta irq_vector
		lda #>raster_irq
		sta irq_vector + $1
		lda #$7f
		sta cia1_irq_control
		lda #$01
		sta vic_irq_enable
		sta vic_raster
		lda #$10
		ora scroll_y
		sta vic_control_1
		lda cpu_port
		and #$fd
		sta cpu_port
		lda #$18
		sta draw_rows
		jsr draw_top_row
; jumped to by: draw_screen_call
draw_screen_row:
		inc row_tile_y
		lda row_tile_y
		cmp #$08
		bne draw_screen_next
		lda #$00
		sta row_tile_y
		clc 
		lda map_row
		adc map_width
		sta map_row
		lda map_row + $1
		adc map_width + $1
		sta map_row + $1
; jumped to by: draw_screen_row
draw_screen_next:
		clc 
		lda draw_offset
		adc #$28
		sta draw_offset
		sta draw_screen_low
		sta draw_row_store + 1
		bcc draw_screen_call
		inc draw_offset + $1
; jumped to by: draw_screen_next
draw_screen_call:
		lda draw_offset + $1
		jsr draw_row
		dec draw_rows
		bne draw_screen_row
		lda cpu_port
		ora #$03
		sta cpu_port
		jsr show_screen
		rts 

; written by: draw_screen
; modified by: draw_screen_call
draw_rows:
		.byte	$00
; two raster IRQs, at lines $fa and $ff: both set the scroll registers and the
; background colour, every other one also runs the scroll phase and chains to
; the frame handler
; read by: raster_irq_split
; written by: raster_irq
; modified by: raster_irq
raster_index:		.byte	$01
; read by: raster_irq_split
raster_lines:
		.byte	$fa, $ff
; read by: raster_irq_split, scroll_fine_left_check, scroll_fine_right_check
; written by: scroll_fine_left_set, scroll_fine_right_set, engine_init_sprites
scroll_x:		.byte	$02
; read by: draw_screen, raster_irq_split, scroll_fine, scroll_fine_up_check
; written by: scroll_fine_down_set, scroll_fine_up_set, engine_init_sprites
scroll_y:		.byte	$02
; read by: raster_irq_split, frame_destroyed
; written by: frame_destroyed, frame_joystick
background_flash:		.byte	$00
; the scroll direction, joystick bits (0 = up, 1 = down, 2 = left, 3 = right;
; a 0 bit moves), latched at phase 7
; read by: scroll_fine, scroll_fine_up_check, scroll_fine_left_check, scroll_fine_right_check, scroll_phase_5_3_1, scroll_shift_screen, scroll_move_map, scroll_move_map_down, scroll_move_map_left, scroll_move_map_right, scroll_draw_rows, scroll_draw_rows_bottom, scroll_draw_columns, scroll_draw_columns_right
; written by: scroll_latch_direction
scroll_direction:		.byte	$0f
unused_c084:		.byte	$0f
; counts down 8-1 each frame: the scroll phase
; read by: intro_frame, main_loop, guardian_right, scroll_fine, scroll_fine_up_check, scroll_fine_left_check, scroll_fine_right_check, scroll_phase_select, animate
; written by: scroll_phase_select
; modified by: scroll_fine
frame_counter:		.byte	$08
; 1: the fine scroll wrapped, show the other screen
; read by: scroll_phase
; written by: scroll_fine, scroll_fine_down, scroll_fine_up, scroll_fine_left, scroll_fine_right
swap_screens:		.byte	$00
; high bytes of the screen copy's source and destination
; read by: scroll_shift_screen
; written by: scroll_shift_colours, scroll_shift_chars, scroll_shift_chars_2
copy_source_high:		.byte	$00
unused_c088:		.byte	$00
; read by: scroll_shift_screen
; written by: scroll_shift_colours, scroll_shift_chars, scroll_shift_chars_2
copy_dest_high:		.byte	$00
unused_c08a:		.byte	$00
; the next scroll direction, from the joystick and the collisions
; read by: scroll_latch_direction, frame_hit_sides, frame_hit_right
; written by: frame_engine_sound, frame_hit, frame_hit_bottom, frame_set_direction_a
next_direction:		.byte	$0f
; 1: the guardian moves left
; read by: main_loop
; written by: puzzle_wrong, guardian_from_right
guardian_left:		.byte	$00

; the map position of the top left of the screen ($e000-$ffff)
; read by: puzzle_wrong, radar_start, radar_add_column, scroll_move_map, scroll_move_map_down, scroll_move_map_left, scroll_move_map_right, draw_top_row, draw_bottom_row, draw_left_column, draw_right_column
; written by: scroll_move_map, scroll_move_map_down, scroll_move_map_left, scroll_move_map_right, engine_init_sprites
map_position:
		.word	$f030
; read by: draw_screen_row, draw_row_pass, draw_column_pass
; written by: draw_screen_row, draw_top_row, draw_bottom_row, draw_left_column, draw_right_column
; modified by: draw_right_column
map_row:		.word	$f000

; read by: draw_row_colours, draw_column_colours
; written by: draw_screen_next, draw_top_row, draw_bottom_row, draw_left_column, draw_right_column
draw_screen_low:
		.byte	$00
; read by: draw_row_colours, draw_column_colours
; written by: draw_row, draw_column
draw_screen_page:		.byte	$00

; read by: draw_screen_next, draw_screen_call
; written by: draw_screen_next, draw_top_row, draw_row_screen_1
; modified by: draw_screen_next
draw_offset:
		.word	$0000

; the character within the tile at the top left
; read by: scroll_move_map_right, draw_row_pass, draw_left_column, draw_right_column
; written by: scroll_move_map_left, scroll_move_map_right, engine_init_sprites
; modified by: scroll_move_map_left, scroll_move_map_right
tile_x:
		.byte	$00
; read by: scroll_move_map_down, draw_top_row, draw_bottom_row, draw_column_pass
; written by: scroll_move_map, scroll_move_map_down, engine_init_sprites
; modified by: scroll_move_map, scroll_move_map_down
tile_y:		.byte	$00
; read by: draw_column_tile
; written by: draw_left_column, draw_right_column, draw_right_column_wrap
column_tile_x:		.byte	$00
; read by: draw_screen_row, draw_row_tile
; written by: draw_screen_row, draw_top_row, draw_bottom_row
; modified by: draw_screen_row
row_tile_y:		.byte	$00

; bytes per map row
; read by: draw_screen_row, scroll_move_map, scroll_move_map_down, draw_column_next
map_width:
		.word	$0080

raster_irq:
		lda vic_irq_status
		sta vic_irq_status
		and #$01
		beq irq_return
		dec raster_index
		bpl raster_irq_split
		lda #$01
		sta raster_index
; jumped to by: raster_irq
raster_irq_split:
		ldx raster_index
		lda raster_lines, x
		sta vic_raster
		lda scroll_x
		ora #$10
		sta vic_control_2
		lda background_flash
		sta background_color
		lda scroll_y
		ora #$10
		sta vic_control_1
		cpx #$01
		beq scroll_fine
; jumped to by: raster_irq
irq_return:
		pla 
		tay 
		pla 
		tax 
		pla 
		rti 

; the scroll phase: fine scroll y/x, set swap_screens when it wraps
; jumped to by: raster_irq_split
scroll_fine:
		dec frame_counter
		lda #$00
		sta swap_screens
		lda scroll_direction
		and #$02
		bne scroll_fine_up_check
		ldy scroll_y
		bne scroll_fine_down
		lda frame_counter
		cmp #$07
		bne scroll_fine_up_check
; jumped to by: scroll_fine
scroll_fine_down:
		dey 
		bpl scroll_fine_down_set
		ldy #$07
		sty swap_screens
; jumped to by: scroll_fine_down
scroll_fine_down_set:
		sty scroll_y
		dec vic_sprite_coords + $f
		bne scroll_fine_up_check
		lda vic_sprite_enable
		and #$7f
		sta vic_sprite_enable
; jumped to by: scroll_fine, scroll_fine_down_set
scroll_fine_up_check:
		lda scroll_direction
		and #$01
		bne scroll_fine_left_check
		ldy scroll_y
		cpy #$07
		bne scroll_fine_up
		lda frame_counter
		cmp #$07
		bne scroll_fine_left_check
; jumped to by: scroll_fine_up_check
scroll_fine_up:
		iny 
		cpy #$08
		bne scroll_fine_up_set
		sty swap_screens
		ldy #$00
; jumped to by: scroll_fine_up
scroll_fine_up_set:
		sty scroll_y
		inc vic_sprite_coords + $f
		bne scroll_fine_left_check
		lda vic_sprite_enable
		and #$7f
		sta vic_sprite_enable
; jumped to by: scroll_fine_up_check, scroll_fine_up_set
scroll_fine_left_check:
		lda scroll_direction
		and #$04
		bne scroll_fine_right_check
		ldy scroll_x
		cpy #$07
		bne scroll_fine_left
		lda frame_counter
		cmp #$07
		bne scroll_fine_right_check
; jumped to by: scroll_fine_left_check
scroll_fine_left:
		iny 
		cpy #$08
		bne scroll_fine_left_set
		sty swap_screens
		ldy #$00
; jumped to by: scroll_fine_left
scroll_fine_left_set:
		sty scroll_x
		lda #$02
		sta guardian_follow
		jmp scroll_fine_right_check

; called by: main_loop, guardian_follow_scroll
guardian_move_left:
		lda vic_sprite_coords + $e
		bne guardian_move_left_step
		lda vic_sprite_x_high_bits
		bne guardian_move_left_wrap
		lda vic_sprite_enable
		and #$7f
		sta vic_sprite_enable
; jumped to by: guardian_move_left
guardian_move_left_wrap:
		lda #$00
		sta vic_sprite_x_high_bits
; jumped to by: guardian_move_left
guardian_move_left_step:
		dec vic_sprite_coords + $e
		rts 

; jumped to by: scroll_fine_left_check, scroll_fine_left_set
scroll_fine_right_check:
		lda scroll_direction
		and #$08
		bne scroll_phase
		ldy scroll_x
		bne scroll_fine_right
		lda frame_counter
		cmp #$07
		bne scroll_phase
; jumped to by: scroll_fine_right_check
scroll_fine_right:
		dey 
		bpl scroll_fine_right_set
		ldy #$07
		sty swap_screens
; jumped to by: scroll_fine_right
scroll_fine_right_set:
		sty scroll_x
		lda #$01
		sta guardian_follow
		jmp scroll_phase

; 1 = the screen scrolled left, 2 = right: the guardian moves along
; read by: guardian_follow_scroll, guardian_follow_right
; written by: sound_effect, scroll_fine_left_set, scroll_fine_right_set
guardian_follow:
		.byte	$00

; called by: guardian_right, guardian_follow_right
guardian_move_right:
		lda vic_sprite_x_high_bits
		bne guardian_move_right_high
		inc vic_sprite_coords + $e
		bne guardian_move_right_done
		lda #$80
		sta vic_sprite_x_high_bits
		rts 

; jumped to by: guardian_move_right
guardian_move_right_high:
		lda vic_sprite_coords + $e
		cmp #$96
		bne guardian_move_right_step
		lda vic_sprite_enable
		and #$7f
		sta vic_sprite_enable
; jumped to by: guardian_move_right
guardian_move_right_done:
		rts 

; jumped to by: guardian_move_right_high
guardian_move_right_step:
		inc vic_sprite_coords + $e
		rts 

; jumped to by: scroll_fine_right_check, scroll_fine_right_set
scroll_phase:
		lda swap_screens
		beq scroll_phase_select
		jsr show_screen
; jumped to by: scroll_phase
scroll_phase_select:
		lda frame_counter
		bne scroll_phase_7
		lda #$08
		sta frame_counter
		jmp scroll_draw_columns

; jumped to by: scroll_phase_select
scroll_phase_7:
		cmp #$07
		bne scroll_phase_5_3_1
		jmp scroll_latch_direction

; jumped to by: scroll_phase_7
scroll_phase_5_3_1:
		ldy scroll_direction
		cpy #$0f
		beq scroll_phase_done
		cmp #$05
		bne scroll_phase_3
		jmp scroll_shift_chars

; jumped to by: scroll_phase_5_3_1
scroll_phase_3:
		cmp #$03
		bne scroll_phase_1
		jmp scroll_shift_colours

; jumped to by: scroll_phase_3
scroll_phase_1:
		cmp #$01
		bne scroll_phase_done
		jmp scroll_draw_rows

; the KERNAL IRQ until the engine starts, then frame_handler
; jumped to by: scroll_phase_5_3_1, scroll_phase_1, scroll_latch_direction, scroll_shift_colours, scroll_move_map_done, scroll_draw_rows_done, scroll_draw_columns_done
; written by: engine_init
scroll_phase_done:
		jmp kernal_irq	; operand set by engine_init

; shows the other screen and copies the colour buffer to the colour RAM
; called by: draw_screen_call, scroll_phase
show_screen:
		cli 
		lda vic_memory_setup
		eor #$30
		sta vic_memory_setup
.if fast_engine
		jmp colour_copy
.else
		ldy #$00
show_screen_colours_1:
		lda colour_buffer - 1, y
		sta $d7ff, y
		lda colour_buffer + $ff, y
		sta color_ram + $ff, y
		iny 
		bne show_screen_colours_1
show_screen_colours_2:
		lda colour_buffer + $1ff, y
		sta color_ram + $1ff, y
		lda colour_buffer + $2ff, y
		sta color_ram + $2ff, y
		iny 
		bne show_screen_colours_2
		rts 
.endif

; copies the screen (or the colour buffer) shifted by one character in the
; scroll direction, in 4 parts of 250 bytes; the loop's index direction and
; carry are patched per direction
; called by: scroll_shift_colours, scroll_move_map
scroll_shift_screen:
		lda cpu_port
		pha 
		and #$fd
		sta cpu_port
		ldx scroll_direction
		lda scroll_direction_index, x
		tax 
		lda scroll_copy_start, x
		sta scroll_shift_part + 1
		lda scroll_copy_source, x
		clc 
		sta scroll_shift_loop + 1
		pla 
		sta cpu_port
		cli 
		lda scroll_source_high, x
		adc copy_source_high
		sta scroll_shift_loop + 2
		lda scroll_dest_low, x
		clc 
		sta scroll_shift_store + 1
		lda scroll_dest_high, x
		adc copy_dest_high
		sta scroll_shift_store + 2
		lda scroll_index_opcode, x
		sta scroll_shift_step
		lda scroll_end_index, x
		sta scroll_shift_compare + 1
.if fast_engine
; the English version: the copy loop is unrolled to 4 copies (the 4 parts),
; set up for up or down by scroll_shift_up / scroll_shift_down
		lda scroll_carry_opcode, x
		beq +
		jmp scroll_shift_down
+		jmp scroll_shift_up

scroll_shift_part:
		ldy #$fa	; operand set by scroll_shift_screen
scroll_shift_loop:
		lda $ffff, y	; operand set by scroll_shift_screen
scroll_shift_store:
		sta $ffff, y	; operand set by scroll_shift_screen
scroll_shift_loop_2:
		lda $ffff, y	; operand set by scroll_shift_up, scroll_shift_down
scroll_shift_store_2:
		sta $ffff, y	; operand set by scroll_shift_up, scroll_shift_down
scroll_shift_loop_3:
		lda $ffff, y	; operand set by scroll_shift_up, scroll_shift_down
scroll_shift_store_3:
		sta $ffff, y	; operand set by scroll_shift_up, scroll_shift_down
scroll_shift_loop_4:
		lda $ffff, y	; operand set by scroll_shift_up, scroll_shift_down
scroll_shift_store_4:
		sta $ffff, y	; operand set by scroll_shift_up, scroll_shift_down
scroll_shift_step:
		dey 	; set by scroll_shift_screen
scroll_shift_compare:
		cpy #$ff	; operand set by scroll_shift_screen
		bne scroll_shift_loop
		rts 

; parts 2-4 start 250 bytes after each other
scroll_shift_up:
		ldx scroll_shift_loop + 2
		clc 
		lda scroll_shift_loop + 1
		adc #$fa
		sta scroll_shift_loop_2 + 1
		bcc +
		inx 
		clc 
+		stx scroll_shift_loop_2 + 2
		lda scroll_shift_loop_2 + 1
		adc #$fa
		sta scroll_shift_loop_3 + 1
		bcc +
		inx 
		clc 
+		stx scroll_shift_loop_3 + 2
		lda scroll_shift_loop_3 + 1
		adc #$fa
		sta scroll_shift_loop_4 + 1
		bcc +
		inx 
		clc 
+		stx scroll_shift_loop_4 + 2
		ldx scroll_shift_store + 2
		lda scroll_shift_store + 1
		adc #$fa
		sta scroll_shift_store_2 + 1
		bcc +
		inx 
		clc 
+		stx scroll_shift_store_2 + 2
		lda scroll_shift_store_2 + 1
		adc #$fa
		sta scroll_shift_store_3 + 1
		bcc +
		inx 
		clc 
+		stx scroll_shift_store_3 + 2
		lda scroll_shift_store_3 + 1
		adc #$fa
		sta scroll_shift_store_4 + 1
		bcc +
		inx 
		clc 
+		stx scroll_shift_store_4 + 2
		jmp scroll_shift_part

; parts 2-4 start 250 bytes before each other
scroll_shift_down:
		sec 
		ldx scroll_shift_loop + 2
		lda scroll_shift_loop + 1
		sbc #$fa
		sta scroll_shift_loop_2 + 1
		bcs +
		dex 
		sec 
+		stx scroll_shift_loop_2 + 2
		lda scroll_shift_loop_2 + 1
		sbc #$fa
		sta scroll_shift_loop_3 + 1
		bcs +
		dex 
		sec 
+		stx scroll_shift_loop_3 + 2
		lda scroll_shift_loop_3 + 1
		sbc #$fa
		sta scroll_shift_loop_4 + 1
		bcs +
		dex 
		sec 
+		stx scroll_shift_loop_4 + 2
		ldx scroll_shift_store + 2
		lda scroll_shift_store + 1
		sbc #$fa
		sta scroll_shift_store_2 + 1
		bcs +
		sec 
		dex 
+		stx scroll_shift_store_2 + 2
		lda scroll_shift_store_2 + 1
		sbc #$fa
		sta scroll_shift_store_3 + 1
		bcs +
		dex 
		sec 
+		stx scroll_shift_store_3 + 2
		lda scroll_shift_store_3 + 1
		sbc #$fa
		sta scroll_shift_store_4 + 1
		bcs +
		dex 
		sec 
+		stx scroll_shift_store_4 + 2
		jmp scroll_shift_part

.else
		lda scroll_carry_opcode, x
		sta scroll_shift_carry
		ldx #$04
; jumped to by: scroll_shift_next_part, scroll_shift_down_next
; written by: scroll_shift_screen
scroll_shift_part:
		ldy #$fa	; operand set by scroll_shift_screen
; jumped to by: scroll_shift_compare
; read by: scroll_shift_carry, scroll_shift_down
; written by: scroll_shift_screen, scroll_shift_carry, scroll_shift_down
; modified by: scroll_shift_carry, scroll_shift_down
scroll_shift_loop:
		lda $ffff, y	; operand set by scroll_shift_screen, scroll_shift_carry, scroll_shift_down
; read by: scroll_shift_next_dest_up, scroll_shift_down_dest
; written by: scroll_shift_screen, scroll_shift_next_dest_up, scroll_shift_down_dest
; modified by: scroll_shift_next_dest_up, scroll_shift_down_dest
scroll_shift_store:
		sta $ffff, y	; operand set by scroll_shift_screen, scroll_shift_next_dest_up, scroll_shift_down_dest
; written by: scroll_shift_screen
scroll_shift_step:
		dey 
; written by: scroll_shift_screen
scroll_shift_compare:
		cpy #$ff	; operand set by scroll_shift_screen
		bne scroll_shift_loop
; written by: scroll_shift_screen
scroll_shift_carry:
		clc 
		bcs scroll_shift_down
		lda scroll_shift_loop + 1
		adc #$fa
		sta scroll_shift_loop + 1
		bcc scroll_shift_next_dest_up
		inc scroll_shift_loop + 2
		clc 
; jumped to by: scroll_shift_carry
scroll_shift_next_dest_up:
		lda scroll_shift_store + 1
		adc #$fa
		sta scroll_shift_store + 1
		bcc scroll_shift_next_part
		inc scroll_shift_store + 2
; jumped to by: scroll_shift_next_dest_up
scroll_shift_next_part:
		dex 
		bne scroll_shift_part
		rts 

; jumped to by: scroll_shift_carry
scroll_shift_down:
		lda scroll_shift_loop + 1
		sbc #$fa
		sta scroll_shift_loop + 1
		bcs scroll_shift_down_dest
		dec scroll_shift_loop + 2
		sec 
; jumped to by: scroll_shift_down
scroll_shift_down_dest:
		lda scroll_shift_store + 1
		sbc #$fa
		sta scroll_shift_store + 1
		bcs scroll_shift_down_next
		dec scroll_shift_store + 2
; jumped to by: scroll_shift_down_dest
scroll_shift_down_next:
		dex 
		bne scroll_shift_part
		rts 
.endif

; by direction (joystick bits): the index into the tables below
; read by: scroll_shift_screen
scroll_direction_index:
		.byte	$08, $08, $08, $08, $08, $00, $01, $02, $08, $04, $05, $06, $08, $08, $09, $08
; read by: scroll_shift_screen
scroll_source_high:
		.byte	$00, $02, $00, $01, $00, $02, $02, $01, $00, $02
; read by: scroll_shift_screen
scroll_dest_low:
		.byte	$00, $ee, $00, $01, $01, $ef, $ef, $01, $00, $ee
; read by: scroll_shift_screen
scroll_dest_high:
		.byte	$00, $02, $00, $01, $00, $02, $02, $01, $00, $02
; dey or iny, the end index and clc or sec of the copy loop
; read by: scroll_shift_screen
scroll_index_opcode:
		.byte	$c8, $88, $c8, $01, $c8, $88, $88, $01, $c8, $88
; read by: scroll_shift_screen
scroll_end_index:
		.byte	$fa, $ff, $fa, $01, $fa, $ff, $ff, $01, $fa, $ff
; read by: scroll_shift_screen
scroll_carry_opcode:
.if fast_engine
		.byte	$00, $38, $00, $01, $00, $38, $38, $01, $00, $38	; up: 0
.else
		.byte	$18, $38, $18, $01, $18, $38, $38, $01, $18, $38
.endif

; jumped to by: scroll_phase_7
scroll_latch_direction:
		lda next_direction
		and #$0f
		sta scroll_direction
		jmp scroll_phase_done

; jumped to by: scroll_phase_3
scroll_shift_colours:
.if fast_engine
; the English version shifts colour RAM into the buffer
		lda #>color_ram
		sta copy_source_high
		lda #>colour_buffer
.else
		lda #>colour_buffer
		sta copy_source_high
.endif
		sta copy_dest_high
		jsr scroll_shift_screen
		jmp scroll_phase_done

; jumped to by: scroll_phase_5_3_1
scroll_shift_chars:
		lda vic_memory_setup
		and #$10
		bne scroll_shift_chars_2
		lda #$08
		sta copy_source_high
		lda #$04
		sta copy_dest_high
		bne scroll_move_map
; jumped to by: scroll_shift_chars
scroll_shift_chars_2:
		lda #$04
		sta copy_source_high
		lda #$08
		sta copy_dest_high
; jumped to by: scroll_shift_chars
scroll_move_map:
		jsr scroll_shift_screen
		lda scroll_direction
		and #$01
		bne scroll_move_map_down
		dec tile_y
		bpl scroll_move_map_down
		lda #$07
		sta tile_y
		sec 
		lda map_position
		sbc map_width
		sta map_position
		lda map_position + $1
		sbc map_width + $1
		ora #$e0
		sta map_position + $1
; jumped to by: scroll_move_map
scroll_move_map_down:
		lda scroll_direction
		and #$02
		bne scroll_move_map_left
		inc tile_y
		lda tile_y
		cmp #$08
		bne scroll_move_map_left
		lda #$00
		sta tile_y
		clc 
		lda map_position
		adc map_width
		sta map_position
		lda map_position + $1
		adc map_width + $1
		ora #$e0
		sta map_position + $1
; jumped to by: scroll_move_map_down
scroll_move_map_left:
		lda scroll_direction
		and #$04
		bne scroll_move_map_right
		dec tile_x
		bpl scroll_move_map_right
		lda #$07
		sta tile_x
		sec 
		lda map_position
		sbc #$01
		sta map_position
		lda map_position + $1
		sbc #$00
		ora #$e0
		sta map_position + $1
; jumped to by: scroll_move_map_left
scroll_move_map_right:
		lda scroll_direction
		and #$08
		bne scroll_move_map_done
		inc tile_x
		lda tile_x
		cmp #$08
		bne scroll_move_map_done
		lda #$00
		sta tile_x
		clc 
		lda map_position
		adc #$01
		sta map_position
		lda map_position + $1
		adc #$00
		ora #$e0
		sta map_position + $1
; jumped to by: scroll_move_map_right
scroll_move_map_done:
		jmp scroll_phase_done

; jumped to by: scroll_phase_1
scroll_draw_rows:
		lda cpu_port
		and #$fd
		sta cpu_port
		lda scroll_direction
		and #$01
		bne scroll_draw_rows_bottom
		jsr draw_top_row
; jumped to by: scroll_draw_rows
scroll_draw_rows_bottom:
		lda scroll_direction
		and #$02
		bne scroll_draw_rows_done
		jsr draw_bottom_row
; jumped to by: scroll_draw_rows_bottom
scroll_draw_rows_done:
		lda cpu_port
		ora #$03
		sta cpu_port
		cli 
		jmp scroll_phase_done

; jumped to by: scroll_phase_select
scroll_draw_columns:
		lda cpu_port
		and #$fd
		sta cpu_port
		lda scroll_direction
		and #$04
		bne scroll_draw_columns_right
		jsr draw_left_column
; jumped to by: scroll_draw_columns
scroll_draw_columns_right:
		lda scroll_direction
		and #$08
		bne scroll_draw_columns_done
		jsr draw_right_column
; jumped to by: scroll_draw_columns_right
scroll_draw_columns_done:
		lda cpu_port
		ora #$03
		sta cpu_port
		cli 
		jmp scroll_phase_done

; draws the top row into the hidden screen
; called by: draw_screen, scroll_draw_rows
draw_top_row:
		lda #$00
		sta draw_screen_low
		sta draw_offset
		sta draw_row_store + 1
		lda tile_y
		sta row_tile_y
		lda map_position
		sta map_row
		lda map_position + $1
		sta map_row + $1
		lda vic_memory_setup
		and #$10
		beq draw_row_screen_1
		lda #$08

bit_skip_c45d:
		.byte	$2c

; jumped to by: draw_top_row
draw_row_screen_1:
		lda #$04
		sta draw_offset + $1
; draws a row of 40 characters and their colours: A = the screen page
; called by: draw_screen_call
; jumped to by: draw_bottom_row_screen_1
draw_row:
		sta draw_row_store + 2
		sta draw_screen_page
		lda #$80
		sta draw_row_page + 1
; jumped to by: draw_row_colours
draw_row_pass:
		ldx tile_x
		ldy #$00
		lda map_row
		sta draw_row_tile + 1
		lda map_row + $1
		sta draw_row_tile + 2
; jumped to by: draw_row_next_tile
; read by: draw_row_next_tile
; written by: draw_row_pass, draw_row_next_tile
; modified by: draw_row_store
draw_row_tile:
		lda $ffff	; operand set by draw_row_pass, draw_row_store, draw_row_next_tile
		pha 
		and #$1f
		sta draw_row_char + 1
		lda #$00
		sta draw_row_char + 2
		asl draw_row_char + 1
		rol draw_row_char + 2
		asl draw_row_char + 1
		rol draw_row_char + 2
		asl draw_row_char + 1
		rol draw_row_char + 2
		pla 
		ror 
		ror 
		and #$18
		ora draw_row_char + 2
		clc 
		adc row_tile_y
		and #$1f
; written by: draw_row, draw_row_colours
draw_row_page:
		ora #$00	; operand set by draw_row, draw_row_colours
		sta draw_row_char + 2
; jumped to by: draw_row_store
; read by: draw_row_tile
; written by: draw_row_tile, draw_row_page
; modified by: draw_row_tile
draw_row_char:
		lda $ffff, x	; operand set by draw_row_tile, draw_row_page
; read by: draw_row_colours
; written by: draw_screen_next, draw_top_row, draw_row, draw_row_colours, draw_bottom_row
draw_row_store:
		sta $ffff, y	; operand set by draw_screen_next, draw_top_row, draw_row, draw_row_colours, draw_bottom_row
		cpy #$27
		beq draw_row_colours
		iny 
		inx 
		cpx #$08
		bne draw_row_char
		ldx #$00
		inc draw_row_tile + 1
		bne draw_row_next_tile
		inc draw_row_tile + 2
; jumped to by: draw_row_store
draw_row_next_tile:
		lda draw_row_tile + 2
		ora #$e0
		sta draw_row_tile + 2
		bne draw_row_tile
; jumped to by: draw_row_store
draw_row_colours:
		lda draw_row_store + 2
		and #$80
		bne draw_row_done
		lda draw_screen_page
		ora #$cc
		sta draw_row_store + 2
		lda draw_screen_low
		sta draw_row_store + 1
		lda #$a0
		sta draw_row_page + 1
		jmp draw_row_pass

; jumped to by: draw_row_colours
draw_row_done:
		rts 

; draws the bottom row (row 24)
; called by: scroll_draw_rows_bottom
draw_bottom_row:
		lda #$c0
		sta draw_row_store + 1
		sta draw_screen_low
		lda tile_y
		sta row_tile_y
		clc 
		lda map_position
		adc bottom_row_offset
		sta map_row
		lda map_position + $1
		adc bottom_row_offset + $1
		sta map_row + $1
		lda vic_memory_setup
		and #$10
		beq draw_bottom_row_screen_1
		lda #$0b

bit_skip_c51e:
		.byte	$2c

; jumped to by: draw_bottom_row
draw_bottom_row_screen_1:
		lda #$07
		jmp draw_row

; draws the left column into the hidden screen
; called by: scroll_draw_columns
draw_left_column:
		lda #$00
		sta draw_column_store + 1
		sta draw_screen_low
		lda map_position
		sta map_row
		lda map_position + $1
		sta map_row + $1
		lda tile_x
		sta column_tile_x
		lda vic_memory_setup
		and #$10
		beq draw_left_column_screen_1
		lda #$08

bit_skip_c547:
		.byte	$2c

; jumped to by: draw_left_column
draw_left_column_screen_1:
		lda #$04
; draws a column of 25 characters and their colours: A = the screen page
; jumped to by: draw_right_column_screen_1
draw_column:
		sta draw_column_store + 2
		sta draw_screen_page
		lda #$80
		sta draw_column_page + 1
; jumped to by: draw_column_colours
draw_column_pass:
		ldx tile_y
		ldy #$00
		lda map_row
		sta draw_column_tile + 1
		lda map_row + $1
		sta draw_column_tile + 2
; jumped to by: draw_column_next
; read by: draw_column_next
; written by: draw_column_pass, draw_column_next
draw_column_tile:
		lda $ffff	; operand set by draw_column_pass, draw_column_next
		pha 
		and #$1f
		sta draw_column_char + 1
		lda #$00
		sta draw_column_char + 2
		asl draw_column_char + 1
		rol draw_column_char + 2
		asl draw_column_char + 1
		rol draw_column_char + 2
		asl draw_column_char + 1
		rol draw_column_char + 2
		clc 
		lda draw_column_char + 1
		adc column_tile_x
		sta draw_column_char + 1
		bcc draw_column_tile_row
		inc draw_column_char + 2
; jumped to by: draw_column_tile
draw_column_tile_row:
		pla 
		ror 
		ror 
		and #$18
		ora draw_column_char + 2
		sta draw_column_char + 2
		clc 
		txa 
		adc draw_column_char + 2
		and #$1f
; written by: draw_column, draw_column_colours
draw_column_page:
		ora #$00	; operand set by draw_column, draw_column_colours
		sta draw_column_char + 2
; jumped to by: draw_column_next
; read by: draw_column_tile, draw_column_tile_row
; written by: draw_column_tile, draw_column_tile_row, draw_column_page
; modified by: draw_column_tile, draw_column_next
draw_column_char:
		lda $ffff	; operand set by draw_column_tile, draw_column_tile_row, draw_column_page, draw_column_next
; read by: draw_column_colours
; written by: draw_left_column, draw_column, draw_column_colours, draw_right_column
draw_column_store:
		sta $ffff	; operand set by draw_left_column, draw_column, draw_column_store, draw_column_colours, draw_right_column
		cpy #$18
		beq draw_column_colours
		iny 
		clc 
		lda draw_column_store + 1
		adc #$28
		sta draw_column_store + 1
		bcc draw_column_next
		inc draw_column_store + 2
; jumped to by: draw_column_store
draw_column_next:
		inc draw_column_char + 2
		inx 
		cpx #$08
		bne draw_column_char
		ldx #$00
		clc 
		lda draw_column_tile + 1
		adc map_width
		sta draw_column_tile + 1
		lda draw_column_tile + 2
		adc map_width + $1
		ora #$e0
		sta draw_column_tile + 2
		bne draw_column_tile
; jumped to by: draw_column_store
draw_column_colours:
		lda draw_column_store + 2
		and #$80
		bne draw_column_done
		lda draw_screen_page
		ora #$cc
		sta draw_column_store + 2
		lda draw_screen_low
		sta draw_column_store + 1
		lda #$a0
		sta draw_column_page + 1
		jmp draw_column_pass

; jumped to by: draw_column_colours
draw_column_done:
		rts 

; draws the right column (column 39)
; called by: scroll_draw_columns_right
draw_right_column:
		lda #$27
		sta draw_column_store + 1
		sta draw_screen_low
		lda map_position
		clc 
		adc #$04
		sta map_row
		lda map_position + $1
		adc #$00
		sta map_row + $1
		lda tile_x
		beq draw_right_column_wrap
		sec 
		sbc #$01
		sta column_tile_x
		inc map_row
		bne draw_right_column_tile
		inc map_row + $1
; jumped to by: draw_right_column
draw_right_column_tile:
		jmp draw_right_column_screen

; jumped to by: draw_right_column
draw_right_column_wrap:
		lda #$07
		sta column_tile_x
; jumped to by: draw_right_column_tile
draw_right_column_screen:
		lda vic_memory_setup
		and #$10
		beq draw_right_column_screen_1
		lda #$08

bit_skip_c641:
		.byte	$2c

; jumped to by: draw_right_column_screen
draw_right_column_screen_1:
		lda #$04
		jmp draw_column

; map offset of the bottom row: 24 / 8 = 3 rows of tiles down
; read by: draw_bottom_row
bottom_row_offset:
		.word	$0180

; Sets up the VIC, the SID, the sprites, the barrier characters and the screen,
; then a new game
; jumped to by: engine_start
engine_init:
		lda #<frame_handler
		sei 
		sta scroll_phase_done + 1
		ldx #$fb
		txs 
		lda #>frame_handler
		sta scroll_phase_done + 2
		lda #$00
		sta barrier_closing
		lda #$00
		sta vic_sprite_x_high_bits
		sta background_color
		lda #$0b
		sta border_color
		lda #$0f
		sta background_color_1
		lda #$07
		sta background_color_2
		lda #$00
		sta game_over
		lda #$1a
		sta vic_memory_setup
		lda #$ed
		sta stop_vector
		lda #$80
		ldx #$00
engine_clear_screens:
		sta screen_ram, x
		sta screen_ram + $100, x
		sta screen_ram + $200, x
		sta screen_ram + $300, x
		sta screen_2, x
		sta screen_2_unused + $f3, x
		sta screen_2_unused + $1f3, x
		sta screen_2_unused + $2f3, x
		dex 
		bne engine_clear_screens
		ldx #$18
		lda #$00
engine_clear_sid:
		sta voice1_frequency, x
		dex 
		bpl engine_clear_sid
		lda #$0a
		sta voice3_frequency
		sta engine_noise_rate
		lda #$10
		sta voice3_control
		lda #$01
		sta voice1_pulse_width + $1
		lda #$8f
		sta sid_vol_filter
		lda #$f9
		sta voice1_sustain_release
		sta voice2_sustain_release
		lda #$11
		sta voice1_control
		lda #$05
		ldx #$07
engine_init_sprites:
		lda sprite_coords_init, x
		sta vic_sprite_coords, x
		lda sprite_coords_init_2, x
		sta vic_sprite_coords + $8, x
		lda sprite_colours_init, x
		sta vic_sprite_colors, x
		lda sprite_pointers_init, x
		sta sprite_pointers, x
		sta screen_2_sprite_pointers, x
		dex 
		bpl engine_init_sprites
		ldx #$7f
		stx vic_sprite_priority
		ldx #$3f
		stx vic_sprite_enable
		ldx #$3c
		stx vic_sprite_multicolor
		ldx #$80
		stx vic_sprite_double_width
		stx vic_sprite_double_height
		lda #$07
		sta sprite_multicolor_1
		lda #$32
		sta map_position
		lda #$e4
		sta map_position + $1
		lda #$06
		sta sprite_multicolor_2
		ldx #$04
		stx engine_pitch + $1
		ldx #$00
		stx engine_pitch
		stx tile_x
		stx scroll_x
		stx tile_y
		stx scroll_y
engine_init_barrier:
		lda #$00
		sta charset, x
		sta charset + $300, x
		lda #$ff
		sta charset + $100, x
		sta charset + $200, x
		dex 
		bne engine_init_barrier
		stx barrier_left
		stx barrier_left_char
		stx barrier_closing
		lda #$3f
		sta barrier_right
		lda #$38
		sta barrier_right_char
		lda #$07
		sta barrier_mask_index
		jsr draw_screen
		cli 
		jmp new_game

; engine sound: frequency added to the noise, and voice 3's frequency (the
; random source)
; read by: frame_engine_sound, frame_joystick, frame_engine_down_check
; written by: engine_init_sprites, frame_engine_up, frame_engine_down_check
; modified by: frame_engine_up, frame_engine_down_check
engine_pitch:
		.word	$0400
; read by: frame_engine_sound
; written by: frame_handler, frame_engine_sound
; modified by: frame_engine_sound
engine_tone:		.word	$0000

; read by: frame_engine_sound, frame_joystick, frame_engine_down_check
; written by: engine_clear_sid
; modified by: frame_engine_up, frame_engine_down_check
engine_noise_rate:
		.byte	$03
; read by: engine_init_sprites
sprite_colours_init:
		.byte	$06, $06, $0d, $0d, $0d, $0d, $01, $09
; read by: engine_init_sprites
sprite_pointers_init:
		.byte	$35, $36, $32, $33, $30, $31, $39, $3c
; read by: engine_init_sprites
sprite_coords_init:
		.byte	$94, $83, $ac, $83, $88, $83, $b8, $83
; sprite collisions: background bits 2-5 (the hull's sides), $ff when the
; guardian touched the ship
; read by: update_status, update_damage_message, frame_hit, frame_hit_sides
; written by: new_game_reset, frame_hit
collisions:		.byte	$00
; read by: engine_init_sprites
sprite_coords_init_2:
		.byte	$a0, $78, $a0, $8d, $00, $00, $00, $64

; Once a frame from the raster IRQ: the engine sound, collisions and damage,
; the joystick and the barrier animation
frame_handler:
		lda voice3_oscillator
		sta engine_tone
		cmp #$e4
		bcc frame_flame_colour
		lda #$01
		bne frame_engine_sound
; jumped to by: frame_handler
frame_flame_colour:
		cmp #$c0
		bcc frame_flame_dark
		lda #$0f
		bne frame_engine_sound
; jumped to by: frame_flame_colour
frame_flame_dark:
		lda #$0b
; jumped to by: frame_handler, frame_flame_colour
frame_engine_sound:
		sta sprite_multicolor_1
		lda #$00
		sta engine_tone + $1
		asl engine_tone
		rol engine_tone + $1
		asl engine_tone
		rol engine_tone + $1
		clc 
		lda engine_tone
		adc engine_pitch
		sta voice1_frequency
		lda engine_tone + $1
		adc engine_pitch + $1
		sta voice1_frequency + $1
		lda engine_noise_rate
		sta voice3_frequency
		ldx #$00
		ldy #$0f
		sty next_direction
		lda game_over
		beq frame_collisions
		jmp frame_destroyed

; jumped to by: frame_engine_sound
frame_collisions:
		stx vic_sprite_collision
		lda vic_sprite_collision
		and #$80
		beq frame_background_collision
		lda #$ff
		jmp frame_hit

; jumped to by: frame_collisions
frame_background_collision:
		stx vic_background_collision
		lda vic_background_collision
; jumped to by: frame_collisions
frame_hit:
		sta collisions
		and #$3c
		beq frame_joystick
		lda #$81
		sta voice1_control
		lda sprite_multicolor_2
		eor #$05
		sta sprite_multicolor_2
		lda collisions
		and #$30
		beq frame_hit_sides
		cmp #$10
		bne frame_hit_bottom
		lda #$0d
		sta next_direction
		jmp frame_hit_sides

; jumped to by: frame_hit
frame_hit_bottom:
		cmp #$20
		bne frame_destroyed
		lda #$0e
		sta next_direction
; jumped to by: frame_hit
frame_hit_sides:
		lda collisions
		and #$0c
		beq frame_joystick_done
		cmp #$04
		bne frame_hit_right
		lda next_direction
		and #$f7
		jmp frame_set_direction_a

; jumped to by: frame_hit_sides
frame_hit_right:
		cmp #$08
		bne frame_destroyed
		lda next_direction
		and #$fb
		jmp frame_set_direction_a

; the end of the game: flash, then explode after 256 frames
; jumped to by: frame_engine_sound, frame_hit_bottom, frame_hit_right
frame_destroyed:
		lda background_flash
		eor #$0e
		sta background_flash
		inc destroyed_timer
		bne frame_destroyed_sound
		jmp ship_explode

; jumped to by: frame_destroyed
frame_destroyed_sound:
		lda #$81
		sta voice1_control
		jmp animate

; written by: ship_explode, frame_joystick
; modified by: frame_destroyed
destroyed_timer:
		.byte	$00
; read by: frame_engine_sound
; written by: update_status, update_fuel, engine_init
game_over:		.byte	$00
; read by: ship_explode
; written by: frame_joystick
; modified by: ship_explode_step
explode_step:		.byte	$00

; jumped to by: frame_hit
frame_joystick:
		lda #$11
		sta voice1_control
		lda #$06
		sta sprite_multicolor_2
		lda #$00
		sta background_flash
		lda #$00
		sta explode_step
		sta destroyed_timer
		lda cia1_port_a
		and #$10
		beq frame_engine_down
		lda puzzle_state
		bne frame_engine_down
		lda cia1_port_a
		and #$0f
		tay 
		cmp #$0f
		beq frame_engine_down_check
		lda engine_noise_rate
		cmp #$0f
		bcs frame_engine_up
		lda engine_pitch
; jumped to by: frame_joystick
frame_engine_up:
		adc #$04
		sta engine_pitch
		bcc frame_set_direction
		inc engine_pitch + $1
		inc engine_noise_rate
		inc engine_noise_rate
; jumped to by: frame_engine_up, frame_engine_down_check
frame_set_direction:
		tya 
; jumped to by: frame_hit_sides, frame_hit_right
frame_set_direction_a:
		sta next_direction
; jumped to by: frame_hit_sides
frame_joystick_done:
		jmp animate

; jumped to by: frame_joystick
frame_engine_down:
		ldy #$0f
; jumped to by: frame_joystick
frame_engine_down_check:
		lda engine_noise_rate
		cmp #$05
		bcc frame_set_direction
		lda engine_pitch
		sbc #$04
		sta engine_pitch
		bcs frame_set_direction
		dec engine_pitch + $1
		dec engine_noise_rate
		dec engine_noise_rate
		jmp frame_set_direction

.if !fast_engine
		#barrier_code
.endif
; leftovers of an earlier memory image: the language's leftovers_2.bin, cut
; or padded to fit
leftovers_2:
		.binary	"leftovers_2.bin", 0, $cc00 - *
		.fill	$cc00 - *, 0
		.cerror	* != $cc00, "the engine doesn't fit below the colour buffer"
; the colour buffer: drawn with the hidden screen, copied to the colour RAM
; when the screens swap. Its contents in the file are what was on the screen
; when the game was saved (the language's colour_buffer.bin).
; read by: show_screen_colours_1, show_screen_colours_2
colour_buffer:
		.binary	"colour_buffer.bin"

.virtual $d000
; x and y of sprites 0-7
; read by: guardian_move_left, guardian_move_right_high
; written by: puzzle_wrong, guardian_from_right, guardian_start, probe_up, probe_left, probe_right, engine_init_sprites
; modified by: ship_explode_step, ship_explode_move, scroll_fine_down_set, scroll_fine_up_set, guardian_move_left_step, guardian_move_right, guardian_move_right_step
vic_sprite_coords:
		.fill	16
; read by: ship_explode_step, ship_explode_move, guardian_move_left, guardian_move_right
; written by: puzzle_wrong, guardian_from_right, ship_explode_step, ship_explode_move, guardian_move_left_wrap, guardian_move_right, engine_init
vic_sprite_x_high_bits:		.byte	?
; written by: draw_screen, raster_irq_split
vic_control_1:		.byte	?
; written by: draw_screen, raster_irq_split
vic_raster:		.byte	?
.endv

.virtual $d015
; read by: puzzle_wrong, ship_explode_step, probe_extend, probe_retract, scroll_fine_down_set, scroll_fine_up_set, guardian_move_left, guardian_move_right_high
; written by: guardian_start, ship_explode_step, probe_extend, probe_retract, scroll_fine_down_set, scroll_fine_up_set, guardian_move_left, guardian_move_right_high, engine_init_sprites
vic_sprite_enable:		.byte	?
; written by: raster_irq_split
vic_control_2:		.byte	?
; written by: engine_init_sprites
vic_sprite_double_height:		.byte	?
; read by: probe_touch, show_screen, scroll_shift_chars, draw_top_row, draw_bottom_row, draw_left_column, draw_right_column_screen
; written by: reset_system, show_screen, engine_init
vic_memory_setup:		.byte	?
; read by: raster_irq
; written by: raster_irq
vic_irq_status:		.byte	?
; written by: draw_screen
vic_irq_enable:		.byte	?
; written by: ship_explode_step, engine_init_sprites
vic_sprite_priority:		.byte	?
; written by: engine_init_sprites
vic_sprite_multicolor:		.byte	?
; written by: engine_init_sprites
vic_sprite_double_width:		.byte	?
; read by: frame_collisions
; written by: frame_collisions
vic_sprite_collision:		.byte	?
; read by: frame_background_collision
; written by: new_game_reset, frame_background_collision
vic_background_collision:		.byte	?
; written by: clear_screen_black, engine_init
border_color:		.byte	?
; written by: cycle_background, clear_screen_black, raster_irq_split, engine_init
background_color:		.byte	?
; written by: engine_init
background_color_1:		.byte	?
; written by: engine_init
background_color_2:		.byte	?
.endv

.virtual $d025
; written by: engine_init_sprites, frame_engine_sound
sprite_multicolor_1:		.byte	?
; read by: frame_hit
; written by: engine_init_sprites, frame_hit, frame_joystick
sprite_multicolor_2:		.byte	?
; written by: show_message, engine_init_sprites
; modified by: ship_explode_step, probe_active
vic_sprite_colors:
		.fill	8
.endv

.virtual $d400
; written by: reset_system_sid, game_won_loop, engine_clear_sid, frame_engine_sound
voice1_frequency:		.word	?
; written by: game_won, engine_clear_sid
voice1_pulse_width:		.word	?
; written by: game_won, ship_explode, engine_clear_sid, frame_hit, frame_destroyed_sound, frame_joystick
voice1_control:		.byte	?
.endv

.virtual $d406
; written by: game_won, engine_clear_sid
voice1_sustain_release:		.byte	?
; written by: sound_effect_step, sound_effect_off
voice2_frequency:		.word	?
.endv

.virtual $d40b
; written by: puzzle_draw_changed, guardian_start, fuel_tank_fill, radar_blink, switch_set_closed, sound_solved
voice2_control:		.byte	?
.endv

.virtual $d40d
; written by: engine_clear_sid
voice2_sustain_release:		.byte	?
; written by: game_won, engine_clear_sid, frame_engine_sound
voice3_frequency:		.word	?
.endv

.virtual $d412
; written by: game_won, engine_clear_sid
voice3_control:		.byte	?
.endv

.virtual $d418
; written by: game_won, engine_clear_sid
sid_vol_filter:		.byte	?
.endv

.virtual $d41b
; read by: game_won_loop, frame_handler
voice3_oscillator:		.byte	?
.endv

.virtual $d800
; written by: clear_screen_black_loop, show_screen_colours_1, show_screen_colours_2
color_ram:
		.fill	1000
.endv

.virtual $dc00
; keyboard columns, joystick port 2
; read by: puzzle_terminal, puzzle_terminal_editing, puzzle_terminal_move, puzzle_terminal_left, puzzle_letter_previous, puzzle_letter_next, puzzle_terminal_check, fuel_tank, radar, intro_loop, probe, probe_direction, probe_check_left, probe_check_right, frame_joystick
cia1_port_a:		.byte	?
.endv

.virtual $dc08
; read by: puzzle_next, update_status
; written by: new_game_reset
cia1_tod_tenths:		.byte	?
; read by: update_status
; written by: new_game_reset
cia1_tod_seconds:		.byte	?
; read by: update_status
; written by: new_game_reset
cia1_tod_minutes:		.byte	?
; read by: update_status
; written by: new_game_reset
cia1_tod_hours:		.byte	?
.endv

.virtual $dc0d
; written by: draw_screen
cia1_irq_control:		.byte	?
.endv

.virtual $dc0f
; read by: new_game_reset
; written by: new_game_reset
cia1_timer_b_control:		.byte	?
.endv

.virtual $dd0d
; read by: nmi_restore_game
; written by: nmi_restore_game
cia2_irq_control:		.byte	?
.endv

.virtual $e000
; ---------------------------------------------------------------- RAM under the KERNAL
; the map at run time
; written by: start_copy_store
map:
		.fill	7472
; read by: scroll_shift_screen
; written by: start_copy_tables
scroll_copy_start:
		.fill	10
; read by: scroll_shift_screen
scroll_copy_source:
		.fill	710
.endv
