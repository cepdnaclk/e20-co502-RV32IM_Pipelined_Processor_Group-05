
`include "mux_2x1_32bit.v"

module program_counter(
    input         clock,
    input         reset,
    input  [31:0] branch_address,
    input         branch_enable,      // Control signal for branching
    output reg [31:0] pc              // Program counter output
);

// Default PC increment value
parameter PC_INCREMENT = 4;

// Internal signals
wire [31:0] next_pc;
wire [31:0] incremented_pc;

// Increment PC value
assign incremented_pc = pc + PC_INCREMENT;

// Instantiate the MUX to select between incremented PC or branch address
mux_2x1_32bit u_mux_2x1_32bit (
    .IN0(incremented_pc), 
    .IN1(branch_address), 
    .OUT(next_pc), 
    .SELECT(branch_enable)
);

// PC update logic
always @(posedge clock or posedge reset) begin
    if (reset) begin
        pc <= 32'd0; // Reset PC to 0
    end 
    else begin
        pc <= next_pc; // Update PC based on MUX output
    end
end

endmodule
