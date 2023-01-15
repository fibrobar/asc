bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    ;S: 'a', 'A', 'b', 'B', '2', 'C', 'D', 'M'
    ;D: 'A', 'B', 'M'
    
    s db 'AiB32.-C+g#Z'
    langes EQU $ - s ;die länge der Zeichenfolge s
    d RESB langes ;wir reservieren einen Speicherplatz für die Zielzeichenfolge, damit wir edi richtig setzen können
    ; d times langes db 0
    
; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov edi, d ; edi übernimmt die adresse von d
        mov esi, s ; esi übernimmt die adresse von s
        mov ecx, langes ;ECX übernimmt die länge des zu durchlaufenden Strings
        JECXZ endloop ;wenn die es keinen charakter gibt wird direkt das programm beendet um die 2^32 fachen loop zu vermeiden
        CLD ;directionflag wird gecleart um in aufsteigender Reihenfolge ESI und EDI zu durchlaufen
        anfang:

        LODSB ;charakter aus esi adresse wird in al geladen
        ;wenn charakter zwischen E (64;91) liegt, wird dieser zur liste hinzugefügt
        CMP al, 65
        JL endif
        CMP al, 90
        JG endif
        STOSB
        endif:
        Loop anfang
        endloop:
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program