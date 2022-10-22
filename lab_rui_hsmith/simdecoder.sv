// test bench for the decoder module

module simdecoder;

    logic clk, reset;
    logic [31:0] vectornum, errors;
    logic [31:0] testvectors[10000:0];
    logic [31:0] instruction_EX;

    //decoder dut();

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
        instruction_EX = testvectors[vectornum];

    end

    always @(negedge clk) begin
        $display("%d : %h", vectornum, instruction_EX);
        vectornum = vectornum + 32'b1;
        if (testvectors[vectornum] === 32'bx) begin
            $display(
                "%d tests completed with %d errors",
                vectornum, errors);
            $finish;
        end
    end

endmodule
