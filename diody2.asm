.area MAIN(ABS)
.org 0x00

    LJMP START;

.org 0x30

petla1:
    DJNZ R0, petla1;
    RET

START:
    MOV P1, #0b00000000;
    MOV R0, #16  ; swiecenie przez krotszy okres czasu, dzieki czemu widac efekt
    LCALL petla1;
    MOV P1, #0b00111111;
    MOV R0, #255 ; nieswiecenie dluzej
    LCALL petla1;
    LJMP START;
