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

KBC_Data_Read:
    push    bp
    mov     bp, sp

    push    cx

    mov     cx, 0
.10L:
    in      al, 0x64        ; AL = inp(0x64) // KBCステータス
    test    al, 0x01        ; ZF = AL & 0x01 // 読み込み可能？
    loopnz  .10L

    cmp     cx, 0
    jz      .20E

    mov     ah, 0x00        ; AH = 0x00
    in      al, 0x60        ; AL = inp(0x60)

    mov     di, [bp + 4]     ; DI = ptr
    mov     [di + 0], ax    ; DI[0] = AX
.20E:
    mov     ax, cx

    pop     cx
    mov     sp, bp
    pop     bp

    ret
KBC_Cmd_Write:
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

    mov     al, [bp + 4]    ; AL = コマンド
    out     0x64, al        ; outp(0x64, AL)
.20E:
    mov     ax, cx

    pop     cx
    mov     sp, bp
    pop     bp

    ret
