/* Copyright 2020 Jason Bakos, Philip Conrad, Charles Daniels */

/* Top-level module for CSCE611 RISC-V CPU, for running under simulation.  In
 * this case, the I/Os and clock are driven by the simulator. */

module simtop;

	logic clk;
	logic [6:0] HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7;
	logic [17:0] SW;

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
		.KEY(),

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

	// your code here
	initial begin
		clk = 0; #5;
		$display("-----------------------------");
		
		// HEX0
		SW = 17'b00_0000_0000_0000_0000;
		clk = 1; #5;
		if (HEX0 === 7'b100_0000) $display("HEX0 test 1 PASS");
		clk = 0; #5;
		
		SW = 17'b00_0000_0000_0000_0001;
		clk = 1; #5;
		if (HEX0 === 7'b111_1001) $display("HEX0 test 2 PASS");
		clk = 0; #5;
		$display("-----------------------------");

		// HEX1
		SW = 17'b00_0000_0000_0001_0000;
		clk = 1; #5;
		if (HEX1 === 7'b111_1001) $display("HEX1 test 1 PASS");
		clk = 0; #5;
		
		SW = 17'b00_0000_0000_0100_0000;
		clk = 1; #5;
		if (HEX1 === 7'b001_1001) $display("HEX1 test 2 PASS");
		clk = 0; #5;
		$display("-----------------------------");
		
		// HEX2
		SW = 17'b00_0000_1100_0000_0000;
		clk = 1; #5;
		if (HEX2 === 7'b100_0110) $display("HEX2 test 1 PASS");
		clk = 0; #5;
		
		SW = 17'b00_0000_0011_0000_0000;
		clk = 1; #5;
		if (HEX2 === 7'b011_0000) $display("HEX2 test 2 PASS");
		clk = 0; #5;
		$display("-----------------------------");
		
		// HEX3
		SW = 17'b00_1101_0000_0000_0000;
		clk = 1; #5;
		if (HEX3 === 7'b010_0001) $display("HEX3 test 1 PASS");
		clk = 0; #5;
		
		SW = 17'b00_1001_0000_0000_0000;
		clk = 1; #5;
		if (HEX3 === 7'b001_1000) $display("HEX3 test 2 PASS");
		clk = 0; #5;
		$display("-----------------------------");
		
		// HEX4
		SW = 17'b01_0000_0000_0000_0000;
		clk = 1; #5;
		if (HEX4 === 7'b111_1001) $display("HEX4 test 1 PASS");
		clk = 0; #5;
		
		SW = 17'b00_0000_0000_0000_0000;
		clk = 1; #5;
		if (HEX4 === 7'b100_0000) $display("HEX4 test 2 PASS");
		clk = 0; #5;
		$display("-----------------------------");	
		
	end

endmodule

