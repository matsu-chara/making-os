BOOT_LOAD   equ 0x7c00  ; ブートプログラムのロード位置
BOOT_SIZE   equ (1024 * 8) ; ブートコードサイズ
SECT_SIZE   equ (512)   ; セクタサイズ
BOOT_SECT   equ (BOOT_SIZE / SECT_SIZE) ; ブートプログラムのセクタ数

E820_RECORD_SIZE    equ 20   ; BIOSで取得したメモリ情報を格納する領域のサイズ

KERNEL_LOAD equ 0x0010_1000 ; カーネルのロードアドレス
KERNEL_SIZE equ (1024 * 8); カーネルサイズ

BOOT_END    equ (BOOT_LOAD + BOOT_SIZE)
BOOT_SECT   equ (BOOT_SIZE / SECT_SIZE)
KERNEL_SECT equ (KERNEL_SIZE / SECT_SIZE)

VECT_BASE   equ 0x0010_0000 ; 0010_0000:0010_07FF

STACK_BASE  equ 0x0010_3000 ; タスク用スタックエリア
STACK_SIZE  equ 1024        ; スタックサイズ
SP_TASK_0   equ STACK_BASE + (STACK_SIZE * 1)
SP_TASK_1   equ STACK_BASE + (STACK_SIZE * 2)
SP_TASK_2   equ STACK_BASE + (STACK_SIZE * 3)
SP_TASK_3   equ STACK_BASE + (STACK_SIZE * 4)
SP_TASK_4   equ STACK_BASE + (STACK_SIZE * 5)
SP_TASK_5   equ STACK_BASE + (STACK_SIZE * 6)
SP_TASK_6   equ STACK_BASE + (STACK_SIZE * 7)

CR3_BASE    equ 0x0010_5000     ; ページ変換テーブル

PARAM_TASK_4 equ 0x0010_8000    ; 描画パラメータ
PARAM_TASK_5 equ 0x0010_9000    ; 描画パラメータ
PARAM_TASK_6 equ 0x0010_A000    ; 描画パラメータ

CR3_TASK_4   equ 0x0020_0000    ; ページ変換テーブル
CR3_TASK_5   equ 0x0020_2000    ; ページ変換テーブル
CR3_TASK_6   equ 0x0020_4000    ; ページ変換テーブル
