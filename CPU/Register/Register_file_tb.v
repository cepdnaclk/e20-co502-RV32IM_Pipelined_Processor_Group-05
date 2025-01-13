/*******************************************
    * Testbench for the Register File
*******************************************/

module Register_file_tb;

    // Inputs
    reg [4:0] ADRS1, ADRS2, WB_ADDRESS;
    reg WRITE_ENABLE;
    reg [31:0] WRITE_DATA;
    reg CLK, RESET;

    // Outputs
    wire [31:0] DATA_OUT1, DATA_OUT2;

    // Instantiate the Register File
    Register_file RF(
        .ADRS1(ADRS1),
        .ADRS2(ADRS2),
        .WB_ADDRESS(WB_ADDRESS),
        .WRITE_ENABLE(WRITE_ENABLE),
        .WRITE_DATA(WRITE_DATA),
        .CLK(CLK),
        .RESET(RESET),
        .DATA_OUT1(DATA_OUT1),
        .DATA_OUT2(DATA_OUT2)
    );

    // Clock Generation
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK; // 10 time unit clock period
    end

    // Test Cases
    initial begin
        // Dump waveform for analysis
        $dumpfile("register_dump.vcd");
        $dumpvars(0, Register_file_tb);

        // Initialize inputs
        RESET = 1; WRITE_ENABLE = 0; WRITE_DATA = 0;
        ADRS1 = 0; ADRS2 = 0; WB_ADDRESS = 0;

        // Apply reset
        #10 RESET = 0;

        // Write data to register 2
        #10 WRITE_ENABLE = 1; WRITE_DATA = 32'hDEADBEEF; WB_ADDRESS = 5'd2;

        // Read data from register 2
        #10 WRITE_ENABLE = 0; ADRS1 = 5'd2;

        // Write data to register 3
        #10 WRITE_ENABLE = 1; WRITE_DATA = 32'hCAFEBABE; WB_ADDRESS = 5'd3;

        // Read data from register 3 and 2
        #10 WRITE_ENABLE = 0; ADRS1 = 5'd3; ADRS2 = 5'd2;

        // End simulation
        #50 $finish;
    end

endmodule
