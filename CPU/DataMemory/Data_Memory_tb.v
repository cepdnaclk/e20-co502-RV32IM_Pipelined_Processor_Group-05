// Testbench for Data Memory Module with LB, LH, LW, SH, SB, SW
module Data_Memory_tb;
    // Inputs
    reg Read;
    reg Write;
    reg Clock;
    reg Reset;
    reg [31:0] Address;
    reg [31:0] Write_data;
    reg [2:0] Func3;

    // Outputs
    wire [31:0] Read_data;
    wire busywait;

    // Instantiate the Data Memory Module
    Data_Memory uut (
        .Read(Read),
        .Write(Write),
        .Clock(Clock),
        .Reset(Reset),
        .Address(Address),
        .Write_data(Write_data),
        .Func3(Func3),
        .Read_data(Read_data),
        .busywait(busywait)
    );

    // Clock generation
    always #5 Clock = ~Clock;

    // Initialize the simulation and VCD file for GTKWave
    initial begin
        // Create a VCD dump file for GTKWave
        $dumpfile("data_memory_tb.vcd");  // File name for VCD dump
        $dumpvars(0, Data_Memory_tb);     // Dump all signals in the testbench

        // Initialize inputs
        Clock = 0;
        Reset = 1;
        Read = 0;
        Write = 0;
        Address = 0;
        Write_data = 0;
        Func3 = 0;

        // Reset memory
        #10 Reset = 0;

        // Test case 1: Store a word
        Address = 32'h00000004; // Address = 4
        Write_data = 32'h12345678; // Data to write
        Func3 = 3'b010; // SW (Store Word)
        Write = 1; #10 Write = 0;

        // Test case 2: Load the word
        Read = 1; Func3 = 3'b010; #10 Read = 0;

        // Test case 3: Store a byte
        Address = 32'h00000005; // Address = 5
        Write_data = 32'h000000AA; // Data to write (only byte is considered)
        Func3 = 3'b000; // SB (Store Byte)
        Write = 1; #10 Write = 0;

        // Test case 4: Load the byte (LB)
        Read = 1; Func3 = 3'b000; #10 Read = 0;

        // Test case 5: Store a halfword
        Address = 32'h00000006; // Address = 6
        Write_data = 32'h0000BBBB; // Data to write (only halfword is considered)
        Func3 = 3'b001; // SH (Store Halfword)
        Write = 1; #10 Write = 0;

        // Test case 6: Load the halfword (LH)
        Read = 1; Func3 = 3'b001; #10 Read = 0;

        // Test case 7: Store a word (SW)
        Address = 32'h00000010; // Address = 16
        Write_data = 32'hDEADBEEF; // Data to write
        Func3 = 3'b010; // SW (Store Word)
        Write = 1; #10 Write = 0;

        // Test case 8: Load the word (LW)
        Read = 1; Func3 = 3'b010; #10 Read = 0;

        // Finish simulation
        #50 $finish;
    end

    // Monitor signals
    initial begin
        $monitor("Time = %0t | Read = %b | Write = %b | Address = %h | Write_data = %h | Read_data = %h | Func3 = %b | busywait = %b", 
                 $time, Read, Write, Address, Write_data, Read_data, Func3, busywait);
    end
endmodule


