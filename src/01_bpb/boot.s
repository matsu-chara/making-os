; entrypoint
entry:
    jmp ipl

    ; BPB (BIOS Parameter Block)
    times 90 - ($- $$) db 0x90

; IPL(initial program loader)
ipl:
    jmp $

; boot flag
    times 510 - ($ - $$) db 0x00
    db 0x55, 0xAA
