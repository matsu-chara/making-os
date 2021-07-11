draw_rect:
    push    ebp
    mov     ebp, esp

    push	eax
    push	ebx
    push	ecx
    push    edx
    push	esi

    mov     eax, [ebp + 8]
    mov     ebx, [ebp + 12]
    mov     ecx, [ebp + 16]
    mov     edx, [ebp + 20]
    mov     esi, [ebp + 24]

    ; 座標の大小を確定
    cmp     eax, ecx
    jl      .10E
    xchg    eax, ecx
.10E:
    cmp     ebx, edx
    jl      .20E
    xchg    ebx, edx
.20E:
    cdecl   draw_line, eax, ebx, ecx, ebx, esi
    cdecl   draw_line, eax, ebx, eax, edx, esi

    dec     edx
    cdecl   draw_line, eax, edx, ecx, edx, esi
    inc     edx

    dec     ecx
    cdecl   draw_line, ecx, ebx, ecx, edx, esi

    pop     esi
    pop     edx
    pop		ecx
    pop		ebx
    pop		eax

    mov     esp, ebp
    pop     ebp
    ret
