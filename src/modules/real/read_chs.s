read_chs:
    ; スタックフレーム
                ;   + 8 コピー先
                ;   + 6 セクタ数
                ;   + 4 パラメータバッファ
                ;
                ;   + 2 IP (戻り番地)
    push bp     ; BP+ 0 BP(元の値)
    mov bp, sp
    push 3      ;   - 2 (retry = 3)
    push 0      ;   - 4 sect = 0 (読み込みセクタ数)

    ; レジスタの保存
    push bx
    push cx
    push dx
    push es
    push si

    ; 処理の開始
    mov si, [bp + 4]    ; SI = SRCバッファ

    ; CXレジスタの設定(BIOSコールの呼び出しに適した形に変換)
    mov ch, [si + drive.cyln + 0]       ; CH = シリンダ番号（下位バイト）
    mov cl, [si + drive.cyln + 1]       ; CL = シリンダ番号（上位バイト）
    shl cl, 6                           ; CL <<= 6; 最上位２ビットにシフト
    or  cl, [si + drive.sect]           ; CL |= セクタ番号

    ; セクタ読み込み
    mov dh, [si + drive.head]           ; DH = ヘッド番号
    mov dl, [si + 0]                    ; DL = ドライブ番号
    mov ax, 0x0000                      ; AX = 0x0000;
    mov es, ax                          ; ES = セグメント
    mov bx, [bp + 8]                    ; BX = コピー先
.10L                                    ; do {
    mov ah, 0x02                        ;   AH = セクタ読み込み
    mov al, [bp + 6]                    ;   BX = コピー先
    int 0x13                            ;   CF = BIOS(0x13, 0x02)
    jnc .11E                            ;   if (CF) {
    mov al, 0                           ;       AL = 0;
    jmp .10E                            ;       break;
.11E:                                   ;   }
    cmp al, 0                           ;   if (読み込んだセクタがあれば) {
    jne .10E                            ;       break;
                                        ;   }
    mov ax, 0                           ;   ret = 0
    dec word [bp - 2]                   ; }
    jnz .10L                            ;  while(--retry)
.10E
    mov ah, 0                           ; AH = 0 // ステータス情報は破棄

    ; レジスタ復帰
    pop si
    pop es
    pop dx
    pop cx
    pop bx

    mov sp, bp
    pop bp

    ret