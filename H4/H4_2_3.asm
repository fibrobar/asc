bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, fopen, fread, fclose, printf              ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import printf msvcrt.dll
import fopen msvcrt.dll
import fread msvcrt.dll
import fclose msvcrt.dll

segment data use32 class=data
    nume_fisier db "input2.txt", 0
    mod_acces db "r", 0 
    descriptor_fis dd -1
    nr_car_citite dd 0
    len equ 100
    buffer resb len    
    cifre_pare dd 0
    format db "Nr de cifre pare: %d", 0


segment code use32 class=code
    start:
    ; call [fopen] deschide fisierul cu numele si modul de acces la care le am dat pus si returneaza un text descriptor in eax sau 0 in caz de eroare
        push dword mod_acces
        push dword nume_fisier
        call [fopen]
        add esp, 4*2
        
        cmp eax, 0
        je ende
        mov [descriptor_fis], eax
        loop:
            push dword [descriptor_fis]
            push dword len
            push dword 1
            push dword buffer
            call [fread]
            add esp, 4*4
            cmp eax, 0
            je cleanup
            mov [nr_car_citite], eax
            jmp loop
            
        cleanup:
            push dword [descriptor_fis]
            call [fclose]
            add esp, 4
        ende:
            
        mov esi, 0
        mov ebx, [nr_car_citite]
    
        start_loop:
            cmp ebx, 0
            je end_loop
            ; comparam el din sir cu valorile ascii pt nr pare
            cmp byte[buffer+esi], 48
            je increment_counter
            cmp byte[buffer+esi], 50
            je increment_counter
            cmp byte[buffer+esi], 52
            je increment_counter
            cmp byte[buffer+esi], 54
            je increment_counter
            cmp byte[buffer+esi], 56  
            je increment_counter; daca sunt egale trece la increment_counter
            jmp cifra_para
            increment_counter:
            inc dword [cifre_pare]; creste contorul
            inc esi; creste esi pt a trece la urmatorul el
            dec ebx; scade ebi ca sa se termine loopul cand ajungem la ultimul el
            jmp start_loop
            
            
            cifra_para:
            inc esi
            dec ebx
            jmp start_loop
        end_loop:

        push dword [cifre_pare]
        push dword format
        call [printf]
        add esp, 4*2
        
        push    dword 0      
        call    [exit]   