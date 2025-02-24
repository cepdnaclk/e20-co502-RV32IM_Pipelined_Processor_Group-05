# Test J-type instructions (jal)
jal x1, 12       # Jump forward 12 bytes (3 instructions) and store return address in x1
jal x0, 1024     # Jump forward 1024 bytes (unconditional jump with no return address saved)
jal x2, -8       # Jump backward 8 bytes
jal x3, 0        # Jump to current address (infinite loop)
jal x4, 2048     # Jump with large positive offset
jal x5, -2048    # Jump with large negative offset
jal x6, 0x7ff    # Jump with maximum positive offset in hex
jal x7, -0x800   # Jump with maximum negative offset in hex