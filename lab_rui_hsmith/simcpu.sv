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


    always begin
        clk = 1'b1; #5;
        clk = 1'b0; #5;
    end

    initial begin
        GPIO_in = 32'd0;
        rst_n = 1'b0; #20;
        rst_n = 1'b1;
    end

    //always @(posedge clk) begin
        //$display("CPU result --->  %h", GPIO_out);
    //    $display(" ----- Positive Clock Edge ----- ");
    //end

endmodule
