module cpu(
    input logic clk,
    input logic rst_n,
    input [31:0] cpu_in,
    output [31:0] cpu_out
);

    // Set up instruction memory
    logic [31:0] inst_ram [4095:0];
    initial $readmemh("program.rom",inst_ram);
    logic [11:0] PC_FETCH = 12'd0;
    logic [31:0] instruction_EX;

    // set up decoded instruction signals
    logic [6:0] opcode_EX;
    logic [4:0] rd_EX;
    logic [2:0] funct3_EX;
    logic [4:0] rs1_EX;
    logic [4:0] rs2_EX;
    logic [6:0] funct7_EX;
    logic [11:0] imm12_EX;
    logic [19:0] imm20_EX;
    logic [11:0] csr_EX;

    // register file outputs
    logic [31:0] readdata1;
    logic [31:0] readdata2;

    decoder dcdr(
        .instruction_EX(instruction_EX),
        .opcode_EX(opcode_EX),
        .rd_EX(rd_EX),
        .funct3_EX(funct3_EX),
        .rs1_EX(rs1_EX),
        .rs2_EX(rs2_EX),
        .funct7_EX(funct7_EX),
        .imm12_EX(imm12_EX),
        .imm20_EX(imm20_EX),
        .csr_EX(csr_EX)
    );

    regfile rf(
        // inputs
        .clk(clk),
        .rst(~rst_n),
        .we(),
        .readaddr1(rs1_EX),
        .readaddr2(rs2_EX),
        .writeaddr(),
        .writedata(),
        // outputs
        .readdata1(readdata1),
        .readdata2(readdata2)
    );

    always_ff @(posedge clk) begin
        if (~rst_n) begin
            PC_FETCH <= 12'd0;
            instruction_EX <= 32'd0;
        end else begin
            PC_FETCH <= PC_FETCH + 1'b1;
            instruction_EX <= inst_ram[PC_FETCH];
        end
    end

endmodule