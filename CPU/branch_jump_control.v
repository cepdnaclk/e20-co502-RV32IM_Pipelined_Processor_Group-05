`timescale 1ns/100ps

module branch_jump_control(
    input  BRANCH,
    input  JUMP,
    input  ZERO,
    input [31:0] ALU_OUT,
    input [2:0] Func3,

    input [31:0] PC,
    input [31:0] IMM_VALUE,

    output reg [31:0] NEXT_PC,
    output reg MUX_SELECT,
    output reg FLUSH
);

    always @(*) begin
        if (BRANCH) begin
            case (Func3)
                3'b000: // BEQ
                    if (ZERO) begin
                        MUX_SELECT = 1;
                        NEXT_PC = PC + IMM_VALUE;
                        FLUSH = 1;
                    end
                    else begin
                        MUX_SELECT = 0;
                        NEXT_PC = PC + 4;
                        FLUSH = 0;
                    end
                3'b001: // BNE
                    if (!ZERO) begin
                        MUX_SELECT = 1;
                        NEXT_PC = PC + IMM_VALUE;
                        FLUSH = 1;
                    end
                    else begin
                        MUX_SELECT = 0;
                        NEXT_PC = PC + 4;
                        FLUSH = 0;
                    end
                3'b100: // BLT
                    if (ALU_OUT[0]) begin
                        MUX_SELECT = 1;
                        NEXT_PC = PC + IMM_VALUE;
                        FLUSH = 1;
                    end
                    else begin
                        MUX_SELECT = 0;
                        NEXT_PC = PC + 4;
                        FLUSH = 0;
                    end
                3'b101: // BGE
                    if (!ALU_OUT[0]) begin
                        MUX_SELECT = 1;
                        NEXT_PC = PC + IMM_VALUE;
                        FLUSH = 1;
                    end
                    else begin
                        MUX_SELECT = 0;
                        NEXT_PC = PC + 4;
                        FLUSH = 0;
                    end
                3'b110: // BLTU
                    if (ALU_OUT[0]) begin
                        MUX_SELECT = 1;
                        NEXT_PC = PC + IMM_VALUE;
                        FLUSH = 1;
                    end
                    else begin
                        MUX_SELECT = 0;
                        NEXT_PC = PC + 4;
                        FLUSH = 0;
                    end
                3'b111: // BGEU
                    if (!ALU_OUT[0]) begin
                        MUX_SELECT = 1;
                        NEXT_PC = PC + IMM_VALUE;
                        FLUSH = 1;
                    end
                    else begin
                        MUX_SELECT = 0;
                        NEXT_PC = PC + 4;
                        FLUSH = 0;
                    end
                default: begin
                    MUX_SELECT = 0;
                    NEXT_PC = PC + 4;
                    FLUSH = 0;
                end
            endcase
        end
        else if (JUMP) begin
            MUX_SELECT = 1;
            NEXT_PC = PC + IMM_VALUE;
            FLUSH = 1;
        end
        else begin
            MUX_SELECT = 0;
            NEXT_PC = PC + 4;
            FLUSH = 0;
        end
    end



endmodule