func_16:
        push bp
        mov bp, sp
        sub sp, 2
        push 0

        ; start process
        mov [bp - 2], word 10   ; i = 10;
        mov [bp - 4], word 20   ; j = 20;

        mov ax, [bp + 4]        ; access to arg[1]
        add ax, [bp + 6]        ; access to arg[2]
        mov ax, 1               ; return 1
        ; end process

        mov sp, bp
        pop bp
        ret

