memcpy:
        push bp
        mov bp, sp

        ; save register
        push cx
        push si
        push di

        ; start process
        cld                     ; DF=0 (copy increment direction by MOVSB)
        mov di, [bp + 4]        ; DI = copy_destination;
        mov si, [bp + 6]        ; SI = copy_source;
        mov cx, [bp + 8]        ; CX = num_bytes

        rep movsb               ; while (*DI++ = *SI++)
        ; end process

        ; restore register
        pop di
        pop si
        pop cx

        mov sp, bp
        pop bp
        ret
