// test bench for the decoder module

module simdecoder;

    logic clk, reset;
    logic [31:0] vectornum, errors;
    logic [31:0] testvectors[10000:0];
    logic instruction_EX [31:0];

    decoder dut();

    // generate clock
    always begin
        clk = 1'b1; #5; clk = 1'b0; #5;
    end

    // read test vectors
    initial begin
        $readmemb("testdecoder.dat", testvectors);
        vectornum = 32'b0; errors=32'b0;
        reset = 1'b1; #20; reset = 1'b0;
    end

    // apply test vectors on rising clock edge
    always @(posedge clk) begin
        instruction_EX = testvectors[vectornum];
        $display(instruction_EX);
    end


