# Test U-type instructions (lui and auipc)
lui x1, 0x12345  # Load upper immediate, loads 0x12345000 into x1
lui x2, 0xFFFFF  # Maximum value
lui x3, 0x00000  # Minimum value
lui x4, 0x7FFFF  # Load a positive value
lui x5, 0x80000  # Load a negative value

auipc x6, 0x12345  # Add upper immediate to PC
auipc x7, 0x00000  # Add zero to PC
auipc x8, 0xFFFFF  # Add maximum value to PC

# Test with decimal values
lui x9, 1048575   # Maximum decimal value (0xFFFFF)
lui x10, 0        # Zero
lui x11, 74565    # Random decimal value (0x12345)