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
        push dword mod_acces; mod_acces auf Stack
        push dword nume_fisier; nume_fisier auf Stack
        call [fopen]; offnen die Datei
        add esp, 4*2; loschen Parameter von Stack
        
        cmp eax, 0; 
        je ende; existiert Fehler
        mov [descriptor_fis], eax
        loop:
            push dword [descriptor_fis]
            push dword len
            push dword 1
            push dword buffer
            call [fread];lesen aus Datei
            add esp, 4*4; loschen Parameter aus Stack
            cmp eax, 0
            je cleanup; hat man nichts mehr zu lesen
            mov [nr_car_citite], eax
            jmp loop
            
        cleanup:
            push dword [descriptor_fis]
            call [fclose]; schliessen Datei
            add esp, 4
        ende:
            
        mov esi, 0
        mov ebx, [nr_car_citite]
    
        start_loop:
            cmp ebx, 0
            je end_loop; wenn Datei leer ist
            cmp byte[buffer+esi], 48; cmp mit 0
            je increment_counter; 
            cmp byte[buffer+esi], 50; mit 2
            je increment_counter
            cmp byte[buffer+esi], 52; mit 4
            je increment_counter
            cmp byte[buffer+esi], 54; mit 6
            je increment_counter
            cmp byte[buffer+esi], 56; mit 8
            je increment_counter
            jmp not_par
            increment_counter:
            inc dword [cifre_pare]; wachst die Anzahl der geraden Ziffern
            inc esi
            dec ebx
            jmp start_loop
            not_par:
            inc esi
            dec ebx
            jmp start_loop
        end_loop:

        push dword [cifre_pare]
        push dword format
        call [printf]; print die Anzahl
        add esp, 4*2
        
        push    dword 0      
        call    [exit]   