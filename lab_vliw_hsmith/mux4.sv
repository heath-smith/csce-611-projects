// Behavioral representation of a
// 32-bit 4 to 1 multiplexer
module mux4(

    // inputs
    input logic [31:0] a, b, c, d,
    input logic [1:0] s,

    // output
    output logic [31:0] out

);

    always_comb begin
         out = s[1] ? (s[0] ? d : c) : (s[0] ? b : a);
    end
endmodule