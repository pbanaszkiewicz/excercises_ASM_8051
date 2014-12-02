.area MAIN(ABS)
.org 0x00
LJMP START;

.org 0x0b
LJMP P_IRQ

.org 0x30
START:
	; tryb 16b, wart. pocz. 0
	MOV TMOD, #0x01
	MOV TH0, #250
	MOV TL0, #180

	; uruchomienie przerwań i timera
	SETB EA;
	SETB ET0;
	SETB TR0;

	MOV R0, #5
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
	;  Dzięki temu można precyzyjnie ustawić wypełnienie sygnału PWM: od 0/8 do
	;  8/1, utrzymując przy tym częstotliwość bliską 50Hz.
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
	MOV R0, #5
	MOV A, #8
	SUBB A, R0
	MOV R1, A  ; R1=8-R0

	; zapalenie diody jest również "restartowane", również w celu oszczędzenia
	; cykli maszynowych
	CLR P1.0

	RETI

LED_LOOP:
	RETI
