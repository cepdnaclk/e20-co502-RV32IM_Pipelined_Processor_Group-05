`timescale 1ns/100ps

module instruction_memory (
    input wire clk,
    input wire reset,
    input wire [31:0] pc,         // Program Counter input
    output reg [31:0] instruction // Instruction output
);

    // Memory array to store instructions
    reg [31:0] imem [0:1023];  // 1024 x 32-bit instruction memory
    integer i;
    
    // Initialize memory with instructions (typically done through external file)
    initial begin
        // Initialize all memory locations to NOP (0x00000013)
        
        for (i = 0; i < 1024; i = i + 1) begin
            imem[i] = 32'h00000013;
        end
        
        // Example instructions (RV32IM)
        // You can modify these or load from a file
        imem[0] = 32'h00500113;    // addi x2, x0, 5
        imem[1] = 32'h00600193;    // addi x3, x0, 6
        imem[2] = 32'h002081b3;    // add x3, x1, x2
        imem[3] = 32'h02310263;    // beq x2, x3, 36
        imem[4] = 32'h02728663;    // mul x4, x5, x7
        imem[5] = 32'hfe20aee3;    // sw x2, -4(x1)
        imem[6] = 32'h0040a023;    // sw x4, 0(x1)
        imem[7] = 32'h0050a423;    // sw x5, 8(x1)
    end

    // Asynchronous read
    always @(*) begin
        if (reset) begin
            instruction = 32'h00000013;  // NOP during reset
        end else begin
            // Check if PC is word-aligned and within valid range
            if ((pc[1:0] == 2'b00) && (pc[31:2] < 1024)) begin
                instruction = imem[pc[31:2]];  // Word-aligned access
            end else begin
                instruction = 32'h00000013;    // Return NOP for invalid addresses
            end
        end
    end

    // Optional: Add ability to load instructions from file
    // synthesis translate_off
    //task load_program;
    //    input string filename;
    //    begin
    //        $readmemh(filename, imem);
    //    end
    //endtask
    // synthesis translate_on

endmodule

// End of file