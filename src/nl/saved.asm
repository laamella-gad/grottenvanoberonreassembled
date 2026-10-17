; The values some variables held when this version was saved. grotten.asm
; starts them with these, so that the build is identical to the original.

; the status scroller's pixel column and character
saved_status_pixel = $06
saved_status_index = $01
saved_last_frame = $08
; scroller workspace
saved_glyph_buffer = [$00, $8d, $39, $e0, $4c, $86, $98, $ad, $00, $f0, $29, $10, $98, $03, $4c, $98, $7b, $a9, $f0, $8d]
; puzzle answer workspace
saved_answer = [$20, $31, $2b, $32, $2b, $33, $2b, $34, $2b, $b2, $3d, $31, $32, $20]
; the voice 2 sound effect
saved_sfx_frequency = $1040
saved_sfx_step = $0040
saved_sfx_time = $001f
saved_fuel_timer = $08
; the switch: 1 = set
saved_switch_state = $01
; the operand of status_copy_glyph
saved_status_glyph = $2c10
