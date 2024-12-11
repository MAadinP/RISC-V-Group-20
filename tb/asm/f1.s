main:

    LI a0, 0x00                 # Initialize LED state (all off)
    LI t0, 0xFF                 # Value when all LEDs are on (8 LEDs)

loop:

    JAL ra, delay               # Delay before updating state
    BEQ a0, t0, reset           # If all LEDs are on, reset to 0

    # Update LED state (shift left and add 1 to turn on next LED)
    SLL a0, a0, 1              
    ADDI a0, a0, 1              
    J loop                      # Repeat the loop

reset:
    LI a0, 0x00                 # Reset all LEDs 
    J loop                      # Restart the sequence


delay:
    LI t2, 10                   # Adjust delay here

delay_loop:
    ADDI t2, t2, -1             # Decrement counter
    BNEZ t2, delay_loop         # Loop until counter reaches 0
    RET                         # Return to main program
