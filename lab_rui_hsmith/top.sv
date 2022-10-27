
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
	assign LEDR = SW;
	//assign LEDG = leds[7:0];
	assign LEDG = 8'b0000_0000;

	/* LED state register, 0 means going left, 1 means going right */
	logic ledstate;

	logic [31:0] CPU_in;
	logic [31:0] CPU_out;
	assign CPU_in = {14'b0, SW};

//=======================================================
//  Structural coding
//=======================================================


	initial begin
		clkdiv = 26'h0;
	end

	cpu _cpu(
		.clk(CLOCK_50),
		.rst_n(KEY[0]),
		.GPIO_in(CPU_in),
		.GPIO_out(CPU_out)
	);

	hexdriver hex_0(.val(CPU_out[3:0]), .HEX(HEX7));
	hexdriver hex_1(.val(CPU_out[7:4]), .HEX(HEX6));
	hexdriver hex_2(.val(CPU_out[11:8]), .HEX(HEX5));
	hexdriver hex_3(.val(CPU_out[15:12]), .HEX(HEX4));
	hexdriver hex_4(.val(CPU_out[19:16]), .HEX(HEX3));
	hexdriver hex_5(.val(CPU_out[23:20]), .HEX(HEX2));
	hexdriver hex_6(.val(CPU_out[27:24]), .HEX(HEX1));
	hexdriver hex_7(.val(CPU_out[31:28]), .HEX(HEX0));


endmodule
