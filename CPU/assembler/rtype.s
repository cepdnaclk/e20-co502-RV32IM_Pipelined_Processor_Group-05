# R-type instructions
add  x5, x6, x7    # x5 = x6 + x7
sub  x8, x9, x10   # x8 = x9 - x10
sll  x11, x12, x13 # x11 = x12 << x13
slt  x14, x15, x16 # x14 = (x15 < x16) ? 1 : 0
sltu x17, x18, x19 # Unsigned version of slt
xor  x20, x21, x22 # x20 = x21 XOR x22
srl  x23, x24, x25 # x23 = x24 >> x25 (Logical)
sra  x26, x27, x28 # x26 = x27 >> x28 (Arithmetic)
or   x29, x30, x31 # x29 = x30 OR x31
and  x1, x2, x3    # x1 = x2 AND x3

# Multiply and Divide (RV32M extension)
mul   x4, x5, x6   # x4 = x5 * x6
mulh  x7, x8, x9   # High bits of signed x8 * x9
mulhsu x10, x11, x12 # High bits of signed x11 * unsigned x12
mulhu x13, x14, x15 # High bits of unsigned x14 * x15
div   x16, x17, x18 # x16 = x17 / x18 (signed)
rem   x19, x20, x21 # x19 = x20 % x21 (signed)
remu  x22, x23, x24 # x22 = x23 % x24 (unsigned)