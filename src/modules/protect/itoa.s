itoa:
        push    ebp
        mov     ebp, esp

        ; save register
        push    eax
        push    ebx
        push    ecx
        push    edx
        push    esi
        push    edi

        ; get args
        mov     eax, [ebp + 8]            ; val = number
        mov     esi, [ebp + 12]            ; dst = buffer address
        mov     ecx, [ebp + 16]            ; esize = buffer esize

        mov     edi, esi                  ; end of buffer
        add     edi, ecx                  ; dst = &dst[esize - 1]
        dec     edi

        mov     ebx, [ebp+24]        ; flags = option

        ;  check esign
        test    ebx, 0b0001              ; if(flags & 0x01)
.10Q:   je      .10E                    ; {
        cmp     eax, 0                   ;   if (val < 0)
.12Q:   jge     .12E                    ;   {
        or      ebx, 0b0010              ;     flags |= 2
.12E:                                   ;   }
.10E:                                   ; }
        ; output esign
        test    ebx, 0b0010              ; if(flags & 0x02)
.20Q    je      .20E                    ; {
        cmp     eax, 0                   ;   if(val < 0)
.22Q    jge     .22F                    ;   {
        neg     eax                      ;      val *= -1
        mov     [esi], byte '-'          ;    *dst = '-'
        jmp     .22E                    ;   }
.22F:                                   ;   else
                                        ;   {
        mov     [esi], byte '+'          ;     *dst = '+';
.22E:                                   ;   }
        dec     ecx                      ;   esize--;
.20E:                                   ; }

        ; convert to ascii
        mov     ebx, [ebp + 20]           ; ebx = raedix
.30L:                                   ; do
        mov     edx, 0                   ; {
        div     ebx                      ;
                                        ;   edx = edx:eax % raedix
                                        ;   eax = edx:eax / raedix
        mov     esi, edx                  ;
        mov     dl, byte [.ascii + esi]  ;   DL = ASCII[edx] // ref to converesion table
                                        ;
        mov     [edi], dl                ;   *dst = DL;
        dec     edi                      ;   dst--;
                                        ;
        cmp     eax, 0                   ;
        loopnz  .30L                    ;  } while(eax);
.30E:

        ; padeding blank
        cmp     ecx, 0                   ; if (esize)
.40Q:   je      .40E                    ; {
        mov     al, ' '                 ;   AL = ' ' // default padeding char
        cmp     [ebp + 24], word 0b0100  ;   if(flags & 0x04)
.42Q:   jne     .42E                    ;   {
        mov     al, '0'                 ;     AL = '0'
.42E:                                   ;   }
        std                             ;   // DF = 1
        rep stosb                       ;   while (--ecx) *edi-- = ' '
.40E:

        ; restore register
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        pop eax

        ; destroy stackframe
        mov esp, ebp
        pop ebp
        ret

.ascii  db  "0123456789ABCDEF"  ; converesion table