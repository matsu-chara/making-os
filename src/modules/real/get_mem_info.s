get_mem_info:
  push eax
  push ebx
  push ecx
  push edx
  push si
  push di
  push bp

  mov bp, 0
  mov ebx, 0
.10L:
  mov eax, 0x0000E820       ; EAX=0xE820
                            ; EBX = インデックス
  mov ecx, E820_RECORD_SIZE ; ECX = 要求バイト数
  mov edx, 'PAMS'           ; EDX = 'SMAP'
  mov di, .b0               ; ES:DI = バッファ
  int 0x15                  ; ES:DI = BIOS(0x15, 0xE820)

  ; コマンドに対応していたか？
  cmp   eax, 'PAMS'           ; if('SMAP' != EAX)
  je    .12E
  jmp   .10E                  ;     break
.12E:
    ; エラーなし？            ; if(CF)
  jnc   .14E
  jmp   .10E                ;     break
.14E:
    ; 1レコード分の情報を表示
  cdecl put_mem_info, di

    ; ACPI dataのアドレスを表示
  mov   eax, [di + 16]
  cmp   eax, 3
  jne   .15E
  mov   eax, [di + 0]
  mov   [ACPI_DATA.adr], eax
  mov   eax, [di + 8]
  mov   [ACPI_DATA.len], eax
.15E:
  cmp   ebx, 0
  jz    .16E
  inc   bp
  and   bp, 0x07
  jnz   .16E
  cdecl puts, .s2

  mov   ah, 0x10
  int   0x16                ; キー入力待ち
  cdecl puts, .s3
.16E:

  cmp   ebx, 0
  jne   .10L
.10E:

.s2: db " <more...>", 0
.s3: db 0x0D, "          ", 0x0D, 0

ALIGN 4, db 0
.b0:	times E820_RECORD_SIZE db 0


put_mem_info:
    push bp
    mov  bp, sp

    push bx
    push si

    mov  si, [bp + 4]

    ; Base(64bit)
    cdecl   itoa, word [si + 6], .p2 + 0, 4, 16, 0b0100
    cdecl   itoa, word [si + 4], .p2 + 4, 4, 16, 0b0100
    cdecl   itoa, word [si + 2], .p3 + 0, 4, 16, 0b0100
    cdecl   itoa, word [si + 0], .p3 + 4, 4, 16, 0b0100

    ; Length(64bit)
    cdecl   itoa, word [si + 14], .p4 + 0, 4, 16, 0b0100
    cdecl   itoa, word [si + 12], .p4 + 4, 4, 16, 0b0100
    cdecl   itoa, word [si + 10], .p5 + 0, 4, 16, 0b0100
    cdecl   itoa, word [si +  8], .p5 + 4, 4, 16, 0b0100

    ; Type(32bit)
    cdecl   itoa, word [si + 18], .p6 + 0, 4, 16, 0b0100
    cdecl   itoa, word [si + 16], .p6 + 4, 4, 16, 0b0100

    cdecl puts, .s1

    mov bx, [si + 16]   ; タイプを文字列で表示
    and bx, 0x07        ; BX = Type(0~5)
    shl bx, 1           ; BX *= 2 // 要素サイズに変換
    add bx, .t0         ; BX += .t0 // テーブルの先頭アドレスを加算
    cdecl puts, word [bx]   ; puts(*BX)

    pop si
    pop bx

    mov sp, bp
    pop bp
    ret

.s1: db " "
.p2: db "ZZZZZZZZ_"
.p3: db "ZZZZZZZZ "
.p4: db "ZZZZZZZZ_"
.p5: db "ZZZZZZZZ "
.p6: db "ZZZZZZZZ", 0

.s4: db " (Unknown)", 0x0A, 0x0D, 0
.s5: db " (usable)", 0x0A, 0x0D, 0
.s6: db " (reserved)", 0x0A, 0x0D, 0
.s7: db " (ACPI data)", 0x0A, 0x0D, 0
.s8: db " (ACPI NVS)", 0x0A, 0x0D, 0
.s9: db " (bad memory)", 0x0A, 0x0D, 0

.t0: dw .s4, .s5, .s6, .s7, .s8, .s9, .s4, .s4