.area main(ABS);
.org 0x00;
LJMP INIT

.org 0x0b ; link do kodu obsługi przerwania T0
LJMP T_IRQ;

.org 0x30
INIT:
    ; wstępna konfiguracja
    MOV TMOD, #0x01
    MOV TL0, #0x00
    MOV TH0, #0xFE
    SETB EA
    SETB ET0
    SETB TR0

    CLR P1.0 ; dioda, która swieci dla porównania
    MOV R1, #0x05 ; to jest stosunek swiecenia do nieswiecenia
    MOV A, #0x08
    SUBB A, R1;
    MOV R2, A;
    MOV A, R1
    LJMP MAIN

MAIN:
    LJMP MAIN

T_IRQ:
    MOV TL0, #0x00
    MOV TH0, #0xFE
    DJNZ R2, ZAPAL ;przez R2 interwałów dioda zapalona
    INC R2 ;WAZNE: zapobiega przed przejciem R2 do wartosci FF co rozwala
           ; działanie programu
    DJNZ ACC, ZGAS ;przez ACC = R1 interwałów dioda zgaszona
    MOV ACC, #0x8
    SUBB A, R1
    MOV R2,A
    MOV A,R1
    RETI
ZAPAL:
    CLR P1.1 ; dioda o jasności R1/8 * 100%
    setb P1.3 ; dioda o jasności (8-R1)/8 * 100 %
    RETI
ZGAS:
    SETB P1.1
    clr P1.3
    RETI
