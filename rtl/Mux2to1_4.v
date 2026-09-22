module Mux2to1_4 (a , b , sel , out);

input [3:0] a , b ;
input sel ;
output reg [3:0] out;


always @(a , b, sel) begin
    out <= (sel) ? b : a ;
end

endmodule