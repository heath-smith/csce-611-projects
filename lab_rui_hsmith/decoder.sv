// decode the instruction passed from the
// instruction memory. Extract all possible
// values for every instruction and output them
// from this module. Determine the instruction
// type later.
module decoder(
    input [31:0] instruction_EX   /* instruction input */
    output [6:0] opcode_EX,
    output [4:0] rd_EX,
    output [2:0] funct3_EX,
    output [4:0] rs1_EX,
    output [4:0] rs2_EX,
    output [6:0] funct7_EX,
    output [11:0] imm12_EX,
    output [19:0] imm20_EX,
    output [11:0] csr_EX
);

    always_comb begin
        opcode_EX = ins[6:0];
        rd_EX = inst[11:7];
        funct3_EX = inst[14:12];
        rs1_EX = inst[19:15];
        rs2_EX = inst[24:20];
        funct7_EX = inst[31:25];
        imm12_EX = inst[31:20];
        imm20_EX = inst[31:12];
        csr_EX = inst[31:20];
    end

endmodule