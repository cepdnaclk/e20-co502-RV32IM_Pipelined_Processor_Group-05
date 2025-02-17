# Initialize memory
lui x10, 0x54110       # x10 = 0x54110000
addi x10, x10, -3357   # x10 = 0x5410F2E3
sw x10, 5(x0)          # Store x10 at Memory[5]

# NOP for safety
addi x0, x0, 0         # NOP

# Test load byte instructions
lb x5, 5(x0)           # Sign-extended: 0xFFFFFFE3
lh x6, 5(x0)           # Sign-extended: 0xFFFFF2E3
lw x7, 5(x0)           # Full word: 0x5410F2E3
lbu x8, 5(x0)          # Zero-extended: 0x000000E3
lhu x9, 5(x0)          # Zero-extended: 0x0000F2E3

# Test arithmetic immediate instructions
addi x11, x12, 5       # x11 = x12 + 5
slli x13, x14, 2       # x13 = x14 << 2
slti x15, x16, 3       # x15 = (x16 < 3) ? 1 : 0
sltiu x17, x18, 7      # x17 = (x18 < 7) ? 1 : 0
xori x19, x20, 10      # x19 = x20 ^ 10
srli x21, x22, 1       # x21 = x22 >> 1 (logical)
srai x23, x24, 2       # x23 = x24 >> 2 (arithmetic)
ori x25, x26, 15       # x25 = x26 | 15
andi x27, x28, 255     # x27 = x28 & 255

# Test negative immediates
addi x29, x0, -50      # Test negative immediate
lw x30, -4(x10)        # Test negative offset

# Test maximum immediate values
addi x31, x0, 2047     # Test maximum positive immediate (2^11 - 1)
addi x1, x0, -2048     # Test maximum negative immediate (-2^11)

# Test immediate edge cases
slli x2, x3, 31        # Test maximum shift amount
srli x4, x5, 31        # Test maximum shift amount
srai x6, x7, 31        # Test maximum arithmetic shift

# Additional NOPs for safety
addi x0, x0, 0         # NOP
addi x0, x0, 0         # NOP