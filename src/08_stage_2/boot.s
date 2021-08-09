    BOOT_LOAD   equ     0x7c00
    ORG         BOOT_LOAD

; macro
%include "../include/macro.s"

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

    mov [BOOT.DRIVE], dl    ; save boot drive

    ; print string
    cdecl puts, .s0

    ; read next 512 byte
    mov ah, 0x02            ; AH = 読み込み命令
    mov al, 1               ; AL = 読み込みセクタ数
    mov cx, 0x0002          ; CX = シリンダ/セクタ
    mov dh, 0x00            ; DH = ヘッド位置
    mov dl, [BOOT.DRIVE]    ; DL = ドライブ番号
    mov bx, 0x7c00 + 512    ; BX = オフセット
    int 0x13                ; if (CF = BIOS(0x13, 0x02))
.10Q: jnc .10E              ; {
.10T: cdecl puts, .e0       ;   puts(.e0);
    call reboot             ;   reboot();
.10E:
    jmp stage_2             ; 2nd stageへ移行

.s0 db "Booting...", 0x0A, 0x0D, 0
.e0 db "Error:sector read", 0

ALIGN 2, db 0
BOOT:
  .DRIVE:  dw 0

; module
%include "../modules/real/puts.s"
%include "../modules/real/reboot.s"

; boot flag
    times 510 - ($ - $$) db 0x00    ; 先頭512バイトの終了
    db 0x55, 0xAA

stage_2:
    cdecl puts, .s0
    jmp $                               ; while(1); (無限ループ)

; data
.s0 db "2nd stage...", 0x0A, 0x0D, 0

; パディング（今後作成するコード量を見越して8KBのファイルにしている）
    times (1024*8) - ($-$$) db 0
