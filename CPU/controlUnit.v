    `timescale 1ns/100ps
    
    /******************************************
    *  Author : Senavirathna A.P.B.P.
    *  Created On : 2024-12-13
    *  File : controlUnit.v
    *******************************************/

    /******************************************
    
    *  Module: controlUnit
    *  Purpose: This module is used to control the operations of the processor.
    *  Functions: This module  controls the operations of the processor.
    
    * Inputs: INSTRUCTION
    * Outputs: MUX1, MUX2, MUX3, REGISTERWRITE, MEMORYWRITE, MEMORYREAD, BRANCH, JUMP, JAL, ALUOP, IMMEDIATE

    *******************************************/

    /*
    ***********   Instruction set   ***********

    Control signals

    Unit            0                       1
    Multiplexer     select 0 input          select 1 input
    REGISTERWRITE   Register Write disale   Register write enable
    MEMORYWRITE     Memory Write disale     Memory write enable
    MEMORYREAD      Memory Read disale      Memory Read enable
    BRANCH          No branch               Branch
    JUMP            No jump                 Jump
    JAL             No jal                  Jal

    ALU operations
    ALUOP   Operation   Description
    00000   add         additon
    00001   sll         shift left logical
    00010   slt         set less than 
    00011   sltu        set less than unsigned
    00100   xor         bitwise xor
    00101   srl         shift right logical
    00110   or          bitwise or
    00111   and         bitwise and
    01000   mul         multiply
    01001   mulh        multiply high
    01010   mulhsu      multiply high signed/unsigned
    01011   mulhu       multiply high unsigned
    01100   div         divide
    01101   rem         remainder
    01111   remu        remainder unsigned
    10000               pass the value
  * 10001   sub         subtraction
  * 10010   sra         shift right arithmetic

    Immidiate values

    INstruction         IMM
    R-type              000
    U-type              000
    I-type              001
    I-type srli/srai    010
    S-type              011
    B-type              100
    J-type              101



    R-type instructions 

        Instruction  OP-Code   Funct3  Funct7     ALUOP  MUX1  MUX2  MUX3 REGISTERWRITE MEMORYWRITE MEMORYREAD BRANCH  JUMP JAL  IMM TWOSCOMP
        add          0110011   000     0000000    00000    1     1     0    1             0           0          0      0    0   000  0
        sub          0110011   000     0100000    00000    1     1     0    1             0           0          0      0    0   000  1
        sll          0110011   001     0000000    00001    1     1     0    1             0           0          0      0    0   000  0
        slt          0110011   010     0000000    00010    1     1     0    1             0           0          0      0    0   000  0 
        sltu         0110011   011     0000000    00011    1     1     0    1             0           0          0      0    0   000  0
        xor          0110011   100     0000000    00100    1     1     0    1             0           0          0      0    0   000  0
        srl          0110011   101     0000000    00101    1     1     0    1             0           0          0      0    0   000  0
        sra          0110011   101     0100000    00101    1     1     0    1             0           0          0      0    0   000  1
        or           0110011   110     0000000    00110    1     1     0    1             0           0          0      0    0   000  0
        and          0110011   111     0000000    00111    1     1     0    1             0           0          0      0    0   000  0
        mul          0110011   000     0111011    01000    1     1     0    1             0           0          0      0    0   000  0
        mulh         0110011   001     0111011    01001    1     1     0    1             0           0          0      0    0   000  0
        mulhsu       0110011   010     0111011    01010    1     1     0    1             0           0          0      0    0   000  0
        mulhu        0110011   011     0111011    01011    1     1     0    1             0           0          0      0    0   000  0
        div          0110011   100     0111011    01100    1     1     0    1             0           0          0      0    0   000  0
        rem          0110011   110     0111011    01101    1     1     0    1             0           0          0      0    0   000  0
        remu         0110011   111     0111011    01111    1     1     0    1             0           0          0      0    0   000  0

    I-type instructions

        Instruction  OP-Code   Funct3  ALUOP  MUX1  MUX2  MUX3 REGISTERWRITE MEMORYWRITE MEMORYREAD BRANCH  JUMP JAL  IMM TWOSCOMP
        lb           0000011   000     10000    1     1     1    1             0           1          0      0    0   001  0
        lh           0000011   001     10000    1     1     1    1             0           1          0      0    0   001  0
        lw           0000011   010     10000    1     1     1    1             0           1          0      0    0   001  0 
        lbu          0000011   100     10000    1     1     1    1             0           1          0      0    0   001  0
        lhu          0000011   101     10000    1     1     1    1             0           1          0      0    0   001  0
        
        addi         0010011   000     00000    1     0     0    1             0           0          0      0    0   001  0
        slli         0010011   001     00001    1     0     0    1             0           0          0      0    0   001  0
        slti         0010011   010     00010    1     0     0    1             0           0          0      0    0   001  0
        sltiu        0010011   011     00011    1     0     0    1             0           0          0      0    0   001  0
        xori         0010011   100     00100    1     0     0    1             0           0          0      0    0   001  0
        srli *       0010011   101     00101    1     0     0    1             0           0          0      0    0   010 *0
        srai *       0010011   101     00101    1     0     0    1             0           0          0      0    0   010 *1
        ori          0010011   110     00110    1     0     0    1             0           0          0      0    0   001  0
        andi         0010011   111     00111    1     0     0    1             0           0          0      0    0   001  0

        jalr         1100111   000     00000    1     0     0    1             0           0          0      1    1   001  0

    S-type instructions

        Instruction  OP-Code   Funct3  ALUOP  MUX1  MUX2  MUX3 REGISTERWRITE MEMORYWRITE MEMORYREAD BRANCH  JUMP JAL  IMM TWOSCOMP
        sb           0100011   000     00000    1     1     X    0             1           0          0      0    0   011  0
        sh           0100011   001     00000    1     1     X    0             1           0          0      0    0   011  0
        sw           0100011   010     00000    1     1     X    0             1           0          0      0    0   011  0
        sbu          0100011   100     00000    1     1     X    0             1           0          0      0    0   011  0
        shu          0100011   101     00000    1     1     X    0             1           0          0      0    0   011  0

    U-type instructions

        Instruction  OP-Code   ALUOP  MUX1  MUX2  MUX3 REGISTERWRITE MEMORYWRITE MEMORYREAD BRANCH  JUMP JAL  IMM TWOSCOMP
        auipc        0010111   00000    0     0     0    1             0           0          0      0    0   000  0
        lui          0110111   10000    0     0     0    1             0           0          0      0    0   000  0

    B-type instructions

        Instruction  OP-Code   Funct3  ALUOP  MUX1  MUX2  MUX3 REGISTERWRITE MEMORYWRITE MEMORYREAD BRANCH  JUMP JAL  IMM  TWOSCOMP
        beq          1100011   000     00000    1     0     0    0             0           0          1      0    1   100  1 
        bne          1100011   001     00000    1     0     0    0             0           0          1      0    1   100  1
        blt          1100011   100     00010    1     0     0    0             0           0          1      0    1   100  0
        bge          1100011   101     00010    1     0     0    0             0           0          1      0    1   100  0
        bltu         1100011   110     00011    1     0     0    0             0           0          1      0    1   100  0
        bgeu         1100011   111     00011    1     0     0    0             0           0          1      0    1   100  0

    J-type instructions

        Instruction  OP-Code  ALUOP  MUX1  MUX2  MUX3 REGISTERWRITE MEMORYWRITE MEMORYREAD BRANCH  JUMP JAL  IMM TWOSCOMP
        jal          1101111  00000    0     0     X    1             0           0          0      1    1   101  0


    *******************************************/

module controlUnit(INSTRUCTION, MUX1, MUX2, MUX3, ALUOP,REGISTERWRITE, MEMORYWRITE, MEMORYREAD, BRANCH, JUMP, JAL, IMMEDIATE, TWOSCOMP);
    input [31:0] INSTRUCTION;
    reg [7:0] OPCODE;
    reg [2:0] FUNCT3;
    reg [6:0] FUNCT7;

    output reg MUX1, MUX2 , MUX3, REGISTERWRITE, MEMORYWRITE, MEMORYREAD, BRANCH, JUMP, JAL, TWOSCOMP;
    output reg  [4:0] ALUOP;
    output reg [2:0] IMMEDIATE;
    


always @(INSTRUCTION) //Decoding the instruction 
    begin
        OPCODE = INSTRUCTION[6:0];
        FUNCT3 = INSTRUCTION[14:12];
        FUNCT7 = INSTRUCTION[31:25];
        
        // Add decoding logic here based on OPCODE, FUNCT3, and FUNCT7
        // Use the decoded values to set the control signals

        case(OPCODE)

        // R-type instructions

            7'b0110011: begin
                case(FUNCT3)
                    3'b000: begin
                        case(FUNCT7)

                            // add, sll, slt, sltu, xor, or, and
                            7'b0000000: begin
                                assign ALUOP = {2'b00, FUNCT3}; //extend Funct3 to 5 bits by adding 00 in the MSB
                                assign MUX1 = 1;
                                assign MUX2 = 1;
                                assign MUX3 = 0;
                                assign REGISTERWRITE = 1;
                                assign MEMORYWRITE = 0;
                                assign MEMORYREAD = 0;
                                assign BRANCH = 0;
                                assign JUMP = 0;
                                assign JAL = 0;
                                assign IMMEDIATE = 3'b000;
                                assign TWOSCOMP = 0;
                            end

                            // sub, sra
                            7'b0100000: begin
                                assign ALUOP = {2'b00, FUNCT3}; //extend Funct3 to 5 bits by adding 00 in the MSB
                                assign MUX1 = 1;
                                assign MUX2 = 1;
                                assign MUX3 = 0;
                                assign REGISTERWRITE = 1;
                                assign MEMORYWRITE = 0;
                                assign MEMORYREAD = 0;
                                assign BRANCH = 0;
                                assign JUMP = 0;
                                assign JAL = 0;
                                assign IMMEDIATE = 3'b000;
                                assign TWOSCOMP = 1;
                            end

                            // mul, mulh, mulhsu, mulhu, div, rem, remu
                            7'b0111011: begin
                                assign ALUOP = {2'b01, FUNCT3}; //extend Funct3 to 5 bits by adding 01 in the MSB
                                assign MUX1 = 1;
                                assign MUX2 = 1;
                                assign MUX3 = 0;
                                assign REGISTERWRITE = 1;
                                assign MEMORYWRITE = 0;
                                assign MEMORYREAD = 0;
                                assign BRANCH = 0;
                                assign JUMP = 0;
                                assign JAL = 0;
                                assign IMMEDIATE = 3'b000;
                                assign TWOSCOMP = 0;
                            end
                        endcase
                    end
                    endcase
            end

        // I-type instructions

            // lb, lh, lw, lbu, lhu
            7'b0000011: begin
                assign ALUOP = 5'b10000 ;
                assign MUX1 = 1;
                assign MUX2 = 1;
                assign MUX3 = 1;
                assign REGISTERWRITE = 1;
                assign MEMORYWRITE = 1;
                assign MEMORYREAD = 0;
                assign BRANCH = 0;
                assign JUMP = 0;
                assign JAL = 0;

                //if immediate value set by memory unit by Funct3 ( byte, halfword, word, unsigned byte, unsigned halfword)
                assign IMMEDIATE = 3'b001; 
                // if immediate value set by immediate_extend module
                // assign IMMEDIATE = FUNCT3; // case(FUNCT3)
                // case(FUNCT3)
                //     3'b000: assign IMMEDIATE = 3'b001;
                //     3'b001: assign IMMEDIATE = 3'b001;
                //     3'b010: assign IMMEDIATE = 3'b010;
                //     3'b100: assign IMMEDIATE = 3'b100;
                //     3'b101: assign IMMEDIATE = 3'b101;
                // endcase

                assign TWOSCOMP = 0;

            end

            // addi, slli, slti, sltiu, xori, srli, srai, ori, andi
            7'b0010011: begin
                assign ALUOP = {2'b00, FUNCT3}; //extend Funct3 to 5 bits by adding 00 in the MSB
                assign MUX1 = 1;
                assign MUX2 = 0;
                assign MUX3 = 0;
                assign REGISTERWRITE = 1;
                assign MEMORYWRITE = 0;
                assign MEMORYREAD = 0;
                assign BRANCH = 0;
                assign JUMP = 0;
                assign JAL = 0;
                case(FUNCT3)
                    3'b000: assign IMMEDIATE = 3'b001;
                    3'b001: assign IMMEDIATE = 3'b001;
                    3'b010: assign IMMEDIATE = 3'b001;
                    3'b011: assign IMMEDIATE = 3'b001;
                    3'b100: assign IMMEDIATE = 3'b001;
                    3'b101: assign IMMEDIATE = 3'b010; //srli, srai ( 30th bit is 0 for srli and 1 for srai instruction )
                    3'b110: assign IMMEDIATE = 3'b001;
                    3'b111: assign IMMEDIATE = 3'b001;
                endcase
                case(FUNCT3)
                    3'b000: assign TWOSCOMP = 0;
                    3'b001: assign TWOSCOMP = 0;
                    3'b010: assign TWOSCOMP = 0;
                    3'b011: assign TWOSCOMP = 0;
                    3'b100: assign TWOSCOMP = 0;
                    3'b101: 
                        case(FUNCT7)
                            7'b0000000: assign TWOSCOMP = 0; //srli
                            7'b0100000: assign TWOSCOMP = 1; //srai
                        endcase
                    3'b110: assign TWOSCOMP = 0;
                    3'b111: assign TWOSCOMP = 0;

                endcase


            end

            //jalr
            7'b1100111: begin
                assign ALUOP = 5'b00000;
                assign MUX1 = 1;
                assign MUX2 = 0;
                assign MUX3 = 0;
                assign REGISTERWRITE = 1;
                assign MEMORYWRITE = 0;
                assign MEMORYREAD = 0;
                assign BRANCH = 0;
                assign JUMP = 1;
                assign JAL = 0;
                assign IMMEDIATE = 3'b001;
                assign TWOSCOMP = 0;
            end

        // S-type instructions

            // sb, sh, sw, sbu, shu
            7'b0100011: begin
                assign ALUOP = 5'b00000;
                assign MUX1 = 1;
                assign MUX2 = 1;
                assign MUX3 = 0;
                assign REGISTERWRITE = 0;
                assign MEMORYWRITE = 1;
                assign MEMORYREAD = 0;
                assign BRANCH = 0;
                assign JUMP = 0;
                assign JAL = 0;
                assign IMMEDIATE = 3'b011;
                assign TWOSCOMP = 0;
            end

        // U-type instructions

            // auipc
            7'b0010111: begin
                assign ALUOP = 5'b00000;
                assign MUX1 = 0;
                assign MUX2 = 0;
                assign MUX3 = 0;
                assign REGISTERWRITE = 1;
                assign MEMORYWRITE = 0;
                assign MEMORYREAD = 0;
                assign BRANCH = 0;
                assign JUMP = 0;
                assign JAL = 0;
                assign IMMEDIATE = 3'b000;
                assign TWOSCOMP = 0;
            end

            // lui
            7'b0110111: begin
                assign ALUOP = 5'b10000;
                assign MUX1 = 0;
                assign MUX2 = 0;
                assign MUX3 = 0;
                assign REGISTERWRITE = 1;
                assign MEMORYWRITE = 0;
                assign MEMORYREAD = 0;
                assign BRANCH = 0;
                assign JUMP = 0;
                assign JAL = 0;
                assign IMMEDIATE = 3'b000;
                assign TWOSCOMP = 0;
            end

        // B-type instructions

            // beq, bne, blt, bge, bltu, bgeu
            7'b1100011: begin
                case(FUNCT3)
                    3'b000: assign ALUOP = 5'b00000;
                    3'b001: assign ALUOP = 5'b00000;
                    3'b100: assign ALUOP = 5'b00010;
                    3'b101: assign ALUOP = 5'b00010;
                    3'b110: assign ALUOP = 5'b00011;
                    3'b111: assign ALUOP = 5'b00011;
                endcase
                assign MUX1 = 1;
                assign MUX2 = 0;
                assign MUX3 = 0;
                assign REGISTERWRITE = 0;
                assign MEMORYWRITE = 0;
                assign MEMORYREAD = 0;
                assign BRANCH = 1;
                assign JUMP = 0;
                assign JAL = 1;
                assign IMMEDIATE = 3'b100;
                case(FUNCT3)
                    3'b000: assign TWOSCOMP = 1;
                    3'b001: assign TWOSCOMP = 1;
                    3'b100: assign TWOSCOMP = 0;
                    3'b101: assign TWOSCOMP = 0;
                    3'b110: assign TWOSCOMP = 0;
                    3'b111: assign TWOSCOMP = 0;
                endcase
            end

        // J-type instructions
        
            // jal
            7'b1101111: begin
                assign ALUOP = 5'b00000;
                assign MUX1 = 0;
                assign MUX2 = 0;
                assign MUX3 = 0;
                assign REGISTERWRITE = 1;
                assign MEMORYWRITE = 0;
                assign MEMORYREAD = 0;
                assign BRANCH = 0;
                assign JUMP = 1;
                assign JAL = 1;
                assign IMMEDIATE = 3'b101;
                assign TWOSCOMP = 0;
            end


        endcase
    end

endmodule