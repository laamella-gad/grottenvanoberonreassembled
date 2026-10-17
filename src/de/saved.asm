; The values some variables held when this version was saved. grotten.asm
; starts them with these, so that the build is identical to the original.

; the status scroller's pixel column and character
saved_status_pixel = $00
saved_status_index = $00
saved_last_frame = $00
; scroller workspace
saved_glyph_buffer = [$8d, $82, $1d, $a9, $ff, $a0, $07, $99, $70, $2f, $88, $10, $fa, $78, $ad, $0f, $dc, $29, $7f, $8d]
; puzzle answer workspace
saved_answer = [$0f, $dc, $a9, $3b, $8d, $18, $03, $a9, $1f, $8d, $19, $03, $20, $31]
; the voice 2 sound effect
saved_sfx_frequency = $0000
saved_sfx_step = $0000
saved_sfx_time = $0000
saved_fuel_timer = $0a
; the switch: 1 = set
saved_switch_state = $00
; the operand of status_copy_glyph
saved_status_glyph = $ffff
