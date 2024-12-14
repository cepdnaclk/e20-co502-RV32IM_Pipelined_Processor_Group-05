    /******************************************
    *  Author : Ariyarathna D.B.S
    *  Created On : 2024-12-14
    *  File : Immediate_extend.v
    *******************************************/

    /******************************************
    *  Module: Immediate_extend
    *  Purpose: This module is used to extend the immediate value to 32 bits.
    *  Functions: This module has the following functions:
    *             1. immediate_extend: This function extends the immediate value to 32 bits.
    * Inputs: instruction[31:7]
    * for I type : instruction[31:20]
    * for R type : instruction[31:25] 
    * for S type : instruction[31:25] & instruction[11:7]
    * for B type : instruction[31] & instruction[7] & instruction[30:25] & instruction[11:8]
    * for U type : instruction[31:12]
    * for J type : instruction[31] & instruction[19:12] & instruction[20] & instruction[30:21]
    * Outputs: imm_value[31:0]
    *******************************************/

module immediate_extend(imm_value,extended_imm_value,imm_select);

    // Inputs
    input [31:0] imm_value;
    input [2:0] imm_select;

    // Outputs
    output [31:0] extended_imm_value;

    // Internal Registers
    reg [31:0] extended_imm_value;

    // decode the instruction to immediate value
    wire I_imm = imm_value[31:20];
    wire R_imm = imm_value[31:25];
    wire S_imm_1 = imm_value[31:25];
    wire S_imm_2 = imm_value[11:7];
    wire B_imm_1 = imm_value[31];
    wire B_imm_2 = imm_value[7];
    wire B_imm_3 = imm_value[30:25];
    wire B_imm_4 = imm_value[11:8];
    wire U_imm = imm_value[31:12];
    wire J_imm_1 = imm_value[31];
    wire J_imm_2 = imm_value[19:12];
    wire J_imm_3 = imm_value[20];
    wire J_imm_4 = imm_value[30:21];

    // extend the immediate value to 32 bits
    always @(*)
    begin
        case(imm_select)
            3'b000: extended_imm_value = {I_imm, {12{I_imm[11]}}}; // I type
            3'b001: extended_imm_value = {R_imm, {20{R_imm[4]}}}; // R type
            3'b010: extended_imm_value = {S_imm_1, {20{S_imm_1[4]}}, S_imm_2}; // S type
            3'b011: extended_imm_value = {B_imm_1, {19{B_imm_1[0]}}, B_imm_2, {11{B_imm_2[0]}}, B_imm_3, B_imm_4, 1'b0}; // B type
            3'b100: extended_imm_value = {U_imm}; // U type
            3'b101: extended_imm_value = {J_imm_1, {10{J_imm_1[0]}}, J_imm_2, J_imm_3, J_imm_4, 1'b0}; // J type
            default: extended_imm_value = 0;
        endcase
    end

endmodule


            
