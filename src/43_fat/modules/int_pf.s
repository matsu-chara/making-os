int_pf:
    push    ebp
    mov     ebp, esp

    pusha
    push    ds
    push    es

    mov     ax, 0x0010
    mov     ds, ax
    mov     es, ax

    ; 例外が発生したアドレスの確認
    mov     eax, cr2                                    ; CR2
    and     eax, ~0x0FFF                                ; 4Kバイト以内のアクセス
    cmp     eax, 0x0010_7000                            ; ptr = アクセスアドレス
    jne     .10F                                        ; if (0x0010_7000 == ptr) {
    mov     [0x00106000 + 0x107 * 4], dword 0x00107007   ;   ページ有効化
    cdecl   memcpy, 0x0010_7000, DRAW_PARAM, rose_size  ;   描画パラメータ
    jmp     .10E                                        ; } else
.10F:                                                   ; {
    add     esp, 4
    add     esp, 4
    popa
    pop     ebp

    pushf
    push    cs
    push    int_stop

    mov     eax, .s0
    iret
.10E:                                                   ; }
    pop     es
    pop     ds
    popa

    mov     esp, ebp
    pop     ebp

    add     esp, 4
    iret

.s0 db " < PAGE FAULT >", 0
