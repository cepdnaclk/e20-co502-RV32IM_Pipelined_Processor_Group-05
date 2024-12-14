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

module Register_file(ADRS1,ADRS2,WRITE_ENABLE,WRITE_DATA,WB_ADDRESS,DATA1,DATA2,CLK,RESET,DATA_OUT1,DATA_OUT2);

    // Inputs
    input [4:0] ADRS1,ADRS2,WB_ADDRESS;
    input WRITE_ENABLE;
    input [31:0] WRITE_DATA;
    input CLK,RESET;

    // Outputs
    output [31:0] DATA_OUT1,DATA_OUT2;// Outputs
    reg [31:0] DATA_OUT1,DATA_OUT2; // Internal Registers
    reg [31:0] DATA1,DATA2;// Internal Registers

    // create space for Internal Registers 32X32 bits
    // 32 registers each of 32 bits
    reg [31:0] REGISTER_FILE [31:0];

    // Register File
    integer i;
    
    always @(posedge CLK or posedge RESET)
    begin
        // Reset the Register File
        if(RESET)
        begin
            for(i=0;i<32;i=i+1)
            begin
                REGISTER_FILE[i] <= 0;
            end
        end

        // Read and Write Operations
        else
        begin
            if(WRITE_ENABLE)
            begin
                // Write Data to the Register File
                REGISTER_FILE[WB_ADDRESS] <= WRITE_DATA;
            end
            // Read Data from the Register File
            DATA1 <= REGISTER_FILE[ADRS1];
            DATA2 <= REGISTER_FILE[ADRS2];
        end
    end
    
    // Output
    assign DATA_OUT1 = DATA1;
    assign DATA_OUT2 = DATA2;

endmodule