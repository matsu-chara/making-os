acpi_find:
    push    ebp
    mov     ebp, esp
    pusha

    mov     edi, [ebp + 8]  ; edi = アドレス
    mov     ecx, [ebp + 12] ; ecx = サイズ
    mov     eax, [ebp + 16] ; eax = 検索データ

    cld
.10L:
    repne   scasb

    cmp     ecx, 0          ; ECX=0なら該当なし
    jnz     .11E            ; ECX!=0なら次のエントリへ
    mov     eax, 0          ; ないならeax=0をセットしてリターン
    jmp     .10E
.11E:
    cmp     eax, [es:edi - 1] ; 4文字比較
    jne     .10L              ; ちがったら次エントリへ

    dec     edi             ; EAX = EDI - 1
    mov     eax, edi
.10E:
    popa
    mov     esp, ebp
    pop     ebp
    ret
