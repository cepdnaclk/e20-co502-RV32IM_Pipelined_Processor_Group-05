// Test ADD instruction: 
add x6, x1, x2
INSTRUCTION = 32'b0000000_00010_00001_000_00110_0110011; // x6 = x1 + x2

// Test SUB instruction: 
sub x4, x6, x5
INSTRUCTION = 32'b0100000_00101_00110_000_00100_0110011; // x4 = x6 - x5