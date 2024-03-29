test_and_set:
    push    ebp
    mov     ebp, esp

    push    eax
    push    ebx

    mov     eax, 0                  ; local = 0
    mov     ebx, [ebp + 8]          ; global = アドレス

.10L:
                                    ; for (;;) {
    lock    bts [ebx], eax          ;    CF = TEST_AND_SET(IN_USE, 1)  ; lockプレフィックスを付けるとread/writeがatomicに行われる
    jnc     .10E                    ;    if (0 == CF) break
.12L:                               ;    for(;;) {
    bt      [ebx], eax              ;       CF = TEST(IN_USE, 1)
    jc      .12L                    ;       if (0 == CF) break
                                    ;    }
    jmp     .10L                    ; }
.10E:
    push    ebx
    push    eax

    mov     esp, ebp
    pop     ebp

    ret
