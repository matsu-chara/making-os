memcmp:
        push bp
        mov bp, sp

        ; save register
        push si
        push di

        ; start process
        cld                     ; DF clear
        mov si, [bp + 4]
        mov di, [bp + 6]
        mov cx, [bp + 8]

        repe cmpsb
        jnz .10F
        mov ax, 0
        jmp .10E
.10F:
        mov ax, -1
.10E:
        ; end process

        pop di
        pop si

        mov sp, bp
        pop bp
        ret
