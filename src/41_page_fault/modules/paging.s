page_set_4m:
    push    ebp
    mov     ebp, esp

    pusha

    ; ページディレクトリの設定
    cld                             ; DF = +方向
    mov     edi, [ebp + 8]          ; EDI = ページディレクトリの先頭
    mov     eax, 0x00000000         ; EAX = 0 (P = 0になっている)
    mov     ecx, 1024               ; count = 1024
    rep     stosd                   ; while(count--) *dst++= 属性 (Store EAX at address)

    ; 先頭のエントリを設定
    mov     eax, edi                ; EAX = EDI     ページディレクトリの直後
    and     eax, ~0x0000_0FFF       ; EAX &= ~0FFF 物理アドレスの指定
    or      eax, 7                  ; EAX |= 7  RW許可
    mov     [edi - (1024 * 4)], eax ; 先頭エントリの設定

    ; ページテーブルの設定
    mov     eax, 0x00000007         ; 物理アドレスの指定とRW許可
    mov     ecx, 1024
.10L:
    stosd                           ; *dst++ = 属性
    add     eax, 0x00001000         ; adr += 0x1000
    loop    .10L

    popa

    mov     esp, ebp
    pop     ebp
    ret

init_page:
    pusha

    cdecl   page_set_4m, CR3_BASE
    mov     [0x00106000 + 0x107 * 4], dword 0   ; 0x0010_7000 をページ不在に設定

    popa
    ret
