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
.10L
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
  cdecl pts, .s3
.16E:

  cmp   ebx, 0
  jne   .10L
.10E:

.s2: db " <more...>", 0
.s3: db 0x0D, "          ", 0x0D, 0