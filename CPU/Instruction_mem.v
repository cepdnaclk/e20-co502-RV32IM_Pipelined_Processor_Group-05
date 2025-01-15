`timescale 1ns/100ps

module instruction_memory(
    input              clock,
    input              reset,
    input              read,
    input      [5:0]   address,
    output reg [127:0] readinst,
    output reg         busywait
);

// Declare memory array 1024x8-bits 
reg [7:0] memory_array [1023:0]; // 1024 bytes memory array

// Internal signal to track read access
reg readaccess;

// Initialize instruction memory
initial
begin
    busywait = 0;
    readaccess = 0;

    // Sample program hardcoded with updated instructions
    
    // Load 3 into R1 (LOADI R1, 3)
    {memory_array[3], memory_array[2], memory_array[1], memory_array[0]} = 32'b00000000000000010000000000000011; // loadi R1, 3
    
    // Load 2 into R2 (LOADI R2, 2)
    {memory_array[7], memory_array[6], memory_array[5], memory_array[4]} = 32'b00000000000000100000000000000010; // loadi R2, 2
    
    // Add R1 and R2, store result in R3 (ADD R3, R1, R2)
    {memory_array[11], memory_array[10], memory_array[9], memory_array[8]} = 32'b00000000000000100000000100011000; // add R3, R1, R2
    
    // Load 90 into R1 (LOADI R1, 90)
    {memory_array[15], memory_array[14], memory_array[13], memory_array[12]} = 32'b00000000000000010000000001011010; // loadi R1, 90
    
    // Sub R1, R1, R4 (SUB R1, R1, R4)
    {memory_array[19], memory_array[18], memory_array[17], memory_array[16]} = 32'b00000011000000010000000100000100; // sub R1, R1, R4
end

// Reset Logic
always @(posedge clock or posedge reset)
begin
    if (reset)
    begin
        busywait <= 0;
        readaccess <= 0;
        readinst <= 128'b0;
    end
end

// Detecting an incoming memory access
always @(posedge clock)
begin
    if (read && !busywait)
    begin
        busywait <= 1;
        readaccess <= 1;
    end
end

// Reading
always @(posedge clock)
begin
    if (readaccess)
    begin
        // Fetch 16 bytes (128 bits) from consecutive memory locations
        // The address is a 6-bit value, so multiply it by 4 to correctly index the 32-bit instruction
        readinst[7:0]     <= #40 memory_array[address*4 + 0];
        readinst[15:8]    <= #40 memory_array[address*4 + 1];
        readinst[23:16]   <= #40 memory_array[address*4 + 2];
        readinst[31:24]   <= #40 memory_array[address*4 + 3];
        readinst[39:32]   <= #40 memory_array[address*4 + 4];
        readinst[47:40]   <= #40 memory_array[address*4 + 5];
        readinst[55:48]   <= #40 memory_array[address*4 + 6];
        readinst[63:56]   <= #40 memory_array[address*4 + 7];
        readinst[71:64]   <= #40 memory_array[address*4 + 8];
        readinst[79:72]   <= #40 memory_array[address*4 + 9];
        readinst[87:80]   <= #40 memory_array[address*4 + 10];
        readinst[95:88]   <= #40 memory_array[address*4 + 11];
        readinst[103:96]  <= #40 memory_array[address*4 + 12];
        readinst[111:104] <= #40 memory_array[address*4 + 13];
        readinst[119:112] <= #40 memory_array[address*4 + 14];
        readinst[127:120] <= #40 memory_array[address*4 + 15];
        
        busywait <= 0;
        readaccess <= 0;
    end
end

endmodule
