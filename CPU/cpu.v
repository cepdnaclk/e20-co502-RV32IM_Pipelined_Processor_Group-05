`include "ALU.v"
`include "controlUnit.v"
`include "immediate_extend.v"
`include "Register_file.v"

module CPU(
    input [31:0] PC;
    input [31:0] INSTRUCTION;
    input CLK,RESET;
    output MEM_READ,MEM_WRITE,MUX3_SELECT,REGWRITE_ENABLE;
    output [31:0] ALUOUT;
    output [31:0] DATA2;
    output [2:0] FUNC7;
    output [4:0] WRITEBACK_ADDRESS;
);

controlUnit cu(INSTRUCTION, MUX1_SELECT, MUX2_SELECT, MUX3_SELECT, ALUOP,REGWRITE_ENABLE, MEMWRITE, MEMREAD,BRANCH, JUMP, JAL, IMMEDIATE);

endmodule