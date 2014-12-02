.area MAIN(ABS)
.org 0x00
LJMP START;

.org 0x30
START:
    ; zaświecenie wszystkich diod
    MOV P1, #0b00000000;

    ; Ustalenie wartości w rejestrach podstawowych, dzięki czemu wykona się ok.
    ; (229 * 2) * (42 * 2) * (2 * 2) = 153888 cykli maszynowych.
    ; 1/6 sekundy to ok. 153600 cykli maszynowych.
    ; Dzięki temu uda nam się osiągnąć częstotliwość mrugania diodami 3Hz
    MOV R0, #229
    MOV R1, #42
    MOV R2, #2
    LCALL petla3

    ; zgaszenie wszystkich diod poza dwoma pierwszymi
    MOV P1, #0b00111111;

    ; analogiczna pętla jak wyżej
    MOV R0, #229
    MOV R1, #42
    MOV R2, #2
    LCALL petla3

    LJMP START;

; potrójna zagnieżdżona pętla korzystająca z trzech rejestrów pomocniczych:
; R0, R1 oraz R2.
petla3:
    petla2:
        petla1:
            ; DJZN zajmuje 2 cykle maszynowe
            DJNZ R0, petla1;
        DJNZ R1, petla2;
    DJNZ R2, petla3;
    RET
