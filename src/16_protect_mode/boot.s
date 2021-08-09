; macro
%include "../include/macro.s"
%include "../include/define.s"

    ORG BOOT_LOAD

; entrypoint
entry:
    jmp ipl

    ; BPB (BIOS Parameter Block)
    times 90 - ($- $$) db 0x90

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
        mov     ah, 0x00
        int     0x16

        cmp     al, '1'
        jb      .10E

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
        mov ah, 0x00
        int 0x16                ; AL = BIOS(0x16, 0x00) // キー入力待ち
        cmp al, ' '
        jne .10L

        ; ビデオモードの設定
        mov ax, 0x0012          ; VGA 640x480
        int 0x10

        jmp stage_7th

.s0     db "6th stage...", 0x0A, 0x0D, 0x0A, 0x0D
        db " [Push SPACE key to protect mode...]", 0x0A, 0x0D, 0

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


        ; パディング（今後作成するコード量を見越して8KBのファイルにしている）
        times BOOT_SIZE - ($-$$) db 0
