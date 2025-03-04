module Forwarding_Unit(rs1,rs2,data1,data2,rd1,rd2,EX_MEM_data,MEM_WB_data,rs1_out,rs2_out);
    input [4:0] rs1,rs2,rd1,rd2;
    input [31:0] EX_MEM_data, MEM_WB_data,data1,data2;
    output reg [31:0] rs1_out,rs2_out;
    
    always @ (*) begin
        if (rd1 == rs1) begin
            rs1_out = EX_MEM_data;
        end
        else if (rd2 == rs1) begin
            rs1_out = MEM_WB_data;
        end
        else begin
            rs1_out = data1;
        end
        
        if (rd1 == rs2) begin
            rs2_out = EX_MEM_data;
        end
        else if (rd2 == rs2) begin
            rs2_out = MEM_WB_data;
        end
        else begin
            rs2_out = data2;
        end
    end

endmodule 