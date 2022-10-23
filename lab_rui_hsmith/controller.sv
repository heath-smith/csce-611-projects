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
);

    // controller logic signals
    logic [8:0] controls;

    assign { alusrc, regwrite, regsel, aluop, gpio_we} = controls;

    always_comb begin
        // set defaults here
        case (opcode_EX)
            // I-type instructions
            // alusrc gets a 1 - we want mux to return imm12 sign-extended in mux
            // regwrite gets a 1 - we want to immediately write back to regfile
            7'b0010011:
                begin
                    controls =
                        (funct3_EX == 3'b000) ? 8'b1_1_10_0011_0 :           // addi
                        (funct3_EX == 3'b111) ? 8'b1_1_10_0001_0 :           // andi
                        (funct3_EX == 3'b110) ? 8'b1_1_10_0010_0 :           // ori
                        (funct3_EX == 3'b100) ? 8'b1_1_10_0000_0 :           // xori
                        (funct3_EX == 3'b001
                            && funct7_EX == 7'b0000000) ? 8'b1_1_10_1000_0 : // slli
                        (funct3_EX == 3'b101
                            && funct7_EX == 7'b0100000) ? 8'b1_1_10_1010_0 : // srai
                        (funct3_EX == 3'b101
                            && funct7_EX == 7'b0000000) ? 8'b1_1_10_1001_0 : // srli
                        8'bx_x_xx_xxxx_x;
                end

            // R-type instructions
            7'b0110011:
                begin
                    controls = 8'bx_x_xx_xxxx_x;
                end

            // U-type instructions
            7'b0110111:
                begin
                    controls = 8'bx_x_xx_xxxx_x;
                end

            // Control and Status Register instructions
            7'b1110011:
                begin
                    controls = (funct3_EX == 3'b001) ?
                end

            default: controls = 8'bx_x_xx_xxxx_x;

        endcase
    end

endmodule