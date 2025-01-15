`timescale 1ns/100ps

`include "ALU.v"
module ALU_tb;


reg [31:0] DATA1;
reg [31:0] DATA2;
reg [4:0] SELECT;
wire [31:0] RESULT;

// Instantiate the ALU module
alu uut(.DATA1(DATA1),.DATA2(DATA2),.SELECT(SELECT),.RESULT(RESULT));



initial begin
    // Dump VCD file for waveform viewing
    $dumpfile("ALU_tb.vcd");
    $dumpvars(0,ALU_tb);

     // Monitor inputs and result
    $monitor("Data1: %d, Data2: %d,Result: %d Sel:%b",DATA1,DATA2,RESULT,SELECT);

    // Provide input values and select signals for testing
    #5                     // Wait for 5 time units before applying the first set of inputs
    DATA1 = 32'd5;  
    DATA2 = 32'd9;  
    SELECT= 5'b00000;       // Select operation 0 (ADD)

    #5                    // Wait for 5 time units before applying the second set of inputs
    DATA1 = 32'b00000011;  
    DATA2 = 32'd3;  
    SELECT= 5'b00001;       // Select operation 1 (SLL)

    #5                    // Wait for 5 time units before applying the second set of inputs
    DATA1 = 32'b00000011;  
    DATA2 = 32'd3;  
    SELECT= 5'b00010;       // Select operation 1 (SLT)

    #5                    // Wait for 5 time units before applying the second set of inputs
    DATA1 = 32'b00000011;  
    DATA2 = 32'd3;  
    SELECT= 5'b00011;       // Select operation 1 (SLTU)


    #5                    // Wait for 5 time units before applying the third set of inputs
    DATA1 = 8'b00000011;  
    DATA2 = 8'b00000001;  
    SELECT= 5'b00100;       // Select operation 2 (XOR)

    #5                    // Wait for 5 time units before applying the third set of inputs
    DATA1 = 8'b00000011;  
    DATA2 = 8'b00000001;  
    SELECT= 5'b00101;       // Select operation 2 (SRL)

    #5                    // Wait for 5 time units before applying the third set of inputs
    DATA1 = 8'b00000011;  
    DATA2 = 8'b00000001;  
    SELECT= 5'b00110;       // Select operation 2 (OR)


    #5                    // Wait for 5 time units before applying the third set of inputs
    DATA1 = 8'b00000011;  
    DATA2 = 8'b00000001;  
    SELECT= 5'b00111;       // Select operation 2 (AND)

    #5                    // Wait for 5 time units before applying the fourth set of inputs
    DATA1 = 8'b00000101;  
    DATA2 = 8'b00000010;  
    SELECT= 5'b01000;       //Select operation 3 (MUL)

    #5                    // Wait for 5 time units before applying the fourth set of inputs
    DATA1 = 8'b00000101;  
    DATA2 = 8'b00000001;  
    SELECT= 5'b01001;       //Select operation 3 (MULH)

    #5                    // Wait for 5 time units before applying the fourth set of inputs
    DATA1 = 8'b00000101;  
    DATA2 = 8'b00000001;  
    SELECT= 5'b01010;       //Select operation 3 (MULHSU)

    #5                    // Wait for 5 time units before applying the fourth set of inputs
    DATA1 = 8'b00000101;  
    DATA2 = 8'b00000001;  
    SELECT= 5'b01011;       //Select operation 3 (MULHU)

    #5                    // Wait for 5 time units before applying the fourth set of inputs
    DATA1 = 8'b00000111;  
    DATA2 = 8'b00000010;  
    SELECT= 5'b01100;       //Select operation 3 (DIV)

    #5                    // Wait for 5 time units before applying the fourth set of inputs
    DATA1 = 8'b00000101;  
    DATA2 = 8'b00000010;  
    SELECT= 5'b01101;       //Select operation 3 (REM)

    #5                    // Wait for 5 time units before applying the fourth set of inputs
    DATA1 = 8'b00000101;  
    DATA2 = 8'b00000010;  
    SELECT= 5'b01111;       //Select operation 3 (REMU)

    #100                  // Wait for 100 time units before finishing simulation 
    $finish;
end

    
endmodule