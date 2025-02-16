    /***********************************************
    * CPU/Immediate_extend_tb.v - Testbench Module
    ***********************************************/

module Immediate_extend_tb;

    // Inputs
    reg [31:0] imm_value;
    reg [2:0] imm_select;

    // Outputs
    wire [31:0] extended_imm_value;

    // Instantiate the Immediate Extend Module
    immediate_extend IE(imm_value,extended_imm_value,imm_select);

    // Test Case 1
    initial
    begin
        // Initialize the inputs
        imm_value = 32'h00000000;
        imm_select = 3'b000;

        // Wait for some time
        #10

        // Apply Test Case 1
        // I type
        imm_value = 32'h0000000A;
        imm_select = 3'b000;

        // Wait for some time
        #10

        // Apply Test Case 2
        // R type
        imm_value = 32'h0000000A;
        imm_select = 3'b001;

        // Wait for some time
        #10

        // Apply Test Case 3
        // S type
        imm_value = 32'h0000000A;
        imm_select = 3'b010;

        // Wait for some time
        #10

        // Apply Test Case 4
        // B type
        imm_value = 32'h0000000A;
        imm_select = 3'b011;

        // Wait for some time
        #10

        // Apply Test Case 5
        // U type
        imm_value = 32'h0000000A;
        imm_select = 3'b100;

        // Wait for some time
        #10

        // Apply Test Case 6
        // J type
        imm_value = 32'h0000000A;
        imm_select = 3'b101;

        // Wait for some time
        #10
    end
endmodule