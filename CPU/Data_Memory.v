/**********************************************************
    Data Memory Module
    stores data in memory
    reads data from memory

************************************************************/



module Data_Memory(
    Read,
    Write,
    Address,
    Read_data,
    Write_data,
    Clock,
    Func3,
    Reset
);
input Read, Write, Clock, Reset;
input [31:0] Address, Write_data;
output [31:0] Read_data;
input [2:0] Func3;

//Space for memory registers
reg [31:0] memory [0:1023];

//Read data from memory
assign Read_data = memory[Address];

//Read & Write
always @(posedge Clock or posedge Reset)
begin
    if(Reset)
    begin
        memory[Address] <= 0;
    end
    else
    begin
        if(Read)
        begin
            Read_data <= memory[Address];
        end
        if(Write)
        begin
            case(Func3)
                3'b000: memory[Address] <= Write_data; //SB
                3'b001: memory[Address] <= Write_data; //SH
                3'b010: memory[Address] <= Write_data; //SW
                3'b100: memory[Address] <= Write_data; //SD
            endcase
        end
    end
end








endmodule