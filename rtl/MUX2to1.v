module MUX2to1 (
    inA,
    inB,
    sel,
    out
);
  input [31:0] inA, inB;
  output [31:0] out;
  input sel;

  assign out = (sel) ? inB : inA;
endmodule




