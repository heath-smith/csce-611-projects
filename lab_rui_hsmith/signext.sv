// sign extend module
module signext(
    input logic [11:0] in12,
    input logic [31:0] out32
);

// sign extend using most significant bit
// of 12-bit input value
assign out32 = { {20{in12[11]}}, in12};

endmodule