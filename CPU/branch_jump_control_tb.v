`timescale 1ns/100ps
`include "branch_jump_control.v"

module tb_branch_jump_control;
    reg BRANCH;
    reg JUMP;
    reg ZERO;
    reg [31:0] ALU_OUT;
    reg [2:0] Func3;
    reg [31:0] PC;
    reg [31:0] IMM_VALUE;
    
    wire [31:0] NEXT_PC;
    wire MUX_SELECT;
    wire FLUSH;
    
    // Instantiate the Unit Under Test (UUT)
    branch_jump_control uut (
        .BRANCH(BRANCH),
        .JUMP(JUMP),
        .ZERO(ZERO),
        .ALU_OUT(ALU_OUT),
        .Func3(Func3),
        .PC(PC),
        .IMM_VALUE(IMM_VALUE),
        .NEXT_PC(NEXT_PC),
        .MUX_SELECT(MUX_SELECT),
        .FLUSH(FLUSH)
    );
    
    initial begin
        // Initialize Inputs
        PC = 32'h00000004;
        IMM_VALUE = 32'h00000008;
        
        // Test BEQ (Branch if Equal)
        BRANCH = 1; JUMP = 0; ZERO = 1; Func3 = 3'b000; ALU_OUT = 0;
        #10;
        
        // Test BNE (Branch if Not Equal)
        ZERO = 0; Func3 = 3'b001;
        #10;
        
        // Test BLT (Branch if Less Than)
        ALU_OUT = 32'h00000001; Func3 = 3'b100;
        #10;
        
        // Test BGE (Branch if Greater or Equal)
        ALU_OUT = 32'h00000000; Func3 = 3'b101;
        #10;
        
        // Test BLTU (Branch if Less Than Unsigned)
        ALU_OUT = 32'h00000001; Func3 = 3'b110;
        #10;
        
        // Test BGEU (Branch if Greater or Equal Unsigned)
        ALU_OUT = 32'h00000000; Func3 = 3'b111;
        #10;
        
        // Test JUMP
        BRANCH = 0; JUMP = 1;
        #10;
        
        // Default case (no branch or jump)
        BRANCH = 0; JUMP = 0;
        #10;
        
        $finish;
    end
    
    initial begin
        $monitor("Time=%0t | BRANCH=%b | JUMP=%b | ZERO=%b | Func3=%b | ALU_OUT=%h | PC=%h | IMM_VALUE=%h | NEXT_PC=%h | MUX_SELECT=%b | FLUSH=%b", 
                 $time, BRANCH, JUMP, ZERO, Func3, ALU_OUT, PC, IMM_VALUE, NEXT_PC, MUX_SELECT, FLUSH);
    end
    
endmodule
