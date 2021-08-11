int_timer:
    pushad
    push    ds
    push    es

    mov     ax, 0x0010
    mov     ds, ax
    mov     es, ax

    ; tick
    inc     dword [TIMER_COUNT]

    ; 割り込みフラグをクリア
    outp    0x20, 0x20

    ; タスク切換え
    str     ax          ; AX = TR 現在のタスクレジスタ
    cmp     ax, SS_TASK_0
    je      .11L
    cmp     ax, SS_TASK_1
    je      .12L

    jmp     SS_TASK_0:0
    jmp     .10E
.11L:
    jmp     SS_TASK_1:0
    jmp     .10E
.12L:
    jmp     SS_TASK_2:0
    jmp     .10E
.10E:
    pop     es
    pop     ds
    popad

    iret

ALIGN 4, db 0
TIMER_COUNT: dq 0
