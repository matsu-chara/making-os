get_font_adr:
  ; スタックフレームの構築
  push bp
  mov  bp, sp

  ; save register
  push ax
  push bx
  push si
  push es
  push bp

  ; 引数
  mov si, [bp + 4]      ; dst = FONDアドレスの保存先

  ; get fond address
  mov ax, 0x1130
  mov bh, 0h06
  int 10h               ; ES:BP = フォントアドレス

  ; save font address
  mov [si + 0], es
  mov [si + 2], bp

  pop bp
  pop es
  pop si
  pop bx
  pop ax

  mov sp, bp
  pop bp

  ret