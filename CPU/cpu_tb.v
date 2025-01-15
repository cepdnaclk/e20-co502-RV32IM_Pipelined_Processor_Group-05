`timescale 1ns/100ps

`include "cpu_ex.v" // Include the CPU module

module CPU_tb;

    // Testbench signals
    reg CLK, RESET;
    reg [31:0] INSTRUCTION, READ_DATA;
    wire MEM_READ, MEM_WRITE;
    wire [31:0] MEM_WRITE_DATA, MEM_ADDRESS;

    // Instantiate the CPU
    CPU uut (
        .CLK(CLK),
        .RESET(RESET),
        .INSTRUCTION(INSTRUCTION),
        .READ_DATA(READ_DATA),
        .MEM_READ(MEM_READ),
        .MEM_WRITE(MEM_WRITE),
        .MEM_WRITE_DATA(MEM_WRITE_DATA),
        .MEM_ADDRESS(MEM_ADDRESS)
    );

    // Clock generation (50MHz clock)
    always begin
        #5 CLK = ~CLK;  // Toggle clock every 5ns
    end

    // Stimulus generation
    initial begin
        // Initialize signals
        CLK = 0;
        RESET = 0;
        INSTRUCTION = 32'h00000000; // Set initial instruction value
        READ_DATA = 32'h00000000;   // Set read data to 0

        // Open the VCD dump file for GTKWave
        $dumpfile("cpu_tb.vcd");
        $dumpvars(0, CPU_tb);

        // Apply reset
        RESET = 1;
        #10 RESET = 0;  // Reset pulse duration

        // Apply test stimulus (Load values to registers, then perform an ADD)
        #10 INSTRUCTION = 32'b00000000000000010000000000000001; // ADDI R1, R0, 1 (Load immediate 1 to R1)
        #10 INSTRUCTION = 32'b00000000000000100000000000000010; // ADDI R2, R0, 2 (Load immediate 2 to R2)
        #10 INSTRUCTION = 32'b00000000001000001000000110110011; // ADD R1, R2, R3 (ADD R1 = R2 + R3)

        // Check results after a few cycles
        #50 INSTRUCTION = 32'h00000000; // NOP (no operation)
        #50 INSTRUCTION = 32'h00000000; // NOP (no operation)

        // End simulation after a certain number of cycles
        #100 $finish;
    end

    // Monitor register values (outputs)
    initial begin
        $monitor("Time = %0t, R1 = %h, R2 = %h, R3 = %h", $time, uut.regfile.REGISTER_FILE[1], uut.regfile.REGISTER_FILE[2], uut.regfile.REGISTER_FILE[3]);
    end

endmodule
