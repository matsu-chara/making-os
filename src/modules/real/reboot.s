reboot:
        ; print message
        cdecl   puts, .s0       ; display reboot message

        ; wait for key input
.10L:                           ; do
                                ; {
        mov     ah, 0x10        ;    // wait for key
        int     0x16            ;    AL = BIOS(0x16, 0x10)
                                ;
        cmp     al, ' '         ; zF = AL == ' '
        jne     .10L            ; } while (!ZF)

        ; output newline
        cdecl   puts, .s1

        ; rebooting
        int     0x19            ; BIOS(0x19)

        ;data
.s0     db  0x0A, 0x0D, "Push SPACE key to reboot...", 0
.s1     db  0x0A, 0x0D, 0x0A, 0x0D, 0