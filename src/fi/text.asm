; Finnish texts, included by grotten.asm (see NOTES.md, "Texts").
; PETSCII, upper case only; [ is A with dots (A umlaut), \ is O with dots (the
; Finnish charset has them there). Each .segment is put in place by grotten.asm.

language = "fi"

; the title screen, printed with CHROUT: control codes as bytes, ends with 0
text_title .segment
		.text	$13, $8e, $08, $11, $11, $11, $11, $11, $90, $12, "    OBERONIN LUOLAT:", $0d
		.text	$11, $11, $12, "    F1: YKSINKERTAINEN PALAPELI", $0d
		.text	$12, $11, "    F3: NORMAALI PALAPELI", $0d
		.text	$12, $11, "    F5: VAIKEA PALAPELI", $0d
		.text	$12, $11, "    F7: ERITTAIN VAIKEA PALAPELI", $0d
		.text	$12, $11, $11, "    (C) COPYRIGHT 1985 RADARSOFT", $0d
		.null	$12, $11, "    TEKIJA: C. KRAMER"
		.endsegment

; the end text when the way out is found, printed like the title
text_won .segment
		.text	$13, $8e, $08, $11, $11, $11, $12, $11, $90, "   ONNITTELEMME !!", $0d
		.text	$12, $11, " OLET ONNISTUNUT SAATTAMAAN", $0d
		.text	$12, $11, " IHMISKUNNAN TIETOON PALJON", $0d
		.text	$12, $11, " UUTTA TIETOA! RATKAISEMALLA", $0d
		.text	$12, $11, " PALAPELISEIKKAILUN OLET TODISTANUT,", $0d
		.text	$12, $11, " ETTA OMAAT OIVALLUSTA, ALYKKYYTTA", $0d
		.text	$12, $11, " SEKA HYVAN MUISTIN", $0d
		.text	$12, $11, " JA ITSESUOJELUVAISTON !", $0d
		.null	$12, $11, "       C.KRAMER 9-11-1985"
		.endsegment

; The status line, scrolled through the status sprites: fuel, time and damage
; (written by the game into the digits), then the current message, which
; show_message copies into status_message. Any length; the scroller follows.
text_status .segment
		.text	" POLTTOAINE:"
status_fuel:
		.text	"0000"
		.text	" AIKA:"
status_hours:
		.text	"00"
		.text	":"
status_minutes:
		.text	"00"
		.text	":"
status_seconds:
		.text	"00"
		.text	" VAURIO:"
status_message:
		.text	"00 % - COPYRIGHT 1985 RADARSOFT TEKIJ[: C.KRAMER -    "
		.endsegment

; The messages. show_message copies 54 characters from the start of one; a
; shorter message shows the start of the next after it. The default one comes
; after the two damage digits; it is the normal status (credits).
text_messages .segment
damage:
		.text	"00"
message_default:
		.text	" % - COPYRIGHT 1985 RADARSOFT TEKIJ[: C.KRAMER -    "
message_damage_top:
		.text	" ALUKSEN TIETOKONE: ", $22, "ALUKSEN ULKOPUOLINEN VAURIO", $22, "     "
message_damage_bottom:
		.text	" TIETOKONE ILMOITTAA: ", $22, "PIENI VAURIO ALUKSEN ALAOSASSA", $22
message_damage_right:
		.text	" ALUKSEN TIETOKONE: ", $22, "VAKAVA VAURIO OIKEASSA LAIDASSA", $22, " "
message_damage_left:
		.text	" TIETOKONE ILMOITTAA: ", $22, "VAURIO ALUKSEN VAS. LAIDASSA", $22, "  "
message_damage_all:
		.text	" TIETOKONE ILMOITTAA: ", $22, "ERITT. VAKAVA VAURIO", $22, "          "
message_switch:
		.text	" KYTKIMEN K[[NT[MINEN KAUKO-OHJAUKSELLA               "
message_door_open:
		.text	" OVI AVATTU V[LIAIK. RADIO-OHJAUKSELLA                "
message_puzzle:
		.text	" TIETOKONEOHJAUS KYTKETTY P[[LLE                      "
message_fuel_tank:
		.text	" S[ILI\ KYTKETTY                                      "
message_radar:
		.text	" TUTKA AKTIVOITU: SIJAINTI ANNETTU                    "
message_solved:
		.text	" OIKEA KOODI: OVI AVATTU V[LIAIK.                     "
message_out_of_fuel:
		.text	" POLTTOAINE LOPPU: PELI P[[TTYNYT!                    "
message_destroyed:
		.text	" 100 % VAURIO: PELI P[[TTYNYT!!!!                     "
		.endsegment

; shown in the puzzle display when the fuel is 1000 or more, 4 characters
text_fuel_full .segment
		.text	"****"
		.endsegment

; the introduction, scrolled through the puzzle display until fire is pressed,
; ends with 0
text_intro .segment
		.text	"T[M[ PELI VIE SINUT VUOTEEN 2107. HUIPPUNYKYAIKAISET "
		.text	"AVARUUSALUKSET OVAT TUTKIMASSA AURINKOKUNTAA. ", $22, "OBERONISSA", $22, ", "
		.text	"JOKA ON URANUS-PLANEETAN ULOMPI KUU, ON L\YDETTY VALTAVA "
		.text	"LUOLAVERKOSTO, JONKA ON LUONUT JO AIKOJA SITTEN H[VINNYT "
		.text	"KULTTUURI. KAIKKI KULTTUURISTA KERTOVA TIETO ON S[ILYNYT "
		.text	"N[ISS[ LUOLISSA. T[M[ TIETO ON HALUTTO SUOJATA MAHDOLLISILTA "
		.text	"VIHOLLISILTA. LUOLAVERKOSTOA SUOJAA MONIMUTKAINEN "
		.text	"PALAPELI, JOKA ON RATKAISTAVA ENNEN KUIN P[[SEE K[SIKSI "
		.text	"SUOJATTUIHIN TIETOIHIN. SINUN TEHT[V[SI ON L\YT[[ "
		.text	"K[TKETTY TIETO JA VIISAUS, JONKA H[VINNYT KULTTUURI "
		.null	"ON J[TT[NYT J[LKEENS[. ONNEA YRITYKSELLE!     "
		.endsegment
