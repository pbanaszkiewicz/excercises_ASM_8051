.area MAIN(ABS)
.org 0x00
LJMP START;

.org 0x0b
LJMP P_IRQ

.org 0x23
LJMP SERIAL_IRQ

.org 0x30
START:
    ; tryb timera T0 16b, wartości pocz. T0
    MOV TMOD, #0x21  ; T0: tryb 1 (16b), T1: tryb 2 (8b reload)
    MOV TH0, #250
    MOV TL0, #180

    ; ustawienia komunikacji szeregowej
    MOV PCON, #0x00  ; brak SMOD
    MOV SCON, #0x50  ; SETB REN (odbiór), SETB SM1 (tryb 1, transmisja asyn.)
    MOV TMOD, #0x20  ; drugi tryb zegara T1 (z przeładowaniem)

    MOV TH1, #0xFD   ; dla baud=9600
    MOV TL1, #0xFD   ;

    ; uruchomienie przerwań (w tym przerwania od portu szereg.) i timerów
    SETB EA
    SETB ES
    SETB ET0
    SETB TR0
    SETB TR1

    ; ustawienie wartości PWM
    MOV R2, #5  ; R3 - jest zapisywane przez SERIAL_IRQ, ale inicjalizujemy
    MOV R0, R3
    MOV A, #8
    SUBB A, R0
    MOV R1, A  ; R1=8-R0

    CLR P1.1
    CLR P1.0

MAIN:
    LJMP MAIN

; obsługa przerwania z timera T0:
P_IRQ:
    ; wartości początkowe
    ;  Przerwanie działa co (20/8)ms, lub inaczej: 8 razy częściej niż f=50Hz.
    ;  Dzięki temu można precyzyjnie ustawić wypełnienie sygnału PWM: od 0:8 do
    ;  8:1, utrzymując przy tym częstotliwość bliską 50Hz.
    ;  Na początku przerwania resetujemy wartość timera T0.
    MOV TH0, #250
    MOV TL0, #180

    ; zapalenie diody przez R0 cykli
    ;  Następnie wykonujemy pętlę ustawiającą świecenie diody. Ona zawiera
    ;  powrót z przerwania (instrukcja RETI), dzięki czemu wyłączenie diody
    ;  oraz reset rejestrów pomocniczych R0, R1 **nie wykona się** dopóki
    ;  R0 != 0.
    DJNZ R0, LED_LOOP

    ;  Ustawianie R0 "na sztywno" na 0.  Dzięki temu będzie wykonywał się kod
    ;  poniżej.
    MOVB R0, #1

    ; zgaszenie diody przez R1=(8 - R0) cykli
    ;  Po R0-cyklach (np. 5, jak w naszym programie) uruchomionych zostaje
    ;  (8-R0) cykli wyłączania diody.
    SETB P1.0; wykonywane w obsłudze przerwania aby zaoszczędzić na ilości cykli maszynowych
    DJNZ R1, LED_LOOP

    ; reset ustawień R0 i R1
    ;  Na samym końcu następuje reset wartości rejestrów pomocniczych.
    MOV R0, R2
    MOV A, #8
    SUBB A, R0
    MOV R1, A  ; R1=8-R0

    ; zapalenie diody jest również "restartowane", również w celu oszczędzenia
    ; cykli maszynowych
    CLR P1.0

    RETI

LED_LOOP:
    RETI

; obsługa portu szeregowego
SERIAL_IRQ:
    MOV R2, SBUF  ; zapisanie przychodzącego bajtu do R1
    MOV SBUF, R2  ; odesłanie tego samego bajtu
    CLR RI;  zerowanie flagi odbioru
    CLR TI;  zerowanie flagi nadawania
    RETI
