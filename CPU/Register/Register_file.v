/*****************************************************
    * Module: Register_file
    *
    * Purpose: This module is used to implement the register file
    *          for the CPU.
    *
    * Functions: This module has the following functions:
    *            1. Read: This function reads the data from the register file.
    *            2. Write: This function writes the data to the register file.
    *
******************************************************/

module Register_file(
    input [4:0] ADRS1,
    input [4:0] ADRS2,
    input [4:0] WB_ADDRESS,
    input WRITE_ENABLE,
    input [31:0] WRITE_DATA,
    input CLK,
    input RESET,
    output [31:0] DATA_OUT1,
    output [31:0] DATA_OUT2
);

    // Internal Registers
    reg [31:0] REGISTER_FILE [31:0]; // 32 registers each of 32 bits
    reg [31:0] DATA1, DATA2; // Temporary storage for output data

    integer i;

    // Synchronous logic with reset
    always @(posedge CLK or posedge RESET) begin
        if (RESET) begin
            // Reset all registers
            for (i = 0; i < 32; i = i + 1) begin
                REGISTER_FILE[i] <= 0;
            end
        end else if (WRITE_ENABLE) begin
            // Write data to register
            REGISTER_FILE[WB_ADDRESS] <= WRITE_DATA;
        end
    end

    // Read data from registers
    always @(*) begin
        DATA1 = REGISTER_FILE[ADRS1];
        DATA2 = REGISTER_FILE[ADRS2];
    end

    // Assign outputs
    assign DATA_OUT1 = DATA1;
    assign DATA_OUT2 = DATA2;

endmodule
