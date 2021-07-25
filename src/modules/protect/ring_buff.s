ring_rd:
    push    ebp
    mov     ebp, esp

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

    mov     al, [esi + ring_buff.item + ebx]
    mov     [edi], al

    inc     ebx
    and     ebx, RING_INDEX_MASK
    mov     [esi + ring_buff.rp], ebx

    mov     eax, 1

.10E:
    pop     edi
    pop     esi
    pop     ebx

    mov     esp, ebp
    pop     ebp

    ret

ring_wr:
    push    ebp
    mov     ebp, esp

    push    ebx
    push    ecx
    push    esi

    ; 引数
    mov     esi, [ebp + 8]      ; ESI = リングバッファ 

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
    pop		esi
    pop		ecx
    pop		ebx

    mov     esp, ebp
    pop     ebp

    ret

draw_key:
    push    ebp
    mov     ebp, esp

    pusha

    mov		edx, [ebp + 8]					; EDX = X（列）;
    mov		edi, [ebp +12]					; EDI = Y（行）;
    mov		esi, [ebp +16]					; ESI = リングバッファ;

    mov     ebx, [esi + ring_buff.rp]
    lea     esi, [esi + ring_buff.item]
    mov     ecx, RING_ITEM_SIZE
.10L:
    dec     ebx
    and     ebx, RING_INDEX_MASK
    mov     al, [esi + ebx]

    cdecl   itoa, eax, .tmp, 2, 16, 0b0100
    cdecl   draw_str, edx, edi, 0x02, .tmp
    add     edx, 3
    loop    .10L

.10E:

    popa

    mov     esp, ebp
    pop     ebp
    ret

.tmp    db "-- ", 0