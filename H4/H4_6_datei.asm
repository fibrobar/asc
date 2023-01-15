bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, fopen, fclose, fread, printf
import exit msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import fread msvcrt.dll
import printf msvcrt.dll

             ; tell nasm that exit exists even if we won't be defining it
    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    
file_name db "Lab4ASC.txt.txt", 0
access_mode db "r", 0
file_descriptor dd -1  ; die Variable, in der wir den Deskriptor der Datei speichern, necesar pentru a putea face
                        ; referire la fisier

len equ 100
buffer times len db 0 ; die Zeichenfolge, in die der Text aus der Datei gelesen wird
len_buffer equ $-buffer
format  db "Das Kleinbuchstabe %c hat die höchste Häufigkeit, und zwar %d",0

haufig times 25 db 0
len_haufig equ $-haufig




; our code starts here
segment code use32 class=code
    start:
        ; ...
    ; Eine Textdatei wird gegeben. Lese den Inhalt der Datei, bestimme der Kleinbuchstabe mit der höchsten Frequenz(Häufigkeit)und zeige der Buchstabe zusammen mit ihrer Frequenz auf dem Bildschirman. Der Name der Textdatei wird im Datensegment definiert.
    
    push dword access_mode
    push dword file_name
    call [fopen]
    add esp, 4*2 
    mov [file_descriptor], eax
    cmp eax, 0 ; Wir prüfen, ob die fopen-Funktion erfolgreich erstellt wurde (falls EAX != 0)
    je final
    
 
    push dword [file_descriptor]
    push dword len
    push dword 1
    push dword buffer
    call [fread]
    add esp, 4*4  ; eax= Anzahl der gelesenen Zeichen
        
 
   mov esi, buffer  ;Zeichenfolge wird in esi gestellt
   mov ebx, 1
    
    mov ecx, eax ;  Anzahl Iterationen = lange text
    jecxz endloop
    again:
        cld
        lodsb ; Element aus esi ist in al gespeichert
        ;Wir uberprufen ob der Buchstabe klein ist:
        cmp al, "a"
        JB Grosbuchstabe
        cmp al, "z"
        JA Grosbuchstabe
        
        sub al, 97 ; wir subtrahieren ASCII(a), um den Buchstabe auf die richtige Position im Vektor haufig setzen zu konnen
        mov edx, 0 
        mov ah, 0
        mov dx, 0
        push dx
        push ax
        pop eax
        mov edx, eax
        ;mov dl, al ;Ergebniss in edx
        add [haufig+edx], ebx ; zur Adresse [haufig+edx] addieren wir 1 = counter
       
       
        Grosbuchstabe:
    loop again
    
    endloop:
    mov bl, 0
    mov ecx, len_haufig ;Anzahl Iterationen = lange des Vektors = 26
    jecxz stop
    again2:
        mov al, [haufig+ecx]
      
        cmp al, bl ; Falls al groser als bl ist, wird al im bl gestellt
        jbe then
      
       mov bl, al      
       mov bh, 0
       push 0
       push bx
       pop ebx ; In ebx stellen wir die Frequenz
       mov edx, ecx ;Die Position der hochsten Frequenz ist der Buchstabe, und wirds in edx gestellt
       add edx, 97 ; Wir addieren ASCII(a), um den Buchstabe bekommen

        then:
        dec ecx
        cmp ecx, 0
        jge again2
    
   stop:
   
    push dword ebx
    push dword edx
    push dword format
    call [printf] ;wir drucken das Ergebnis
    add esp, 4*3
    
   
    cleanup: ; Wir rufen die Funktion fclose auf, um die Datei zu schließen
    push dword [file_descriptor]
    call [fclose]
    add esp, 4


 
    final:
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
