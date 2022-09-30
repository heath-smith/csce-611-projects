
//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================


module top (

	//////////// CLOCK //////////
	input 		          		CLOCK_50,
	input 		          		CLOCK2_50,
	input 		          		CLOCK3_50,

	//////////// LED //////////
	output		     [8:0]		LEDG,
	output		    [17:0]		LEDR,

	//////////// KEY //////////
	input 		     [3:0]		KEY,

	//////////// SW //////////
	input 		    [17:0]		SW,

	//////////// SEG7 //////////
	output		     [6:0]		HEX0,
	output		     [6:0]		HEX1,
	output		     [6:0]		HEX2,
	output		     [6:0]		HEX3,
	output		     [6:0]		HEX4,
	output		     [6:0]		HEX5,
	output		     [6:0]		HEX6,
	output		     [6:0]		HEX7
);



//=======================================================
//  REG/WIRE declarations
//=======================================================

	/* 24 bit clock divider, converts 50MHz clock signal to 2.98Hz */
	logic [23:0] clkdiv;
	logic ledclk;
	assign ledclk = clkdiv[23];

	/* driver for LEDs */
	//logic [25:0] leds;
	//assign LEDR = leds[25:8];
	assign LEDR = SW;
	//assign LEDG = leds[7:0];
	assign LEDG = 8'b0000_0000;

	/* LED state register, 0 means going left, 1 means going right */
	logic ledstate;
	
	// default 7-seg value
	logic [3:0] seg_0;
	logic [3:0] seg_1;
	logic [3:0] seg_2;
	logic [3:0] seg_3;
	logic [3:0] seg_4;
	assign seg_0 = SW[3:0];
	assign seg_1 = SW[7:4];
	assign seg_2 = SW[11:8];
	assign seg_3 = SW[15:12];
	assign seg_4[1:0] = SW[17:16];
//=======================================================
//  Structural coding
//=======================================================


	initial begin
		clkdiv = 26'h0;
		/* start at the far right, LEDG0 */
		//leds = 26'b1;
		/* start out going to the left */
		ledstate = 1'b0;
		/* set unused bits of seg_4 */
		seg_4[3:2] = 2'b00;
	end


	
	
	hexdriver hex_0(.val(seg_0), .HEX(HEX0));
	hexdriver hex_1(.val(seg_1), .HEX(HEX1));
	hexdriver hex_2(.val(seg_2), .HEX(HEX2));
	hexdriver hex_3(.val(seg_3), .HEX(HEX3));
	hexdriver hex_4(.val(seg_4), .HEX(HEX4));
	hexdriver hex_5(.val(4'b0000), .HEX(HEX5));
	hexdriver hex_6(.val(4'b0000), .HEX(HEX6));
	hexdriver hex_7(.val(4'b0000), .HEX(HEX7));
	
	always @(posedge CLOCK_50) begin
		/* drive the clock divider, every 2^26 cycles of CLOCK_50, the
		* top bit will roll over and give us a clock edge for clkdiv
		* */
		clkdiv <= clkdiv + 1;
	end

	// always @(posedge ledclk) begin	
		/* going left and we are at the far left, time to turn around */
		// if ( (ledstate == 0) && (leds == 26'b10000000000000000000000000) ) begin
			// ledstate <= 1;
			// leds <= leds >> 1;

		/* going left and not at the far left, keep going */
		// end else if (ledstate == 0) begin
			// ledstate <= 0;
			// leds <= leds << 1;

		/* going right and we are at the far right, turn around */
		// end else if ( (ledstate == 1) && (leds == 26'b1) ) begin
			// ledstate <= 0;
			// leds <= leds << 1;

		/* going right, and we aren't at the far right */
		// end else begin
			// leds <= leds >> 1;
		//end	
	// end

endmodule
