itoa:
        push    bp
        mov     bp, sp

        ; save register
        push    ax
        push    bx
        push    cx
        push    dx
        push    si
        push    di

        ; get args
        mov     ax, [bp + 4]            ; val = number
        mov     si, [bp + 6]            ; dst = buffer address
        mov     cx, [bp + 8]            ; size = buffer size

        mov     di, cx                  ; end of buffer
        add     di, cx                  ; dst = &dst[size - 1]
        dec     di

        mov     bx, word [bp+12]        ; flags = option

        ;  check sign
        test    bx, 0b0001              ; if(flags & 0x01)
.10Q:   je      .10E                    ; {
        cmp     ax, 0                   ;   if (val < 0)
.12Q:   jge     .12E                    ;   {
        or      bx, 0b0010              ;     flags |= 2
.12E:                                   ;   }
.10E:                                   ; }
        ; output sign
        test    bx, 0b0010              ; if(flags & 0x02)
.20Q    je      .20E                    ; {
        cmp     ax, 0                   ;   if(val < 0)
.22Q    jge     .22F                    ;   {
        neg     ax                      ;      val *= -1
        mov     [si], byte '-'          ;    *dst = '-'
        jmp     .22E                    ;   }
.22F:                                   ;   else
                                        ;   {
        mov     [si], byte '+'          ;     *dst = '+';
.22E:                                   ;   }
        dec     cx                      ;   size--;
.20E:                                   ; }

        ; convert to ascii
        mov     bx, [bp + 10]           ; BX = radix
.30L:                                   ; do
        mov     dx, 0                   ; {
        div     bx                      ;
                                        ;   DX = DX:AX % radix
                                        ;   AX = DX:AX / radix
        mov     si, dx                  ;
        mov     dl, byte [.ascii + si]  ;   DL = ASCII[DX] // ref to conversion table
                                        ;
        mov     [di], dl                ;   *dst = DL;
        dec     di                      ;   dst--;
                                        ;
        cmp     ax, 0                   ;
        loopnz  .30L                    ;  } while(AX);
.30E:

        ; padding blank
        cmp     cx, 0                   ; if (size)
.40Q:   je      .40E                    ; {
        mov     al, ' '                 ;   AL = ' ' // default padding char
        cmp     [bp + 12], word 0b0100  ;   if(flags & 0x04)
.42Q:   jne     .42E                    ;   {
        mov     al, '0'                 ;     AL = '0'
.42E:                                   ;   }
        std                             ;   // DF = 1
        rep stosb                       ;   while (--CX) *DI-- = ' '
.40E:

        ; restore register
        pop di
        pop si
        pop dx
        pop cx
        pop bx
        pop ax

        ; destroy stackframe
        mov sp, bp
        pop bp
        ret

.ascii  db  "0123456789ABCDEF"  ; conversion table