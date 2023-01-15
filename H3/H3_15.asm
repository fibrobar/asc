bits 32

global start        

extern exit               
import exit msvcrt.dll    

segment data use32 class=data
        s1 db 1, 3, 6, 2, 3, 2 ; declaram sirurile
        s2 db 6, 3, 8, 1, 2, 5 
        l equ $-s1 ; l salveaza lungimea l = 6
        d times l db 0 ; rezervam un sir de lungimea l in memorie 
        
segment code use32 class=code
    start:
        mov ecx, l ; mutam in ecx l
        mov esi, 0 
        jecxz end  
        while: 
            mov al, [esi + s1]; punem in al el din s1 pe rand
            mov bl, [esi + s2]; punem in bl el din s2 pe rand 
            add al, bl; adunam elementele
            mov [d + esi], al; punem suma elementelor in sir 
            inc esi
        loop while
        end 

        push    dword 0      
        call    [exit]       
