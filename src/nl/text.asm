; Dutch texts, included by grotten.asm (see NOTES.md, "Texts").
; PETSCII, upper case only. Each .segment is put in place by grotten.asm.

language = "nl"

; the title screen, printed with CHROUT: control codes as bytes, ends with 0
text_title .segment
		.text	$13, $8e, $08, $11, $11, $11, $11, $11, $90, $12, "    DE GROTTEN VAN OBERON", $0d
		.text	$11, $11, $12, "    F1: EENVOUDIGE PUZZELS", $0d
		.text	$12, $11, "    F3: NORMALE PUZZELS", $0d
		.text	$12, $11, "    F5: PITTIGE PUZZELS", $0d
		.text	$12, $11, "    F7: MOEILIJKE PUZZELS", $0d
		.text	$12, $11, $11, "    (C) COPYRIGHT 1985 RADARSOFT", $0d
		.null	$12, $11, "    DOOR C.KRAMER FEBRUARI 1985"
		.endsegment

; the end text when the way out is found, printed like the title
text_won .segment
		.text	$13, $8e, $08, $11, $11, $11, $12, $11, $90, "   PROFICIAT MET DEZE GRANDIOZE", $0d
		.text	$12, $11, "   PRESTATIE: HET IS U GELUKT OM", $0d
		.text	$12, $11, "   DE MENSHEID VEEL EXTRA KENNIS", $0d
		.text	$12, $11, "   TE VERSCHAFFEN.", $0d
		.text	$12, $11, " DOOR DIT PUZZELAVONTUUR OP TE LOSSEN", $0d
		.text	$12, $11, " HEEFT U BEWEZEN OVER VEEL INZICHT,", $0d
		.text	$12, $11, " GEHEUGEN, INTELLIGENTIE EN", $0d
		.text	$12, $11, " DOORZETTINGSVERMOGEN TE BESCHIKKEN !", $0d
		.null	$12, $11, "       C.KRAMER 18-2-1985"
		.endsegment

; The status line, scrolled through the status sprites: fuel, time and damage
; (written by the game into the digits), then the current message, which
; show_message copies into status_message. Any length; the scroller follows.
text_status .segment
		.text	" BRANDSTOF:"
status_fuel:
		.text	"0000"
		.text	" TIJD:"
status_hours:
		.text	"01"
		.text	":"
status_minutes:
		.text	"00"
		.text	":"
status_seconds:
		.text	"00"
		.text	" SCHADE:"
status_message:
		.text	"00 % -   GEKRAAKT  IN  1985  DOO"
		.text	"R  ABC        -       "
		.endsegment

; The messages. show_message copies 54 characters from the start of one; a
; shorter message shows the start of the next after it. The default one comes
; after the two damage digits; it is the normal status (credits).
text_messages .segment
damage:
		.text	"00"
message_default:
		.text	" % -   GEKRAAKT  IN  1985  DOOR  ABC        -       "
; the fuel warning, shown when the fuel counts down to fuel_low_level
message_fuel_low:
		.text	" MACHINEKAMER MELDT: ", $22, "DE BRANDSTOF RAAKT OP !", $22, "        "
message_damage_top:
		.text	" BOORDCOMPUTER MELDT: ", $22, "SCHADE AAN BOVENKANT", $22, "          "
message_damage_bottom:
		.text	" ", $22, "LICHTE SCHADE AAN ONDERKANT", $22, " ALDUS BOORDCOMPUTER   "
message_damage_right:
		.text	" BOORDCOMPUTER: ", $22, "AANZIENLIJKE SCHADE RECHTERKANT", $22, "     "
message_damage_left:
		.text	" ", $22, "OPPERVLAKKIGE SCHADE LINKERKANT", $22, " ZEGT BOORDCOMPUTER "
message_damage_all:
		.text	" ", $22, "ALGEHELE ZWARE BESCHADIGINGEN", $22, " MELDT BOORDCOMPUTER  "
message_switch:
		.text	" SCHAKELAAR OMGEZET MET AFSTANDSBEDIENING             "
message_door_open:
		.text	" DEUR TIJDELIJK GEOPEND DOOR RADIOVERBINDING          "
message_puzzle:
		.text	" BESTURING COMPUTER INGESCHAKELD                      "
message_fuel_tank:
		.text	" VERBINDING MET TANK AANGEBRACHT                      "
message_radar:
		.text	" RADARSCHERM GEACTIVEERD: POSITIE AANGEGEVEN         "
message_solved:
		.text	" DE JUISTE CODE IS INGEVOERD EN DE DOORGANG IS VRIJ   "
message_out_of_fuel:
		.text	" BRANDSTOF OP: EINDE VAN SPEL !!                      "
message_destroyed:
		.text	" 100 % SCHADE: EINDE VAN SPEL !!                      "
		.endsegment

; shown in the puzzle display when the fuel is 1000 or more, 4 characters
text_fuel_full .segment
		.text	"VOL!"
		.endsegment

; the introduction, scrolled through the puzzle display until fire is pressed,
; ends with 0
text_intro .segment
		.text	"WELKOM BIJ: ", $22, "DE GROTTEN VAN OBERON", $22, "!  HET IS MOMENTEEL HET "
		.text	"JAAR 2107 EN MET MODERNE RUIMTESCHEPEN WORDT HET "
		.text	"ZONNESTELSEL VERKEND. OP OBERON, DE BUITENSTE MAAN VAN DE "
		.text	"PLANEET URANUS WERD EEN GIGANTISCH GROTTENSTELSEL ONTDEKT. "
		.text	"UIT ONDERZOEKINGEN BLEEK DAT HET WAS AANGELEGD DOOR EEN "
		.text	"REEDS LANG GELEDEN UITGESTORVEN BESCHAVING. IN DE GROTTEN "
		.text	"WERD ALLE KENNIS VAN DE BESCHAVING BEWAARD. OM DEZE KENNIS "
		.text	"VERBORGEN TE HOUDEN VOOR EVENTUELE VIJANDEN, WERD HET "
		.text	"GROTTENSTELSEL VOORZIEN VAN INGEWIKKELDE VRAGEN DIE MEN "
		.text	"MOEST OPLOSSEN OM BIJ DE KENNIS TE KOMEN. HET IS UW TAAK OM "
		.text	"TE PROBEREN DE KENNIS EN WIJSHEID VAN DEZE VERLOREN CULTUUR "
		.null	"OP TE SPOREN: VEEL SUCCES !!!       "
		.endsegment
