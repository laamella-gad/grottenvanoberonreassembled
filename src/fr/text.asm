; French texts, included by grotten.asm (see NOTES.md, "Texts"). The French
; version is new, translated from the English one; no accents, the font has
; none. PETSCII, upper case only. Each .segment is put in place by grotten.asm.

language = "fr"

; the title screen, printed with CHROUT: control codes as bytes, ends with 0
text_title .segment
		.text	$13, $8e, $08, $11, $11, $11, $11, $11, $90, $12, "    LES GROTTES D'OBERON", $0d
		.text	$11, $11, $12, "    F1: PUZZLES SIMPLES", $0d
		.text	$12, $11, "    F3: PUZZLES NORMAUX", $0d
		.text	$12, $11, "    F5: PUZZLES DIFFICILES", $0d
		.text	$12, $11, "    F7: PUZZLES TRES DIFFICILES", $0d
		.text	$12, $11, $11, "    (C) COPYRIGHT 1985 RADARSOFT", $0d
		.null	$12, $11, "    PAR C. KRAMER"
		.endsegment

; the end text when the way out is found, printed like the title
text_won .segment
		.text	$13, $8e, $08, $11, $11, $11, $12, $11, $90, "   FELICITATIONS !!", $0d
		.text	$12, $11, "   VOUS AVEZ APPORTE A", $0d
		.text	$12, $11, "   L'HUMANITE BEAUCOUP DE", $0d
		.text	$12, $11, "   NOUVELLES CONNAISSANCES !", $0d
		.text	$12, $11, " EN RESOLVANT CETTE AVENTURE,", $0d
		.text	$12, $11, " VOUS AVEZ PROUVE QUE VOUS AVEZ", $0d
		.text	$12, $11, " DE LA PERSPICACITE, DE L'ESPRIT,", $0d
		.text	$12, $11, " DE LA MEMOIRE ET DE LA PATIENCE !", $0d
		.null	$12, $11, "       C.KRAMER 8-5-1985"
		.endsegment

; The status line, scrolled through the status sprites: fuel, time and damage
; (written by the game into the digits), then the current message, which
; show_message copies into status_message. Any length; the scroller follows.
text_status .segment
		.text	" CARBURANT:"
status_fuel:
		.text	"0000"
		.text	" TEMPS:"
status_hours:
		.text	"00"
		.text	":"
status_minutes:
		.text	"00"
		.text	":"
status_seconds:
		.text	"00"
		.text	" DEGATS:"
status_message:
		.text	"00 % - COPYRIGHT 1985 RADARSOFT "
		.text	"PAR C.KRAMER -        "
		.endsegment

; The messages. show_message copies 54 characters from the start of one; a
; shorter message shows the start of the next after it. The default one comes
; after the two damage digits; it is the normal status (credits).
text_messages .segment
damage:
		.text	"00"
message_default:
		.text	" % - COPYRIGHT 1985 RADARSOFT PAR C.KRAMER -        "
; the fuel warning, shown when the fuel counts down to fuel_low_level
message_fuel_low:
		.text	" SALLE DES MACHINES: ", $22, "PLUS BEAUCOUP DE CARBURANT", $22, "     "
message_damage_top:
		.text	" ORDINATEUR DE BORD: ", $22, "DEGATS AU-DESSUS DU VAISSEAU", $22, "   "
message_damage_bottom:
		.text	" L'ORDINATEUR SIGNALE: ", $22, "LEGERS DEGATS EN DESSOUS", $22, "     "
message_damage_right:
		.text	" ORDINATEUR DE BORD: ", $22, "GRAVES DEGATS A DROITE", $22, "         "
message_damage_left:
		.text	" L'ORDINATEUR DIT: ", $22, "DEGATS COTE GAUCHE DU VAISSEAU", $22, "   "
message_damage_all:
		.text	" L'ORDINATEUR SIGNALE: ", $22, "GRAVES DEGATS PARTOUT", $22, "        "
message_switch:
		.text	" INTERRUPTEUR INVERSE PAR TELECOMMANDE                "
message_door_open:
		.text	" PORTE OUVERTE UN MOMENT PAR RADIOCOMMANDE            "
message_puzzle:
		.text	" COMMANDE PAR ORDINATEUR ACTIVEE                      "
message_fuel_tank:
		.text	" RESERVOIR BRANCHE                                    "
message_radar:
		.text	" RADAR ACTIVE: POSITION INDIQUEE                      "
message_solved:
		.text	" CODE CORRECT: PORTE OUVERTE UN MOMENT                "
message_out_of_fuel:
		.text	" PLUS DE CARBURANT: PARTIE TERMINEE !                 "
message_destroyed:
		.text	" 100 % DE DEGATS !: PARTIE TERMINEE !!!!!!!           "
		.endsegment

; shown in the puzzle display when the fuel is 1000 or more, 4 characters
text_fuel_full .segment
		.text	"MAX!"
		.endsegment

; the introduction, scrolled through the puzzle display until fire is pressed,
; ends with 0
text_intro .segment
		.text	"CE JEU VOUS EMMENE EN L'AN 2107. DES VAISSEAUX ULTRA-"
		.text	"MODERNES EXPLORENT LE SYSTEME SOLAIRE. SUR ", $22, "OBERON", $22, ", LA "
		.text	"LUNE EXTERIEURE DE LA PLANETE URANUS, ON A DECOUVERT UN "
		.text	"GIGANTESQUE RESEAU DE GROTTES, CONSTRUIT PAR UNE CIVILISATION "
		.text	"DISPARUE DEPUIS LONGTEMPS. TOUT LE SAVOIR DE CETTE "
		.text	"CIVILISATION EST CONSERVE DANS CES GROTTES. POUR LE CACHER "
		.text	"A D'EVENTUELS ENNEMIS, LE RESEAU EST PROTEGE PAR DES "
		.text	"PUZZLES COMPLIQUES QU'IL FAUT RESOUDRE POUR ATTEINDRE LE "
		.text	"SAVOIR CACHE. VOTRE MISSION: DECOUVRIR LE SAVOIR ET LA "
		.null	"SAGESSE DE CETTE CIVILISATION PERDUE. BONNE CHANCE !!!      "
		.endsegment
