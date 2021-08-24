; TSS
TSS_0:
.link:      dd 0                        ;   0: 前のタスクへのリンク
.esp0:      dd SP_TASK_0 - 512          ;*  4:ESP0
.ss0:       dd DS_KERNEL                ;*  8:
.esp1:      dd 0                        ;* 12:ESP1
.ss1:       dd 0                        ;* 16:
.esp2:      dd 0                        ;* 20:ESP2
.ss2:       dd 0                        ;* 24:
.cr3:       dd CR3_BASE                 ;* 28:CR3(PDBR)
.eip:       dd 0                        ;* 32:EIP
.eflags:    dd 0                        ;* 36:EFLAGS
.eax:       dd 0                        ;* 40:EAX
.ecx:       dd 0
.edx:       dd 0
.ebx:       dd 0
.esp:       dd 0
.ebp:       dd 0
.esi:       dd 0
.edi:       dd 0
.es:        dd 0
.cs:        dd 0
.ss:        dd 0
.ds:        dd 0
.fs:        dd 0
.gs:        dd 0
.ldt:       dd 0                        ;* 96:LDTセグメントセレクタ
.io:        dd 0                        ; 100:I/Oマップベースアドレス
.fp_save:   times 108 + 4 db 0          ; FPUコンテキスト保存領域

TSS_1:
.link:      dd 0                        ;   0: 前のタスクへのリンク
.esp0:      dd SP_TASK_1 - 512          ;*  4:ESP0
.ss0:       dd DS_KERNEL                ;*  8:
.esp1:      dd 0                        ;* 12:ESP1
.ss1:       dd 0                        ;* 16:
.esp2:      dd 0                        ;* 20:ESP2
.ss2:       dd 0                        ;* 24:
.cr3:       dd CR3_BASE                 ;* 28:CR3(PDBR)
.eip:       dd task_1                   ;* 32:EIP
.eflags:    dd 0x0202                   ;* 36:EFLAGS
.eax:       dd 0                        ;* 40:EAX
.ecx:       dd 0
.edx:       dd 0
.ebx:       dd 0
.esp:       dd SP_TASK_1
.ebp:       dd 0
.esi:       dd 0
.edi:       dd 0
.es:        dd DS_TASK_1
.cs:        dd CS_TASK_1
.ss:        dd DS_TASK_1
.ds:        dd DS_TASK_1
.fs:        dd DS_TASK_1
.gs:        dd DS_TASK_1
.ldt:       dd SS_LDT                   ;* 96:LDTセグメントセレクタ
.io:        dd 0                        ; 100:I/Oマップベースアドレス
.fp_save:   times 108 + 4 db 0          ; FPUコンテキスト保存領域

TSS_2:
.link:      dd 0                        ;   0: 前のタスクへのリンク
.esp0:      dd SP_TASK_2 - 512          ;*  4:ESP0
.ss0:       dd DS_KERNEL                ;*  8:
.esp1:      dd 0                        ;* 12:ESP1
.ss1:       dd 0                        ;* 16:
.esp2:      dd 0                        ;* 20:ESP2
.ss2:       dd 0                        ;* 24:
.cr3:       dd CR3_BASE                 ;* 28:CR3(PDBR)
.eip:       dd task_2                   ;* 32:EIP
.eflags:    dd 0x0202                   ;* 36:EFLAGS
.eax:       dd 0                        ;* 40:EAX
.ecx:       dd 0
.edx:       dd 0
.ebx:       dd 0
.esp:       dd SP_TASK_2
.ebp:       dd 0
.esi:       dd 0
.edi:       dd 0
.es:        dd DS_TASK_2
.cs:        dd CS_TASK_2
.ss:        dd DS_TASK_2
.ds:        dd DS_TASK_2
.fs:        dd DS_TASK_2
.gs:        dd DS_TASK_2
.ldt:       dd SS_LDT                   ;* 96:LDTセグメントセレクタ
.io:        dd 0                        ; 100:I/Oマップベースアドレス
.fp_save:   times 108 + 4 db 0          ; FPUコンテキスト保存領域

TSS_3:
.link:      dd 0                        ;   0: 前のタスクへのリンク
.esp0:      dd SP_TASK_3 - 512          ;*  4:ESP0
.ss0:       dd DS_KERNEL                ;*  8:
.esp1:      dd 0                        ;* 12:ESP1
.ss1:       dd 0                        ;* 16:
.esp2:      dd 0                        ;* 20:ESP2
.ss2:       dd 0                        ;* 24:
.cr3:       dd CR3_BASE                 ;* 28:CR3(PDBR)
.eip:       dd task_3                   ;* 32:EIP
.eflags:    dd 0x0202                   ;* 36:EFLAGS
.eax:       dd 0                        ;* 40:EAX
.ecx:       dd 0
.edx:       dd 0
.ebx:       dd 0
.esp:       dd SP_TASK_3
.ebp:       dd 0
.esi:       dd 0
.edi:       dd 0
.es:        dd DS_TASK_3
.cs:        dd CS_TASK_3
.ss:        dd DS_TASK_3
.ds:        dd DS_TASK_3
.fs:        dd DS_TASK_3
.gs:        dd DS_TASK_3
.ldt:       dd SS_LDT                   ;* 96:LDTセグメントセレクタ
.io:        dd 0                        ; 100:I/Oマップベースアドレス
.fp_save:   times 108 + 4 db 0          ; FPUコンテキスト保存領域

TSS_4:
.link:      dd 0                        ;   0: 前のタスクへのリンク
.esp0:      dd SP_TASK_4 - 512          ;*  4:ESP0
.ss0:       dd DS_KERNEL                ;*  8:
.esp1:      dd 0                        ;* 12:ESP1
.ss1:       dd 0                        ;* 16:
.esp2:      dd 0                        ;* 20:ESP2
.ss2:       dd 0                        ;* 24:
.cr3:       dd CR3_TASK_4                 ;* 28:CR3(PDBR)
.eip:       dd task_3                   ;* 32:EIP
.eflags:    dd 0x0202                   ;* 36:EFLAGS
.eax:       dd 0                        ;* 40:EAX
.ecx:       dd 0
.edx:       dd 0
.ebx:       dd 0
.esp:       dd SP_TASK_4
.ebp:       dd 0
.esi:       dd 0
.edi:       dd 0
.es:        dd DS_TASK_4
.cs:        dd CS_TASK_3
.ss:        dd DS_TASK_4
.ds:        dd DS_TASK_4
.fs:        dd DS_TASK_4
.gs:        dd DS_TASK_4
.ldt:       dd SS_LDT                   ;* 96:LDTセグメントセレクタ
.io:        dd 0                        ; 100:I/Oマップベースアドレス
.fp_save:   times 108 + 4 db 0          ; FPUコンテキスト保存領域
TSS_5:
.link:      dd 0                        ;   0: 前のタスクへのリンク
.esp0:      dd SP_TASK_5 - 512          ;*  4:ESP0
.ss0:       dd DS_KERNEL                ;*  8:
.esp1:      dd 0                        ;* 12:ESP1
.ss1:       dd 0                        ;* 16:
.esp2:      dd 0                        ;* 20:ESP2
.ss2:       dd 0                        ;* 24:
.cr3:       dd CR3_TASK_5                 ;* 28:CR3(PDBR)
.eip:       dd task_3                   ;* 32:EIP
.eflags:    dd 0x0202                   ;* 36:EFLAGS
.eax:       dd 0                        ;* 40:EAX
.ecx:       dd 0
.edx:       dd 0
.ebx:       dd 0
.esp:       dd SP_TASK_5
.ebp:       dd 0
.esi:       dd 0
.edi:       dd 0
.es:        dd DS_TASK_5
.cs:        dd CS_TASK_3
.ss:        dd DS_TASK_5
.ds:        dd DS_TASK_5
.fs:        dd DS_TASK_5
.gs:        dd DS_TASK_5
.ldt:       dd SS_LDT                   ;* 96:LDTセグメントセレクタ
.io:        dd 0                        ; 100:I/Oマップベースアドレス
.fp_save:   times 108 + 4 db 0          ; FPUコンテキスト保存領域
TSS_6:
.link:      dd 0                        ;   0: 前のタスクへのリンク
.esp0:      dd SP_TASK_6 - 512          ;*  4:ESP0
.ss0:       dd DS_KERNEL                ;*  8:
.esp1:      dd 0                        ;* 12:ESP1
.ss1:       dd 0                        ;* 16:
.esp2:      dd 0                        ;* 20:ESP2
.ss2:       dd 0                        ;* 24:
.cr3:       dd CR3_TASK_6                 ;* 28:CR3(PDBR)
.eip:       dd task_3                   ;* 32:EIP
.eflags:    dd 0x0202                   ;* 36:EFLAGS
.eax:       dd 0                        ;* 40:EAX
.ecx:       dd 0
.edx:       dd 0
.ebx:       dd 0
.esp:       dd SP_TASK_6
.ebp:       dd 0
.esi:       dd 0
.edi:       dd 0
.es:        dd DS_TASK_6
.cs:        dd CS_TASK_3
.ss:        dd DS_TASK_6
.ds:        dd DS_TASK_6
.fs:        dd DS_TASK_6
.gs:        dd DS_TASK_6
.ldt:       dd SS_LDT                   ;* 96:LDTセグメントセレクタ
.io:        dd 0                        ; 100:I/Oマップベースアドレス
.fp_save:   times 108 + 4 db 0          ; FPUコンテキスト保存領域
; グローバルディスクリプタテーブル
GDT:        dq 0x0000000000000000       ; NULL
.cs_kernel: dq 0x00CF9A000000FFFF       ; CODE 4G
.ds_kernel: dq 0x00CF92000000FFFF       ; DATA 4G
.cs_bit16   dq 0x000F9A000000FFFF       ; コードセグメント(16bit)
.ds_bit16   dq 0x000F92000000FFFF       ; データセグメント(16bit)
.ldt:        dq 0x0000820000000000       ; LDTディスクリプタ
.tss_0:      dq 0x0000890000000067       ; TSSディスクリプタ
.tss_1:      dq 0x0000890000000067       ; TSSディスクリプタ
.tss_2:      dq 0x0000890000000067       ; TSSディスクリプタ
.tss_3:      dq 0x0000890000000067       ; TSSディスクリプタ
.tss_4:      dq 0x0000890000000067       ; TSSディスクリプタ
.tss_5:      dq 0x0000890000000067       ; TSSディスクリプタ
.tss_6:      dq 0x0000890000000067       ; TSSディスクリプタ
.call_gate  dq 0x0000EC0400080000       ; 386 コールゲート
.end:

CS_KERNEL   equ .cs_kernel  - GDT
DS_KERNEL   equ .ds_kernel  - GDT
SS_LDT      equ .ldt        - GDT
SS_TASK_0   equ .tss_0      - GDT
SS_TASK_1   equ .tss_1      - GDT
SS_TASK_2   equ .tss_2      - GDT
SS_TASK_3   equ .tss_3      - GDT
SS_TASK_4   equ .tss_4      - GDT
SS_TASK_5   equ .tss_5      - GDT
SS_TASK_6   equ .tss_6      - GDT
SS_GATE_0   equ .call_gate  - GDT

GDTR:   dw GDT.end - GDT - 1
        dd GDT


; ローカルディスクリプタテーブル
LDT:        dq 0x0000000000000000       ; NULL
.cs_task_0: dq 0x00CF9A000000FFFF       ; CODE 4G
.ds_task_0: dq 0x00CF92000000FFFF       ; DATA 4G
.cs_task_1: dq 0x00CFFA000000FFFF       ; CODE 4G
.ds_task_1: dq 0x00CFF2000000FFFF       ; DATA 4G
.cs_task_2: dq 0x00CFFA000000FFFF       ; CODE 4G
.ds_task_2: dq 0x00CFF2000000FFFF       ; DATA 4G
.cs_task_3: dq 0x00CFFA000000FFFF       ; CODE 4G
.ds_task_3: dq 0x00CFF2000000FFFF       ; DATA 4G
.cs_task_4: dq 0x00CFFA000000FFFF       ; CODE 4G
.ds_task_4: dq 0x00CFF2000000FFFF       ; DATA 4G
.cs_task_5: dq 0x00CFFA000000FFFF       ; CODE 4G
.ds_task_5: dq 0x00CFF2000000FFFF       ; DATA 4G
.cs_task_6: dq 0x00CFFA000000FFFF       ; CODE 4G
.ds_task_6: dq 0x00CFF2000000FFFF       ; DATA 4G
.end:

CS_TASK_0   equ (.cs_task_0 - LDT) | 4  ; タスク0用CSセレクタ
DS_TASK_0   equ (.ds_task_0 - LDT) | 4  ; タスク0用DSセレクタ
CS_TASK_1   equ (.cs_task_1 - LDT) | 4 | 3  ; タスク1用CSセレクタ
DS_TASK_1   equ (.ds_task_1 - LDT) | 4 | 3  ; タスク1用DSセレクタ

CS_TASK_2   equ (.cs_task_2 - LDT) | 4 | 3  ; タスク2用CSセレクタ
DS_TASK_2   equ (.ds_task_2 - LDT) | 4 | 3  ; タスク2用DSセレクタ

CS_TASK_3   equ (.cs_task_3 - LDT) | 4 | 3  ; タスク3用CSセレクタ
DS_TASK_3   equ (.ds_task_3 - LDT) | 4 | 3  ; タスク3用DSセレクタ
CS_TASK_4   equ (.cs_task_4 - LDT) | 4 | 3  ; タスク4用CSセレクタ
DS_TASK_4   equ (.ds_task_4 - LDT) | 4 | 3  ; タスク4用DSセレクタ
CS_TASK_5   equ (.cs_task_5 - LDT) | 4 | 3  ; タスク5用CSセレクタ
DS_TASK_5   equ (.ds_task_5 - LDT) | 4 | 3  ; タスク5用DSセレクタ
CS_TASK_6   equ (.cs_task_6 - LDT) | 4 | 3  ; タスク6用CSセレクタ
DS_TASK_6   equ (.ds_task_6 - LDT) | 4 | 3  ; タスク6用DSセレクタ

LDT_LIMIT   equ .end        - LDT - 1
