// Behavioral representation of a
// 4 to 1 multiplexer
module mux4(

    // inputs
    input a, b, c, d,
    input logic [1:0] s,

    // output
    output out

);

assign out = s[1] ? (s[0] ? d : c) : (s[0] ? b : a);

endmodule