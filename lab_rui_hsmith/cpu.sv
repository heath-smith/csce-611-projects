module cpu(
    input logic clk,
    input logic rst_n,
    input [31:0] GPIO_in,
    output [31:0] GPIO_out
);

    // Set up instruction memory
    logic [31:0] inst_ram [4095:0];
    initial $readmemh("../../testcpu.mem",inst_ram);
    logic [11:0] PC_FETCH = 12'd0;
    logic [31:0] instruction_EX;

    // EX stage signals
    logic [6:0] opcode_EX;
    logic [4:0] rd_EX;
    logic [2:0] funct3_EX;
    logic [4:0] rs1_EX;
    logic [4:0] rs2_EX;
    logic [6:0] funct7_EX;
    logic [11:0] imm12_EX;
    logic [19:0] imm20_EX;
    logic [11:0] csr_EX;

    // register file signals
    logic [31:0] readdata1;
    logic [31:0] readdata2;
    logic [31:0] writedata_WB;

    // controller signals
    logic alusrc_EX;
    logic regwrite_EX;
    logic [1:0] regsel_EX;
    logic [3:0] aluop_EX;
    logic GPIO_we;

    // WB stage signals
    logic [4:0] rd_WB;
    logic [31:0] R_WB;
    logic regwrite_WB;
    logic [1:0] regsel_WB;
    logic [31:0] GPIO_in_WB;
    logic [31:0] imm20_WB;

    // ALU signals
    /* A_EX == rs1_EX */
    logic [31:0] B_EX;
    logic [31:0] R_EX;
    logic zero;


    // sign extended imm12
    logic [31:0] imm12_EX_32;
    assign imm12_EX_32 = { {20{imm12_EX[11]}}, imm12_EX};

    logic [31:0] CPU_out;
    assign GPIO_out = CPU_out;

    decoder _decoder(
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

    controller _controller(
        // inputs
        .opcode_EX(opcode_EX),
        .funct3_EX(funct3_EX),
        .funct7_EX(funct7_EX),
        // outputs
        .alusrc(alusrc_EX),
        .regwrite(regwrite_EX),
        .regsel(regsel_EX),
        .aluop(aluop_EX),
        .gpio_we(GPIO_we)
    );

    regfile _regfile(
        // inputs
        .clk(clk),
        .rst(~rst_n),
        .we(regwrite_WB),
        .readaddr1(rs1_EX),
        .readaddr2(rs2_EX),
        .writeaddr(rd_WB),
        .writedata(writedata_WB),
        // outputs
        .readdata1(readdata1),
        .readdata2(readdata2)
    );

    mux _mux(
        // inputs
        .a(readdata2),
        .b(imm12_EX_32),
        .s(alusrc_EX),
        // outputs
        .y(B_EX)
    );

    alu _alu(
        // inputs
        .A(readdata1),
        .B(B_EX),
        .op(aluop_EX),
        // outputs
        .R(R_EX),
        .zero(zero)
    );

    mux3 _mux3(
        // inputs
        .a(GPIO_in_WB),
        .b({imm20_EX, 12'b0}),
        .c(R_WB),
        .s(regsel_WB),
        // outputs
        .y(writedata_WB)
    );


    // registers
    always_ff @(posedge clk) begin
        if (~rst_n) begin

            PC_FETCH <= 12'd0;          // process counter
            instruction_EX <= 32'd0;    // instruction to execute

            rd_WB <= 5'd0;              // destination register write back
            regwrite_WB <= 1'b0;        // register file write enable
            regsel_WB <= 2'b00;         // register selection
            imm20_WB <= 32'd0;          // imm20 bits
            R_WB <= 32'd0;              // alu output signal

            // GPIO signals
            GPIO_in_WB <= 32'd0;
            CPU_out <= 32'd0;

        end else begin
            PC_FETCH <= PC_FETCH + 1'b1;
            instruction_EX <= inst_ram[PC_FETCH];

            rd_WB <= rd_EX;
            regwrite_WB <= regwrite_EX;
            regsel_WB <= regsel_EX;
            imm20_WB <= { imm20_EX, 12'b0 };
            R_WB <= R_EX;

            GPIO_in_WB <= (GPIO_we) ? GPIO_in : 32'd0;
            CPU_out <= (GPIO_we) ? readdata1 : 32'd0;

        end
    end

     always @(negedge clk) begin
        $display("-----------------------------------------------");
        //$display("process counter ---> %d", PC_FETCH);
        $display("loaded instruction ---> %b", inst_ram[PC_FETCH]);
        $display("imm12_EX ---> %b", imm12_EX);
        $display("imm12_EX_32 ---> %b", imm12_EX_32);
        //$display(" ----- Controller Outputs ----- ");
        //$display("alusrc_EX ---> %b", alusrc_EX);
        //$display("regwrite_EX ---> %b", regwrite_EX);
        //$display("regsel_EX ---> %b", regsel_EX);
        //$display("aluop_EX ---> %b", aluop_EX);
        //$display("GPIO_we ---> %b", GPIO_we);
        //$display("------------------------");
        $display("rs1_EX ---> %b", rs1_EX);
        //$display("rs2_EX ---> %b", rs2_EX);
        $display("rd_EX ---> %b", rd_EX);
        $display("readdata1 ---> %b", readdata1);
        //$display("readdata2 ---> %b", readdata2);
        //$display("writedata_WB ---> %b", writedata_WB);
        //$display("regsel_WB ---> %b", regsel_WB);
        $display("B_EX ---> %h", B_EX);
        $display("R_EX ---> %h", R_EX);
        $display("R_WB ---> %h", R_WB);
        $display("-----------------------------------------------");
     end

endmodule