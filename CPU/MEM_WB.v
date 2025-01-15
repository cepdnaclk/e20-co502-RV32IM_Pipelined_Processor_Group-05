module MEM_WB( CLK,RESET,BUSYWAIT,
        MUX3_SELECT_IN,REGWRITE_ENABLE_IN,ALUOUT_IN,MEM_IN,RD_IN,
        MUX3_SELECT_OUT,REGWRITE_ENABLE_OUT,ALUOUT_OUT,MEM_OUT,RD_OUT
        );
    input CLK;
    input RESET;
    input BUSYWAIT;    
    input MUX3_SELECT_IN;
    input REGWRITE_ENABLE_IN;
    input [31:0] ALUOUT_IN;
    input [31:0] MEM_IN;
    input [4:0] RD_IN;
    output reg MUX3_SELECT_OUT;
    output reg REGWRITE_ENABLE_OUT;
    output reg [31:0] ALUOUT_OUT;
    output reg [31:0] MEM_OUT;
    output reg [4:0] RD_OUT;

    always @(posedge CLK) begin
        if (RESET==1'b1) begin
            MUX3_SELECT_OUT=1'b0;
            REGWRITE_ENABLE_OUT=1'b0;
            ALUOUT_OUT=1'b0;
            MEM_OUT=1'b0;
            RD_OUT=1'b0;
        end 
        else if (BUSYWAIT == 1'b0) begin
            #2
            MUX3_SELECT_OUT <= MUX3_SELECT_IN;
            REGWRITE_ENABLE_OUT <= REGWRITE_ENABLE_IN;
            ALUOUT_OUT <= ALUOUT_IN;
            MEM_OUT <= MEM_IN;
            RD_OUT <= RD_IN;
        end
    end

endmodule