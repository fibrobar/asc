bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
                          
extern scanf, printf
import scanf msvcrt.dll
import printf msvcrt.dll

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a resb 1
    b resb 1
    format1 db "%x", 0
    format2 db "%x", 0
    format3 db "%d", 0
    ; ...

; our code starts here
segment code use32 class=code
    start:
    push dword a ; Parameter auf Stack
    push dword format1 ; Format auf Stack
    call [scanf] ; lesen Zahl a
    add esp, 4 * 2 ; loschen Parameter aus Stack
    
    mov al,[a] ; al= Wert von a
    
    push dword b ; Parameter auf Stack
    push dword format2 ; Format auf Stack
    call [scanf] ; lesen Zahl b
    add esp, 4 * 2 ; loschen Parameter aus Stack
    
    add [b], al       
    
    push dword [b] ; Parameter auf Stack
    push dword format3 ; Format auf Stack
    call [printf] ; print Summe von a und b
    add esp, 4 * 2 ; loschen Parameter aus Stack
        ; ...
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program