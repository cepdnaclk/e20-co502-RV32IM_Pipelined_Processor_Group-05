module instruction_memory_tb;

    // Testbench signals
    reg clock;
    reg reset;
    reg read;
    reg [5:0] address;
    wire [127:0] readinst;
    wire busywait;

    // Instantiate the instruction memory module
    instruction_memory uut (
        .clock(clock),
        .reset(reset),
        .read(read),
        .address(address),
        .readinst(readinst),
        .busywait(busywait)
    );

    // Clock generation
    initial
    begin
        clock = 0;
        forever #5 clock = ~clock; // 10 time unit clock period
    end

    // Test sequence
    initial
    begin
        // Initialize inputs
        reset = 1;
        read = 0;
        address = 0;

        // Apply reset
        #10 reset = 0;

        // Test read operation
        #10 read = 1; address = 6'd0; // Fetch instructions starting from address 0
        wait (!busywait); // Wait for the busywait to de-assert
        #10 read = 0;

        #20 read = 1; address = 6'd1; // Fetch instructions starting from address 1
        wait (!busywait);
        #10 read = 0;

        // End simulation
        #50 $finish;
    end

    // Monitor signals
    initial
    begin
        $monitor("Time: %0d | Reset: %b | Read: %b | Address: %h | ReadInst: %h | Busywait: %b",
                 $time, reset, read, address, readinst, busywait);
    end

endmodule