KBC_Data_Write:
    push    bp
    mov     bp, sp

    push    cx

    mov     cx, 0
.10L:
    in      al, 0x64        ; AL = inp(0x64) // KBCステータス
    test    al, 0x02        ; ZF = AL & 0x02 // 書き込み可能？
    loopnz  .10L

    cmp     cx, 0
    jz      .20E

    mov     al, [bp + 4]    ; AL = データ
    out     0x60, al        ; outp(0x60, AL)
.20E:
    mov     ax, cx

    pop     cx
    mov     sp, bp
    pop     bp

    ret