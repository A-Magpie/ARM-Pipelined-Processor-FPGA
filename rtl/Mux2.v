module Mux2#(parameter BITS = 4) (a , b , sel , out);

input [BITS - 1:0] a , b ;
input sel ;
output reg [BITS - 1:0] out;

always @(a , b, sel) begin
    out <= (sel) ? b :a;
end

endmodule