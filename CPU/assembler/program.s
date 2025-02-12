# Basic Operations
addi x1, x0, 5      
addi x2, x0, 7      
add  x3, x1, x2     
sw   x3, 0(x0)      

# Arithmetic Operations
sub  x4, x1, x2     

# Logical Operations  
and  x8, x1, x2     
or   x9, x1, x2     
xor  x10, x1, x2    

# Shift Operations
slli x11, x1, 2     
srli x12, x2, 1     
srai x13, x2, 1     

# Compare Operations
slt  x14, x1, x2    
sltu x15, x1, x2    

# Memory Operations
lw  x16, 4(x0)     
lw  x17, 8(x0)     
lw  x18, 12(x0)    
sw  x19, 16(x0)    
sw  x20, 20(x0)    

# Branch Operations
# Using immediate offsets instead of labels
beq  x1, x2, 16     # Branch forward 4 instructions
bne  x1, x2, 12     # Branch forward 3 instructions
blt  x1, x2, 8      # Branch forward 2 instructions
bge  x1, x2, 4      # Branch forward 1 instruction

# Simple instructions after branch targets
addi x21, x0, 1     
addi x22, x0, 2     
addi x23, x0, 3     
addi x24, x0, 4     

# Jump Operations
# Using immediate offsets instead of labels
jal  x25, 8         # Jump forward 2 instructions
jalr x0, x25, 0     

# Function body
addi x26, x0, 10    
add  x27, x26, x1   
jalr x0, x1, 0      # Return using jalr instead of ret