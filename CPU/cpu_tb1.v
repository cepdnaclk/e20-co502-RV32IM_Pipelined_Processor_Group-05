`timescale 1ns/100ps
`include "CPU.v"

module CPU_tb;
    // Inputs to the CPU
    reg [31:0] PC;
    reg [31:0] INSTRUCTION;
    reg CLK, RESET;
    reg [31:0] READ_DATA;

    // Outputs from the CPU
    wire MEM_READ, MEM_WRITE;
    wire [31:0] MEM_WRITE_DATA;
    wire [31:0] MEM_ADDRESS;

    // Instantiate the CPU module
    CPU cpu(
        .PC(PC),
        .INSTRUCTION(INSTRUCTION),
        .CLK(CLK),
        .RESET(RESET),
        .READ_DATA(READ_DATA),
        .MEM_READ(MEM_READ),
        .MEM_WRITE(MEM_WRITE),
        .MEM_WRITE_DATA(MEM_WRITE_DATA),
        .MEM_ADDRESS(MEM_ADDRESS)
    );

    // Clock generation
    always #5 CLK = ~CLK;

    initial begin
        // Initialize inputs
        CLK = 0;
        RESET = 1;
        PC = 32'd0;
        INSTRUCTION = 32'b0;
        READ_DATA = 32'd0;

        // Apply reset
        #10 RESET = 0;

        // Test Case: R-Type Instruction
        // Format: funct7 (7 bits) | rs2 (5 bits) | rs1 (5 bits) | funct3 (3 bits) | rd (5 bits) | opcode (7 bits)
        // Example: ADD instruction (opcode = 0110011, funct3 = 000, funct7 = 0000000)
        PC = 32'd4;
        INSTRUCTION = 32'b0000000_00010_00001_000_00011_0110011; // ADD x3, x1, x2 (rd=x3, rs1=x1, rs2=x2, opcode=0110011)
        #20;

        // Test Case: Another R-Type Instruction
        // Example: SUB instruction (opcode = 0110011, funct3 = 000, funct7 = 0100000)
        PC = 32'd8;
        INSTRUCTION = 32'b0100000_00010_00001_000_00100_0110011; // SUB x4, x1, x2 (rd=x4, rs1=x1, rs2=x2, opcode=0110011)
        #20;

        // Stop simulation
        $finish;
    end

    // Monitor the inputs and outputs of the ID_EX module
    initial begin
        $monitor($time, " CLK=%b RESET=%b PC=%h INSTRUCTION=%h | ID_EX Outputs: PC_PLUS_FOUR_OUT=%h PC_OUT=%h IMM_OUT=%h DATA1_OUT=%h DATA2_OUT=%h FUNC3_OUT=%b RD_OUT=%h",
            CLK, RESET, PC, INSTRUCTION,
            cpu.ID_EXREG.PC_PLUS_FOUR_OUT,
            cpu.ID_EXREG.PC_OUT,
            cpu.ID_EXREG.IMM_OUT,
            cpu.ID_EXREG.DATA1_OUT,
            cpu.ID_EXREG.DATA2_OUT,
            cpu.ID_EXREG.FUNC3_OUT,
            cpu.ID_EXREG.RD_OUT
        );
    end
endmodule
