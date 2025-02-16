`timescale 1ns/100ps

// Optional: Testbench for verification
module instruction_memory_tb;
    reg clk;
    reg rst;
    reg [31:0] pc;
    wire [31:0] instruction;
    
    // Instantiate instruction memory
    instruction_memory imem (
        .clk(clk),
        .rst(rst),
        .pc(pc),
        .instruction(instruction)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // Test stimulus
    initial begin
        // Initialize signals
        rst = 1;
        pc = 32'h0;
        
        // Release reset
        #10 rst = 0;
        
        // Test different PC values
        #10 pc = 32'h0;    // First instruction
        #10 pc = 32'h4;    // Second instruction
        #10 pc = 32'h8;    // Third instruction
        #10 pc = 32'hC;    // Fourth instruction
        
        // Test misaligned access
        #10 pc = 32'h2;
        
        // Test out-of-range access
        #10 pc = 32'h1000;
        
        // End simulation
        #10 $finish;
    end
    
    // Optional: Waveform dump
    initial begin
        $dumpfile("instruction_memory.vcd");
        $dumpvars(0, instruction_memory_tb);
    end
endmodule