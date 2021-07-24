ring_rd:
    push    ebp
    mov     ebp, esp

    push    eax
    push    ebx
    push    esi
    push    edi

    ; 引数
    mov     esi, [ebp + 8]      ; ESI = リングバッファ 
    mov     edi, [ebp + 12]     ; EDI = データアドレス

    ; 読み込み位置を確認
    mov     eax, 0
    mov     ebx, [esi + ring_buff.rp]
    cmp     ebx, [esi + ring_buff.wp]
    je      .10E

    mov     al, [esi + ring_buiff.item + ebx]
    mov     [edi], al

    inc     ebx
    and     ebx, RING_INDEX_MASK
    mov     [esi + ring_buff.rp], ebx

    mov     eax, 1

.10E:
    pop     edi
    pop     esi
    pop     ebx
    pop     eax

    mov     esp, ebp
    pop     ebp

    ret

ring_wr:
    push    ebp
    mov     ebp, esp

    push    eax
    push    ebx
    push    esi
    push    edi

    ; 引数
    mov     esi, [ebp + 8]      ; ESI = リングバッファ 
    mov     edi, [ebp + 12]     ; EDI = データアドレス

    ; 書き込み位置を確認
    mov     eax, 0
    mov     ebx, [esi + ring_buff.wp]
    mov     ecx, ebx
    inc     ecx
    and     ecx, RING_INDEX_MASK

    cmp     ecx, [esi + ring_buff.rp]
    je      .10E

    mov     al, [ebp + 12]

    mov     [esi + ring_buff.item + ebx], al
    mov     [esi + ring_buff.wp], ecx
    mov     eax, 1

.10E:
    pop     edi
    pop     esi
    pop     ebx
    pop     eax

    mov     esp, ebp
    pop     ebp

    ret
