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
    logic [8:0] controls;

    assign { alusrc, regwrite, regsel, aluop, gpio_we} = controls;

    always_comb begin
        // set defaults here
		  $display("control signals ---> %b", controls);
        case (opcode_EX)
            // I-type instructions
            // alusrc === gets a 1 - we want to use sign extended imm12 field from mux
				// 	as input B to the ALU
            // regwrite === gets a 1 - we want to immediately write back to regfile
				// regsel === should be 2 (10) so we pick the ALU output
            7'b0010011:
                begin
                    controls =
                        (funct3_EX == 3'b000) ? 9'b1_1_10_0011_0 :           // addi
                        (funct3_EX == 3'b111) ? 9'b1_1_10_0000_0 :           // andi
                        (funct3_EX == 3'b110) ? 9'b1_1_10_0001_0 :           // ori
                        (funct3_EX == 3'b100) ? 9'b1_1_10_0010_0 :           // xori
                        (funct3_EX == 3'b001
                            && funct7_EX == 7'b0000000) ? 9'b1_1_10_1000_0 : // slli
                        (funct3_EX == 3'b101
                            && funct7_EX == 7'b0100000) ? 9'b1_1_10_1010_0 : // srai
                        (funct3_EX == 3'b101
                            && funct7_EX == 7'b0000000) ? 9'b1_1_10_1001_0 : // srli
                        9'bx_x_xx_xxxx_x;
                end

            // R-type instructions
            7'b0110011:
                begin
                    controls =
                        (funct3_EX == 3'b000
                            && funct7_EX == 7'b0000000) ? 9'b0_1_10_0011_0 :    // add
                        (funct3_EX == 3'b000
                            && funct7_EX == 7'b0100000) ? 9'b0_1_10_0100_0 :    // sub
                        (funct3_EX == 3'b111
                            && funct7_EX == 7'b0000000) ? 9'b0_1_10_0000_0 :    // and
                        (funct3_EX == 3'b110
                            && funct7_EX == 7'b0000000) ? 9'b0_1_10_0001_0 :    // or
                        (funct3_EX == 3'b100
                            && funct7_EX == 7'b0000000) ? 9'b0_1_10_0010_0 :    // xor
                        (funct3_EX == 3'b001
                            && funct7_EX == 7'b0000000) ? 9'b0_1_10_1000_0 :   // sll
                        (funct3_EX == 3'b101
                            && funct7_EX == 7'b0100000) ? 9'b0_1_10_1010_0 :   // sra
                        (funct3_EX == 3'b101
                            && funct7_EX == 7'b0000000) ? 9'b0_1_10_1001_0 :   // srl
                        (funct3_EX == 3'b010
                            && funct7_EX == 7'b0000000) ? 9'b0_1_10_1100_0 :   // slt
                        (funct3_EX == 3'b011
                            && funct7_EX == 7'b0000000) ? 9'b0_1_10_1101_0 :   // sltu
                        (funct3_EX == 3'b000
                            && funct7_EX == 7'b0000001) ? 9'b0_1_10_0101_0 :   // mul
                        (funct3_EX == 3'b001
                            && funct7_EX == 7'b0000001) ? 9'b0_1_10_0110_0 :   // mulh
                        (funct3_EX == 3'b011
                            && funct7_EX == 7'b0000001) ? 9'b0_1_10_0111_0 :   // mulhu
                        9'bx_x_xx_xxxx_x;
                end

            // U-type instructions
            7'b0110111:
                begin
                    controls = 9'bx_1_01_xxxx_0;    // lui
                end

            // Control and Status Register instructions
            7'b1110011:
                begin
                    // cssrw
                    controls =
                        (csr_EX == 12'b111100000010) ? 9'bx_0_xx_xxxx_1 : // HEX
																		 9'bx_1_00_xxxx_0; // SW
                end

            default: controls = 9'bx_x_xx_xxxx_x;

        endcase
    end

endmodule
