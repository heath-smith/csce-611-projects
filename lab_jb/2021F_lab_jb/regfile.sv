/* 32 x 32 register file implementation */

module regfile (

/**** inputs *****************************************************************/

	input [0:0 ] clk,		/* clock */
	input [0:0 ] rst,		/* reset */
	input [0:0 ] we,		/* write enable */
	input [4:0 ] readaddr1,		/* read address 1 */
	input [4:0 ] readaddr2,		/* read address 2 */
	input [4:0 ] writeaddr,		/* write address */
	input [31:0] writedata,		/* write data */

/**** outputs ****************************************************************/

	output [31:0] readdata1,	/* read data 1 */
	output [31:0] readdata2		/* read data 2 */
);



logic [31:0] mem[31:0];
// note that declaring readdata*, reg30_out as 'output reg' would have the
// same effect.
logic [31:0] readdata1_buf, readdata2_buf;


always_ff @(posedge clk, posedge rst) begin


	if (rst) begin
		// initialize reg 0 to 0
		mem[0] <= 0;
	end

	else begin

		// write to the requested addr iff we is high

		// handle case where we are writing to reg0. we explicitly write 0 to
		// as a precaution to make sure nothing gets optimized out of the
		// design.
		if (we && (writeaddr == 0)) mem[0] <= 0;

		// handle the default case
		else if (we) mem[writeaddr] <= writedata;

	end

end

always_comb begin
	// $monitor("reg 6: %8h", mem[6]);
	// $monitor("reg 5: %8h", mem[5]);
	// $monitor("writeaddr: %8h, we: %1h", writeaddr, we);

	// special case to prevent write bypass from kicking in for reg0
	if (we && (readaddr1 == 0)) readdata1_buf = 0;

	// write-bypass
	else if (we && (readaddr1 == writeaddr)) readdata1_buf = writedata;

	// default case
	else readdata1_buf = mem[readaddr1];

	if (we && (readaddr2 == 0)) readdata2_buf = 0;
	else if (we && (readaddr2 == writeaddr)) readdata2_buf = writedata;
	else readdata2_buf = mem[readaddr2];
end

// connect the output buffers to the output wires
assign readdata1 = readdata1_buf;
assign readdata2 = readdata2_buf;

endmodule
