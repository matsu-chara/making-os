%define USE_SYSTEM_CALL
%define USE_TEST_AND_SET

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

    ; TSSディスクリプタ設定
    set_desc    GDT.tss_0, TSS_0
    set_desc    GDT.tss_1, TSS_1
    set_desc    GDT.tss_2, TSS_2
    set_desc    GDT.tss_3, TSS_3
    set_desc    GDT.tss_4, TSS_4
    set_desc    GDT.tss_5, TSS_5
    set_desc    GDT.tss_6, TSS_6

    ; コールゲートの設定
    set_gate    GDT.call_gate, call_gate

    ; LDT設定
    set_desc	GDT.ldt, LDT, word LDT_LIMIT

    ; GDTをロードして再設定
    lgdt	[GDTR]

    ; スタックの設定
    mov		esp, SP_TASK_0

    ; タスクレジスタの初期化
    mov		ax, SS_TASK_0
    ltr		ax                          ; LTR(ロードタスクレジスタ) (タスク０が実行中とCPUに認識されるのでタスクが切り替わるとタスク０にコンテキストが保存される)

    ; 初期化
    cdecl   init_int
    cdecl   init_pic
    cdecl   init_page
    set_vect 0x00, int_zero_div
    set_vect 0x07, int_nm
    set_vect 0x0E, int_pf
    set_vect 0x20, int_timer
    set_vect 0x21, int_keyboard
    set_vect 0x28, int_rtc              ; 0x28はスレーブPICの割り込みベクタの開始位置
    set_vect 0x81, trap_gate_81, word 0xEF00
    set_vect 0x82, trap_gate_82, word 0xEF00

    ; デバイスの割り込み許可
    cdecl   rtc_int_en, 0x10            ; RTCの更新サイクル終了の割り込み許可
    cdecl   int_en_timer0               ; タイマー割り込みの許可


    ; IMR（割り込みマスクレジスタ）の設定
    outp    0x21, 0b_1111_1000           ; 割り込み有効: スレーブPIC/KBC/タイマー
    outp    0xA1, 0b_1111_1110           ; 割り込み有効: RTC

    ; ページング有効化
    mov     eax, CR3_BASE
    mov     cr3, eax
    mov     eax, cr0
    or      eax, (1 << 31)
    mov     cr0, eax
    jmp     $+2                         ; FLUSH (内部にキャッシュされた命令の破棄)

    ; CPUの割り込み許可
    sti

    ; LDTの設定
    set_desc    GDT.ldt, LDT, word, LDT_LIMIT

    ; フォントの一覧表示
    cdecl   draw_font, 63, 13
    cdecl   draw_color_bar, 63, 4

    ; 文字列の表示
    cdecl   draw_str, 25, 14, 0x010F, .s0

.10L:
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

; タスク
%include	"descriptor.s"
%include	"modules/int_timer.s"
%include	"modules/int_pf.s"
%include	"modules/paging.s"
%include	"tasks/task_1.s"
%include	"tasks/task_2.s"
%include	"tasks/task_3.s"

; モジュール
%include	"../modules/protect/vga.s"
%include	"../modules/protect/draw_char.s"
%include	"../modules/protect/draw_font.s"
%include	"../modules/protect/draw_str.s"
%include	"../modules/protect/draw_color_bar.s"
%include	"../modules/protect/draw_pixel.s"
%include	"../modules/protect/draw_line.s"
%include	"../modules/protect/draw_rect.s"
%include	"../modules/protect/itoa.s"
%include	"../modules/protect/rtc.s"
%include	"../modules/protect/draw_time.s"
%include	"../modules/protect/interrupt.s"
%include	"../modules/protect/pic.s"
%include	"../modules/protect/int_rtc.s"
%include	"../modules/protect/int_keyboard.s"
%include	"../modules/protect/ring_buff.s"
%include	"../modules/protect/timer.s"
%include	"../modules/protect/draw_rotation_bar.s"
%include	"../modules/protect/call_gate.s"
%include	"../modules/protect/trap_gate.s"
%include	"../modules/protect/test_and_set.s"
%include	"../modules/protect/int_nm.s"
%include	"../modules/protect/wait_tick.s"
%include	"../modules/protect/memcpy.s"

    times KERNEL_SIZE - ($ - $$) db 0
