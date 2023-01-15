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
    
 a db 2, 1, 3, 3, 4, 2, 6
 b db 4, 5, 7, 6, 2, 1
 l equ $-b
 l2 equ $-a
 r db 0
 

; our code starts here
segment code use32 class=code
    start:
        ; ...
    ; Zwei Folgen (von Bytes) A und B werden angegeben.
    ;Erstelle die Folge R, indem man die Elemente von B in umgekehrter Reihenfolge 
    ;und die geraden Elemente von A verketten werden.

    
    mov esi, b+l-1
    mov edi, r
    
    mov ecx, l ;anzahl der Iterationen = Lange von b
    JECXZ endFor ; Schleife endet, wenn l=0
    again:
        std ; DF=1, so dass die Werte von rechts nach links genommen werden
        lodsb ;kopiert was in esi steht in al
        cld ; DF=0, so dass die Werte von links nach rechts in edi geschrieben werden
        stosb ; speichert das Byte von al in edi
    loop again
    endFor:
    
    
    mov esi, a
    mov bl, 2
    mov ecx, l2 ; anzahl der Iterationen ist die Lange von a
    Jecxz sfarsit ; springt zum ende wenn ecx 0 ist
    
    again2:
        lodsb ; alle bytes aus esi werden in al kopiert
        mov ah, 0 ; al => ax
        div bl
        cmp ah, 0 ; wenn ah, also der Rest der Division 0 ist, dann ist die Zahl paar und die Schleife wird
       ;fortgesetzt. Falls es nicht gleicht ist, springt es zum endif
        jne endif
        mul bl ; wir brauchen der originalle wert zuruck
        stosb ; speichert das byte von al in edi
        endif:
    loop again2
    sfarsit:
    
    
    
    
    
   
    
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
