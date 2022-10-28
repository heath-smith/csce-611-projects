/* Copyright 2020 Jason Bakos, Philip Conrad, Charles Daniels */

/* Top-level module for CSCE611 RISC-V CPU, for running under simulation.  In
 * this case, the I/Os and clock are driven by the simulator. */

module simtop;

	logic clk;
	logic [2:0] KEY;
 	logic [6:0] HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7;
	logic [17:0] SW;
	logic [31:0] HEX_DISPLAY;


	assign HEX_DISPLAY = { HEX7,HEX6,HEX5,HEX4,HEX3,HEX2,HEX1,HEX0 };

	top dut
	(
		//////////// CLOCK //////////
		.CLOCK_50(clk),
		.CLOCK2_50(),
	        .CLOCK3_50(),

		//////////// LED //////////
		.LEDG(),
		.LEDR(),

		//////////// KEY //////////
		.KEY(KEY),

		//////////// SW //////////
		.SW(SW),

		//////////// SEG7 //////////
		.HEX0(HEX0),
		.HEX1(HEX1),
		.HEX2(HEX2),
		.HEX3(HEX3),
		.HEX4(HEX4),
		.HEX5(HEX5),
		.HEX6(HEX6),
		.HEX7(HEX7)
	);


    	always begin
      		clk = 1'b1; #5;
        	clk = 1'b0; #5;
    	end

    	initial begin
        	SW = 18'b00_0000_0000_1110_1010;
        	KEY[0] = 1'b0; #20;
        	KEY[0] = 1'b1;
    	end

    	always @(posedge clk) begin
        	$display("HEX DISPLAY output --->  %h", HEX_DISPLAY);
    	end

endmodule

