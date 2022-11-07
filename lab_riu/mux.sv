// 32-bit multiplexer
module mux(
    // inputs
    input logic [31:0] a,
    input logic [31:0] b,
    input logic  s,
    // outputs
    output logic [31:0] y
);

assign y = (s) ? b : a;

endmodule
