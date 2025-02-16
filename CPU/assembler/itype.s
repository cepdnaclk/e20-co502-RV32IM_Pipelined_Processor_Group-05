# Load Instructions
lb    x5, 0(x10)   # Load byte from memory address in x10 into x5 (sign-extended)
lh    x6, 4(x10)   # Load halfword from memory address in x10 + 4 into x6 (sign-extended)
lw    x7, 8(x10)   # Load word from memory address in x10 + 8 into x7
lbu   x8, 12(x10)  # Load byte from memory, zero-extended
lhu   x9, 16(x10)  # Load halfword from memory, zero-extended

# Immediate ALU Instructions
addi  x11, x12, 5   # x11 = x12 + 5
slli  x13, x14, 2   # x13 = x14 << 2 (logical shift left)
slti  x15, x16, 3   # x15 = (x16 < 3) ? 1 : 0
sltiu x17, x18, 7   # Unsigned version of slti
xori  x19, x20, 10  # x19 = x20 XOR 10
srli  x21, x22, 1   # x21 = x22 >> 1 (logical shift right)
srai  x23, x24, 2   # x23 = x24 >> 2 (arithmetic shift right)
ori   x25, x26, 15  # x25 = x26 OR 15
andi  x27, x28, 255 # x27 = x28 AND 255

# Jump Register Instruction
#jalr  x29, x30, 20  # Jump to x30 + 20, store return address in x29
