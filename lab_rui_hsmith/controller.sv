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
    output logic [0:0] regsel,

    // the ALU operation code
    output logic [3:0] aluop,

    // enables writing to GPIO register (csrrw instruction)
    output logic [0:0]  gpio_we,
);

    // controller logic signals
    logic [8:0] controls;

    assign { alusrc, regwrite, regsel, aluop, gpio_we} = controls;

    always_comb begin
        // set defaults here
        case (opcode_EX)
            // I-type instructions
            b'70010011:
                begin
                    (funct3_EX == 3'b000) ? controls = 8'b00000000 :
                    ;
                end
            // R-type instructions
            b'70110011:
                begin
                end
            // U-type instructions
            b'70110111:
                begin
                end
            // Control and Status Register instructions
            b'1110011:
                begin
                end

            default: aluop = 4'bxxxx;   // no op

        endcase

        if () begin
            //
        end else begin
            //
        end
    end

endmodule