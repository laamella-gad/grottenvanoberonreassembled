; The release image: the game (build/<language>.prg, $0801-$cfff) with the
; loading picture behind it, in the RAM under the I/O and the KERNAL, and the
; code that shows it. pucrunch unpacks it with all RAM banked in and starts
; show_picture with $01 = $35; a key or fire starts the game. The game copies
; its map over the picture at the start. See NOTES.md, "The loading picture".
;
;   64tass -D 'game="nl.prg"' -I build -I src/nl -o build/nl_release.prg src/release.asm

cpu_port = $01
vic_control_1 = $d011
vic_control_2 = $d016
vic_memory_setup = $d018
border_color = $d020
background_color = $d021
color_ram = $d800
cia1_port_a = $dc00
cia1_port_b = $dc01
cia2_port_a = $dd00
cia2_direction_a = $dd02
nmi_vector = $fffa
tape_buffer = $033c
start = $1000

*=$0801
		.binary	game, 2
		.cerror	* != $d000, "the game doesn't end at $d000"

; the picture, a Koala file (load address, bitmap, screen, colours,
; background), in VIC bank 3 ($c000-$ffff): the colours at $d000, copied to
; the colour RAM, the screen at $d400, the bitmap at $e000
picture_colours:
		.binary	"picture.kla", 2 + 9000, 1000
		.fill	$d400 - *, 0
picture_screen:
		.binary	"picture.kla", 2 + 8000, 1000
		.fill	$e000 - *, 0
picture_bitmap:
		.binary	"picture.kla", 2, 8000

; shows the picture until a key or fire is pressed (and let go), then starts
; the game. Runs with the KERNAL banked out and interrupts off. The Makefile
; gives pucrunch this address.
show_picture:
		.cerror	* != $ff40, "show_picture moved: change the Makefile"
		sei
		lda #$35
		sta cpu_port
		lda #$0b
		sta border_color
		lda picture_background
		sta background_color
		ldx #$00
; the colours: read with the I/O banked out, written with it in
show_picture_colours:
		lda #$34
		sta cpu_port
		lda picture_colours, x
		ldy #$35
		sty cpu_port
		sta color_ram, x
		lda #$34
		sta cpu_port
		lda picture_colours + $100, x
		sty cpu_port
		sta color_ram + $100, x
		lda #$34
		sta cpu_port
		lda picture_colours + $200, x
		sty cpu_port
		sta color_ram + $200, x
		lda #$34
		sta cpu_port
		lda picture_colours + $2e8, x
		sty cpu_port
		sta color_ram + $2e8, x
		inx
		bne show_picture_colours
; VIC bank 3, screen $d400, bitmap $e000, multicolour bitmap mode
		lda cia2_direction_a
		ora #$03
		sta cia2_direction_a
		lda cia2_port_a
		and #$fc
		sta cia2_port_a
		lda #$58
		sta vic_memory_setup
		lda #$18
		sta vic_control_2
		lda #$3b
		sta vic_control_1
; wait until nothing is pressed (RETURN of RUN), then for a press, then until
; it is let go
		jsr show_picture_pressed
		bne * - 3
		jsr show_picture_pressed
		beq * - 3
		jsr show_picture_pressed
		bne * - 3
; banking the KERNAL in from here would pull this code away under the CPU, so
; the last step runs from the tape buffer (not used by the game)
		ldx #show_picture_start_end - show_picture_start - 1
-		lda show_picture_start, x
		sta tape_buffer, x
		dex
		bpl -
		jmp tape_buffer

show_picture_start:
		.logical tape_buffer
		lda #$37
		sta cpu_port
		jmp start
		.endlogical
show_picture_start_end:

; Z clear when a key or the fire button of joystick 2 is pressed
show_picture_pressed:
		lda #$00
		sta cia1_port_a
		lda cia1_port_b
		cmp #$ff
		bne +
		lda #$ff
		sta cia1_port_a
		lda cia1_port_a
		and #$10
		eor #$10
+		rts

; RESTORE while the KERNAL is banked out
show_picture_nmi:
		rti

picture_background:
		.binary	"picture.kla", 2 + 10000, 1
		.cerror	* > nmi_vector, "show_picture runs into the vectors"
		.fill	nmi_vector - *, 0
		.word	show_picture_nmi	; NMI
		.word	show_picture	; reset, not used
		.word	show_picture_nmi	; IRQ, interrupts are off
