%include "../include/define.s"
%include "../include/macro.s"

    ORG KERNEL_LOAD

[BITS 32]
kernel:
    ; フォントアドレスの取得
    mov     esi,    BOOT_LOAD + SECT_SIZE       ; ESI = 0x7c00 + 512
    movzx   eax,    word [esi + 0]              ; EAX = [ESI + 0] // セグメント
    movzx   ebx,    word [esi + 2]              ; EBX = [ESI + 2] // オフセット
    shl     eax,    4                           ; EAX <<= 4
    add     eax,    ebx                         ; EAX += EBX
    mov     [FONT_ADR], eax                     ; FONT_ADR[0] = EAX

    ; 初期化
    cdecl   init_int
    cdecl   init_pic
    set_vect 0x00, int_zero_div
    set_vect 0x20, int_timer
    set_vect 0x21, int_keyboard
    set_vect 0x28, int_rtc              ; 0x28はスレーブPICの割り込みベクタの開始位置

    ; デバイスの割り込み許可
    cdecl   rtc_int_en, 0x10            ; RTCの更新サイクル終了の割り込み許可
    cdecl   int_en_timer0               ; タイマー割り込みの許可


    ; IMR（割り込みマスクレジスタ）の設定
    outp    0x21, 0b_1111_1000           ; 割り込み有効: スレーブPIC/KBC/タイマー
    outp    0xA1, 0b_1111_1110           ; 割り込み有効: RTC

    ; CPUの割り込み許可
    sti

    ; フォントの一覧表示
    cdecl   draw_font, 63, 13
    cdecl   draw_color_bar, 63, 4

    ; 文字列の表示
    cdecl   draw_str, 25, 14, 0x010F, .s0

.10L:
    ; 時刻の表示
    mov     eax, [RTC_TIME]
    cdecl   draw_time, 72, 0, 0x0700, eax

    ; タイマー割り込みによる回転バーの表示
    cdecl   draw_rotation_bar

    ; キーコード取得
    cdecl   ring_rd, _KEY_BUFF, .int_key
    cmp     eax, 0
    je      .10E

    ; キーコードの表示
    cdecl   draw_key, 2, 29, _KEY_BUFF

.10E:
    jmp .10L

    ; 処理の終了
    jmp $

.s0 db  " Hello, kernel! ", 0

ALIGN 4, db 0
.int_key: dd 0

ALIGN 4, db 0
FONT_ADR: dd 0
RTC_TIME: dd 0

%include "../modules/protect/vga.s"
%include "../modules/protect/draw_char.s"
%include "../modules/protect/draw_font.s"
%include "../modules/protect/draw_str.s"
%include "../modules/protect/draw_color_bar.s"
%include "../modules/protect/draw_pixel.s"
%include "../modules/protect/draw_line.s"
%include "../modules/protect/draw_rect.s"
%include "../modules/protect/itoa.s"
%include "../modules/protect/rtc.s"
%include "../modules/protect/draw_time.s"
%include "../modules/protect/interrupt.s"
%include "../modules/protect/pic.s"
%include "../modules/protect/int_rtc.s"
%include "../modules/protect/ring_buff.s"
%include "../modules/protect/int_keyboard.s"
%include "./modules/int_timer.s"
%include "../modules/protect/draw_rotation_bar.s"
%include "../modules/protect/timer.s"

    times KERNEL_SIZE - ($ - $$) db 0
