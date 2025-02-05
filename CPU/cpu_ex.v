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
`include "adder_32bit.v"
`include "Twos_complement.v"
`include "PC.v"

module CPU(
    input CLK, RESET,
    input [31:0] INSTRUCTION,
    input [31:0] READ_DATA,  // Data from Data Memory
    output MEM_READ, MEM_WRITE,
    output [31:0] MEM_WRITE_DATA, MEM_ADDRESS
);

    // Program Counter wires
    wire [31:0] PC;               // Current program counter value
    wire [31:0] branch_address;   // Branch address for branching
    wire branch_enable;           // Control signal for branching

    // Instantiate the program counter module
    program_counter pc_module(
        .clock(CLK),
        .reset(RESET),
        .branch_address(branch_address),
        .branch_enable(branch_enable),
        .pc(PC)
    );

    // Wires between IF/ID and ID/EX
    wire [31:0] PC_PLUS_FOUR_OUT, PC_OUT, INSTRUCTION_OUT;
    wire BUSYWAIT;

    // Control Unit Wires
    wire MUX1_SELECT, MUX2_SELECT, MUX3_SELECT, REGWRITE_ENABLE, MEMWRITE, MEMREAD, BRANCH, JUMP, JAL;
    wire [4:0] ALUOP;
    wire [2:0] IMMEDIATE;

    // Add the adder for PC + 4
    assign branch_address = PC + 4;

    // Instantiate the control unit
    controlUnit cu(
        .INSTRUCTION(INSTRUCTION),
        .MUX1(MUX1_SELECT),
        .MUX2(MUX2_SELECT),
        .MUX3(MUX3_SELECT),
        .ALUOP(ALUOP),
        .REGISTERWRITE(REGWRITE_ENABLE),
        .MEMORYWRITE(MEMWRITE),
        .MEMORYREAD(MEMREAD),
        .BRANCH(BRANCH),
        .JUMP(JUMP),
        .JAL(JAL),
        .IMMEDIATE(IMMEDIATE)
    );

    // Register File and Immediate Extension
    wire [31:0] DATA1, DATA2, WRITE_DATA;
    wire [31:0] extended_imm_value;
    wire [4:0] WB_ADDRESS;

    Register_file regfile(
        .ADRS1(INSTRUCTION[19:15]),
        .ADRS2(INSTRUCTION[24:20]),
        .WB_ADDRESS(WB_ADDRESS),
        .WRITE_ENABLE(REGWRITE_ENABLE),
        .WRITE_DATA(WRITE_DATA),
        .CLK(CLK),
        .RESET(RESET),
        .DATA_OUT1(DATA1),
        .DATA_OUT2(DATA2)
    );

    immediate_extend immex(
        .imm_value(INSTRUCTION),
        .extended_imm_value(extended_imm_value),
        .imm_select(IMMEDIATE)
    );

    // ALU and Branch Logic
    wire [31:0] ALU_RESULT;
    wire ALU_ZERO;

    ALU alu(
        .DATA1(DATA1),
        .DATA2(DATA2),
        .SELECT(ALUOP),
        .RESULT(ALU_RESULT),
        .ZERO(ALU_ZERO)
    );

    // Branch logic (determine branch enable)
    assign branch_enable = BRANCH & ALU_ZERO;

    // Memory Write and Read
    assign MEM_WRITE_DATA = DATA2;
    assign MEM_ADDRESS = ALU_RESULT;
    assign MEM_READ = MEMREAD;
    assign MEM_WRITE = MEMWRITE;

endmodule
