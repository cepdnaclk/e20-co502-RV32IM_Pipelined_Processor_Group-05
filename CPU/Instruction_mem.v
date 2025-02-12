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
        
        // Load instructions from binary file
        $readmemb("program.mem", imem);
        $display("Program loaded from program.mem");
        // Example instructions (RV32IM)
        // You can modify these or load from a file
        //imem[0]  = 32'b0000000_00011_00010_000_00001_0110011; // add x1, x2, x3 
        //imem[1]  = 32'b0100000_00101_01100_000_00001_0110011; // sub x1, x12, x5
        //imem[2]  = 32'b0000000_00110_00101_110_00100_0110011; // or x4, x5, x6
        //imem[3]  = 32'b0000000_01001_01000_111_00111_0110011; // and x7, x8, x9
        //imem[4]  = 32'b0000000_01100_01011_100_01010_0110011; // xor x10, x11, x12
        //imem[5]  = 32'b0000000_01010_01110_000_01101_0010011; // addi x13, x14, 0x000A
        //imem[6]  = 32'b0000000_01001_01000_010_01100_0100011; // sw x8, 12(x9)
        //imem[7]  = 32'b0000000_10010_10001_010_10001_0000011; // lw x17, 16(x18)
    end

    initial begin
        $readmemb("program.mem", imem);  // Use $readmemb for binary format
        $display("Program loaded from program.mem");
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

 
endmodule

// End of file