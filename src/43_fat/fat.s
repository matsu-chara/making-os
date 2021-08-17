times (FAT1_START) - ($ - $$) db 0x00

FAT1:
    db  0xFF, 0xFF
    dw  0xFFFF
    dw  0xFFFF

times (FAT2_START) - ($ - $$) db 0x00
FAT2:
    db  0xFF, 0xFF
    dw  0xFFFF
    dw  0xFFFF


times (ROOT_START) - ($ - $$) db 0x00
FAT_ROOT:
    db  'BOOTABLE', 'DSK'               ; ボリュームラベル
    db  ATTR_ARCHIVE | ATTR_VOLUME_ID   ; 属性
    db  0x00                            ; 予約
    db  0x00                            ; TS
    dw  (0 << 11) | (0 << 5) | (0 / 2)  ; 作成時刻
    dw  (0 << 9)  | (0 << 5) | ( 1)     ; 作成日
    dw  (0 << 9)  | (0 << 5) | ( 1)     ; アクセス日
    dw  0x0000                          ; 予約
    dw  (0 << 11) | (0 << 5) | (0 / 2)  ; 更新時刻
    dw  (0 << 9)  | (0 << 5) | ( 1)     ; 更新日
    dw  0                               ; 先頭クラスタ
    dd  0                               ; ファイルサイズ
    
    db  'SPECIAL', 'TXT'                ; ボリュームラベル
    db  ATTR_ARCHIVE                    ; 属性
    db  0x00                            ; 予約
    db  0                               ; TS
    dw  (0 << 11) | (0 << 5) | (0 / 2)  ; 作成時刻
    dw  (0 << 9)  | (1 << 5) | ( 1)     ; 作成日
    dw  (0 << 9)  | (1 << 5) | ( 1)     ; アクセス日
    dw  0x0000                          ; 予約
    dw  (0 << 11) | (0 << 5) | (0 / 2)  ; 更新時刻
    dw  (0 << 9)  | (1 << 5) | ( 1)     ; 更新日
    dw  2                               ; 先頭クラスタ
    dd  FILE.end - FILE                 ; ファイルサイズ
    
; データ領域
    times   FILE_START - ($ - $$) db 0x00

FILE:   db  'hello, FAT!'
.end:   db  0

ALIGN 512 db 0x00
        times (512 * 63) db 0x00
