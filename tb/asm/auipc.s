# File: test_auipc.s

.section .text
.global _start

_start:
    auipc t0, 0x1       # t0 = PC + (0x1 << 12)
    auipc t1, 0x0       # t1 = PC + (0x0 << 12), should be equal to PC
    addi t2, t0, 0      # t2 = t0 (debug register to inspect t0 value)

    # Infinite loop to prevent program exit
loop:
    j loop
