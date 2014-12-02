.area MAIN(ABS)
.org 0x00
	LJMP START;

ORG 0BH ; obsluga przerwania T0

    PUSH PSW  ; przechowywanie rejestrów na stosie
    PUSH ACC
    
    MOV TH0, #76  ; uruchomienie na 50ms
    DJNZ TIME, WAIT_1S
    
WAIT_1S:
    POP ACC  ; odtworzenie rejestrów
    POP PSW
	RETI

ORG 100H;
START:
	MOV TMOD, #00000010B;  T0 uruchomiony w trybie 2
	MOV TH0, #200;  wartosc ladowana do tl0 po obsludze przerwania
	
	CLR TF0;
	MOV TL0, #230;
	
	SETB TR0;  uruchomiony timer 0
	
	SETB EA;  globalne przerwania aktywne
	SETB ET0;  przerwania od T0 aktywne
	
	JMP LOOP;
LOOP:
	INC p1;
	JMP LOOP;

