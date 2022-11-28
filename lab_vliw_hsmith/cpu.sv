module cpu(
    input logic clk,
    input logic rst_n,
    input [31:0] GPIO_in,
    output [31:0] GPIO_out
);

    // Set up instruction memory
    logic [63:0] inst_ram [2047:0];
    initial $readmemh("sqrt64.dat", inst_ram);
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
    // VLIW
    logic [6:0] opcode_EX2;
    logic [4:0] rd_EX2;
    logic [2:0] funct3_EX2;
    logic [4:0] rs1_EX2;
    logic [4:0] rs2_EX2;
    logic [6:0] funct7_EX2;
    logic [11:0] imm12_EX2;
    logic [19:0] imm20_EX2;
    logic [11:0] csr_EX2;

    // register file signals
    logic [31:0] readdata1;
    logic [31:0] readdata2;
    logic [31:0] writedata_WB;
    // VLIW
    logic [31:0] readdata11;
    logic [31:0] readdata22;
    logic [31:0] writedata_WB2;

    // branch and jump signals
    logic [12:0] branch_offset_EX;
    logic [11:0] branch_addr_EX;
    assign branch_addr_EX = PC_EX + { branch_offset_EX[12], branch_offset_EX[12:2] };
    logic [20:0] jal_offset_EX;
    logic [11:0] jal_addr_EX;
    assign jal_addr_EX = PC_EX + jal_offset_EX[13:2];
    logic [11:0] jalr_offset_EX;
    logic [11:0] jalr_addr_EX;
    assign jalr_addr_EX = readdata1 + { {2{jalr_offset_EX[11]}}, jalr_offset_EX[11:2] };

    // controller signals
    logic alusrc_EX;
    logic regwrite_EX;
    logic [1:0] regsel_EX;
    logic [3:0] aluop_EX;
    logic GPIO_we;
    // VLIW
    logic alusrc_EX2;
    logic regwrite_EX2;
    logic [1:0] regsel_EX2;
    logic [3:0] aluop_EX2;
    logic GPIO_we2;


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
    // VLIW
    logic [31:0] B_EX2;
    logic [31:0] R_EX2;
    logic zero_EX2;

    // stall signals
    logic stall_FETCH;
    logic stall_EX;
    //vliw -- unused
    logic stall_FETCH2;
    logic stall_EX2;

    // sign extended imm12
    logic [31:0] imm12_EX_32;
    assign imm12_EX_32 = { {20{imm12_EX[11]}}, imm12_EX };
    // vliw
    logic [31:0] imm12_EX_32_2;
    assign imm12_EX_32_2 = { {20{imm12_EX2[11]}}, imm12_EX2 };

	// left shifted imm20
	logic [31:0] imm20_EX_SL;
	assign imm20_EX_SL = { imm20_EX, 12'b0 };
    // vliw
	logic [31:0] imm20_EX_SL2;
	assign imm20_EX_SL2 = { imm20_EX2, 12'b0 };


    // CPU output signals
    logic [31:0] CPU_out;
    assign GPIO_out = CPU_out;

    decoder _decoder1(
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

    decoder _decoder2(
        .instruction_EX(instruction_EX2),
        .opcode_EX(opcode_EX2),
        .rd_EX(rd_EX2),
        .funct3_EX(funct3_EX2),
        .rs1_EX(rs1_EX2),
        .rs2_EX(rs2_EX2),
        .funct7_EX(funct7_EX2),
        .imm12_EX(imm12_EX2),
        .imm20_EX(imm20_EX2),
        .csr_EX(csr_EX2),
        .branch_offset_EX(branch_offset_EX2),
        .jal_offset_EX(jal_offset_EX2),
        .jalr_offset_EX(jalr_offset_EX2)
    );

    controller _controller1(
        // inputs
        .opcode_EX(opcode_EX),
        .funct3_EX(funct3_EX),
        .funct7_EX(funct7_EX),
        .csr_EX(csr_EX),
        .stall_EX(stall_EX),
        .R_EX(R_EX),
        .zero_EX(zero_EX),

        // outputs
        .alusrc(alusrc_EX),
        .regwrite(regwrite_EX),
        .regsel(regsel_EX),
        .aluop(aluop_EX),
        .gpio_we(GPIO_we),
        .pc_src_EX(pc_src_EX),
        .stall_FETCH(stall_FETCH)
    );

    controller _controller2(
        // inputs
        .opcode_EX(opcode_EX2),
        .funct3_EX(funct3_EX2),
        .funct7_EX(funct7_EX2),
        .csr_EX(csr_EX2),
        .stall_EX(stall_EX2),
        .R_EX(),
        .zero_EX(),

        // outputs
        .alusrc(alusrc_EX2),
        .regwrite(regwrite_EX2),
        .regsel(regsel_EX2),
        .aluop(aluop_EX2),
        .gpio_we(GPIO_we2),
        .pc_src_EX(pc_src_EX),
        .stall_FETCH()
    );

    regfile _regfile(
        // inputs
        .clk(clk),
        .rst(~rst_n),
        .we1(regwrite_WB),
        .we2(),
        .readaddr1(rs1_EX),
        .readaddr2(rs2_EX),
        .readaddr11(),
        .readaddr22(),
        .writeaddr1(rd_WB),
        .writeaddr2(),
        .writedata1(writedata_WB),
        .writedata2(),
        // outputs
        .readdata1(readdata1),
        .readdata2(readdata2),
        .readdata11(),
        .readdate22()
    );

    mux2 _mux2(
        // inputs
        .a(readdata2),
        .b(imm12_EX_32),
        .s(alusrc_EX),
        // outputs
        .y(B_EX)
    );

    alu _alu1(
        // inputs
        .A(readdata1),
        .B(B_EX),
        .op(aluop_EX),
        // outputs
        .R(R_EX),
        .zero(zero_EX)
    );

    alu _alu2(
        // inputs
        .A(),
        .B(),
        .op(),
        // outputs
        .R(),
        .zero()
    );

    // control which value to write
    // to the register file
    mux4 _mux4_regwrite(
        // inputs
        .a(GPIO_in_WB),
        .b(imm20_WB),
        .c(R_WB),
        .d({ 20'b0, PC_EX }),
        .s(regsel_WB),
        // outputs
        .out(writedata_WB)
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

            stall_EX <= 1'b0;
            //stall_FETCH <= 1'b0;

        end else begin
            //PC_FETCH <= PC_FETCH + 1'b1;
            PC_FETCH <= pc_src_EX[1] ?
                 (pc_src_EX[0] ? jalr_addr_EX : jal_addr_EX) :
                 (pc_src_EX[0] ? branch_addr_EX : PC_FETCH + 2'd2);

            PC_EX <= PC_FETCH;
            instruction_EX <= inst_ram[PC_FETCH[9:1]];

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
		$display("process counter ---> %d", PC_FETCH);
		$display("loaded instruction ---> %8h", inst_ram[PC_FETCH[9:1]]);
		//$display("stall_EX ---> %1b", stall_EX);
        //$display("stall_FETCH ---> %1b", stall_FETCH);
        //$display("pc_src_EX ---> %2b", pc_src_EX);
        //$display("funct3_EX ---> %3b", funct3_EX);
		//$display("zero_EX ---> %1b", zero_EX);
        //$display("opcode_EX ---> %b", opcode_EX);
	    //$display("imm12_EX ---> %b", imm12_EX);
	    //$display("imm12_EX_32 ---> %d", $unsigned(imm12_EX_32));
	    //$display("signed im12-32 ===> %8h", imm12_EX_32);
	    //$display("imm20_EX ---> %8h", imm20_EX);
	    //$display("imm20_WB ---> %8h", imm20_WB);
	    //$display("imm20_EX_SL ---> %8h", imm20_EX_SL);
	    //$display(" ----- Controller Outputs ----- ");
	    //$display("alusrc_EX ---> %b", alusrc_EX);
	    //$display("regwrite_EX ---> %b", regwrite_EX);
	    //$display("regsel_EX ---> %b", regsel_EX);
	    //$display("aluop_EX ---> %b", aluop_EX);
	    //$display("------------------------");
	    //$display("rs1_EX ---> %b", rs1_EX);
	    //$display("rs2_EX ---> %b", rs2_EX);
	    //$display("rd_EX ---> %b", rd_EX);
	    //$display("readdata1 ---> %8h", readdata1);
	    //$display("readdata2 ---> %b", readdata2);
	    //$display("regwrite_WB ---> %b", regwrite_WB);
	    //$display("writedata_WB ---> %8h", writedata_WB);
	    //$display("unsigned imm12 ===> %d", $unsigned(imm12_EX));
	    //$display("signed imm21 ===> %d", $signed(imm12_EX));
	    //$display("regsel_WB ---> %b", regsel_WB);
	    //$display("B_EX ---> %8h", B_EX);
	    //$display("R_EX ---> %8h", R_EX);
	    //$display("R_WB ---> %8h", R_WB);
	    //$display("CPU_out ---> %8h", CPU_out);
	    //$display("GPIO_in ---> %8h", GPIO_in);
	    //$display("GPIO_in_WB ---> %b", GPIO_in_WB);
	    //$display("GPIO_we ---> %b", GPIO_we);
	    //$display("GPIO_out ---> %8h", GPIO_out);
	    $display("-----------------------------------------------");
     end

endmodule