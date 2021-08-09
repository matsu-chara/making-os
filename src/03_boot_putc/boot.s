    BOOT_LOAD   equ     0x7c00
    ORG         BOOT_LOAD

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

    mov al, 'A'
    mov ah, 0x0E            ; output 1 char in teletype
    mov bx, 0x0000          ; set 0 to page_num & char_color
    int 0x10                ; Call to Interrupt Procedure - BIOS call 10. video BIOS call.

    jmp $

ALIGN 2, db 0
BOOT:
.DRIVE: dw 0

; boot flag
    times 510 - ($ - $$) db 0x00
    db 0x55, 0xAA