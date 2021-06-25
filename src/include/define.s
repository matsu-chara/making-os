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

SEL_CODE    equ GDT.cs - GDT
SEEL_DATA   equ GDT.ds - GDT 