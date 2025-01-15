`timescale 1ns/100ps

`include "cpu.v"

module CPU_tb();
    reg [31:0] PC;
    reg [31:0] INSTRUCTION;
    reg CLK, RESET;
    reg [31:0] READ_DATA;
    wire MEM_READ, MEM_WRITE;
    wire [31:0] MEM_WRITE_DATA, MEM_ADDRESS;

    // Instantiate the CPU module
    CPU cpu(PC, INSTRUCTION, CLK, RESET, READ_DATA, MEM_READ, MEM_WRITE, MEM_WRITE_DATA, MEM_ADDRESS);

    // Clock generation
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK; // 10ns clock period
    end

    // Testbench logic
    initial begin
        // Initialize inputs
        PC = 0;
        RESET = 1;
        READ_DATA = 0;

        // Apply reset
        #10 RESET = 0;

        // Test Case 1: ADD instruction (R-type)
        INSTRUCTION = 32'b0000000_00010_00001_000_00011_0110011; // ADD x3, x1, x2
        #10;

        // Test Case 2: OR instruction (R-type)
        INSTRUCTION = 32'b0000000_00100_00011_110_00101_0110011; // OR x5, x3, x4
        #10;

        // Test Case 3: AND instruction (R-type)
        INSTRUCTION = 32'b0000000_00110_00101_111_00111_0110011; // AND x7, x5, x6
        #10;

        // Test Case 4: XOR instruction (R-type)
        INSTRUCTION = 32'b0000000_01000_00111_100_01001_0110011; // XOR x9, x7, x8
        #10;

        // End simulation
        #50 $finish;
    end

endmodule