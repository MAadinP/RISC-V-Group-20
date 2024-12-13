main:

    LI a0, 0x00                 # Initialize LED state (all off)
    LI t0, 0xFF                 # Value when all LEDs are on (8 LEDs)
    LI t3, 0x1234               # Initialize seed for random delay

loop:

    JAL ra, delay               # Delay before updating state
    BEQ a0, t0, random_delay    # If all LEDs are on, introduce random delay

    # Update LED state (shift left and add 1 to turn on next LED)
    SLL a0, a0, 1              
    ADDI a0, a0, 1              
    J loop                      # Repeat the loop

random_delay:

    # Generate random value
    XORI t3, t3, 0x05           # XOR seed with a constant
    SRLI t3, t3, 1              # Shift right to mix bits
    ANDI t3, t3, 0x1F           # Limit delay to a maximum of 31 cycles
    ADDI t2, t3, 10             # Ensure a minimum delay of 10 cycles

random_delay_loop:
    ADDI t2, t2, -1             # Decrement counter
    BNEZ t2, random_delay_loop  # Loop until counter reaches 0

    J reset                     # Proceed to reset the LEDs

reset:
    LI a0, 0x00                 # Reset all LEDs 
    J loop                      # Restart the sequence

delay:
    LI t2, 10                   # Base delay

delay_loop:
    ADDI t2, t2, -1             # Decrement counter
    BNEZ t2, delay_loop         # Loop until counter reaches 0
    RET                         # Return to main program
