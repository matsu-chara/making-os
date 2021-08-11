draw_str:
        push    ebp
        mov     ebp, esp

        push	eax
        push	ebx
        push	ecx
        push	edx
        push	esi
        push	edi

        mov     ecx, [ebp + 8]
        mov     edx, [ebp + 12]
        movzx   ebx, word [ebp + 16]
        mov     esi, [ebp + 20]

        cld                             ; clear direction (DF = 0)
.10L:
        lodsb                           ; load string byte (AL = *ESI++) 文字を取得
        cmp     al, 0                   ; null文字かどうか比較
        je      .10E

%ifdef  USE_SYSTEM_CALL
        int     0x81
%else
        cdecl   draw_char, ecx, edx, ebx, eax
%endif

        ; 列を加算。ただし80文字ごとに行を加算し列を0にする。行が30行以上の場合は行を0リセット
        inc     ecx
        cmp     ecx, 80
        jl      .12E                    ; jump less (ecx < 80)
        mov     ecx, 0                  ; 列初期化
        inc     edx                     ; 行を加算
        cmp     edx, 30
        jl      .12E                    ; jump less (edx < 30)
        mov     edx, 0                  ; 行初期化

.12E:
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
