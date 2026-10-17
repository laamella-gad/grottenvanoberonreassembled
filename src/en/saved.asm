; The values some variables held when this version was saved. grotten.asm
; starts them with these, so that the build is identical to the original.

; the status scroller's pixel column and character
saved_status_pixel = $00
saved_status_index = $00
saved_last_frame = $00
; scroller workspace
saved_glyph_buffer = [$00, $60, $e0, $e0, $60, $60, $00, $00, $a9, $c0, $8d, $19, $00, $01, $12, $00, $31, $3f, $e0, $0d]
; puzzle answer workspace
saved_answer = [$20, $31, $37, $3d, $13, $05, $16, $05, $0e, $14, $05, $05, $0e, $20]
; the voice 2 sound effect
saved_sfx_frequency = $0000
saved_sfx_step = $0000
saved_sfx_time = $0000
saved_fuel_timer = $0a
; the switch: 1 = set
saved_switch_state = $00
; the operand of status_copy_glyph
saved_status_glyph = $ffff
