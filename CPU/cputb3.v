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

        // Test ADD instruction: add x6, x1, x2
        #10 PC = 32'h00000004; INSTRUCTION = 32'b0000000_00010_00001_000_00110_0110011; // x6 = x1 + x2

        // Test SUB instruction: sub x4, x6, x5
        #10 PC = 32'h00000008; INSTRUCTION = 32'b0100000_00101_00110_000_00100_0110011; // x4 = x6 - x5

        #100 $finish;
    end

    // Monitor outputs, including internal wire WRITE_DATA
    initial begin
        $monitor("Time: %0dns | PC: %h | INSTRUCTION: %h | MEM_READ: %b | MEM_WRITE: %b | MEM_ADDRESS: %h | MEM_WRITE_DATA: %h | WRITE_DATA: %h | DATA1: %h | DATA2: %h |data1: %h|data2: %h", 
            $time, PC, INSTRUCTION, MEM_READ, MEM_WRITE, MEM_ADDRESS, MEM_WRITE_DATA, cpu.WRITE_DATA,cpu.INSTRUCTION_OUT[19:15],cpu.INSTRUCTION_OUT[24:20],cpu.DATA1,cpu.DATA2);
    end
endmodule
