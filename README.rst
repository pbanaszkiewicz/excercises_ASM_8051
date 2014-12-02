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

Licencja
--------

Prawa autorskie: Piotr Banaszkiewicz, Piotr Świderek ® 2014
Licencja: MIT.
