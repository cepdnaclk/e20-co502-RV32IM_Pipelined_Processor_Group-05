# Test store halfword (sh) instructions
sh x5, 16(x0)   # Store lower 16 bits of 5 at memory[16]
sh x6, 18(x0)   # Store lower 16 bits of 6 at memory[18]
sh x7, 20(x0)   # Store lower 16 bits of 7 at memory[20]
sh x8, 22(x0)   # Store lower 16 bits of 8 at memory[22]

# Test store byte (sb) instructions
sb x9, 24(x0)   # Store lowest byte of 9 at memory[24]
sb x10, 25(x0)  # Store lowest byte of 10 at memory[25]
sb x11, 26(x0)  # Store lowest byte of 11 at memory[26]
sb x12, 27(x0)  # Store lowest byte of 12 at memory[27]

# Test with offset from non-zero base register
addi x20, x0, 100    # Set base address to 100
sw x13, 4(x20)      # Store 13 at memory[104]
sh x14, 8(x20)      # Store 14 at memory[108]
sb x15, 12(x20)     # Store 15 at memory[112]

# Test negative offsets
sw x16, -4(x20)     # Store 16 at memory[96]
sh x17, -8(x20)     # Store 17 at memory[92]
sb x18, -12(x20)    # Store 18 at memory[88]

# Test maximum positive offset
sw x19, 2047(x0)    # Store 19 at memory[2047]

# Test maximum negative offset
sw x21, -2048(x20)  # Store 21 at memory[-2048+100]

# NOP for safety
addi x0, x0, 0