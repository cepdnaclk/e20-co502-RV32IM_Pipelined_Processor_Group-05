`timescale 1ns/100ps

/******************************************
*  Testbench for R-Type Instructions in controlUnit
*******************************************/

module controlUnit_tb;

    // Inputs
    reg [31:0] INSTRUCTION;

    // Outputs
    wire MUX1, MUX2, MUX3, REGISTERWRITE, MEMORYWRITE, MEMORYREAD, BRANCH, JUMP, JAL, TWOSCOMP;
    wire [4:0] ALUOP;
    wire [2:0] IMMEDIATE;

    // Instantiate the Unit Under Test (UUT)
    controlUnit uut(
        .INSTRUCTION(INSTRUCTION),
        .MUX1(MUX1),
        .MUX2(MUX2),
        .MUX3(MUX3),
        .REGISTERWRITE(REGISTERWRITE),
        .MEMORYWRITE(MEMORYWRITE),
        .MEMORYREAD(MEMORYREAD),
        .BRANCH(BRANCH),
        .JUMP(JUMP),
        .JAL(JAL),
        .ALUOP(ALUOP),
        .IMMEDIATE(IMMEDIATE),
        .TWOSCOMP(TWOSCOMP)
    );

    // Procedure to display results in a table format
    task display_results;
        input [31:0] instr;
        $display(
            "| %b | %b  | %b   | %b     | %b     | %b   | %b   | %b  | %b | %b | %b  |",
            instr, MUX1, MUX2, REGISTERWRITE, MEMORYWRITE, MEMORYREAD,
            TWOSCOMP, BRANCH, JUMP, JAL, ALUOP
        );
    endtask

    initial begin
        $display("-----------------------------------------------------------------------------------------");
        $display("| INSTRUCTION                       | MUX1 | MUX2 | REGWR | MEMWR | MEMRD | TC   | BR | JP | JAL | ALUOP |");
        $display("-----------------------------------------------------------------------------------------");

        // R-type instruction tests
        // Test R-type add
        INSTRUCTION = 32'b0000000_00001_00010_000_00011_0110011; // add x3, x1, x2
        #10;
        display_results(INSTRUCTION);

        // Test R-type sub
        INSTRUCTION = 32'b0100000_00001_00010_000_00011_0110011; // sub x3, x1, x2
        #10;
        display_results(INSTRUCTION);

        // Test R-type AND
        INSTRUCTION = 32'b0000000_00001_00010_111_00011_0110011; // and x3, x1, x2
        #10;
        display_results(INSTRUCTION);

        // Test R-type OR
        INSTRUCTION = 32'b0000000_00001_00010_110_00011_0110011; // or x3, x1, x2
        #10;
        display_results(INSTRUCTION);

        // Test R-type XOR
        INSTRUCTION = 32'b0000000_00001_00010_100_00011_0110011; // xor x3, x1, x2
        #10;
        display_results(INSTRUCTION);

        // Test R-type SLL
        INSTRUCTION = 32'b0000000_00001_00010_001_00011_0110011; // sll x3, x1, x2
        #10;
        display_results(INSTRUCTION);

        // Test R-type SRL
        INSTRUCTION = 32'b0000000_00001_00010_101_00011_0110011; // srl x3, x1, x2
        #10;
        display_results(INSTRUCTION);

        // Test R-type SRA
        INSTRUCTION = 32'b0100000_00001_00010_101_00011_0110011; // sra x3, x1, x2
        #10;
        display_results(INSTRUCTION);

        // Test R-type SLT
        INSTRUCTION = 32'b0000000_00001_00010_010_00011_0110011; // slt x3, x1, x2
        #10;
        display_results(INSTRUCTION);

        // Test R-type MUL
        INSTRUCTION = 32'b0111011_00001_00010_000_00011_0110011; // slt x3, x1, x2
        #10;
        display_results(INSTRUCTION);

        $display("-----------------------------------------------------------------------------------------");
        $display("R-type instruction tests completed.");
        $finish;
    end

endmodule
