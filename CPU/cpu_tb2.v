`timescale 1ns/100ps
`include "CPU.v"

module CPU_tb;
    reg CLK, RESET;
    reg BUSYWAIT;
    reg [31:0] PC, INSTRUCTION, READ_DATA;
    wire MEM_READ, MEM_WRITE;
    wire [31:0] MEM_WRITE_DATA, MEM_ADDRESS;

    // Instantiate the CPU module
    CPU cpu(PC, INSTRUCTION, CLK, RESET, READ_DATA, BUSYWAIT,MEM_READ, MEM_WRITE, MEM_WRITE_DATA, MEM_ADDRESS);

    // Clock generation
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK; // 10ns clock period
    end

    // Test case
    initial begin

        // Dump waveform for analysis
        $dumpfile("cpu_tb.vcd");
        $dumpvars(0, CPU_tb);

        // Initialize signals
        RESET = 1;
        PC = 32'h00000000;
        INSTRUCTION = 32'h00000000;
        READ_DATA = 32'h00000000;
        BUSYWAIT = 0;
        
        // Reset the CPU
        #10 RESET = 0;

        // Test ADD instruction: add x1, x2, x3 (Assume opcode and format are correct)
        #10 PC = 32'h00000004; INSTRUCTION = 32'b0000000_00011_00010_000_00001_0110011; // x1 = x2 + x3
        // #20 READ_DATA = 32'h0000000A; // Sample read data

        // Test SUB instruction: sub x1, x12, x5
        #10 PC = 32'h00000008; INSTRUCTION = 32'b0100000_00101_01100_000_00001_0110011; // x1 = x12 - x5

        // Test OR instruction: or x4, x5, x6
        #10 PC = 32'h0000000C; INSTRUCTION = 32'b0000000_00110_00101_110_00100_0110011; // x4 = x5 | x6

        // Test AND instruction: and x7, x8, x9
        #10 PC = 32'h00000010; INSTRUCTION = 32'b0000000_01001_01000_111_00111_0110011; // x7 = x8 & x9

        // Test XOR instruction: xor x10, x11, x12
        #10 PC = 32'h00000014; INSTRUCTION = 32'b0000000_01100_01011_100_01010_0110011; // x10 = x11 ^ x12

        // Test addi instruction: addi x13, x14, 0x000A
        #10 PC = 32'h00000018; INSTRUCTION = 32'b0000000_1010_01110_000_01101_0010011; // x13 = x14 + 0x000A

        // Test SW instruction: sw x8, 12(x9)
        #10 PC = 32'h00000020; INSTRUCTION = 32'b0000000_01001_01000_010_01100_0100011; // memory[x9 + 12] = x8

        // Test LW instruction: lw x17, 16(x18)
        #10 PC = 32'h00000024; INSTRUCTION = 32'b0000000_10010_10001_010_10001_0000011; // x17 = memory[x18 + 16]


        // Wait and finish simulation
        #100 $finish;
    end

    // Monitor outputs, including internal wire WRITE_DATA
    initial begin
        $monitor("Time: %0dns | PC: %h | INSTRUCTION: %h | MEM_READ: %b | MEM_WRITE: %b | MEM_ADDRESS: %h | MEM_WRITE_DATA: %h | WRITE_DATA: %h | DATA1: %h | DATA2: %h |data1: %h|data2: %h", 
            $time, PC, INSTRUCTION, MEM_READ, MEM_WRITE, MEM_ADDRESS, MEM_WRITE_DATA, cpu.WRITE_DATA,cpu.INSTRUCTION_OUT[19:15],cpu.INSTRUCTION_OUT[24:20],cpu.DATA1,cpu.DATA2);
    end
endmodule
