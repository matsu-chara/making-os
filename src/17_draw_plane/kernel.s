%include "../include/define.s"
%include "../include/macro.s"

    ORG KERNEL_LOAD

[BITS 32]
kernel:
    ; フォントアドレスの取得
    mov     esi,    BOOT_LOAD + SECT_SIZE       ; ESI = 0x7c00 + 512
    movzx   eax,    word [esi + 0]              ; EAX = [ESI + 0] // セグメント
    movzx   ebx,    word [esi + 2]              ; EBX = [ESI + 2] // オフセット
    shl     eax,    4                           ; EAX <<= 4
    add     eax,    ebx                         ; EAX += EBX
    mov     [FONT_ADR], eax                     ; FONT_ADR[0] = EAX

    ; 8ビットの横線
    ; mov     ah, 0x07                            ; AH = 書き込みプレーン(Bit:----IRGB)
    mov     ah, 0x0F                            ; ↑より明るく表示
    mov     al, 0x02                            ; AL = マップマスクレジスタ（書き込みプレーン指定）
    mov     dx, 0x03C4                          ; DX = シーケンサ制御ポート
    out     dx, ax                              ; ポート出力

    mov     [0x000A_0000 + 0], byte 0xFF

    mov     ah, 0x04
    out     dx, ax
    mov     [0x000A_0000 + 1], byte 0xFF

    mov     ah, 0x02
    out     dx, ax
    mov     [0x000A_0000 + 2], byte 0xFF

    mov     ah, 0x01
    out     dx, ax
    mov     [0x000A_0000 + 3], byte 0xFF

    ; 画面を横切る横線
    mov     ah, 0x02
    out     dx, ax

    lea     edi, [0x000A_0000 + 80]
    mov     ecx, 80
    mov     al, 0xFF
    rept    stosb

    ; 8ドットの矩形
    mov     edi, 1
    shl     edi, 8
    lea     edi, [edi * 4 + edi + 0xA_0000]
    mov     [edi + (80 * 0)], word 0xFF
    mov     [edi + (80 * 1)], word 0xFF
    mov     [edi + (80 * 2)], word 0xFF
    mov     [edi + (80 * 3)], word 0xFF
    mov     [edi + (80 * 4)], word 0xFF
    mov     [edi + (80 * 5)], word 0xFF
    mov     [edi + (80 * 6)], word 0xFF
    mov     [edi + (80 * 7)], word 0xFF

    mov     esi, 'A'                        ; ESI = 文字コード
    shl     esi, 4                          ; ESI *= 16
    add     esi, [FONT_ADR]                 ; ESI = FONT_ADR[文字コード]

    mov     edi, 2
    shl     edi, 8
    lea     edi, [edi * 4 + edi + 0xA_0000]
    mov     ecx, 16                         ; ECX = 16 // 一文字の高さ
.10L:                                       ; do {
    movsb                                   ;   *EDI++ = *ESI++
    add     edi, 80 - 1                     ;   EDI += 79
    loop    .10L                            ; } while (--ECX)

    jmp $

    times KERNEL_SIZE - ($ - $$) db 0

ALIGN 4, db 0
FONT_ADR: dd 0