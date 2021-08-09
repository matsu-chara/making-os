trap_gate_81:
    cdecl draw_char, ecx, edx, ebx, eax
    iret

trap_gate_82:
    cdecl draw_pixel, ecx, edx, ebx
    iret
