module cpu(
    input logic clk,
    input logic rst_n,
    input [31:0] GPIO_in,
    output [31:0] GPIO_out
);

    // Set up instruction memory
    logic [31:0] inst_ram [4095:0];
    initial $readmemh("instmem.dat",inst_ram);
    logic [11:0] PC_FETCH = 12'd0;
    logic [11:0] PC_EX = 12'd0;
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
    logic [1:0] pc_src_EX;

    // branch and jump signals
    logic [11:0] branch_offset_EX;
    logic [11:0] branch_addr_EX;
    assign branch_addr_EX = PC_EX + { branch_offset_EX[12], branch_offset_EX[12:2] };
    logic [19:0] jal_offset_EX;
    logic [19:0] jal_addr_EX;
    assign jal_addr_EX = PC_EX + jal_offset_EX[13:2];
    logic [11:0] jalr_offset_EX;
    logic [11:0] jalr_addr_EX;
    assign jalr_addr_EX = readdata1 + { {2{jalr_offset_EX[11]}}, jalr_offset_EX[11:2] };

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
    logic zero_EX;

    // stall signals
    logic stall_FETCH;
    logic stall_EX;

    // sign extended imm12
    logic [31:0] imm12_EX_32;
    assign imm12_EX_32 = { {20{imm12_EX[11]}}, imm12_EX};


	// left shifted imm20
	logic [31:0] imm20_EX_SL;
	assign imm20_EX_SL = { imm20_EX, 12'b0 };

    // CPU output signals
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
        .csr_EX(csr_EX),
        .branch_offset_EX(branch_offset_EX),
        .jal_offset_EX(jal_offset_EX),
        .jalr_offset_EX(jalr_offset_EX)
    );

    controller _controller(
        // inputs
        .opcode_EX(opcode_EX),
        .funct3_EX(funct3_EX),
        .funct7_EX(funct7_EX),
        .csr_EX(csr_EX),
        .stall_EX(stall_EX),

        // outputs
        .alusrc(alusrc_EX),
        .regwrite(regwrite_EX),
        .regsel(regsel_EX),
        .aluop(aluop_EX),
        .gpio_we(GPIO_we),
        .pc_src_EX(pc_src_EX),
        .stall_FETCH(stall_FETCH)
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
        .zero(zero_EX)
    );

    // control which value to write
    // to the register file
    mux4 _mux4(
        // inputs
        .a(GPIO_in_WB),
        .b(imm20_WB),
        .c(R_WB),
        .d(PC_EX),
        .s(regsel_WB),
        // outputs
        .y(writedata_WB)
    );

    // control the state of PC_FETCH
    mux4 _mux4(
        // inputs
        .a(PC_FETCH + 1'b1),
        .b(branch_addr_EX),
        .c(jal_addr_EX),
        .d(jalr_addr_EX),
        .s(pc_src_EX),
        // outputs
        .y(PC_FETCH)
    );


    // registers
    always_ff @(posedge clk) begin
        if (~rst_n) begin

            PC_FETCH <= 12'd0;          // process counter
            instruction_EX <= 32'd0;    // instruction to execute

            rd_WB <= 5'd0;              // destination register write back
            //regwrite_WB <= 1'b0;        // register file write enable
            regsel_WB <= 2'b00;         // register selection
            imm20_WB <= 32'd0;          // imm20 bits
            R_WB <= 32'd0;              // alu output signal

            // GPIO signals
            GPIO_in_WB <= 32'b0;
            CPU_out <= 32'b0;

        end else begin
            //PC_FETCH <= PC_FETCH + 1'b1;
            PC_EX <= PC_FETCH;
            instruction_EX <= inst_ram[PC_FETCH];

            rd_WB <= rd_EX;
            regwrite_WB <= regwrite_EX;
            regsel_WB <= regsel_EX;
            imm20_WB <= imm20_EX_SL;
            R_WB <= R_EX;
			GPIO_in_WB <= GPIO_in;

            stall_EX <= stall_FETCH;

            if (GPIO_we) CPU_out <= readdata1;
        end
    end

     always @(negedge clk) begin
			$display("-----------------------------------------------");
			//$display("process counter ---> %d", PC_FETCH);
			$display("loaded instruction ---> %8h", inst_ram[PC_FETCH]);
			$display("opcode_EX ---> %b", opcode_EX);
			//$display("imm12_EX ---> %b", imm12_EX);
			//$display("imm12_EX_32 ---> %d", $unsigned(imm12_EX_32));
			//$display("signed im12-32 ===> %8h", imm12_EX_32);
			$display("imm20_EX ---> %8h", imm20_EX);
			//$display("imm20_WB ---> %8h", imm20_WB);
			$display("imm20_EX_SL ---> %8h", imm20_EX_SL);
			//$display(" ----- Controller Outputs ----- ");
			//$display("alusrc_EX ---> %b", alusrc_EX);
			//$display("regwrite_EX ---> %b", regwrite_EX);
			//$display("regsel_EX ---> %b", regsel_EX);
			//$display("aluop_EX ---> %b", aluop_EX);
			//$display("------------------------");
			//$display("rs1_EX ---> %b", rs1_EX);
			//$display("rs2_EX ---> %b", rs2_EX);
			//$display("rd_EX ---> %b", rd_EX);
			$display("readdata1 ---> %8h", readdata1);
			$display("readdata2 ---> %b", readdata2);
			$display("regwrite_WB ---> %b", regwrite_WB);
			$display("writedata_WB ---> %8h", writedata_WB);
			//$display("unsigned imm12 ===> %d", $unsigned(imm12_EX));
			//$display("signed imm21 ===> %d", $signed(imm12_EX));
			//$display("regsel_WB ---> %b", regsel_WB);
			$display("B_EX ---> %8h", B_EX);
			$display("R_EX ---> %8h", R_EX);
			$display("R_WB ---> %8h", R_WB);
			$display("CPU_out ---> %8h", CPU_out);
			//$display("GPIO_in ---> %8h", GPIO_in);
			//$display("GPIO_in_WB ---> %b", GPIO_in_WB);
			$display("GPIO_we ---> %b", GPIO_we);
			$display("GPIO_out ---> %8h", GPIO_out);
			$display("-----------------------------------------------");
     end

endmodule