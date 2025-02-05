`timescale 1ns / 1ps

module pc_tb;
    reg clock;
    reg reset;
    reg [31:0] branch_address;
    reg branch_enable;
    wire [31:0] pc;
    wire [31:0] pc_plus_4;

    // Instantiate the program_counter module
    program_counter uut (
        .clock(clock),
        .reset(reset),
        .branch_address(branch_address),
        .branch_enable(branch_enable),
        .pc(pc),
        .pc_plus_4(pc_plus_4)
    );

    // Clock generation
    initial begin
        clock = 0;
        forever #5 clock = ~clock; // 10ns clock period
    end

    // Test scenarios
    initial begin
        // Display table header
        $display("-------------------------------------------------------------------");
        $display("|   Time  | Clock | Reset | Branch Enable | Branch Address |    PC    |  PC+4  |");
        $display("-------------------------------------------------------------------");

        // Monitor the PC and PC+4 values
        $monitor("| %8t |   %b   |   %b   |       %b       |    %h    | %h | %h |", 
                  $time, clock, reset, branch_enable, branch_address, pc, pc_plus_4);

        // Initialize inputs
        reset = 1; branch_enable = 0; branch_address = 32'd100;
        #10 reset = 0; // De-assert reset

        // Increment PC normally
        #50;

        // Test branching
        branch_enable = 1; branch_address = 32'd200;
        #10 branch_enable = 0;

        // Test reset
        #50 reset = 1;
        #10 reset = 0;

        // End simulation
        #50 $finish;
    end
endmodule
