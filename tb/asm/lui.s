# File: test_lui.s

.section .text
.global _start

_start:
    lui t0, 0xFFFFF     # t0 = 0xFFFFF000
    lui t1, 0x1         # t1 = 0x00001000
    lui t2, 0x0         # t2 = 0x00000000

    # Infinite loop to prevent program exit
loop:
    j loop
