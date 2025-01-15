/**********************************************************
    Data Memory Module
    stores data in memory
    reads data from memory

************************************************************/



`timescale 1ns/100ps
// Data Memory Module
module Data_Memory (
    input               Read,         // Memory read signal
    input               Write,        // Memory write signal
    input               Clock,        // Clock signal
    input               Reset,        // Reset signal
    input [31:0]        Address,      // Address input (word address)
    input [31:0]        Write_data,   // Data to write
    input [2:0]         Func3,        // Function field for data type (byte, halfword, word)
    output reg [31:0]   Read_data,    // Data read output
    output reg          busywait      // Busywait signal
);

    // Memory array: 1024 words (32 bits each)
    reg [31:0] memory [0:1023];

    // Internal signals for detecting read/write access
    reg read_access, write_access;

    // Detect memory access
    always @(Read, Write) begin
        busywait = (Read || Write) ? 1 : 0;
        read_access = (Read && !Write) ? 1 : 0;
        write_access = (!Read && Write) ? 1 : 0;
    end

    // Memory read operation
    always @(posedge Clock) begin
        if (read_access) begin
            case (Func3)
                3'b000: // LB (Load Byte - Signed)
                    Read_data = {{24{memory[Address[31:2]][(Address[1:0] * 8) + 7]}}, memory[Address[31:2]][Address[1:0] * 8 +: 8]};
                3'b001: // LH (Load Halfword - Signed)
                    Read_data = {{16{memory[Address[31:2]][(Address[1] * 16) + 15]}}, memory[Address[31:2]][Address[1] * 16 +: 16]};
                3'b010: // LW (Load Word)
                    Read_data = memory[Address[31:2]];
                3'b100: // LBU (Load Byte - Unsigned)
                    Read_data = {24'b0, memory[Address[31:2]][Address[1:0] * 8 +: 8]};
                3'b101: // LHU (Load Halfword - Unsigned)
                    Read_data = {16'b0, memory[Address[31:2]][Address[1] * 16 +: 16]};
                default: // Default case for unsupported Func3
                    Read_data = 32'b0;
            endcase
            busywait = 0;
            read_access = 0;
        end
    end

    // Memory write operation
    always @(posedge Clock) begin
        if (write_access) begin
            case (Func3)
                3'b000: // SB (Store Byte)
                    memory[Address[31:2]][Address[1:0] * 8 +: 8] = Write_data[7:0];
                3'b001: // SH (Store Halfword)
                    memory[Address[31:2]][Address[1] * 16 +: 16] = Write_data[15:0];
                3'b010: // SW (Store Word)
                    memory[Address[31:2]] = Write_data;
            endcase
            busywait = 0;
            write_access = 0;
        end
    end

    // Reset memory
    integer i;
    always @(posedge Reset) begin
        if (Reset) begin
            for (i = 0; i < 1024; i = i + 1)
                memory[i] = 0;
            busywait = 0;
            read_access = 0;
            write_access = 0;
        end
    end

    // Optionally, print memory values when a write or read occurs (for debugging)
   // always @(posedge Clock) begin
      //  if (write_access) begin
           // $display("Writing data %h to Address %h", Write_data, Address);
           // $display("Memory at Address %h: %h", Address, memory[Address[31:2]]);
       // end
       // if (read_access) begin
       //     $display("Reading data from Address %h: %h", Address, Read_data);
      //  end
   // end
endmodule
