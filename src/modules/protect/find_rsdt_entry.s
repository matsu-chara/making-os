find_rsdt_entry:
    push ebp
    mov  ebp, esp
    pusha

    mov  esi, [ebp + 8]     ; EDI = RSDT
    mov  ecx, [ebp + 12]    ; ECX = 名前

    mov  ebx, 0

    ; ACPIテーブル検索処理
    mov  edi, esi
    add  edi, [esi + 4]
    add  esi, 36
.10L:
    cmp  esi, edi
    jge  .10E
    lodsd                   ; EAX = エントリ(ESI++)

    cmp [eax], ecx
    jne .12E
    mov ebx, eax
    jmp .10E
.12E:
.10E:
    

    mov eax, ebx

    popa
    mov ebp, esp
    pop  ebp
    ret
