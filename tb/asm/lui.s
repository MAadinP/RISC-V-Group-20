.section .text
.global _start

_start:
    lui t0, 0xFFFFF     # t0 = 0xFFFFF000
    lui t1, 0x1         # t1 = 0x00001000
    lui t2, 0x0         # t2 = 0x00000000

    # Combine the results for inspection
    add t3, t0, t1      # t3 = t0 + t1 = 0xFFFFF000 + 0x00001000 = 0x00000000 (overflow in 32-bit register)
    or t4, t3, t2       # t4 = t3 | t2 = t3 (t2 is 0)

    # Move final result to a0 for output
    mv a0, t4           # a0 = t4

    # Infinite loop to prevent program exit
loop:
    j loop