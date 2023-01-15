bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program



extern exit , printf              ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll
import printf msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
   

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...

    a dd 23
    b dd 5
    c dd 0
    
   format db "%d mod %d =%d", 0
    
; our code starts here
segment code use32 class=code
    start:
        ; ...
        
        ;Zwei natürliche Zahlen a und b(a,b:Doppelwörter,definiert im Datensegment)werden gegeben.Berechne a/b und zeige den Rest im folgenden Format auf dem Bildschirm an: "<a> mod <b> = <Rest>"
    ; Doubleword a in Quadword umwandeln:
    mov ax, word [a] 
    mov dx, word [a+2]
    push dx
    push ax
    pop eax ; eax = a
    div word [b] ; ax = 4 (Quotient), dx = 3 (Rest)
    ; dx auf eax stellen
    mov ax, dx
    mov dx, 0
    push dx
    push ax
    pop eax
    mov [c], eax
    push dword [c] ; wir stellen die Parameter von recht zu links auf dem Stack
    push dword [b]
    push dword [a]
    push dword format ; Adresse der Zeichenfolge auf dem Stack,
    call [printf]
    add esp, 4*4 ; Parameter vom Stack leeren
    
    
    
        
        
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
