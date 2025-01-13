module EX_MEM(CLK,RESET,BUSYWAIT,
        MEM_WRITE_IN,MEM_READ_IN,MUX3_SELECT_IN,REGWRITE_ENABLE_IN,ALUUD_IN,DATA2_IN,FUNC3_IN,RD_IN,
        MEM_WRITE_OUT,MEM_READ_OUT,MUX3_SELECT_OUT,REGWRITE_ENABLE_OUT,ALUUD_OUT,DATA2_OUT,FUNC3_OUT,RD_OUT
        );

    input CLK;
    input RESET;
    input BUSYWAIT;
    input MEM_WRITE_IN;
    input MEM_READ_IN;
    input MUX3_SELECT_IN;
    input REGWRITE_ENABLE_IN;
    input [31:0] ALUUD_IN;
    input [31:0] DATA2_IN;
    input [2:0] FUNC3_IN;
    input [4:0] RD_IN;
    output reg MEM_WRITE_OUT;
    output reg MEM_READ_OUT;
    output reg MUX3_SELECT_OUT;
    output reg REGWRITE_ENABLE_OUT;
    output reg [31:0] ALUUD_OUT;
    output reg [31:0] DATA2_OUT;
    output reg [2:0] FUNC3_OUT;
    output reg [4:0] RD_OUT;

    always @(posedge CLK) begin
        if (RESET==1'b1) begin
            MEM_READ_OUT=1'b0;
            MEM_READ_OUT=1'b0;
            MUX3_SELECT_OUT=1'b0;
            REGWRITE_ENABLE_OUT=1'b0;
            ALUUD_OUT=1'b0;
            DATA2_OUT=1'b0;
            FUNC3_OUT=1'b0;
            RD_OUT=1'b0;
        end 
        else if (BUSYWAIT == 1'b0) begin
            #2
            MEM_READ_OUT <= MEM_READ_IN;
            MEM_WRITE_OUT <= MEM_WRITE_IN;
            MUX3_SELECT_OUT <= MUX3_SELECT_IN;
            REGWRITE_ENABLE_OUT <= REGWRITE_ENABLE_IN;
            ALUUD_OUT <= ALUUD_IN;
            DATA2_OUT <= DATA2_IN;
            FUNC3_OUT <= FUNC3_IN;
            RD_OUT <= RD_IN;
        end  
    end
endmodule