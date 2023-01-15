bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, printf, scanf            ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    
import printf msvcrt.dll    
import scanf msvcrt.dll     
                          

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a dd 0
    b dd 0
    message1 dd "a = ", 0
    message2 dd "b = ", 0 
    format1 dd "%d", 0
    format2 dd "%d", 0
    format3 dd "%x", 0
    
; our code starts here
segment code use32 class=code
    start:
        push dword message1 ; punem adresa sirului pe stack
        call [printf]; apelam functia print
        add esp, 4*1; golim stack-ul
        push dword a ; punem adresa lui a pe stack
        push dword format1 
        call [scanf]; apelam functia pentru a citi variabila
        add esp, 4*2
        push dword message2
        call [printf]
        add esp, 4*1
        push dword b 
        push dword format2
        call [scanf]
        add esp, 4*2
        mov eax, [a]
        mov ebx, [b]
        add eax, ebx; adunam a si b
        cdq; transformam rezultatul intr un qword pwntru al putea imparti
        mov ecx, 2
        idiv ecx
        push dword eax
        push format3
        call [printf]
        add esp, 4 * 2
        push    dword 0      
        call    [exit]      
