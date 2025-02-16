`timescale 1ns/100ps

module Register_file_tb;
    // Testbench signals
    reg [4:0] ADRS1, ADRS2, WB_ADDRESS;
    reg WRITE_ENABLE, CLK, RESET;
    reg [31:0] WRITE_DATA;
    wire [31:0] DATA_OUT1, DATA_OUT2;
    
    // Instantiate the register file
    Register_file rf (
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
    
    // Clock generation
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;  // 100MHz clock
    end
    
    // Test stimulus
    initial begin
        // Initialize waveform dumping
        $dumpfile("register_file_tb.vcd");
        $dumpvars(0, Register_file_tb);
        
        // Initialize signals
        RESET = 0;
        WRITE_ENABLE = 0;
        ADRS1 = 0;
        ADRS2 = 0;
        WB_ADDRESS = 0;
        WRITE_DATA = 0;
        
        // Test 1: Apply reset
        #10 RESET = 1;
        #20 RESET = 0;
        
        // Test 2: Read initial values after reset
        #10;
        ADRS1 = 5'd1;  // Read from x1
        ADRS2 = 5'd2;  // Read from x2
        #10;
        $display("After reset - x1: %h, x2: %h", DATA_OUT1, DATA_OUT2);
        
        // Test 3: Write new values
        #10;
        WRITE_ENABLE = 1;
        WB_ADDRESS = 5'd15;  // Write to x15
        WRITE_DATA = 32'hAAAA_AAAA;
        #10;
        
        // Test 4: Read written values
        ADRS1 = 5'd15;  // Read from x15
        #10;
        $display("After write - x15: %h", DATA_OUT1);
        
        // Test 5: Try to write to x0 (should remain 0)
        WB_ADDRESS = 5'd0;
        WRITE_DATA = 32'hFFFF_FFFF;
        #10;
        ADRS1 = 5'd0;
        #10;
        $display("After attempting write to x0: %h", DATA_OUT1);
        
        // Test 6: Write multiple values
        WB_ADDRESS = 5'd20;
        WRITE_DATA = 32'h1234_5678;
        #10;
        WB_ADDRESS = 5'd21;
        WRITE_DATA = 32'h8765_4321;
        #10;
        
        // Test 7: Read multiple values simultaneously
        ADRS1 = 5'd20;
        ADRS2 = 5'd21;
        #10;
        $display("Multiple reads - x20: %h, x21: %h", DATA_OUT1, DATA_OUT2);
        
        // Test 8: Test write enable functionality
        WRITE_ENABLE = 0;
        WB_ADDRESS = 5'd25;
        WRITE_DATA = 32'hDEAD_BEEF;
        #10;
        ADRS1 = 5'd25;
        #10;
        $display("After write with WE=0 - x25: %h", DATA_OUT1);
        
        // Print final register contents
        rf.print_registers();
        
        // End simulation
        #100 $finish;
    end
    
endmodule