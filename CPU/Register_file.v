`timescale 1ns/100ps
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
    reg [31:0] DATA1, DATA2;         // Temporary storage for read data
    integer i;

    // Synchronous write with reset
    always @(posedge CLK) begin
        if (RESET) begin
            // Reset all registers to zero
            for (i = 0; i < 32; i = i + 1) begin
                REGISTER_FILE[i] <= 0;  // Initialize all registers to 0
            end
        end 
        else if (WRITE_ENABLE && WB_ADDRESS != 0) begin  // Prevent writing to x0
            // Write data to the specified register
            REGISTER_FILE[WB_ADDRESS] <= WRITE_DATA;
            
            // Debug message for register writes
            $display("Time=%0t Writing %h to x%0d", $time, WRITE_DATA, WB_ADDRESS);
        end
    end

    // Read data from registers (combinational)
    always @(*) begin
        // x0 is hardwired to 0
        DATA1 = (ADRS1 == 0) ? 32'b0 : REGISTER_FILE[ADRS1];
        DATA2 = (ADRS2 == 0) ? 32'b0 : REGISTER_FILE[ADRS2];
    end

    // For debugging - dump register values
    initial begin
        $dumpfile("cpu_tb.vcd");
        for (i = 0; i < 32; i = i + 1) begin
            $dumpvars(0, REGISTER_FILE[i]);
        end
    end

    //initialization for testing
    initial begin
        #11
        // Initialize registers
        //REGISTER_FILE[0] = 32'h00000000;
        REGISTER_FILE[1] = 32'h00000001;
        REGISTER_FILE[2] = 32'h00000002;
        REGISTER_FILE[3] = 32'h00000003;
        REGISTER_FILE[4] = 32'h00000004;
        REGISTER_FILE[5] = 32'h00000005;
        REGISTER_FILE[6] = 32'h00000006;
        REGISTER_FILE[7] = 32'h00000007;
        REGISTER_FILE[8] = 32'h00000008;
        REGISTER_FILE[9] = 32'h00000009;
        REGISTER_FILE[10] = 32'h0000000A;
        REGISTER_FILE[11] = 32'h0000000B;
        REGISTER_FILE[12] = 32'h0000000C;
        REGISTER_FILE[13] = 32'h0000000D;
        REGISTER_FILE[14] = 32'h0000000E;
        REGISTER_FILE[15] = 32'h0000000F;
        REGISTER_FILE[16] = 32'h00000010;
        REGISTER_FILE[17] = 32'h00000011;
        REGISTER_FILE[18] = 32'h00000012;
        REGISTER_FILE[19] = 32'h00000013;
        REGISTER_FILE[20] = 32'h00000014;
        REGISTER_FILE[21] = 32'h00000015;
        REGISTER_FILE[22] = 32'h00000016;
        REGISTER_FILE[23] = 32'h00000017;
        REGISTER_FILE[24] = 32'h00000018;
        REGISTER_FILE[25] = 32'h00000019;
        REGISTER_FILE[26] = 32'h0000001A;
        REGISTER_FILE[27] = 32'h0000001B;
        REGISTER_FILE[28] = 32'h0000001C;
        REGISTER_FILE[29] = 32'h0000001D;
        REGISTER_FILE[30] = 32'h0000001E;
        REGISTER_FILE[31] = 32'h0000001F;
    end

    // Task to display register file contents (for debugging)
    task print_registers;
        begin
            $display("Register File Contents at time %0t:", $time);
            $display("--------------------------------------");
            for (i = 0; i < 32; i = i + 1) begin
                $display("x%0d = %h", i, REGISTER_FILE[i]);
            end
            $display("--------------------------------------");
        end
    endtask

    // Assign outputs
    assign DATA_OUT1 = DATA1;
    assign DATA_OUT2 = DATA2;

endmodule