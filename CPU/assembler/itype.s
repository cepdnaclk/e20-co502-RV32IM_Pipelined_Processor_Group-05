# Memory and Load/Store Operations
sw x14, 5(x0)     # Store 14 (0x0000000E) to Memory[5]

# Load instructions will read same location but interpret differently
lb x5, 5(x0)      # x5 = 0x0000000E (byte with sign extension)
lh x6, 5(x0)      # x6 = 0x0000000E | Memory[6] (halfword with sign extension)
lw x7, 5(x0)      # x7 = 0x0000000E | Memory[6-8] (full word)
lbu x8, 5(x0)     # x8 = 0x0000000E (byte with zero extension)
lhu x9, 5(x0)     # x9 = 0x0000000E | Memory[6] (halfword with zero extension)

# Immediate ALU Instructions (x12=12, x14=14, x16=16, x18=18, x20=20, x22=22, x24=24, x26=26, x28=28)
addi x11, x12, 5   # x11 = 12 + 5 = 17 (0x11)
slli x13, x14, 2   # x13 = 14 << 2 = 56 (0x38)
slti x15, x16, 3   # x15 = (16 < 3) ? 1 : 0 = 0 (0x0)
sltiu x17, x18, 7  # x17 = (18 < 7) ? 1 : 0 = 0 (0x0)
xori x19, x20, 10  # x19 = 20 XOR 10 = 30 (0x1E)
srli x21, x22, 1   # x21 = 22 >> 1 = 11 (0xB)
srai x23, x24, 2   # x23 = 24 >> 2 = 6 (0x6)
ori x25, x26, 15   # x25 = 26 OR 15 = 31 (0x1F)
andi x27, x28, 255 # x27 = 28 AND 255 = 28 (0x1C)
