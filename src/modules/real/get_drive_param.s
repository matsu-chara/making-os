get_drive_param:
        push    bp
        mov     bp, sp

        ; save register
        push    bx
        push    cx
        push    es
        push    si
        push    di

        ; start
        mov     si,   [bp + 4]              ; SI = バッファ
        mov     ax,   0                     ; Disk Base Table Pointerの初期化
        mov     es,   ax                    ; ES = 0
        mov     di,   ax                    ; DI = 0
        mov     ah,   8                     ; get derive parameters
        mov     dl,   [si + drive.no]       ; dl = ドライブ番号   
        int     0x13                        ; CF = BIOS(0x13, 8)
.10Q:   jc      .10F                        ; if (0 == CF)    
.10T:
        mov     al,    cl                   ; AX = セクタ数    
        and     ax,    0x3F                 ; 下位6bitのみ有効なのでandで取り出す
        shr     cl,    6                    ; CX = シリンダ数  (shr = shift right)
        ror     cx,    8                    ; (ror = rotate right)
        inc     cx

        movzx   bx,     dh
        inc     bx                          ; BX = ヘッド数

        mov     [si + drive.cyln],  cx      ; drive.syln = CX
        mov     [si + drive.head],  bx      ; drive.head = BX
        mov     [si + drive.sect],  ax      ; drive.sect = AX
        jmp     .10E
.10F:                                       ; else
        mov     ax, 0                       ; AX = 0 (失敗）
.10E:
        pop     di
        pop     si
        pop     es
        pop     cx
        pop     bx

        mov     sp, bp
        pop     bp

        ret