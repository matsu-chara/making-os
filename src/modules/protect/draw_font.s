draw_font:
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

    mov     ecx, 0

.10L:
    cmp     ecx, 256
    jae     .10E

    ; 列
    mov     eax, ecx
    and     eax, 0x0F       ; 下位4bitを取得
    add     eax, esi

    ; 行
    mov     ebx, ecx
    shr     ebx, 4
    add     ebx, edi

    cdecl   draw_char, eax, ebx, 0x07, ecx

    inc     ecx
    jmp     .10L

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

