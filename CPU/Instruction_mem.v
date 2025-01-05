module instruction_memory(
    input clock,           // Clock signal
    input read,            // Read signal
    input [4:0] address,   // 5-bit instruction address
    output reg [31:0] instruction, // Output instruction
    output reg busywait    // Busy signal to indicate memory access
);

    // Internal memory array (32 locations, each 32 bits wide)
    reg [31:0] memory_array [31:0];

    // Initialize instruction memory
    initial begin
        busywait = 0;

        // Load sample instructions for ALU operations
        memory_array[0] = 32'b00000000000000110000000000100001; // ADD R1, R2, R3
        memory_array[1] = 32'b00000000000001000000000000100010; // SUB R1, R2, R4
        memory_array[2] = 32'b00000000000001010000000000100100; // AND R1, R2, R5
        memory_array[3] = 32'b00000000000001100000000000100101; // OR  R1, R2, R6
        memory_array[4] = 32'b00000000000001110000000000101000; // MUL R1, R2, R7
        memory_array[5] = 32'b00000000000010000000000000101001; // DIV R1, R2, R8
        memory_array[6] = 32'b00000000000010010000000000100011; // SLT R1, R2, R9
        memory_array[7] = 32'b00000000000010100000000000100111; // XOR R1, R2, R10

        // Additional instructions can be added as needed
    end

    // Detect read signal
    always @(posedge clock) begin
        if (read) begin
            busywait <= 1; // Indicate memory is busy
            #5;            // Simulate memory access delay
            instruction <= memory_array[address]; // Fetch instruction
            busywait <= 0; // Indicate memory is ready
        end
    end

endmodule
