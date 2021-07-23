int_rtc:
    pusha
    push    ds
    push    es

    ; データ用セグメントセレクタの設定
    mov     ax, 0x0010                  ; GDTの先頭からのバイト数 (8バイトで構成される要素の2番目)
    mov     ds, ax
    mov     es, ax

    cdecl   rtc_get_time, RTC_TIME

    ; RTCの割り込み要因を取得
    outp    0x70, 0x0c
    in      al, 0x71                    ; RTCの内部レジスタCをALに読み込むと割り込み要因がクリアされる。（読み取った値は使わない）

    ; 割り込みコントローラにEOI(End Of Interrupt）コマンドを送信
    mov     al, 0x20
    out     0xA0, al                    ; スレーブPIC
    out     0x20, al                    ; マスターPIC

    pop     es
    pop     ds
    popa

    iret                                ; フラグレジスタも含めて復帰する命令

rtc_int_en:
    push    ebp
    mov     ebp, esp

    push    eax

    outp    0x70, 0x0B

    in      al, 0x71
    or      al, [ebp + 8]

    out     0x71, al

    pop     eax

    mov     esp, ebp
    pop     ebp

    ret
