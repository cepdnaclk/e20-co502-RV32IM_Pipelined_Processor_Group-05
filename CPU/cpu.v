`timescale 1ns/100ps

`include "ALU.v"
`include "controlUnit.v"
`include "immediate_extend.v"
`include "Register_file.v"
`include "EX_MEM.v"
`include "ID_EX.v"
`include "IF_ID.v"
`include "MEM_WB.v"
`include "mux_4x1_32bit.v"
`include "Twos_complement.v"
`include "Data_memory.v"
`include "pc.v"
`include "Instruction_mem.v"
`include "branch_jump_control.v"
`include "Forwarding_Unit.v"

module CPU(input CLK,input RESET);
    input [31:0] PC;
    input [31:0] INSTRUCTION;
    input [31:0] READ_DATA;
    input BUSYWAIT;
    output wire MEM_READ,MEM_WRITE;
    output wire [31:0] MEM_WRITE_DATA;
    output reg [31:0] MEM_ADDRESS;

    wire [31:0] PC_PLUS_FOUR;
    //adder_32bit adder(PC,PC_PLUS_FOUR);

    wire branch_enable;
    wire [31:0] branch_address;

    //pc module is instantiated here
    program_counter pc(CLK,RESET,branch_address,branch_enable,PC,PC_PLUS_FOUR); 

    //instruction_memory module is instantiated here
    // Instruction memory instantiation
    instruction_memory i_mem(
        .clk(CLK),
        .reset(RESET),
        .pc(PC),
        .instruction(INSTRUCTION)
    );
    
    //BUSYWAIT IS A OUTPUT OF DATA MEMORY MODULE
    //wire BUSYWAIT;
    wire [31:0] PC_PLUS_FOUR_OUT,PC_OUT,INSTRUCTION_OUT;
    IF_ID IF_IDREG(CLK,RESET,BUSYWAIT,PC_PLUS_FOUR,PC,INSTRUCTION,PC_PLUS_FOUR_OUT,PC_OUT,INSTRUCTION_OUT,FLUSH);
    
    wire MUX1_SELECT,MUX2_SELECT,MUX3_SELECT,REGWRITE_ENABLE, MEMWRITE, MEMREAD,BRANCH, JUMP, JAL, TWOSCOMP;
    wire [4:0] ALUOP;
    wire [2:0] IMMEDIATE;
    controlUnit cu(INSTRUCTION_OUT, MUX1_SELECT, MUX2_SELECT, MUX3_SELECT, ALUOP,REGWRITE_ENABLE, MEMWRITE, MEMREAD,BRANCH, JUMP, JAL, IMMEDIATE,TWOSCOMP);

    wire [4:0] WB_ADDRESS;  // output of MEM_WB module
    wire WRITE_ENABLE;  // output of MEM_WB module 
    wire [31:0] WRITE_DATA;  // output of MEM_WB module
    wire [31:0] DATA1,DATA2; 
    wire [31:0] data1,data2;
    Register_file regfile(INSTRUCTION_OUT[19:15],INSTRUCTION_OUT[24:20],WB_ADDRESS,WRITE_ENABLE,WRITE_DATA,CLK,RESET,data1,data2);
    
    wire [31:0] extended_imm_value;
    immediate_extend immex(INSTRUCTION_OUT,extended_imm_value,IMMEDIATE);
    
    wire [31:0] PC_PLUS_FOUR_OUT2,PC_OUT2,extended_imm_value_out;
    wire [4:0] ALUOP_OUT;
    wire MUX1_SELECT_OUT,MUX2_SELECT_OUT,MUX3_SELECT_OUT,REGWRITE_ENABLE_OUT, MEMWRITE_OUT, MEMREAD_OUT,BRANCH_OUT, JUMP_OUT, JAL_OUT;
    wire [31:0] DATA1_OUT,DATA2_OUT;
    wire [2:0] FUNC3_OUT;
    wire [4:0] RD_OUT;
    ID_EX ID_EXREG(CLK,RESET,BUSYWAIT,PC_PLUS_FOUR_OUT,PC_OUT,extended_imm_value,DATA1,DATA2,INSTRUCTION_OUT[14:12],INSTRUCTION_OUT[11:7],ALUOP,MUX1_SELECT,MUX2_SELECT,MUX3_SELECT,REGWRITE_ENABLE,MEMWRITE,MEMREAD,BRANCH,JUMP,JAL,TWOSCOMP,
                   PC_PLUS_FOUR_OUT2,PC_OUT2,extended_imm_value_out,ALUOP_OUT,MUX1_SELECT_OUT,MUX2_SELECT_OUT,MUX3_SELECT_OUT,REGWRITE_ENABLE_OUT,MEMWRITE_OUT,MEMREAD_OUT,BRANCH_OUT,JUMP_OUT,JAL_OUT,TWOSCOMP_OUT,DATA1_OUT,DATA2_OUT,FUNC3_OUT,RD_OUT,FLUSH);
    
    
    wire [31:0] OUT1;
    mux_2x1_32bit mux1(PC_OUT2,DATA1_OUT,OUT1,MUX1_SELECT_OUT); // S type mux1=0, it get PC instead of rs1-base register value???
    
    wire [31:0] OUT2;
    mux_2x1_32bit mux2(extended_imm_value,DATA2_OUT,OUT2,MUX2_SELECT_OUT); 
    
    wire [31:0] OUT2_TWOSCOMP;
    twos_complement_selector twos_complement(OUT2,TWOSCOMP_OUT,OUT2_TWOSCOMP);

    wire [31:0] ALU_RESULT;
    wire ALU_ZERO;
    ALU alu(OUT1,OUT2_TWOSCOMP,ALUOP_OUT,ALU_RESULT,ALU_ZERO);

    wire FLUSH;
    branch_jump_control bjc(BRANCH_OUT,JUMP_OUT,ALU_ZERO,ALU_RESULT,FUNC3_OUT,PC_OUT2,extended_imm_value_out,branch_address,branch_enable,FLUSH);
    
    wire [31:0] JAL_RESULT;
    mux_2x1_32bit JAL_MUX(ALU_RESULT,PC_PLUS_FOUR_OUT2,JAL_RESULT,JAL_OUT);

    wire MUX3_SELECT_OUT2,REGWRITE_ENABLE_OUT2;
    wire [31:0] JAL_RESULT2,DATA2_OUT2;
    wire [2:0] FUNC3_OUT2;
    wire [4:0] RD_OUT2;
    //HERE MEM_WRITE,MEM_READ,MEM_WRITE_DATA,MEM_ADDRESS all are output of CPU module
    EX_MEM EX_MEMREG(CLK,RESET,BUSYWAIT,
        MEMWRITE_OUT,MEMREAD_OUT,MUX3_SELECT_OUT,REGWRITE_ENABLE_OUT,JAL_RESULT,DATA2_OUT,FUNC3_OUT,RD_OUT,
        MEM_WRITE,MEM_READ,MUX3_SELECT_OUT2,REGWRITE_ENABLE_OUT2,JAL_RESULT2,MEM_WRITE_DATA,FUNC3_OUT2,RD_OUT2);


     // Data memory is now internal to CPU
    Data_Memory data_mem(
        .Read(MEM_READ),
        .Write(MEM_WRITE),
        .Clock(CLK),
        .Reset(RESET),
        .Address(JAL_RESULT2),
        .Write_data(MEM_WRITE_DATA),
        .Func3(FUNC3_OUT2),
        .Read_data(READ_DATA),
        .busywait(BUSYWAIT)
    );
    
    always @(*) begin
        MEM_ADDRESS = JAL_RESULT2; 
    end
    
    wire MUX3_SELECT_OUT3;
    wire [31:0] JAL_RESULT3;
    wire [31:0] READ_DATA_OUT;

    //here write_enable,rd_out3 is input to register file module
    MEM_WB MEM_WBREG(CLK,RESET,BUSYWAIT,
        MUX3_SELECT_OUT2,REGWRITE_ENABLE_OUT2,JAL_RESULT2,READ_DATA,RD_OUT2,
        MUX3_SELECT_OUT3,WRITE_ENABLE,JAL_RESULT3,READ_DATA_OUT,WB_ADDRESS); //added WB_ADDRESS as output of MEM_WB module instead of RD_OUT3 (Bhagya)
    
    mux_2x1_32bit MUX3(JAL_RESULT3,READ_DATA_OUT,WRITE_DATA,MUX3_SELECT_OUT3);

    Forwarding_Unit FU(INSTRUCTION_OUT[19:15],INSTRUCTION_OUT[24:20],data1,data2,RD_OUT,RD_OUT2,JAL_RESULT,JAL_RESULT2,DATA1,DATA2);
endmodule