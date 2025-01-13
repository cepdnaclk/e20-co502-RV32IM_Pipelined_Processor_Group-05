/*****************************
** Module: Twos_complement **
******************************/


module twos_complement_selector (
    input [31:0] DATA2,      // 32-bit input data
    input select,             // Select signal: 0 = Data2, 1 = 2's complement of Data2
    output reg [31:0] DATA2_OUT    // Output data (either Data2 or its 2's complement)
);

    always @(*) begin
        if (select == 1) begin
            DATA2_OUT= ~DATA2 + 1;  // 2's complement of Data2
        end else begin
            DATA2_OUT= DATA2;       // Directly pass Data2
        end
    end

endmodule
