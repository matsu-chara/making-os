memcpy:
        push ebp
        mov ebp, esp

        push ebx
        push ecx
        push edx
        push esi
        push edi

        ; start process
        cld                     ; DF=0 (copy increment direction by MOVSB)
        mov edi, [ebp + 8]        ; DI = copy_destination;
        mov esi, [ebp + 12]        ; SI = copy_source;
        mov ecx, [ebp + 16]        ; CX = num_bytes

        rep movsb               ; while (*DI++ = *SI++)
        ; end process

        ; restore register
        pop edi
        pop esi
        pop ecx

        mov esp, ebp
        pop ebp
        ret
