`timescale 1ns/100ps
`include "CPU.v"

module CPU_tb;
    reg CLK, RESET;
    //reg BUSYWAIT;
    //reg [31:0] PC, INSTRUCTION, READ_DATA;
    //wire MEM_READ, MEM_WRITE;
    //wire [31:0] MEM_WRITE_DATA, MEM_ADDRESS;

    // Instantiate the CPU module
    CPU cpu(CLK,RESET);

    // Clock generation
    initial begin
        CLK = 1;
        forever #5 CLK = ~CLK; // 10ns clock period
    end

    // Test case
    initial begin

        // Dump waveform for analysis
        $dumpfile("cpu_tb.vcd");
        $dumpvars(0, CPU_tb);

        // Initialize signals
        RESET = 1;
        
        #11 RESET = 0;

        
        #100;
        $finish;
    end

    // Monitor outputs, including internal wire WRITE_DATA
    initial begin
        $monitor("Time: %0dns | PC: %h | INSTRUCTION: %h | BUSYWAIT: %b | MEM_READ: %b | MEM_WRITE: %b", 
                 $time, cpu.PC, cpu.INSTRUCTION, cpu.BUSYWAIT, cpu.MEM_READ, cpu.MEM_WRITE);
    end
endmodule
