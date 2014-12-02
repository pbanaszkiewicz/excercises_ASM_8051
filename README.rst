========================================
Ćwiczenia laboratoryjne z asemblera 8051
========================================

Przedmiot: Elektronika z Techniką Mikroprocesorową, AiR, EAIIB, AGH.

Copyright ® 2014 Piotr Banaszkiewicz, Piotr Świderek.

Kompilacja programów
--------------------

Dołączony skrypt ``make8051.sh`` automatycznie uruchamia kompilator
``sdas8051`` z pakietu ``sdcc``, linkuje oraz buduje plik ``.hex`` zawierający
kod maszynowy procesora.

Przykładowe wywołanie dla pliku ``diody2.asm``::

    $ ./make8051.sh diody2
    ASlink >> -f diody2.lnk
    ASlink >> -mxiu
    ASlink >> diody2.ihx
    ASlink >> diody2.rel
    ASlink >> -e
    packihx: read 3 lines, wrote 4: OK.
    -------- GOTOWE ---------

Opisy programów
---------------

Poniżej zamieszczone są krótkie opisy zawartości poszczególnych plików.  Więcej
szczegółów można znaleźć w samych plikach - staraliśmy się je dobrze
komentować.

``diody.asm``
    Pierwszy program.  Zaświeca kilka diod.

``diody2.asm``
    Prosty PWM przy dowolnej częstotliwości.

``diody3.asm``
    Świecenie diodami przy określonej częstotliwości (około 3Hz).

``pwm1.asm``
    …

``pwm2.asm``
    PWM na przerwaniach z timera.

``pwm3.asm``
    PWM w skali od 0:8 do 7:8 na przerwaniach z timera.

``pwm_serial.asm``
    PWM w skali od 0:8 do 7:8 na przerwaniach z timera: sterowanie również
    przez port szeregowy (liczby 0-7).

``lcd_serial.asm``
    Wyświetlacz LCD sterowany z portu szeregowego.

Licencja
--------

Prawa autorskie: Piotr Banaszkiewicz, Piotr Świderek ® 2014.

Licencja: MIT.
