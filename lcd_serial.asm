.area MAIN(ABS)

; ustawienie pewnych "stałych"
RS  .equ P1.0
EN  .equ P1.1
DB4 .equ P1.2
DB5 .equ P1.3
DB6 .equ P1.4
DB7 .equ P1.5
DATALINE .equ P1  ; samo "DATA" nie chce się kompilować

.org 0x00
LJMP INIT

.org 0x23
LJMP SERIAL_IRQ

.org 0x30
INIT:
    ; ustawienia komunikacji szeregowej
    MOV PCON, #0x00  ; brak SMOD
    MOV SCON, #0x50  ; SETB REN (odbiór), SETB SM1 (tryb 1, transmisja asyn.)
    MOV TMOD, #0x20  ; drugi tryb zegara T1 (z przeładowaniem)

    MOV TH1, #0xFD   ; dla baud=9600
    MOV TL1, #0xFD   ;

    ; uruchomienie przerwań (w tym przerwania od portu szereg.) i timerów
    SETB EA
    SETB ES
    SETB TR1

    ; nie wiadomo czy resetowanie linii ma w tym miejscu jakikolwiek sens
    ;MOV DATALINE, #0

    ; 3 razy należy czekać i wysyłać wartość 0x3
    LCALL WAIT_LCD
    MOV DATALINE, #0b00001100
    SETB EN
    CLR EN

    LCALL WAIT_LCD
    MOV DATALINE, #0b00001100
    SETB EN
    CLR EN

    LCALL WAIT_LCD
    MOV DATALINE, #0b00001100
    SETB EN
    CLR EN

    ; dla pewności jeszcze jedno czekanie
    LCALL WAIT_LCD

    ; Koniec inicjalizacji przez czekanie, następne instrukcje można wykonać
    ; korzystając z flagi BF (Busy Flag).
    ; Niestety tryb READ wyświetlacza w laboratorium jest niedostępny, więc
    ; i tak musimy korzystać z WAIT_LCD.

    ; ustawienie trybu 4-bitowego (wysłane w trybie 8-bitowym, czyli starszą
    ; połową bajtu)
    MOV DATALINE, #0b00001000
    SETB EN
    CLR EN
    LCALL WAIT_LCD

    ; tryb funkcji (0x2), ustawienie ilości linii i czcionki
    MOV A, #0x20
    LCALL WRITE_LCD
    LCALL WAIT_LCD

    ; wyświetlacz włączony (0x0E) lub nie (0x08)
    MOV A, #0x0E
    LCALL WRITE_LCD
    LCALL WAIT_LCD

    ; czyszczenie wyświetlacza
    MOV A, #0x01
    LCALL WRITE_LCD
    LCALL WAIT_LCD

    ; ustawienie trybu wprowadzania (inkr. adresu o 1, przesuwanie kursora)
    MOV A, #0x06
    LCALL WRITE_LCD
    LCALL WAIT_LCD

    ; koniec inicjalizacji LCD ;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;

MAIN:
    MOV A, #'H'
    LCALL WRITE_CHAR
    MOV A, #'e'
    LCALL WRITE_CHAR
    MOV A, #'l'
    LCALL WRITE_CHAR
    MOV A, #'l'
    LCALL WRITE_CHAR
    MOV A, #'o'
    LCALL WRITE_CHAR

LOOP:
    LJMP LOOP


; oczekiwanie na LCD
WAIT_LCD:
    MOV R1, #232
    MOV R2, #42
    petla3:
        petla2:
            ;petla1:
            ;   DJNZ R0, petla1;
            DJNZ R1, petla2;
        DJNZ R2, petla3;
    RET

; wysłanie dowolnych danych do LCD
WRITE_LCD:
    PUSH ACC  ; wartość akumulatora przyda się do wysyłania pozostałych 4b

    ; zmieniamy ustawienie *tylko* DB7-DB4 na 1
    ORL DATALINE, #0b00111100
    ; ustawiamy młodsze 4b na 1
    ORL A, #0x0F
    ; przesuwamy (cyklicznie) akumulator w prawo o dwie pozycje
    ; dzięki temu zabiegowi najstarsze 4b są na pozycjach bitów 6-2
    RR A
    RR A
    ; logiczny AND ustawia tylko bity odpowiadające DB7-DB4
    ANL DATALINE, A
    SETB EN
    CLR EN

    ; wydaje się, że ten postój jest niepotrzebny
    ;LCALL WAIT_LCD

    POP ACC  ; ściągamy zapisaną wartość ze stosu
    SWAP A  ; dzięki temu starsze 4b zmienione są z młodszymi 4b

    ; cały proces jest powtórzony
    ORL DATALINE, #0b00111100
    ORL A, #0x0F
    RR A
    RR A
    ANL DATALINE, A
    SETB EN
    CLR EN

    RET

; wypisanie znaku z akumulatora
WRITE_CHAR:
    SETB RS
    LCALL WRITE_LCD
    LCALL WAIT_LCD
    RET

; obsługa portu szeregowego
SERIAL_IRQ:
    MOV A, SBUF  ; zapisanie przychodzącego bajtu do akumulatora
    MOV SBUF, A  ; odesłanie tego samego bajtu
    CLR RI;  zerowanie flagi odbioru
    CLR TI;  zerowanie flagi nadawania
    LCALL WRITE_CHAR  ; wyświetlenie znaku na LCD
    RETI
