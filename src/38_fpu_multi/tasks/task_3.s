task_3:
    cdecl   draw_str, 63, 2, 0x07, .s0

    ; 初期化
    fild    dword [.c1000]                 ; 整数をFPUスタックに設定
    fldpi                                   ; PIをFPUスタックに設定
    fidiv   dword [.c180]                   ; pi/180をFPUスタックに設定
    fldpi
    fadd    st0, st0                        ; 2PIをFPUスタックに設定
    fldz                                    ; 0をFPUスタックに設定

.10L:
    fadd    st0, st2                        ; θ += pi/180
    fprem                                   ; θ = θ % 2PI
    fld     st0
    fcos                                    ; sinθ
    fmul    st0, st4                        ; sinθ * 1000
    fbstp   [.bcd]                          ; sinθ * 1000の整数部を格納

    mov     eax, [.bcd]                     ; EAX = sinθ * 1000
    mov     ebx, eax                        ; EBX = EAX
    and     eax, 0x0F0F                     ; 各バイトの上位4ビットをマスク
    or      eax, 0x3030                     ; 各バイトの上位4ビットに0x03を設定

    shr     ebx, 4                          ; EBX >>= 4
    and     ebx, 0x0F0F
    or      ebx, 0x3030

    mov     [.s2 + 0], bh                   ; 1桁目
    mov     [.s3 + 0], ah                   ; 小数1桁目
    mov     [.s3 + 1], bl                   ; 小数2桁目
    mov     [.s3 + 2], al                   ; 小数3桁目

    mov     eax, 7
    bt      [.bcd + 9], eax
    jc      .10F

    mov     [.s1 + 0], byte '+'
    jmp     .10E
.10F:
    mov     [.s1 + 0], byte '-'
.10E:
    cdecl   draw_str, 72, 2, 0x07, .s1

    cdecl   wait_tick, 1

    jmp     .10L

ALIGN 4,    db 0
.c1000:     dd 1000
.c180:      dd 180
.bcd:       times 10 db 0x00

.s0:        db "Task-3", 0
.s1:        db "-"
.s2:        db "0."
.s3:        db "000", 0
