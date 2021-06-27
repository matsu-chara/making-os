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
    mov     ah, 0x07                            ; AH = 書き込みプレーン(Bit:----IRGB)
    mov     al, 0x02                            ; AL = マップマスクレジスタ（書き込みプレーン指定）
    mov     dx, 0x03C4                          ; DX = シーケンサ制御ポート
    out     dx, ax                              ; ポート出力

    mov     [0x000A_0000 + 0], byte 0xFF

    jmp $

    times KERNEL_SIZE - ($ - $$) db 0

ALIGN 4, db 0
FONT_ADR: dd