// 32-bit 3- way multiplexer
module mux3(
    // inputs
    input logic [31:0] a,
    input logic [31:0] b,
    input logic [31:0] c,
    input logic [1:0] s,

    // outputs
    output logic [31:0] y
);

    logic [31:0] temp;

    mux mux1(
        .a(a),
        .b(c),
        .s(s[1]),
        .y(temp)
    );

    mux mux2(
        .a(temp),
        .b(b),
        .s(s[0]),
        .y(y)
    );

endmodule