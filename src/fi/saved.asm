; The values some variables held when this version was saved. grotten.asm
; starts them with these, so that the build is identical to the original.

; the status scroller's pixel column and character
saved_status_pixel = $00
saved_status_index = $00
saved_last_frame = $00
; scroller workspace
saved_glyph_buffer = [$00, $00, $00, $00, $00, $00, $00, $52, $60, $4e, $20, $60, $45, $20, $60, $45, $4e, $c0, $49, $31]
; puzzle answer workspace
saved_answer = [$20, $2b, $20, $32, $20, $2b, $20, $0f, $20, $3d, $20, $36, $20, $20]
; the voice 2 sound effect
saved_sfx_frequency = $0000
saved_sfx_step = $0000
saved_sfx_time = $0000
saved_fuel_timer = $0a
; the switch: 1 = set
saved_switch_state = $00
; the operand of status_copy_glyph
saved_status_glyph = $ffff
