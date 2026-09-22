module Adder (
    inA,
    inB,
    out
);
  input [31:0] inA, inB;
  output [31:0] out;
  assign out = inA + inB;
endmodule
