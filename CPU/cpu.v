`timescale 1ns/100ps

`include "ALU.v"
`include "controlUnit.v"
`include "immediate_extend.v"
`include "Register_file.v"
`include "EX_MEM.v"
`include "ID_EX.v"
`include "IF_ID.v"
`include "MEM_WB.v"
`include "mux_2x1_32bit.v"
`include "mux_4x1_32bit.v"
`include "adder_32bit.v"
`include "Twos_complement.v"

module CPU(PC,INSTRUCTION,CLK,RESET,READ_DATA,MEM_READ,MEM_WRITE,MEM_WRITE_DATA,MEM_ADDRESS);
    input [31:0] PC;
    input [31:0] INSTRUCTION;
    input CLK,RESET;
    input [31:0] READ_DATA;
    output MEM_READ,MEM_WRITE;
    output [31:0] MEM_WRITE_DATA;
    output [31:0] MEM_ADDRESS;

    wire [31:0] PC_PLUS_FOUR;
    adder_32bit adder(PC,PC_PLUS_FOUR);
    
    //BUSYWAIT IS A OUTPUT OF DATA MEMORY MODULE
    wire BUSYWAIT;
    wire [31:0] PC_PLUS_FOUR_OUT,PC_OUT,INSTRUCTION_OUT;
    IF_ID IF_IDREG(CLK,RESET,BUSYWAIT,PC_PLUS_FOUR,PC,INSTRUCTION,PC_PLUS_FOUR_OUT,PC_OUT,INSTRUCTION_OUT);
    
    wire MUX1_SELECT,MUX2_SELECT,MUX3_SELECT,REGWRITE_ENABLE, MEMWRITE, MEMREAD,BRANCH, JUMP, JAL;
    wire [4:0] ALUOP;
    wire [2:0] IMMEDIATE;
    controlUnit cu(INSTRUCTION_OUT, MUX1_SELECT, MUX2_SELECT, MUX3_SELECT, ALUOP,REGWRITE_ENABLE, MEMWRITE, MEMREAD,BRANCH, JUMP, JAL, IMMEDIATE);

    wire [4:0] WB_ADDRESS;  // output of MEM_WB module
    wire WRITE_ENABLE;  // output of MEM_WB module
    wire [31:0] WRITE_DATA;  // output of MEM_WB module
    wire [31:0] DATA1,DATA2; 
    Register_file regfile(INSTRUCTION_OUT[19:15],INSTRUCTION_OUT[24:20],WB_ADDRESS,WRITE_ENABLE,WRITE_DATA,CLK,RESET,DATA1,DATA2);
    
    wire [31:0] extended_imm_value;
    immediate_extend immex(INSTRUCTION_OUT,extended_imm_value,IMMEDIATE);
    
    wire [31:0] PC_PLUS_FOUR_OUT2,PC_OUT2,extended_imm_value_out;
    wire [4:0] ALUOP_OUT;
    wire MUX1_SELECT_OUT,MUX2_SELECT_OUT,MUX3_SELECT_OUT,REGWRITE_ENABLE_OUT, MEMWRITE_OUT, MEMREAD_OUT,BRANCH_OUT, JUMP_OUT, JAL_OUT;
    wire [31:0] DATA1_OUT,DATA2_OUT;
    wire [2:0] FUNC3_OUT;
    wire [4:0] RD_OUT;
    ID_EX ID_EXREG(CLK,RESET,BUSYWAIT,PC_PLUS_FOUR_OUT,PC_OUT,extended_imm_value,DATA1,DATA2,INSTRUCTION_OUT[14:12],INSTRUCTION_OUT[11:7],ALUOP,MUX1_SELECT,MUX2_SELECT,MUX3_SELECT,REGWRITE_ENABLE,MEMWRITE,MEMREAD,BRANCH,JUMP,JAL,
                   PC_PLUS_FOUR_OUT2,PC_OUT2,extended_imm_value_out,ALUOP_OUT,MUX1_SELECT_OUT,MUX2_SELECT_OUT,MUX3_SELECT_OUT,REGWRITE_ENABLE_OUT,MEMWRITE_OUT,MEMREAD_OUT,BRANCH_OUT,JUMP_OUT,JAL_OUT,DATA1_OUT,DATA2_OUT,FUNC3_OUT,RD_OUT);
    
    
    
    mux_2x1_32bit mux1(PC_OUT2,DATA1_OUT,OUT1,MUX1_SELECT_OUT); // S type mux1=0, it get PC instead of rs1-base register value???
    
    mux_2x1_32bit mux2(extended_imm_value,DATA2_OUT,OUT2,MUX2_SELECT_OUT); 

    ALU alu(OUT1,OUT2,ALUOP_OUT,ALU_RESULT,ALU_ZERO);

    EX_MEM EX_MEMREG(CLK,RESET,BUSYWAIT,
        MEMWRITE_OUT,MEMREAD_OUT,MUX3_SELECT_OUT,REGWRITE_ENABLE_OUT,ALU_RESULT,DATA2_OUT,FUNC3_OUT,RD_OUT,
        MEMWRITE_OUT2,MEMREAD_OUT2,MUX3_SELECT_OUT2,REGWRITE_ENABLE_OUT2,ALU_RESULT2,DATA2_OUT2,FUNC3_OUT2,RD_OUT2);

    
endmodule