draw_pixel:
    push    ebp
    mov     ebp, esp

    push	eax
    push	ebx
    push	ecx
    push	edi

    ; Y座標を80倍 (640ドット/8)
    mov     edi, [ebp + 12]
    shl     edi, 4                              ; EDI *= 16
    lea     edi, [edi * 4 + edi + 0xA_0000]     ; 0xA0000[EDI * 4 + EDI]

    ; X座標を1/8
    mov     ebx, [ebp + 8]
    mov     ecx, ebx
    shr     ebx, 3
    add     edi, ebx

    ; X座標を８で割ったあまりからビット位置を計算
    and     ecx, 0x07                           ; ECX = X & 0x07
    mov     ebx, 0x80                           ; EBX = 0x80
    shr     ebx, cl                             ; EBX >>= ECX

    ; 色指定
    mov     ecx, [ebp +16]

    cdecl   vga_set_read_plane, 0x03
    cdecl   vga_set_write_plane, 0x08
    cdecl   vram_bit_copy, ebx, edi, 0x08, ecx

    cdecl   vga_set_read_plane, 0x02
    cdecl   vga_set_write_plane, 0x04
    cdecl   vram_bit_copy, ebx, edi, 0x04, ecx

    cdecl   vga_set_read_plane, 0x01
    cdecl   vga_set_write_plane, 0x02
    cdecl   vram_bit_copy, ebx, edi, 0x02, ecx

    cdecl   vga_set_read_plane, 0x00
    cdecl   vga_set_write_plane, 0x01
    cdecl   vram_bit_copy, ebx, edi, 0x01, ecx


    pop		edi
    pop		ecx
    pop		ebx
    pop		eax

    mov     esp, ebp
    pop     ebp
    ret
