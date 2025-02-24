addi x1, x0, 10      # x1 = 10
addi x2, x0, 20      # x2 = 20
addi x3, x0, 10      # x3 = 10
addi x4, x0, 0       # x4 = 0 (To store result)
beq x1, x3, 8
addi x5, x0, 20  # This should be skipped if branch works
addi x6, x0, 30  # Confirm branch was taken
