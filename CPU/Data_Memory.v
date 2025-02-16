module Data_Memory (
    input               Read,
    input               Write,
    input               Clock,
    input               Reset,
    input [31:0]        Address,
    input [31:0]        Write_data,
    input [2:0]         Func3,
    output reg [31:0]   Read_data,
    output reg          busywait
);

    reg [31:0] memory [0:1023];
    reg read_access, write_access;
    
    // Synchronous memory access control
    always @(posedge Clock) begin
        if (Reset) begin
            busywait <= 0;
            read_access <= 0;
            write_access <= 0;
        end
        else begin
            if (Read || Write) begin
                busywait <= 1;
                read_access <= Read && !Write;
                write_access <= Write && !Read;
            end
            else if (read_access || write_access) begin
                busywait <= 0;
                read_access <= 0;
                write_access <= 0;
            end
        end
    end
    
    // Memory read operation
    always @(*) begin
        if (read_access) begin
            case (Func3)
                3'b000: // LB (Load Byte - Signed)
                    Read_data <= {{24{memory[Address[31:2]][(Address[1:0] * 8) + 7]}}, 
                                 memory[Address[31:2]][Address[1:0] * 8 +: 8]};
                3'b001: // LH (Load Halfword - Signed)
                    Read_data <= {{16{memory[Address[31:2]][(Address[1] * 16) + 15]}}, 
                                 memory[Address[31:2]][Address[1] * 16 +: 16]};
                3'b010: // LW (Load Word)
                    Read_data <= memory[Address[31:2]];
                3'b100: // LBU (Load Byte - Unsigned)
                    Read_data <= {24'b0, memory[Address[31:2]][Address[1:0] * 8 +: 8]};
                3'b101: // LHU (Load Halfword - Unsigned)
                    Read_data <= {16'b0, memory[Address[31:2]][Address[1] * 16 +: 16]};
                default:
                    Read_data <= 32'b0;
            endcase
        end
    end

    // Memory write operation
    always @(posedge Clock) begin
        if (write_access) begin
            case (Func3)
                3'b000: // SB (Store Byte)
                    memory[Address[31:2]][Address[1:0] * 8 +: 8] <= Write_data[7:0];
                3'b001: // SH (Store Halfword)
                    memory[Address[31:2]][Address[1] * 16 +: 16] <= Write_data[15:0];
                3'b010: // SW (Store Word)
                    memory[Address[31:2]] <= Write_data;
            endcase
        end
    end

    // Reset memory
    integer i;
    always @(posedge Reset) begin
        if (Reset) begin
            for (i = 0; i < 1024; i = i + 1)
                memory[i] <= 0;
        end
    end

    initial begin
        $dumpfile("cpu_tb.vcd");
        for (i = 0; i < 1024; i = i + 1)
            $dumpvars(0, memory[i]);
    end

endmodule
