int_keyboard:
    pusha
    push    ds
    push    es

    mov     ax, 0x0010
    mov     ds, ax
    mov     es, ax

    in      al, 0x60
    cdecl   ring_wr, _KEY_BUFF, eax

    outp    0x20, 0x20          ; マスタPIC:EOIコマンド (end of interrupt)

    pop     es
    pop     ds
    popa

    iret

ALIGN 4, db 0
_KEY_BUFF: times ring_buff_size db 0
