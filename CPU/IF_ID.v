module IF_ID(CLK,RESET,PC_PLUS_FOUR_IN,PC_IN,INSTRUCTION_IN,PC_PLUS_FOUR_OUT,PC_OUT,INSTRUCTION_OUT);
    input CLK;
    input RESET;
    input [31:0] PC_PLUS_FOUR_IN;
    input [31:0] PC_IN;
    input [31:0] INSTRUCTION_IN;
    output reg [31:0] PC_PLUS_FOUR_OUT;
    output reg [31:0] PC_OUT;
    output reg [31:0] INSTRUCTION_OUT;

    always @(posedge CLK) begin
        if (RESET==1'b1) begin
            PC_OUT=32'd0;
            PC_PLUS_FOUR_OUT=32'd0;
            INSTRUCTION_OUT=32'd0;    
        end 
        else begin
            #2
            INSTRUCTION_OUT <= INSTRUCTION_IN;
            PC_PLUS_FOUR_OUT <= PC_PLUS_FOUR_IN;
            PC_OUT <= PC_IN;
        end   
    end
endmodule
