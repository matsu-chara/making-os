puts:
        push bp
        mov bp, sp

        ; save register
        push ax
        push bx
        push si

        mov si, [bp + 4]

        ; start process
        mov ah, 0x0E            ; output 1 char in teletype
        mov bx, 0x0000          ; set 0 to page_num & char_color
        cld                     ; clear direction flag
.10L:
        lodsb                   ; AL = *SI++;
        cmp al, 0
        je .10E
        int 0x10                ; Call to Interrupt Procedure - BIOS call 10. video BIOS call.
        jmp .10L
.10E:
        ; end process

        ; restore register
        pop si
        pop bx
        pop ax

        mov sp, bp
        pop bp
        ret
