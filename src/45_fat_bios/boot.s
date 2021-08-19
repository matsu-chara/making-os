; macro
%include "../include/macro.s"
%include "../include/define.s"

    ORG BOOT_LOAD

; entrypoint
entry:

    ; BPB (BIOS Parameter Block)
    jmp ipl                     ; 0x00 ( 3e ブートコードへのジャンプ命令)
    times 3 - ($- $$) db 0x90   ; noop
    db  'OEM-NAME'              ; 0x03 ( 8) OEM名

    dw  512                     ; 0x0B (2) セクタのバイト数
    db  1                       ; 0x0D (1) クラスタのセクタ数
    dw  32                      ; 0x0E (2) 予約セクタ数
    db  2                       ; 0x10 (1) FAT吸う
    dw  512                     ; 0x11 (2) ルートエントリ数
    dw  0xFFF0                  ; 0x13 (2) 総セクタ数16
    db  0xF8                    ; 0x15 (1) メディアタイプ
    dw  256                     ; 0x16 (2) FATのセクタ数
    dw  0x10                    ; 0x18 (2) トラックのセクタ数
    dw  2                       ; 0x1A (2) ヘッド数
    dd  0                       ; 0x1C (4) 隠されたセクタ数
    dd  0                       ; 0x20 (4) 総セクタ数32
    db  0x80                    ; 0x24 (1) ドライブ番号
    db  0                       ; 0x25 (1) 予約
    db  0x29                    ; 0x26 (1) ブートフラグ
    dd  0xbeef                  ; 0x27 (4) シリアルナンバー
    db  'BOOTABLE   '           ; 0x2B (11) ボリュームラベル
    db  'FAT     '              ; 0x36 (8) FATタイプ

; IPL(initial program loader)
ipl:
    cli                     ; clear intrrupt flag -- forbidden intrrupt

    mov ax, 0x0000
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, BOOT_LOAD       ; 0x7C00
    sti                     ; set intrrupt flag -- permit intrrupt (BIOS sets BOOT_DRIVE to dl)
    
    mov [BOOT + drive.no], dl    ; save boot drive

    ; print string
    cdecl puts, .s0

    ; read next 512 byte
    mov bx, BOOT_SECT - 1
    mov cx, BOOT_LOAD + SECT_SIZE
    cdecl read_chs, BOOT, bx, cx
    cmp ax, bx                      ; if(AX != 残りセクタ数)
.10Q:   jz  .10E
.10T:   cdecl   puts,   .e0
        call    reboot
.10E:
    jmp stage_2             ; 2nd stageへ移行

.s0 db "Booting...", 0x0A, 0x0D, 0
.e0 db "Error:sector read", 0

ALIGN 2, db 0

BOOT:
    istruc  drive
        at  drive.no,       dw  0
        at  drive.cyln,     dw  0
        at  drive.sect,     dw  2
    iend

; module 
%include "../modules/real/puts.s"
%include "../modules/real/reboot.s"
%include "../modules/real/read_chs.s"
%include "../modules/real/lba_chs.s"
%include "../modules/real/read_lba.s"
%include "../modules/real/memcpy.s"
%include "../modules/real/memcmp.s"

; boot flag
    times 510 - ($ - $$) db 0x00    ; 先頭512バイトの終了
    db 0x55, 0xAA

; リアルモード時に取得した情報(プロテクトモードとリアルモードでは共通のラベルを参照できないのでロードするセクタの先頭アドレスに配置されるようにする)
FONT:
.seg: dw 0
.off: dw 0
ACPI_DATA:
.adr: dd 0
.len: dd 0

; module 先頭512byte以降に設置
%include "../modules/real/itoa.s"
%include "../modules/real/get_drive_param.s"
%include "../modules/real/get_font_adr.s"
%include "../modules/real/get_mem_info.s"
%include "../modules/real/kbc.s"

stage_2:
        cdecl puts, .s0

        ; get drive param
        cdecl   get_drive_param, BOOT         ; get_drive_param(DX, BOOT.CYLN);
        cmp     ax, 0
.10Q:   jne     .10E
.10T:   cdecl   puts, .e0
        call    reboot
.10E:
        mov     ax, [BOOT + drive.no]
        cdecl   itoa, ax, .p1, 2, 16, 0b0100
        mov     ax, [BOOT + drive.cyln]
        cdecl   itoa, ax, .p2, 4, 16, 0b0100
        mov     ax, [BOOT + drive.head]
        cdecl   itoa, ax, .p3, 2, 16, 0b0100
        mov     ax, [BOOT + drive.sect]
        cdecl   itoa, ax, .p4, 2, 16, 0b0100
        cdecl   puts, .s1

        jmp stage_3rd

; data
.s0 db "2nd stage...", 0x0A, 0x0D, 0
.s1 db " Drive:0x"
.p1 db "  , C:0x"
.p2 db "    , H:0x"
.p3 db "  , S:0x"
.p4 db "  ", 0x0A, 0x0D, 0

.e0 db "Can't get drive parameter.", 0

stage_3rd:
        cdecl  puts, .s0

        ; プロテクトモードで使用するフォントはBIOSに内蔵されたものを利用する
        cdecl  get_font_adr, FONT

        ; フォントアドレスの表示
        cdecl itoa, word [FONT.seg], .p1, 4, 16, 0b0100
        cdecl itoa, word [FONT.off], .p2, 4, 16, 0b0100
        cdecl puts, .s1

        ; メモリ情報の取得と表示
        cdecl get_mem_info, ACPI_DATA       ; get_mem_info(&ACPI_DATA)
        mov   eax,  [ACPI_DATA.adr]         ; EAX = ACPI_DATA.adr
        cmp   eax, 0                        ; if (EAX) {
        je    .10E
        cdecl itoa, ax, .p4, 4, 16, 0b0100  ;   itoa(AX) // 下位アドレスを変換
        shr   eax,  16                      ;   EAX >>= 16
        cdecl itoa, ax, .p3, 4, 16, 0b0100  ;   itoa(AX) // 上位アドレスを変換
        cdecl puts, .s2                     ;   puts(.s2) // アドレスを表示
                                            ; }
.10E:
        jmp stage_4th

.s0 db "3rd stage...", 0x0A, 0x0D, 0
.s1 db " Font Address="
.p1 db "ZZZZ:"
.p2 db "ZZZZ", 0x0A, 0x0D, 0
    db 0x0A, 0x0D, 0

.s2 db " ACPI data="
.p3 db "ZZZZ"
.p4 db "ZZZZ", 0x0A, 0x0D, 0

stage_4th:
        cdecl   puts, .s0

        ; A20ゲートの有効化
        cli                                 ; 割込み禁止
        cdecl   KBC_Cmd_Write, 0XAD         ; キーボード無効化
        cdecl   KBC_Cmd_Write, 0XD0         ; 出力ポート読み出しコマンド
        cdecl   KBC_Data_Read, .key         ; 出力ポートデータ

        mov     bl, [.key]                  ; BL = key
        or      bl, 0x02                    ; BL |= 0x02; // A20ゲート有効化

        cdecl   KBC_Cmd_Write, 0xD1         ; 出力ポート書き込みコマンド
        cdecl   KBC_Data_Write, bx          ; 出力ポートデータ

        cdecl   KBC_Cmd_Write, 0xAE         ; キーボード有効化
        sti                                 ; 割り込み許可

        cdecl   puts, .s1

        ; LEDのテスト
        cdecl   puts, .s2

        mov     bx, 0
.10L:
        ; mov     ah, 0x00
        ; int     0x16

        ; cmp     al, '1'
        ; jb      .10E
        jmp    .10E

        mov     cl, al
        dec     cl
        and     cl, 0x03
        mov     ax, 0x0001
        shl     ax, cl
        xor     bx, ax

        cli
        cdecl   KBC_Cmd_Write, 0xAD
        cdecl   KBC_Data_Write, 0xED
        cdecl   KBC_Data_Read, .key

        cmp     [.key], byte 0xFA
        jne     .11F

        cdecl   KBC_Data_Write, bx
        jmp     .11E
.11F:
        cdecl   itoa, word [.key], .e1, 2, 16, 0b0100
.11E:
        cdecl   KBC_Cmd_Write, 0xAE
        sti
        jmp     .10L
.10E:
        cdecl   puts, .s3
        jmp stage_5th

.s0 db "4th stage...", 0x0A, 0x0D, 0
.s1 db " A20 Gate Enabled.", 0x0A, 0x0D, 0
.s2 db " Keyboard LED Test...", 0
.s3 db " (done)", 0x0A, 0x0D, 0
.e0 db "["
.e1 db "ZZ]", 0
.key dw 0

stage_5th:
        cdecl puts, .s0

        ; read kernel
        cdecl read_lba, BOOT, BOOT_SECT, KERNEL_SECT, BOOT_END
        cmp   ax, KERNEL_SECT
.10Q:   jz    .10E
.10T:   cdecl puts, .e0
        call  reboot
.10E:
        jmp stage_6th

.s0     db  "5th stage...", 0x0A, 0x0D, 0
.e0     db " Failure load kernel...", 0x0A, 0x0D, 0

stage_6th:
        cdecl puts, .s0
.10L:
        ; mov ah, 0x00
        ; int 0x16                ; AL = BIOS(0x16, 0x00) // キー入力待ち
        ; cmp al, ' '
        ; jne .10L

        ; ビデオモードの設定
        mov ax, 0x0012          ; VGA 640x480
        int 0x10

        jmp stage_7th

.s0     db "6th stage...", 0x0A, 0x0D, 0x0A, 0x0D
        db " [Push SPACE key to protect mode...]", 0x0A, 0x0D, 0


read_file:
        push    ax
        push    bx
        push    cx

        ; デフォルトの文字列を設定
        cdecl   memcpy, 0x7800, .s0, .s1 - .s0

        ; ルートディレクトリのセクタを読み込む
        mov     bx, 32 + 256 + 256      ; BX = ディレクトリエントリの先頭セクタ（予約セクタ数=32, FAT領域=256セクタが2個）
        mov     cx, (512 * 32) / 512    ; CX = 512エントリ分のセクタ数
.10L:
        ; 1セクタ（16エントリ）分を読み込む
        cdecl   read_lba, BOOT, bx, 1, 0x7600
        cmp     ax, 0
        je      .10E

        ; ディレクトリエントリからファイル名を検索
        cdecl   fat_find_file
        cmp     ax, 0
        je      .12E
        add     ax, 32 + 256 + 256 + 32 - 2
        cdecl   read_lba, BOOT, ax, 1, 0x7800
        jmp     .10E
.12E:                                            ;     }
        inc     bx
        loop    .10L
.10E:
        pop     cx
        pop     bx
        pop     ax

        ret

.s0:    db        'File not found.', 0
.s1:

fat_find_file:
        push    bx
        push    cx
        push    si

        cld
        mov     bx, 0
        mov     cx, 512 / 32
        mov     si, 0x7600
.10L:
        and     [si + 11], byte 0x18
        jnz     .12E

        cdecl   memcmp, si, .s0, 8 + 3
        cmp     ax, 0
        jne     .12E

        mov     bx, word [si + 0x1A]
        jmp     .10E
.12E:
        add     si, 32
        loop    .10L
.10E:
        mov     ax, bx

        pop     si
        pop     cx
        pop     bx

        ret

.s0:    db      'SPECIAL TXT', 0


; グローバルディスクリプターテーブル
ALIGN 4, db 0
GDT:    dq 0x00_0000_000000_0000
.cs:    dq 0x00_CF9A_000000_FFFF
.ds:    dq 0x00_FF92_000000_FFFF
.gdt_end:

; コード用セレクタとデータ用セレクタ
SEL_CODE    equ GDT.cs - GDT
SEL_DATA   equ GDT.ds - GDT 

; GDT (ディクリプタテーブルのリミットとアドレス)
GDTR:   dw GDT.gdt_end - GDT - 1
        dd GDT

; IDT(疑似：割り込みを禁止にするもの)
IDTR:  dw 0
       dd 0

stage_7th:
        cli

        lgdt [GDTR]
        lidt [IDTR]

        ; プロテクトモードへ移行
        mov eax, cr0
        or  ax, 1
        mov cr0, eax            ; プロテクトモードに移行するためにCR0レジスタにあるPEビットに１をセット
        jmp $ + 2               ; 先読みをクリア

[BITS 32]
        DB 0x66
        jmp SEL_CODE:CODE_32

; 32ビットコード開始
CODE_32:
        ; セレクタ初期化
        mov ax, SEL_DATA
        mov ds, ax
        mov es, ax
        mov fs, ax
        mov gs, ax
        mov ss, ax

        ; カーネルを上位アドレスにコピー
        mov ecx, (KERNEL_SIZE)/ 4           ; ECX = 4byte単位でコピー
        mov esi, BOOT_END                   ; ESI // カーネル部
        mov edi, KERNEL_LOAD                ; EDI // 上位メモリ
        cld                                 ; DFクリア（＋方向）
        rep movsd                           ; while(--ECX) *EDI++ = *ESI++
        
        ; カーネルの先頭にジャンプ
        jmp KERNEL_LOAD


TO_REAL_MODE:
        push   ebp
        mov    ebp, esp

        pusha

        cli

        mov     eax, cr0
        mov     [.cr0_saved], eax
        mov     [.esp_saved], esp
        sidt    [.idtr_save]
        lidt    [.idtr_real]

        ; 16ビットのプロテクトモードに移行
        jmp     0x0018:.bit16
[BITS 16]
.bit16: mov     ax, 0x0020
        mov     ds, ax
        mov     es, ax
        mov     ss, ax

        ;リアルモードへ移行 & ページング無効化
        mov     eax, cr0
        and     eax, 0x7FFF_FFFE
        mov     cr0, eax
        jmp     $ + 2

        jmp    0:.real
.real:    mov    ax, 0x0000
        mov    ds, ax
        mov    es, ax
        mov    ss, ax
        mov    sp, 0x7C00

        ; 割り込みマスクの設定（リアルモード用）
        outp    0x20, 0x11
        outp    0x21, 0x08
        outp    0x21, 0x04
        outp    0x21, 0x01

        outp    0xA0, 0x11
        outp    0xA1, 0x10
        outp    0xA1, 0x02
        outp    0xA1, 0x01

        outp    0x21, 0b_1011_1000              ; 割り込み有効：FDD/スレーブPIC/KBC/タイマー
        outp    0xA1, 0b_1011_1110              ; 割り込み有効：HDD/RTC

        sti                                     ; 割り込み許可

        ; ファイル読み込み
        cdecl   read_file

        cli                                     ; 割込み禁止

        ; 割り込みマスクの設定（プロテクトモード用）
        outp    0x20, 0x11
        outp    0x21, 0x20
        outp    0x21, 0x04
        outp    0x21, 0x01

        outp    0xA0, 0x11
        outp    0xA1, 0x28
        outp    0xA1, 0x02
        outp    0xA1, 0x01

        outp    0x21, 0b_1111_1000              ; 割り込み有効：スレーブPIC/KBC/タイマー
        outp    0xA1, 0b_1111_1110              ; 割り込み有効：RTC


        ; 16ビットプロテクトモードに移行
        mov     eax, cr0
        or      eax, 1
        mov     cr0, eax
        jmp     $ + 2

        ; 32ビットプロテクトモードに移行
        DB      0x66
[BITS 32]
        jmp     0x0008:.bit32
.bit32: mov     ax, 0x0010
        mov     ds, ax
        mov     es, ax
        mov     ss, ax

        ; レジスタ設定の復帰
        mov     esp, [.esp_saved]
        mov     eax, [.cr0_saved]
        mov     cr0, eax
        lidt    [.idtr_save]

        sti

        popa

        mov    esp, ebp
        pop    ebp

        ret

.idtr_real:
        dw      0x3FF
        dd      0

.idtr_save:
        dw      0
        dd      0

.cr0_saved:
        dd      0

.esp_saved:
        dd      0


        ; パディング
        times   BOOT_SIZE - ($ - $$) - 16       db 0
        dd      TO_REAL_MODE
        times   BOOT_SIZE - ($ - $$)            db 0

