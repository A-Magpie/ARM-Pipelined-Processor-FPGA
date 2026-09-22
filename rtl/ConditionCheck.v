module Condition_Check (
    input [3:0] cond,
    input [3:0] status,                // [N Z C V] = [3:0]
    output reg out
);
  wire Z = status[3];
  wire C = status[2];
  wire N = status[1];
  wire V = status[0];
  always @(*) begin
    case (cond)
      4'b0000: out = Z;                 // EQ: Z set
      4'b0001: out = ~Z;                // NE: Z clear
      4'b0010: out = C;                 // CS/HS: C set
      4'b0011: out = ~C;                // CC/LO: C clear
      4'b0100: out = N;                 // MI: N set
      4'b0101: out = ~N;                // PL: N clear
      4'b0110: out = V;                 // VS: V set
      4'b0111: out = ~V;                // VC: V clear
      4'b1000: out = C & ~Z;            // HI: C set and Z clear
      4'b1001: out = ~C | Z;            // LS: C clear or Z set
      4'b1010: out = (N == V);          // GE: N == V
      4'b1011: out = (N != V);          // LT: N != V
      4'b1100: out = ~Z & (N == V);     // GT: Z clear and N == V
      4'b1101: out = Z | (N != V);      // LE: Z set or N != V
      4'b1110: out = 1'b1;              // AL: Always
      4'b1111: out = 1'b0;              // Reserved (Never execute)
      default: out = 1'b0;              // Default safe
    endcase
  end
endmodule

