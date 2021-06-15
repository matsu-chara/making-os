BOOT_LOAD   equ 0x7c00  ; ブートプログラムのロード位置
BOOT_SIZE   equ (1024 * 8) ; ブートコードサイズ
SECT_SIZE   equ (512)   ; セクタサイズ
BOOT_SECT   equ (BOOT_SIZE / SECT_SIZE) ; ブートプログラムのセクタ数

E820_RECORD_SIZE    equ 20   ; BIOSで取得したメモリ情報を格納する領域のサイズ