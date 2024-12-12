# File: test_lbu_lhu.s

.section .data
test_data:
    .byte 0x12, 0x34, 0x56, 0x78  # 4 bytes of test data
    .half 0xABCD                  # 2 bytes of test data

.section .text
.global _start

_start:
    la t0, test_data        # Load address of test_data into t0
    lbu t1, 0(t0)           # Load byte at t0 into t1 (0x12, zero-extended)
    lbu t2, 1(t0)           # Load byte at t0+1 into t2 (0x34, zero-extended)
    lhu t3, 4(t0)           # Load halfword at t0+4 into t3 (0xABCD, zero-extended)
    lbu t4, 6(t0)           # Load byte at t0+6 into t4 (out of range, should trap or 0)

    # Infinite loop to prevent program exit
loop:
    j loop
