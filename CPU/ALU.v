// Addition module: adds operand_A and operand_B, result2 gets updated after a delay of 2 time units
module ADD_module(operand_A,operand_B,result);
input [31:0] operand_A;
input [31:0] operand_B;
output [31:0] result;
assign #2 result=operand_A + operand_B;

endmodule


module SUB_module(operand_A,operand_B,result);
input [31:0] operand_A;
input [31:0] operand_B;
output [31:0] result;
assign #2 result=operand_A - operand_B;     
    
endmodule

module SLL_module(operand_A,operand_B,result);
input [31:0] operand_A;
input [31:0] operand_B;
output [31:0] result;
assign #2 result=operand_A << operand_B;     
    
endmodule

module SLT_module(operand_A, operand_B, result);
    input signed [31:0] operand_A;
    input signed [31:0] operand_B;
    output [31:0] result;

    assign result = (operand_A < operand_B) ? 1 : 0; // Signed comparison
endmodule

module SLTU_module(operand_A, operand_B, result);
    input [31:0] operand_A;
    input [31:0] operand_B;
    output [31:0] result;

    assign result = (operand_A < operand_B) ? 1 : 0; // Unsigned comparison
endmodule


module XOR_module(operand_A,operand_B,result);
input [31:0] operand_A;
input [31:0] operand_B;
output [31:0] result;

assign #2 result=operand_A ^ operand_B;     
    
endmodule

module SRL_module(operand_A,operand_B,result);
input [31:0] operand_A;
input [31:0] operand_B;
output [31:0] result;

assign #2 result=operand_A >> operand_B;     
    
endmodule

module SRA_module(operand_A,operand_B,result);
input [31:0] operand_A;
input [31:0] operand_B;
output [31:0] result;

assign #2 result=operand_A >>> operand_B;     
    
endmodule

module OR_module(operand_A,operand_B,result);
input [31:0] operand_A;
input [31:0] operand_B;
output [31:0] result;

assign #2 result=operand_A | operand_B;     
    
endmodule

module AND_module(operand_A,operand_B,result);
input [31:0] operand_A;
input [31:0] operand_B;
output [31:0] result;

assign #2 result=operand_A & operand_B;     
    
endmodule

module MUL_module(operand_A,operand_B,result);
input [31:0] operand_A;
input [31:0] operand_B;
output [31:0] result;

wire [63:0] product; // Temporary 64-bit product
assign #2 product = operand_A * operand_B;
assign result = product[31:0]; // Upper 32 bits     
    
endmodule

module MULH_module(operand_A,operand_B,result);
input signed [31:0] operand_A;
input signed [31:0] operand_B;
output [31:0] result;

wire [63:0] product; // Temporary 64-bit product
assign #2 product = operand_A * operand_B;
assign result = product[63:32]; // Upper 32 bits    
    
endmodule

module MULHSU_module(operand_A,operand_B,result);
input signed [31:0] operand_A;
input [31:0] operand_B;
output [31:0] result;

wire [63:0] product;
assign #2 product=operand_A * operand_B;
assign result=product[63:32];     
    
endmodule

module MULHU_module(operand_A,operand_B,result);
input [31:0] operand_A;
input [31:0] operand_B;
output [31:0] result;

wire [63:0] product;
assign #2 product=operand_A * operand_B;
assign result=product[63:32];      
    
endmodule

module DIV_module(operand_A,operand_B,result);
input [31:0] operand_A;
input [31:0] operand_B;
output [31:0] result;

assign #2 result=operand_A / operand_B;     
    
endmodule

module REM_module(operand_A,operand_B,result);
input signed [31:0] operand_A;
input signed [31:0] operand_B;
output signed [31:0] result;

assign #2 result=operand_A % operand_B;     
    
endmodule

module REMU_module(operand_A,operand_B,result);
input [31:0] operand_A;
input [31:0] operand_B;
output [31:0] result;

assign #2 result=operand_A % operand_B;     
    
endmodule


module alu(DATA1, DATA2, SELECT, RESULT, ZERO);  // ALU module declaration

// Input port declaration
input [31:0] DATA1, DATA2;  // Two 32-bit input data
input [4:0] SELECT;         // 5-bit SELECT signal for operation selection

// Output port declaration
output reg [31:0] RESULT;   // 32-bit output result
output reg ZERO;            // ZERO flag, set when RESULT is zero

// Internal wires for each operation's result
wire [31:0] Result_add, Result_sub, Result_sll, Result_slt, Result_sltu;
wire [31:0] Result_xor, Result_srl, Result_sra, Result_or, Result_and;
wire [31:0] Result_mul, Result_mulh, Result_mulhsu, Result_mulhu;
wire [31:0] Result_div, Result_rem, Result_remu;

// Instantiation of operation modules
ADD_module add0(.operand_A(DATA1), .operand_B(DATA2), .result(Result_add));
SUB_module sub0(.operand_A(DATA1), .operand_B(DATA2), .result(Result_sub));
SLL_module sll0(.operand_A(DATA1), .operand_B(DATA2), .result(Result_sll));
SLT_module slt0(.operand_A(DATA1), .operand_B(DATA2), .result(Result_slt));
SLTU_module sltu0(.operand_A(DATA1), .operand_B(DATA2), .result(Result_sltu));
XOR_module xor0(.operand_A(DATA1), .operand_B(DATA2), .result(Result_xor));
SRL_module srl0(.operand_A(DATA1), .operand_B(DATA2), .result(Result_srl));
SRA_module sra0(.operand_A(DATA1), .operand_B(DATA2), .result(Result_sra));
OR_module or0(.operand_A(DATA1), .operand_B(DATA2), .result(Result_or));
AND_module and0(.operand_A(DATA1), .operand_B(DATA2), .result(Result_and));
MUL_module mul0(.operand_A(DATA1), .operand_B(DATA2), .result(Result_mul));
MULH_module mulh0(.operand_A(DATA1), .operand_B(DATA2), .result(Result_mulh));
MULHSU_module mulhsu0(.operand_A(DATA1), .operand_B(DATA2), .result(Result_mulhsu));
MULHU_module mulhu0(.operand_A(DATA1), .operand_B(DATA2), .result(Result_mulhu));
DIV_module div0(.operand_A(DATA1), .operand_B(DATA2), .result(Result_div));
REM_module rem0(.operand_A(DATA1), .operand_B(DATA2), .result(Result_rem));
REMU_module remu0(.operand_A(DATA1), .operand_B(DATA2), .result(Result_remu));

// ALU operation selection
always @(*) begin
    case (SELECT)
        5'b00000: RESULT = Result_add;     // ADD
        5'b00001: RESULT = Result_sub;     // SUB
        5'b00010: RESULT = Result_sll;     // SLL
        5'b00011: RESULT = Result_slt;     // SLT
        5'b00100: RESULT = Result_sltu;    // SLTU
        5'b00101: RESULT = Result_xor;     // XOR
        5'b00110: RESULT = Result_srl;     // SRL
        5'b00111: RESULT = Result_sra;     // SRA
        5'b01000: RESULT = Result_or;      // OR
        5'b01001: RESULT = Result_and;     // AND
        5'b01010: RESULT = Result_mul;     // MUL
        5'b01011: RESULT = Result_mulh;    // MULH
        5'b01100: RESULT = Result_mulhsu;  // MULHSU
        5'b01101: RESULT = Result_mulhu;   // MULHU
        5'b01110: RESULT = Result_div;     // DIV
        5'b01111: RESULT = Result_rem;     // REM
        5'b10000: RESULT = Result_remu;    // REMU
        default: RESULT = 32'b0;           // Default to 0 for undefined operations
    endcase

    if (Result_add == 0) 
    begin
        ZERO = 1'b1;
    end
end

endmodule





