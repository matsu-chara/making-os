vga_set_read_plane:
    push    ebp
    mov     ebp, esp

    push    eax
    push    edx

    mov     ah, [ebp + 8]       ; AH = プレーンを選択
    and     ah, 0x03            ; 余計なビットをマスク
    mov     al, 0x04            ; AL = 読み込みマップ選択レジスタ
    mov     dx, 0x03CE          ; DX = グラフィクス制御ポート
    out     dx, ax              ; ポート出力

    pop     edx
    pop     eax

    mov     esp, ebp
    pop     ebp
    ret

vga_set_write_plane:
    push    ebp
    mov     ebp, esp

    push    eax
    push    edx

    mov     ah, [ebp + 8]       ; AH = プレーンを選択
    and     ah, 0x0F            ; 余計なビットをマスク
    mov     al, 0x02            ; AL = 書き込みプレーンを指定
    mov     dx, 0x03CE          ; DX = グラフィクス制御ポート
    out     dx, ax              ; ポート出力

    pop     edx
    pop     eax

    mov     esp, ebp
    pop     ebp

    ret