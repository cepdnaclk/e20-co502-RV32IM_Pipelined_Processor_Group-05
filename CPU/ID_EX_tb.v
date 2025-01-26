`timescale 1ns/100ps
`include "ID_EX.v"

module ID_EX_tb;
    // Inputs
    reg CLK;
    reg RESET;
    reg BUSYWAIT;
    reg [31:0] PC_PLUS_FOUR_IN, PC_IN, IMM_IN, DATA1_IN, DATA2_IN;
    reg [2:0] FUNC3_IN;
    reg [4:0] RD_IN, ALU_IN;
    reg MUX1_IN, MUX2_IN, MUX3_IN, REGWRITE_IN, MEMWRITE_IN, MEMREAD_IN, BRANCH_IN, JUMP_IN, JAL_IN, TWOSCOMP_IN;

    // Outputs
    wire [31:0] PC_PLUS_FOUR_OUT, PC_OUT, IMM_OUT, DATA1_OUT, DATA2_OUT;
    wire [2:0] FUNC3_OUT;
    wire [4:0] RD_OUT, ALU_OUT;
    wire MUX1_OUT, MUX2_OUT, MUX3_OUT, REGWRITE_OUT, MEMWRITE_OUT, MEMREAD_OUT, BRANCH_OUT, JUMP_OUT, JAL_OUT, TWOSCOMP_OUT;

    // Instantiate the DUT (Device Under Test)
    ID_EX uut (
        .CLK(CLK),
        .RESET(RESET),
        .BUSYWAIT(BUSYWAIT),
        .PC_PLUS_FOUR_IN(PC_PLUS_FOUR_IN),
        .PC_IN(PC_IN),
        .IMM_IN(IMM_IN),
        .DATA1_IN(DATA1_IN),
        .DATA2_IN(DATA2_IN),
        .FUNC3_IN(FUNC3_IN),
        .RD_IN(RD_IN),
        .ALU_IN(ALU_IN),
        .MUX1_IN(MUX1_IN),
        .MUX2_IN(MUX2_IN),
        .MUX3_IN(MUX3_IN),
        .REGWRITE_IN(REGWRITE_IN),
        .MEMWRITE_IN(MEMWRITE_IN),
        .MEMREAD_IN(MEMREAD_IN),
        .BRANCH_IN(BRANCH_IN),
        .JUMP_IN(JUMP_IN),
        .JAL_IN(JAL_IN),
        .TWOSCOMP_IN(TWOSCOMP_IN),
        .PC_PLUS_FOUR_OUT(PC_PLUS_FOUR_OUT),
        .PC_OUT(PC_OUT),
        .IMM_OUT(IMM_OUT),
        .DATA1_OUT(DATA1_OUT),
        .DATA2_OUT(DATA2_OUT),
        .FUNC3_OUT(FUNC3_OUT),
        .RD_OUT(RD_OUT),
        .ALU_OUT(ALU_OUT),
        .MUX1_OUT(MUX1_OUT),
        .MUX2_OUT(MUX2_OUT),
        .MUX3_OUT(MUX3_OUT),
        .REGWRITE_OUT(REGWRITE_OUT),
        .MEMWRITE_OUT(MEMWRITE_OUT),
        .MEMREAD_OUT(MEMREAD_OUT),
        .BRANCH_OUT(BRANCH_OUT),
        .JUMP_OUT(JUMP_OUT),
        .JAL_OUT(JAL_OUT),
        .TWOSCOMP_OUT(TWOSCOMP_OUT)
    );

    // Clock generation
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;  // 10 ns clock period
    end

    // Test stimulus
    initial begin
        // Initialize inputs
        RESET = 1;
        BUSYWAIT = 0;
        PC_PLUS_FOUR_IN = 32'h00000000;
        PC_IN = 32'h00000000;
        IMM_IN = 32'h00000000;
        DATA1_IN = 32'h00000000;
        DATA2_IN = 32'h00000000;
        FUNC3_IN = 3'b000;
        RD_IN = 5'b00000;
        ALU_IN = 5'b00000;
        MUX1_IN = 0;
        MUX2_IN = 0;
        MUX3_IN = 0;
        REGWRITE_IN = 0;
        MEMWRITE_IN = 0;
        MEMREAD_IN = 0;
        BRANCH_IN = 0;
        JUMP_IN = 0;
        JAL_IN = 0;
        TWOSCOMP_IN = 0;

        // Apply reset
        #15 RESET = 0;

        // Test case 1: Load inputs
        #10;
        PC_PLUS_FOUR_IN = 32'h00000004;
        PC_IN = 32'h00000008;
        IMM_IN = 32'h00000010;
        DATA1_IN = 32'h12345678;
        DATA2_IN = 32'h87654321;
        FUNC3_IN = 3'b101;
        RD_IN = 5'b00011;
        ALU_IN = 5'b00100;
        MUX1_IN = 1;
        MUX2_IN = 0;
        MUX3_IN = 1;
        REGWRITE_IN = 1;
        MEMWRITE_IN = 1;
        MEMREAD_IN = 0;
        BRANCH_IN = 0;
        JUMP_IN = 0;
        JAL_IN = 1;
        TWOSCOMP_IN = 0;

        // Wait and observe outputs
        #10;
        $display("Test Case 1: PC_PLUS_FOUR_OUT = %h, PC_OUT = %h, IMM_OUT = %h", PC_PLUS_FOUR_OUT, PC_OUT, IMM_OUT);
        $display("DATA1_OUT = %h, DATA2_OUT = %h, FUNC3_OUT = %b", DATA1_OUT, DATA2_OUT, FUNC3_OUT);
        $display("MUX1_OUT = %b, MUX2_OUT = %b, MUX3_OUT = %b", MUX1_OUT, MUX2_OUT, MUX3_OUT);
        $display("REGWRITE_OUT = %b, MEMWRITE_OUT = %b, MEMREAD_OUT = %b", REGWRITE_OUT, MEMWRITE_OUT, MEMREAD_OUT);
        $display("BRANCH_OUT = %b, JUMP_OUT = %b, JAL_OUT = %b", BRANCH_OUT, JUMP_OUT, JAL_OUT);

        // Test case 2: Modify inputs
        #10;
        IMM_IN = 32'hABCDE123;
        RD_IN = 5'b11111;
        MEMWRITE_IN = 0;
        JUMP_IN = 1;

        // Wait and observe outputs
        #10;
        $display("Test Case 2: PC_PLUS_FOUR_OUT = %h, IMM_OUT = %h, RD_OUT = %b", PC_PLUS_FOUR_OUT, IMM_OUT, RD_OUT);
        $display("MEMWRITE_OUT = %b, JUMP_OUT = %b", MEMWRITE_OUT, JUMP_OUT);

        // Finish simulation
        #20;
        $finish;
    end
endmodule
