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
    s db 'a', 'A', 'b', 'B', '2','%','x','z'; man deklariert die Zeichenfolge von Charakteren
    l equ $-s; man berechnet die Lange der Zeichenfolge in l
    d times l db 0; man reserviert l Bytes fur den Zeichenfolge und initialisiere ihn
; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov ecx, l; wir setzen die Lange 1 in ecx, um die Schleife zu machen 
        mov esi, 0 ; source index 0
        mov edi,0; destination index 0
        jecxz sfarsit; jump to sfarsit if ecx is zero
        repeta:
            mov al, [s+esi]
            mov bl,'z'; um die cmp bl, al machen zu konnen
            cmp al, 97 ;
            jl kleiner ; jump short to kleiner if less
            cmp bl, al 
            jl kleiner; jump short to kleiner if less; if 'z'<al 
            mov [d+edi],al; die Kleinbuchstaben werden hier addiert
            inc edi; destination index wachst mit 1 
            kleiner:
            inc esi ; source index wachst mit 1
        loop repeta
        sfarsit: ;Ende des Programms
        
        ;beispiel durchfuhren:
        ;ecx=7
        ;esi=0,edi=0 dann al='a' und d: 'a' bzw. edi=1          ;ecx=6
        ;esi=1,edi=1 dann al='A' und d, edi bleiben so          ;ecx=5
        ;esi=2,edi=1 dann al='b' und d:'a', 'b' bzw edi=2       ;ecx=4
        ;esi=3,edi=2 dann al='B' und d, edi bleiben so          ;ecx=3
        ;esi=4,edi=2 dann al='2' und d,edi bleiben so           ;ecx=2
        ;esi=5,edi=2 dann al='%' und d,edi bleiben so           ;ecx=1
        ;esi=6,edi=3 dann al='x' und d: 'a', 'b', 'x' bzw edi=3 ;ecx=0
        ;ecx=0=>sfarsit:
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
