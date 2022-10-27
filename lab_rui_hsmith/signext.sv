// sign extend module
module signext(
    input logic [11:0] in12,
	 input logic [6:0] opcode,
    output logic [31:0] out32
);

always_comb begin
	out32 = (opcode == 7'b0110111) ? { {20{in12[11]}}, in12} : { 20'b0, $unsigned(in12) } ;
end

endmodule