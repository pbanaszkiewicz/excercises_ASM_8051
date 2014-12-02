.area MAIN(ABS)
.org 0x00
LJMP START;

.org 0x0b
LJMP P_IRQ

.org 0x30
START:
    ; tryb 16b, wart. pocz. 0
    MOV TMOD, #0x01
    MOV TH0, #76
    MOV TL0, #128
    MOV A, #5

    ; uruchomienie przerwań i timera
    SETB EA;
    SETB ET0;
    SETB TR0;

MAIN:
    LJMP MAIN

P_IRQ:
    ; wart. pocz. 0
    MOV TH0, #76
    MOV TL0, #128
    DJNZ ACC, WAIT_1S  ; jeżeli nie jest to 10 obrot przerwania, wroc

    ; zapalenie / zgaszenie diody
    CPL P1.0

    MOV A, #5

WAIT_1S:
    RETI
