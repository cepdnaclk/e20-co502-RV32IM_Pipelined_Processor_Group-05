module ID_EX(CLK,RESET,PC_PLUS_FOUR_IN,PC_IN,IMM_IN,DATA1_IN,DATA2_IN,FUNC3_IN,RD_IN,ALU_IN,MUX1_IN,MUX2_IN,MUX3_IN,REGWRITE_IN,MEMWRITE_IN,MEMREAD_IN,BRANCH_IN,JUMP_IN,JAL_IN,PC_PLUS_FOUR_OUT,PC_OUT,IMM_OUT,,ALU_OUT,MUX1_OUT,MUX2_OUT,MUX3_OUT,REGWRITE_OUT,MEMWRITE_OUT,MEMREAD_OUT,BRANCH_OUT,JUMP_OUT,JAL_OUT,DATA1_OUT,DATA2_OUT,FUNC3_OUT,RD_OUT);
    input CLK;
    input RESET;

    input [31:0] PC_PLUS_FOUR_IN;
    input [31:0] PC_IN;
    input [31:0] IMM_IN;
    input [31:0] DATA1_IN;
    input [31:0] DATA2_IN;
    input [2:0] FUNC3_IN;
    input [4:1] RD_IN;

    input [4:1] ALU_IN;
    input  MUX1_IN;
    input  MUX2_IN;
    input  MUX3_IN;
    input  REGWRITE_IN;
    input  MEMWRITE_IN;
    input  MEMREAD_IN;
    input  BRANCH_IN;
    input  JUMP_IN;
    input  JAL_IN;
    
    output reg [31:0] PC_PLUS_FOUR_OUT;
    output reg [31:0] PC_OUT;
    output reg [31:0] IMM_OUT;
    output reg [31:0] DATA1_OUT;
    output reg [31:0] DATA2_OUT;
    output reg [2:0] FUNC3_OUT;
    output reg [4:1] RD_OUT;

    output reg [4:1] ALU_OUT;
    output reg MUX1_OUT;
    output reg MUX2_OUT;
    output reg MUX3_OUT;
    output reg REGWRITE_OUT;
    output reg MEMWRITE_OUT;
    output reg MEMREAD_OUT;
    output reg BRANCH_OUT;
    output reg JUMP_OUT;
    output reg JAL_OUT;
    

    always @(posedge CLK) begin
        if (RESET==1'b1) begin
            PC_OUT=32'd0;
            PC_PLUS_FOUR_OUT=32'd0;
            IMM_OUT=32'd0;  
            DATA1_OUT=32'd0;
            DATA2_OUT=32'd0;
            FUNC3_OUT=3'd0;
            RD_OUT=5'd0;
            ALU_OUT=5'd0;
            MUX1_OUT=1'b0;
            MUX2_OUT=1'b0;
            MUX3_OUT=1'b0;
            REGWRITE_OUT=1'b0;
            MEMWRITE_OUT=1'b0;
            MEMREAD_OUT=1'b0;
            BRANCH_OUT=1'b0;
            JUMP_OUT=1'b0;
            JAL_OUT=1'b0;

        end 
        else begin
            #2
            IMM_OUT <= IMM_IN;
            PC_PLUS_FOUR_OUT <= PC_PLUS_FOUR_IN;
            PC_OUT <= PC_IN;
            DATA1_OUT <= DATA1_IN;
            DATA2_OUT <= DATA2_IN;
            FUNC3_OUT <= FUNC3_IN;
            RD_OUT <= RD_IN;
            ALU_OUT <= ALU_IN;
            MUX1_OUT <= MUX1_IN;
            MUX2_OUT <= MUX2_IN;
            MUX3_OUT <= MUX3_IN;
            REGWRITE_OUT <= REGWRITE_IN;
            MEMWRITE_OUT <= MEMWRITE_IN;
            MEMREAD_OUT <= MEMREAD_IN;
            BRANCH_OUT <= BRANCH_IN;
            JUMP_OUT <= JUMP_IN;
            JAL_OUT <= JAL_IN;

        end   
    end
endmodule
