module controlUnit(INSTRUCTION, MUX1, MUX2, MUX3, ALUOP,REGISTERWRITE, MEMORYWRITE, MEMORYREAD, BRANCH, JUMP, JAL, IMMEDIATE);
    input [31:0] INSTRUCTION;
    reg [7:0] OPCODE;
    reg [2:0] FUNCT3;
    reg [6:0] FUNCT7;

    output reg MUX1, MUX2 , MUX3, REGISTERWRITE, MEMORYWRITE, MEMORYREAD, BRANCH, JUMP, JAL;
    output reg  [4:0] ALUOP;
    output reg [2:0] IMMEDIATE;
    
/*
*********** Instruction set ***************

Immidiate values

INstruction     IMM
R-type          000
U-type          000
I-type          001
I-type shift    010
S-type          011
B-type          100
J-type          101


R-type instructions

    Instruction  OP-Code   Funct3  Funct7     ALUOP  MUX1  MUX2  MUX3 REGISTERWRITE MEMORYWRITE MEMORYREAD BRANCH  JUMP JAL  IMM
    add          0110011   000     0000000    00000    1     1     0    1             0           0          0      0    0   000
    sub          0110011   000     0100000    00000    1     1     0    1             0           0          0      0    0   000
    sll          0110011   001     0000000    00001    1     1     0    1             0           0          0      0    0   000
    slt          0110011   010     0000000    00010    1     1     0    1             0           0          0      0    0   000
    sltu         0110011   011     0000000    00011    1     1     0    1             0           0          0      0    0   000
    xor          0110011   100     0000000    00100    1     1     0    1             0           0          0      0    0   000
    srl          0110011   101     0000000    00101    1     1     0    1             0           0          0      0    0   000
    sra          0110011   101     0100000    00101    1     1     0    1             0           0          0      0    0   000
    or           0110011   110     0000000    00110    1     1     0    1             0           0          0      0    0   000
    and          0110011   111     0000000    00111    1     1     0    1             0           0          0      0    0   000
    mul          0110011   000     0111011    01000    1     1     0    1             0           0          0      0    0   000
    mulh         0110011   001     0111011    01001    1     1     0    1             0           0          0      0    0   000
    mulhsu       0110011   010     0111011    01010    1     1     0    1             0           0          0      0    0   000
    mulhu        0110011   011     0111011    01011    1     1     0    1             0           0          0      0    0   000
    div          0110011   100     0111011    01100    1     1     0    1             0           0          0      0    0   000
    rem          0110011   110     0111011    01101    1     1     0    1             0           0          0      0    0   000
    remu         0110011   111     0111011    01111    1     1     0    1             0           0          0      0    0   000

I-type instructions

    Instruction  OP-Code   Funct3  Funct7     ALUOP  MUX1  MUX2  MUX3 REGISTERWRITE MEMORYWRITE MEMORYREAD BRANCH  JUMP JAL  IMM
    lb           0000011   000     0000000    10000    1     1     1    1             0           1          0      0    0   001
    lh           0000011   001     0000000    10000    1     1     1    1             0           1          0      0    0   001
    lw           0000011   010     0000000    10000    1     1     1    1             0           1          0      0    0   001
    lbu          0000011   100     0000000    10000    1     1     1    1             0           1          0      0    0   001
    lhu          0000011   101     0000000    10000    1     1     1    1             0           1          0      0    0   001
    
    addi         0010011   000     0000000    00000    1     0     0    1             0           0          0      0    0   001
    slli         0010011   001     0000000    00001    1     0     0    1             0           0          0      0    0   010
    slti         0010011   010     0000000    00010    1     0     0    1             0           0          0      0    0   010
    sltiu        0010011   011     0000000    00011    1     0     0    1             0           0          0      0    0   010
    xori         0010011   100     0000000    00100    1     0     0    1             0           0          0      0    0   001
    srli         0010011   101     0000000    00101    1     0     0    1             0           0          0      0    0   010
    srai         0010011   101     0000000    00101    1     0     0    1             0           0          0      0    0   010
    ori          0010011   110     0000000    00110    1     0     0    1             0           0          0      0    0   001
    andi         0010011   111     0000000    00111    1     0     0    1             0           0          0      0    0   001

    jalr         1100111   000     0000000    00000    0     0     0    1             0           0          0      0    0   001

S-type instructions

    Instruction  OP-Code   Funct3  Funct7     ALUOP  MUX1  MUX2  MUX3 REGISTERWRITE MEMORYWRITE MEMORYREAD BRANCH  JUMP JAL  IMM
    sb           0100011   000     0000000    00000    0     1     1    0             1           0          0      0    0   011
    sh           0100011   001     0000000    00000    0     1     1    0             1           0          0      0    0   011
    sw           0100011   010     0000000    00000    0     1     1    0             1           0          0      0    0   011
    sbu          0100011   100     0000000    00000    0     1     1    0             1           0          0      0    0   011
    shu          0100011   101     0000000    00000    0     1     1    0             1           0          0      0    0   011

U-type instructions

    Instruction  OP-Code   Funct3  Funct7     ALUOP  MUX1  MUX2  MUX3 REGISTERWRITE MEMORYWRITE MEMORYREAD BRANCH  JUMP JAL  IMM
    auipc        0010111   000     0000000    00000    0     0     0    1             0           0          0      0    0   000
    lui          0110111   000     0000000    00000    0     0     0    1             0           0          0      0    0   000

B-type instructions

    Instruction  OP-Code   Funct3  Funct7     ALUOP  MUX1  MUX2  MUX3 REGISTERWRITE MEMORYWRITE MEMORYREAD BRANCH  JUMP JAL  IMM
    beq          1100011   000     0000000    00000    0     0     0    0             0           0          1      1    0   100
    bne          1100011   001     0000000    00000    0     0     0    0             0           0          1      1    0   100
    blt          1100011   100     0000000    00000    0     0     0    0             0           0          1      1    0   100
    bge          1100011   101     0000000    00000    0     0     0    0             0           0          1      1    0   100
    bltu         1100011   110     0000000    00000    0     0     0    0             0           0          1      1    0   100
    bgeu         1100011   111     0000000    00000    0     0     0    0             0           0          1      1    0   100

J-type instructions

    Instruction  OP-Code   Funct3  Funct7     ALUOP  MUX1  MUX2  MUX3 REGISTERWRITE MEMORYWRITE MEMORYREAD BRANCH  JUMP JAL  IMM
    jal          1101111   000     0000000    00000    0     0     0    1             0           0          0      0    1   101

*/

always @(INSTRUCTION) //Decoding the instruction 
    begin
        OPCODE = INSTRUCTION[6:0];
        FUNCT3 = INSTRUCTION[14:12];
        FUNCT7 = INSTRUCTION[31:25];
        
        // Add decoding logic here based on OPCODE, FUNCT3, and FUNCT7
    end

endmodule