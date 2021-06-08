%macro cdecl 1-*.nolist
    %rep %0 - 1
        push %{-1:-1}
        %rotate -1
    %endrep
    %rotate -1
        call %1
    %if 1 < %0
        add sp, (__BITS__ >> 3) * (%0 - 1)
    %endif
%endmacro

struct drive
    .no     resw    1       ; ドライブ番号 reswは2byeの未初期化変数予約 https://qiita.com/MoriokaReimen/items/b320e6cc82c8873a602f
    .cyln   resw    1       ; シリンダ
    .head   resw    1       ; ヘッド
    .sect   resw    1       ; セクタ
endstruc
