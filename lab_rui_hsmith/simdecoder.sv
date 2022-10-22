// test bench for the decoder module

module simdecoder;

    logic clk, reset;                   // clock/reset
    logic [31:0] vectornum, errors;     // index, error counter
    logic [108:0] testvectors[10000:0]; // test vector 2-D array
    logic [31:0] instruction_EX;        // input instruction
    logic [6:0] opcode_EX, opcode_exp;  // op code
    logic [4:0] rd_EX, rd_exp;          // destination register
    logic [2:0] funct3_EX, funct3_exp;  // funct3
    logic [4:0] rs1_EX, rs1_exp;        // register source 1
    logic [4:0] rs2_EX, rs2_exp;        // register source 2
    logic [6:0] funct7_EX, funct7_exp;  // funct 7
    logic [11:0] imm12_EX, imm12_exp;   // imm 12-bit
    logic [19:0] imm20_EX, imm20_exp;   // imm 20-bit
    logic [11:0] csr_EX, csr_exp;       // csr signal

    decoder dut(
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

    // generate clock
    always begin
        clk = 1'b1; #5; clk = 1'b0; #5;
    end

    // read test vectors
    initial begin
        $readmemb("../../testdecoder.mem", testvectors);
        vectornum = 32'b0; errors=32'b0;
        reset = 1'b1; #20; reset = 1'b0;
    end

    // apply test vectors on rising clock edge
    always @(posedge clk) begin
        {
            instruction_EX,
            opcode_exp,
            rd_exp,
            funct3_exp,
            rs1_exp,
            rs2_exp,
            funct7_exp,
            imm12_exp,
            imm20_exp,
            csr_exp } = testvectors[vectornum];

    end

    always @(negedge clk) begin

        // skip during reset
        if (~reset) begin

            if (opcode_EX !== opcode_exp) begin
                $display("opcode_EX ERROR -----> vector[%d] : instruction_EX[%b]", vectornum, instruction_EX);
                $display("expected value: %b, received %b", opcode_exp, opcode_EX);
                errors = errors + 32'b1;
            end

            if (rd_EX !== rd_exp) begin
                $display("rd_EX ERROR -----> vector[%d] : instruction_EX[%b]", vectornum, instruction_EX);
                $display("expected value: %b, received %b", rd_exp, rd_EX);
                errors = errors + 32'b1;
            end

            if (funct3_EX !== funct3_exp) begin
                $display("funct3_EX ERROR -----> vector[%d] : instruction_EX[%b]", vectornum, instruction_EX);
                $display("expected value: %b, received %b", funct3_exp, funct3_EX);
                errors = errors + 32'b1;
            end

            if (rs1_EX !== rs1_exp) begin
                $display("rs1_EX ERROR -----> vector[%d] : instruction_EX[%b]", vectornum, instruction_EX);
                $display("expected value: %b, received %b", rs1_exp, rs1_EX);
                errors = errors + 32'b1;
            end

            if (rs2_EX !== rs2_exp) begin
                $display("rs1_EX ERROR -----> vector[%d] : instruction_EX[%b]", vectornum, instruction_EX);
                $display("expected value: %b, received %b", rs2_exp, rs2_EX);
                errors = errors + 32'b1;
            end

            if (funct7_EX !== funct7_exp) begin
                $display("funct7_EX ERROR -----> vector[%d] : instruction_EX[%b]", vectornum, instruction_EX);
                $display("expected value: %b, received %b", funct7_exp, funct7_EX);
                errors = errors + 32'b1;
            end

            if (imm12_EX !== imm12_exp) begin
                $display("imm12_EX ERROR -----> vector[%d] : instruction_EX[%b]", vectornum, instruction_EX);
                $display("expected value: %b, received %b", imm12_exp, imm12_EX);
                errors = errors + 32'b1;
            end

            if (imm20_EX !== imm20_exp) begin
                $display("imm20_EX ERROR -----> vector[%d] : instruction_EX[%b]", vectornum, instruction_EX);
                $display("expected value: %b, received %b", imm20_exp, imm20_EX);
                errors = errors + 32'b1;
            end

            if (csr_EX !== csr_exp) begin
                $display("csr_EX ERROR -----> vector[%d] : instruction_EX[%b]", vectornum, instruction_EX);
                $display("expected value: %b, received %b", csr_exp, csr_EX);
                errors = errors + 32'b1;
            end

            // increment the vector counter
            vectornum = vectornum + 32'b1;

            // display ending message, exit simulation
            if (testvectors[vectornum] === 109'bx) begin
                $display(
                    "%d tests completed with %d errors",
                    vectornum, errors);
                $finish;
            end
        end
    end

endmodule
