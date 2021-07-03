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
    mov     dx, 0x03C4          ; DX = グラフィクス制御ポート
    out     dx, ax              ; ポート出力

    pop     edx
    pop     eax

    mov     esp, ebp
    pop     ebp
    ret

vram_font_copy:
    push    ebp
    mov     ebp, esp

    push	eax
    push	ebx
    push	ecx
    push	edx
    push	esi
    push	edi

    mov     esi, [ebp + 8]
    mov     edi, [ebp + 12]
    movzx   eax, byte [ebp + 16]
    movzx   ebx, word [ebp + 20]

    test    bh, al
    setz    dh
    dec     dh

    test    bl, al
    setz    dl
    dec     dl

    ; 16ドットフォントのコピー
    cld

    mov     ecx, 16

.10L:
    lodsb
    mov     ah, al
    not     ah

    and     al, dl              ; 前景色 & フォント

    test    ebx, 0x0010
    jz      .11F
    and     ah, [edi]
    jmp     .11E

.11F:
    and     ah, dh

.11E:
    or      al, ah              ; AL = 背景 | 前景

    mov     [edi], al           ; プレーンに書き込む

    add     edi, 80
    loop    .10L

.10E:
    pop		edi
    pop		esi
    pop		edx
    pop		ecx
    pop		ebx
    pop		eax

    mov     esp, ebp
    pop     ebp
    ret
