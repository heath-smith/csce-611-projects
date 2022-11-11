// testbench for CPU
module simcpu;

    logic clk, rst_n;
    logic [31:0] GPIO_in, GPIO_out;

    cpu dut(
        .clk(clk),
        .rst_n(rst_n),
        .GPIO_in(GPIO_in),
        .GPIO_out(GPIO_out)
    );


   initial begin
        rst_n = 1'b0; #20;
	GPIO_in = 18'b00_1111_0000_0000_0000;
        rst_n = 1'b1;
    end

    always begin
        clk = 1'b1; #5;
        clk = 1'b0; #5;
    end



    always @(posedge clk) begin
        $display("CPU output --->  %h", GPIO_out);
    end

endmodule
