putc:
        push bp
        mov bp, sp

        ; save register
        push ax
        push bx

        ; start process
        mov al, [bp + 4]
        mov ah, 0x0E            ; output 1 char in teletype
        mov bx, 0x0000          ; set 0 to page_num & char_color
        int 0x10                ; Call to Interrupt Procedure - BIOS call 10. video BIOS call.
        ; end process

        ; restore register
        pop bx
        pop ax

        mov sp, bp
        pop bp
        ret
