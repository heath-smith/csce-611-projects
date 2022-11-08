// controller unit
module controller(
    /*******************/
    /***** inputs ******/
    /*******************/

    // decoded instruction fields
    input logic [6:0] opcode_EX,
    input logic [2:0] funct3_EX,
    input logic [6:0] funct7_EX,
    input logic [11:0] csr_EX,
    input logic [0:0] stall_EX,

    // use to resolve branches
    input logic [31:0] R_EX,
    input logic zero_EX,

    /*******************/
    /***** outputs *****/
    /*******************/

    // determibnes signal to use as ALU 'b' input
    // between readdata1, readdata2, and instruction[15:0]
    output logic [0:0] alusrc,

    // register file write enable
    output logic [0:0] regwrite,

    // selects regfile 'writedata' between ALU R output
    // and GPIO input and shifted imm field from U-type format
    output logic [1:0] regsel,

    // the ALU operation code
    output logic [3:0] aluop,

    // enables writing to GPIO register (csrrw instruction)
    output logic [0:0] gpio_we,

    // controls the PC mux
    output logic [1:0] pc_src_EX,

    // stall signal
    output logic [0:0] stall_FETCH
);

    // controller logic signals
    logic [11:0] controls;

    assign { alusrc, regwrite, regsel, aluop, gpio_we, pc_src_EX, stall_FETCH } = controls;

    always_comb begin
        // set defaults here
		$display("control signals ---> %b", controls);
        if (stall_EX == 1'b0) begin
            case (opcode_EX)
                // J-Type (jal) always stall after jal
                7'b1101111:
                    begin
                        controls = 12'bx_1_11_xxxx_x_10_1;
                    end

                // jalr (I-Type encoding)
                7'b1100111:
                    begin
                        controls = 12'bx_1_11_xxxx_x_11_1;
                    end

                // B-type
                7'b1100011:
                    begin
                        controls =
                            (funct3_EX == 3'b000) ?
                                ((zero_EX == 1'b1) ?
                                    12'b0_1_11_0100_0_01_1 : 12'b0_1_11_0100_0_00_0) : // beq
                            (funct3_EX == 3'b001) ?
                                ((zero_EX == 1'b0) ?
                                    12'b0_1_11_0100_0_01_1 : 12'b0_1_11_0100_0_00_0) : // bne
                            (funct3_EX == 3'b100) ?
                                ((R_EX == 32'b1) ?
                                    12'b0_1_11_1100_0_01_1 : 12'b0_1_11_1100_0_00_0) : // blt
                            (funct3_EX == 3'b101) ?
                                ((R_EX == 32'b0) ?
                                    12'b0_1_11_1100_0_01_1 : 12'b0_1_11_1100_0_00_0) : // bge
                            (funct3_EX == 3'b110) ?
                                ((R_EX == 32'b1) ?
                                    12'b0_1_11_1101_0_01_1 : 12'b0_1_11_1101_0_00_0) : // bltu
                            (funct3_EX == 3'b111) ?
                                ((R_EX == 32'b0) ?
                                    12'b0_1_11_1101_0_01_1 : 12'b0_1_11_1101_0_00_0) : // bgeu
                            12'bx_x_xx_xxxx_x_xx_x;
                    end

                // I-type instructions
                // alusrc === gets a 1 - we want to use sign extended imm12 field from mux
                    // 	as input B to the ALU
                // regwrite === gets a 1 - we want to immediately write back to regfile
                    // regsel === should be 2 (10) so we pick the ALU output
                7'b0010011:
                    begin
                        controls =
                            (funct3_EX == 3'b000) ? 12'b1_1_10_0011_0_00_0 :           // addi
                            (funct3_EX == 3'b111) ? 12'b1_1_10_0000_0_00_0 :           // andi
                            (funct3_EX == 3'b110) ? 12'b1_1_10_0001_0_00_0 :           // ori
                            (funct3_EX == 3'b100) ? 12'b1_1_10_0010_0_00_0 :           // xori
                            (funct3_EX == 3'b001
                                && funct7_EX == 7'b0000000) ? 12'b1_1_10_1000_0_00_0 : // slli
                            (funct3_EX == 3'b101
                                && funct7_EX == 7'b0100000) ? 12'b1_1_10_1010_0_00_0 : // srai
                            (funct3_EX == 3'b101
                                && funct7_EX == 7'b0000000) ? 12'b1_1_10_1001_0_00_0 : // srli
                            12'bx_x_xx_xxxx_x_xx_x;
                    end

                // R-type instructions
                7'b0110011:
                    begin
                        controls =
                            (funct3_EX == 3'b000
                                && funct7_EX == 7'b0000000) ? 12'b0_1_10_0011_0_00_0 :    // add
                            (funct3_EX == 3'b000
                                && funct7_EX == 7'b0100000) ? 12'b0_1_10_0100_0_00_0 :    // sub
                            (funct3_EX == 3'b111
                                && funct7_EX == 7'b0000000) ? 12'b0_1_10_0000_0_00_0 :    // and
                            (funct3_EX == 3'b110
                                && funct7_EX == 7'b0000000) ? 12'b0_1_10_0001_0_00_0 :    // or
                            (funct3_EX == 3'b100
                                && funct7_EX == 7'b0000000) ? 12'b0_1_10_0010_0_00_0 :    // xor
                            (funct3_EX == 3'b001
                                && funct7_EX == 7'b0000000) ? 12'b0_1_10_1000_0_00_0 :   // sll
                            (funct3_EX == 3'b101
                                && funct7_EX == 7'b0100000) ? 12'b0_1_10_1010_0_00_0 :   // sra
                            (funct3_EX == 3'b101
                                && funct7_EX == 7'b0000000) ? 12'b0_1_10_1001_0_00_0 :   // srl
                            (funct3_EX == 3'b010
                                && funct7_EX == 7'b0000000) ? 12'b0_1_10_1100_0_00_0 :   // slt
                            (funct3_EX == 3'b011
                                && funct7_EX == 7'b0000000) ? 12'b0_1_10_1101_0_00_0 :   // sltu
                            (funct3_EX == 3'b000
                                && funct7_EX == 7'b0000001) ? 12'b0_1_10_0101_0_00_0 :   // mul
                            (funct3_EX == 3'b001
                                && funct7_EX == 7'b0000001) ? 12'b0_1_10_0110_0_00_0 :   // mulh
                            (funct3_EX == 3'b011
                                && funct7_EX == 7'b0000001) ? 12'b0_1_10_0111_0_00_0 :   // mulhu
                            12'bx_x_xx_xxxx_x_xx_x;
                    end

                // U-type instructions
                7'b0110111:
                    begin
                        controls = 12'bx_1_01_xxxx_0_00_0;    // lui
                    end

                // Control and Status Register (cssrw) instructions
                7'b1110011:
                    begin
                        // cssrw
                        controls =
                            (csr_EX == 12'b111100000010) ? 12'bx_0_xx_xxxx_1_00_0 : // HEX
                                                                            12'bx_1_00_xxxx_0_00_0; // SW
                    end

                default: controls = 12'b0_0_00_0000_0_00_0;

            endcase
        end else begin
            controls = 12'b0_0_00_0000_0_xx_0;
        end
    end

endmodule
