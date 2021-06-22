lba_chs:
    push bp
    mov bp, sp

    mov si, [bp + 4]    ; SI = driveバッファ
    mov di, [bp + 6]    ; DI = drv_chsバッファ

    mov al, [si + drive.head]
    mul byte [si + drive.sect]
    mov bx, ax

    mov dx, 0
    mov ax, [bp + 8]
    div bx

    mov [di + drive.cyln], ax

    mov ax, dx
    div byte [si + drive.sect]
    movzx dx, ah
    inc dx
    mov ah, 0x00
    mov [di + drive.head], ax
    mov [di + drive.sect], dx