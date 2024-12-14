    /*******************************************
    * Testbench for the Register File
    *******************************************/

module Register_file_tb;

    // Inputs
    reg [4:0] ADRS1,ADRS2,WB_ADDRESS;
    reg WRITE_ENABLE;
    reg [31:0] WRITE_DATA;
    reg CLK,RESET;

    // Outputs
    wire [31:0] DATA_OUT1,DATA_OUT2;

    // Instantiate the Register File
    Register_file RF(ADRS1,ADRS2,WRITE_ENABLE,WRITE_DATA,WB_ADDRESS,DATA_OUT1,DATA_OUT2,CLK,RESET);

    // Clock Generation
    always
    begin
        #5 CLK = ~CLK;
    end

    // Test Case 1
    initial
    begin
        // Initialize the inputs
        ADRS1 = 5'b00000;
        ADRS2 = 5'b00001;
        WB_ADDRESS = 5'b00010;
        WRITE_ENABLE = 1;
        WRITE_DATA = 32'h0000000A;
        CLK = 0;
        RESET = 0;

        // Wait for some time
        #10

        // Apply Reset
        RESET = 1;

        // Wait for some time
        #10

        // Release Reset
        RESET = 0;

        // Wait for some time
        #10

        // Apply Write Operation
        #5
        WRITE_ENABLE = 1;
        WRITE_DATA = 32'h0000000A;

        // Wait for some time
        #10

        // Apply Read Operation
        #5
        ADRS1 = 5'b00010;
        ADRS2 = 5'b00000;
        WRITE_ENABLE = 0;

        // Wait for some time
        #10

        // Apply Write Operation
        #5
        WRITE_ENABLE = 1;
        WRITE_DATA = 32'h0000000B;

        // Wait for some time
        #10

        // Apply Read Operation
        #5
        ADRS1 = 5'b00010;
        ADRS2 = 5'b00000;
        WRITE_ENABLE = 0;

        // Wait for some time
        #10

        // Apply Write Operation
        #5
        WRITE_ENABLE = 1;
        WRITE_DATA = 32'h0000000C;

        // Wait for some time
        #10

        // Apply Read Operation
        #5
        ADRS1 = 5'b00010;
        ADRS2 = 5'b00000;
        WRITE_ENABLE = 0;

        // Wait for some time
        #10

        // Apply Write Operation
        #5
        WRITE_ENABLE = 1;
        WRITE_DATA = 32'h0000000D;

        #10
    end

endmodule
