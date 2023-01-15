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
    s db '+','4','2','a','@','3','$','*' ; man deklariert die Zeichenfolge von Bytes
    l equ $-s ; man berechnet die Länge der Zeichenfolgein l
    d times l db 0 ; man reserviert l Bytes für den Zielfolgeund initialisiere ihn
; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov ecx, l; ecx wird die Lange l haben
        mov esi,0 ; kontor
        mov edi,0 ; kontor
        jecxz sfarsit ; Man benutzt JECXZ um zu überprüfen ob ECX null ist
        repeta: ; Anfang des loops
            mov al,[s+esi] ; Index
            cmp al,'!' ; Komparation mit jeder Element des String
            jne skip1 ; iump if not/eq
            mov [d+edi],al
            inc edi ; Incrementierung des Index
            skip1:
            cmp al,'@'
            jne skip2
            mov [d+edi],al
            inc edi
            skip2:
            cmp al,'#' 
            jne skip3
            mov [d+edi],al
            inc edi
            skip3:
            cmp al,'$'
            jne skip4
            mov [d+edi],al
            inc edi
            skip4:
            cmp al,'%'
            jne skip5
            mov [d+edi],al
            inc edi
            skip5:
            cmp al,'^'
            jne skip6
            mov [d+edi],al
            inc edi
            skip6:
            cmp al,'&'
            jne skip7
            mov [d+edi],al
            inc edi
            skip7:
            cmp al,'*'
            jne skip8
            mov [d+edi],al
            inc edi
            skip8:
            inc esi 
        loop repeta ; Ende des loops
        sfarsit: ; Ende
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
