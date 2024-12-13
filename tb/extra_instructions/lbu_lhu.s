# File: test_lbu_lhu.s

.section .data
test_data:
    .byte 0x12, 0x34, 0x56, 0x78  # 4 bytes of test data
    .half 0xABCD                  # 2 bytes of test data

.section .text
.global main

main:
    la t0, test_data        # Load address of test_data into t0

    lbu t1, 0(t0)           # Load byte at t0 into t1 (0x12, zero-extended)
    lbu t2, 1(t0)           # Load byte at t0+1 into t2 (0x34, zero-extended)
    lhu t3, 4(t0)           # Load halfword at t0+4 into t3 (0xABCD, zero-extended)

    # Combine results into a0 for testing
    add t4, t1, t2          # t4 = t1 + t2 (0x12 + 0x34 = 0x46)
    add a0, t4, t3          # a0 = t4 + t3 (0x46 + 0xABCD = 0xAC13)

finish:
    bne a0, zero, finish    # Loop forever with the result in a0