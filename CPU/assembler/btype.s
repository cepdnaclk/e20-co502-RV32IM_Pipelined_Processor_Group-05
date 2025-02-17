lui x1, 0x0       # Load upper immediate for x1 (set to 0)
addi x1, x1, 5    # Add immediate value 5 to x1 (x1 = 5)

lui x2, 0x0       # Load upper immediate for x2 (set to 0)
addi x2, x2, 5    # Add immediate value 5 to x2 (x2 = 5)

beq x1, x2, equal # Branch if x1 == x2 (they are equal)
nop               # No operation if not equal
j end             # Jump to end (bypass the equal label)

equal:
    nop               # Here if x1 == x2

end:
    nop               # End of the program