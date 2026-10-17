; English texts, included by grotten.asm (see NOTES.md, "Texts").
; PETSCII, upper case only. Each .segment is put in place by grotten.asm.

language = "en"

; the title screen, printed with CHROUT: control codes as bytes, ends with 0
text_title .segment
		.text	$13, $8e, $08, $11, $11, $11, $11, $11, $90, $12, "    THE CAVES OF OBERON", $0d
		.text	$11, $11, $12, "    F1: SIMPLE PUZZLES", $0d
		.text	$12, $11, "    F3: NORMAL PUZZLES", $0d
		.text	$12, $11, "    F5: DIFFICULT PUZZLES", $0d
		.text	$12, $11, "    F7: VERY DIFFICULT PUZZLES", $0d
		.text	$12, $11, $11, "    (C) COPYRIGHT 1985 RADARSOFT", $0d
		.null	$12, $11, "    BY C. KRAMER"
		.endsegment

; the end text when the way out is found, printed like the title
text_won .segment
		.text	$13, $8e, $08, $11, $11, $11, $12, $11, $90, "   CONGRATULATIONS !!", $0d
		.text	$12, $11, "   YOU ACHIEVED TO PROVIDE", $0d
		.text	$12, $11, "   MANKIND WITH A LOT OF", $0d
		.text	$12, $11, "   EXTRA KNOWLEDGE!", $0d
		.text	$12, $11, " BY SOLVING THIS PUZZLE-ADVENTURE", $0d
		.text	$12, $11, " YOU HAVE PROVED TO HAVE THE", $0d
		.text	$12, $11, " DISPOSAL OF INSIGHT,INTELLIGENCE,", $0d
		.text	$12, $11, " MEMORY AND PERSEVERANCE!", $0d
		.null	$12, $11, "       C.KRAMER 8-5-1985"
		.endsegment

; The status line, scrolled through the status sprites: fuel, time and damage
; (written by the game into the digits), then the current message, which
; show_message copies into status_message. Any length; the scroller follows.
text_status .segment
		.text	" FUEL:"
status_fuel:
		.text	"0000"
		.text	" TIME:"
status_hours:
		.text	"00"
		.text	":"
status_minutes:
		.text	"00"
		.text	":"
status_seconds:
		.text	"00"
		.text	" DAMAGE:"
status_message:
		.text	"00 % - COPYRIGHT 1985 RADARSOFT "
		.text	"BY C.KRAMER -         "
		.endsegment

; The messages. show_message copies 54 characters from the start of one; a
; shorter message shows the start of the next after it. The default one comes
; after the two damage digits; it is the normal status (credits).
text_messages .segment
damage:
		.text	"00"
message_default:
		.text	" % - COPYRIGHT 1985 RADARSOFT BY C.KRAMER -         "
; never shown: the fuel warning
message_fuel_low:
		.text	" MACHINEROOM REPORTS: ", $22, "LOW ON FUEL", $22, "                   "
message_damage_top:
		.text	" SHIPBOARD COMPUTER: ", $22, "DAMAGE UPSIDE SPACESHIP", $22, "        "
message_damage_bottom:
		.text	" COMPUTER REPORTS: ", $22, "SLIGHT DAMAGE BOTTOM SAUCER", $22, "      "
message_damage_right:
		.text	" SHIPBOARD COMPUTER: ", $22, "SERIOUS DAMAGE RIGHT SIDE", $22, "      "
message_damage_left:
		.text	" COMPUTER SAYS: ", $22, "DAMAGE LEFT SIDE SPACESHIP", $22, "          "
message_damage_all:
		.text	" COMPUTER REPORTS: ", $22, "TOTAL SERIOUS DAMAGE", $22, "             "
message_switch:
		.text	" SWITCH REVERSED BY REMOTE CONTROL                    "
message_door_open:
		.text	" DOOR OPENED TEMPORARILY BY RADIO CONTROL             "
message_puzzle:
		.text	" COMPUTER CONTROL SWITCHED ON                         "
message_fuel_tank:
		.text	" TANK CONNECTED                                       "
message_radar:
		.text	" RADAR ACTIVATED: POSITION INDICATED                  "
message_solved:
		.text	" CORRECT CODE: DOOR OPENED TEMPORARILY                "
message_out_of_fuel:
		.text	" OUT OF FUEL: GAME OVER !                             "
message_destroyed:
		.text	" 100 % DAMAGE!: GAME OVER !!!!!!!                     "
		.endsegment

; shown in the puzzle display when the fuel is 1000 or more, 4 characters
text_fuel_full .segment
		.text	"FULL"
		.endsegment

; the introduction, scrolled through the puzzle display until fire is pressed,
; ends with 0
text_intro .segment
		.text	"THIS GAME TAKES YOU TO THE YEAR 2107. ULTRA-MODERN "
		.text	"SPACESHIPS ARE EXPLORING THE SOLAR SYSTEM. ON ", $22, "OBERON", $22, ", THE "
		.text	"OUTER MOON OF THE PLANET URANUS, A GIGANTIC CAVE SYSTEM HAS "
		.text	"BEEN DISCOVERED, CONSTRUCTED BY A CULTURE LONG EXTINCT. ALL "
		.text	"THE KNOWLEDGE OF THIS CULTURE HAS BEEN PRESERVED IN THESE "
		.text	"CAVES. TO HIDE THIS KNOWLEDGE FROM POSSIBLE ENEMIES, THE "
		.text	"CAVE SYSTEM IS PROTECTED BY COMPLICATED PUZZLES THAT HAVE "
		.text	"TO BE SOLVED IN ORDER TO GET TO THE HIDDEN KNOWLEDGE. IT IS "
		.text	"YOUR TASK TO DISCOVER THE KNOWLEDGE AND WISDOM OF THIS LOST "
		.null	"CULTURE. GOOD LUCK!!!      "
		.endsegment
