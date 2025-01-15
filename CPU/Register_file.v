module Register_file(
    input [4:0] ADRS1,            // Address of the first register
    input [4:0] ADRS2,            // Address of the second register
    input [4:0] WB_ADDRESS,       // Writeback register address
    input WRITE_ENABLE,           // Write enable signal
    input [31:0] WRITE_DATA,      // Data to be written to the register
    input CLK,                    // Clock signal
    input RESET,                  // Reset signal
    output [31:0] DATA_OUT1,      // Data from register 1
    output [31:0] DATA_OUT2       // Data from register 2
);

    // Internal Registers
    reg [31:0] REGISTER_FILE [31:0]; // 32 registers, each 32 bits wide
    reg [31:0] DATA1, DATA2; // Temporary storage for read data

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

    // Read data from registers (combinational)
    always @(*) begin
        DATA1 = REGISTER_FILE[ADRS1];
        DATA2 = REGISTER_FILE[ADRS2];
    end

    // Assign outputs
    assign DATA_OUT1 = DATA1;
    assign DATA_OUT2 = DATA2;

endmodule
