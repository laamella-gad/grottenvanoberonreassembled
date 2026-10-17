; German texts, included by grotten.asm (see NOTES.md, "Texts").
; PETSCII, upper case only. Each .segment is put in place by grotten.asm.

language = "de"

; the title screen, printed with CHROUT: control codes as bytes, ends with 0
text_title .segment
		.text	$13, $8e, $08, $11, $11, $11, $11, $11, $90, $12, "    DIE GROTTEN VON OBERON", $0d
		.text	$11, $11, $12, "    F1: LEICHTE RAETSEL", $0d
		.text	$12, $11, "    F3: NORMALE RAETSEL", $0d
		.text	$12, $11, "    F5: KERNIGE RAETSEL", $0d
		.text	$12, $11, "    F7: SCHWERE RAETSEL", $0d
		.text	$12, $11, $11, "    (C) COPYRIGHT 1985 RADARSOFT", $0d
		.null	$12, $11, "    VON C. KRAMER"
		.endsegment

; the end text when the way out is found, printed like the title
text_won .segment
		.text	$13, $8e, $08, $11, $11, $11, $12, $11, $90, "   GRATULIERE MIT DIESER LEISTUNG!", $0d
		.text	$12, $11, "   ES IST IHNEN GELUNGEN UM DIE", $0d
		.text	$12, $11, "   MENSCHHEIT VIEL WISSEN", $0d
		.text	$12, $11, "   ZU VERSCHAFFEN !", $0d
		.text	$12, $11, " DURCH DAS LOESEN DIESES ABENTEUERS", $0d
		.text	$12, $11, " HABEN SIE BEWIESEN UEBER VIEL", $0d
		.text	$12, $11, " EINSICHT INTELLIGENZ AUSDAUER UND", $0d
		.text	$12, $11, " GEDAECHTNIS ZU VERFUEGEN!!!", $0d
		.null	$12, $11, "       C.KRAMER 13-10-1985"
		.endsegment

; The status line, scrolled through the status sprites: fuel, time and damage
; (written by the game into the digits), then the current message, which
; show_message copies into status_message. Any length; the scroller follows.
text_status .segment
		.text	" BRENNSTOFF:"
status_fuel:
		.text	"0000"
		.text	" ZEIT:"
status_hours:
		.text	"00"
		.text	":"
status_minutes:
		.text	"00"
		.text	":"
status_seconds:
		.text	"00"
		.text	" SCHADEN:"
status_message:
		.text	"00 % - COPYRIGHT 1985 RADARSOFT "
		.text	"VON C.KRAMER -        "
		.endsegment

; The messages. show_message copies 54 characters from the start of one; a
; shorter message shows the start of the next after it. The default one comes
; after the two damage digits; it is the normal status (credits).
text_messages .segment
damage:
		.text	"00"
message_default:
		.text	" % - COPYRIGHT 1985 RADARSOFT VON C.KRAMER -        "
message_damage_top:
		.text	" BORDCOMPUTER MELDET: ", $22, "SACHSCHADEN AN OBERSEITE", $22, "      "
message_damage_bottom:
		.text	" ", $22, "LEICHTER SCHADEN AN UNTERSEITE", $22, " LAUT BORDCOMPUTER   "
message_damage_right:
		.text	" BORDCOMPUTER MELDET: ", $22, "SCHADEN RECHTE SEITE", $22, "          "
message_damage_left:
		.text	" ", $22, "OBERFLAECHLICHER SCHADEN LINKE SEITE", $22, " SAGT COMPUTER "
message_damage_all:
		.text	" ", $22, "VOELLIGE SCHWERE BESCHAEDIGUNG", $22, " SAGT BORDCOMPUTER   "
message_switch:
		.text	" SCHALTER UMGESTELLT MIT ABSTANDBEDIENUNG             "
message_door_open:
		.text	" TUER ZEITWEISE GEOEFFNET DURCH RADIOVERBINDUNG       "
message_puzzle:
		.text	" STEUERUNG COMPUTER EINGESCHALTET                     "
message_fuel_tank:
		.text	" VERBINDUNG MIT TANK ZU STANDE GEBRACHT               "
message_radar:
		.text	" RADARSCHIRM ACTIVIERT: POSITION ANGEGEBEN            "
message_solved:
		.text	" RICHTIGE CODE: DER DURCHGANG IST FREI                "
message_out_of_fuel:
		.text	" BRENNSTOFF ALLE: ENDE SPIEL!!!!                      "
message_destroyed:
		.text	" 100 % SCHADEN: ENDE SPIEL!!!!!!!                     "
		.endsegment

; shown in the puzzle display when the fuel is 1000 or more, 4 characters
text_fuel_full .segment
		.text	"VOLL"
		.endsegment

; the introduction, scrolled through the puzzle display until fire is pressed,
; ends with 0
text_intro .segment
		.text	"WILKOMMEN ZU: ", $22, "DIE GROTTEN VON OBERON", $22, ".  WIR SCHREIBEN DAS "
		.text	"JAHR 2107 UND MIT MODERNEN RAUMSCHIFFEN WIRD DAS "
		.text	"SONNENSYSTEM ERKUENDET. AUF OBERON, EIN MOND VOM PLANET "
		.text	"URANUS WIRD EINE GIGANTISCHE HOELENVERSAMMLUNG ENTDECKT. "
		.text	"AUS UNTERSUCHUENGEN ERGAB SICH DASS DIESE SAMMLUNG DURCH "
		.text	"EINE LAENGST AUSGESTORBENE ZIVILISATION ANGELEGT WORDEN "
		.text	"WAR. IN DEN HOEHLEN WURDE DAS GANZE WISSEN DIESER "
		.text	"ZIVILISATION AUFGEHOBEN. UM DIESES WISSEN FUER FEINDE ZU  "
		.text	"BESCHUETZEN WURDE DAS HOEHLENSYSTEM MIT KOMPLIZIERTEN "
		.text	"FRAGEN AUSGESTATTET. MAN MUSSTE SIE LOESEN UM AN DIESER "
		.text	"KENNTNIS HERAN ZU KOMMEN. ES IST IHRE AUFGABE ZU PROBIEREN "
		.text	"UM DIE WEISHEIT UND KENNTNIS DIESER VERLORENEN KULTUR "
		.null	"AUSFINDIG ZU MACHEN: VIEL GLUECK!  "
		.endsegment
