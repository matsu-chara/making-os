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

    cdecl puts, .s0
    jmp $

.s0 db "Booting...", 0x0A, 0x0D, 0

ALIGN 2, db 0
BOOT:
.DRIVE: dw 0

; module
%include "../modules/real/puts.s"

; boot flag
    times 510 - ($ - $$) db 0x00
    db 0x55, 0xAA