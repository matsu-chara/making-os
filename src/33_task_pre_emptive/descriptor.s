; TSS
TSS_0:
.link:      dd 0                        ;   0: 前のタスクへのリンク
.esp0:      dd SP_TASK_0 - 512          ;*  4:ESP0
.ss0:       dd DS_KERNEL                ;*  8:
.esp1:      dd 0                        ;* 12:ESP1
.ss1:       dd 0                        ;* 16:
.esp2:      dd 0                        ;* 20:ESP2
.ss2:       dd 0                        ;* 24:
.cr3:       dd 0                        ;* 28:CR3(PDBR)
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

TSS_1:
.link:      dd 0                        ;   0: 前のタスクへのリンク
.esp0:      dd SP_TASK_1 - 512          ;*  4:ESP0
.ss0:       dd DS_KERNEL                ;*  8:
.esp1:      dd 0                        ;* 12:ESP1
.ss1:       dd 0                        ;* 16:
.esp2:      dd 0                        ;* 20:ESP2
.ss2:       dd 0                        ;* 24:
.cr3:       dd 0                        ;* 28:CR3(PDBR)
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


; グローバルディスクリプタテーブル
GDT:        dq 0x0000000000000000       ; NULL
.cs_kernel: dq 0x00CF9A000000FFFF       ; CODE 4G
.ds_kernel: dq 0x00CF92000000FFFF       ; DATA 4G
.ldt:        dq 0x0000820000000000       ; LDTディスクリプタ
.tss_0:      dq 0x0000890000000067       ; TSSディスクリプタ
.tss_1:      dq 0x0000890000000067       ; TSSディスクリプタ
.end:

CS_KERNEL   equ .cs_kernel  - GDT
DS_KERNEL   equ .ds_kernel  - GDT
SS_LDT      equ .ldt        - GDT
SS_TASK_0   equ .tss_0      - GDT
SS_TASK_1   equ .tss_1      - GDT

GDTR:   dw GDT.end - GDT - 1
        dd GDT


; ローカルディスクリプタテーブル
LDT:        dq 0x0000000000000000       ; NULL
.cs_task_0: dq 0x00CF9A000000FFFF       ; CODE 4G
.ds_task_0: dq 0x00CF92000000FFFF       ; DATA 4G
.cs_task_1: dq 0x00CF9A000000FFFF       ; CODE 4G
.ds_task_1: dq 0x00CF92000000FFFF       ; DATA 4G
.end:

CS_TASK_0   equ (.cs_task_0 - LDT) | 4  ; タスク0用CSセレクタ
DS_TASK_0   equ (.ds_task_0 - LDT) | 4  ; タスク0用DSセレクタ
CS_TASK_1   equ (.cs_task_1 - LDT) | 4  ; タスク0用CSセレクタ
DS_TASK_1   equ (.ds_task_1 - LDT) | 4  ; タスク0用DSセレクタ

LDT_LIMIT   equ .end        - LDT - 1
