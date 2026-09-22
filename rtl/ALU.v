module ALU (
    EXE_CMD,
    Val1,
    Val2,
    Cin,
    C,
    ALU_Res,
    N,
    Z,
    V
);
  input [3:0] EXE_CMD;
  input [31:0] Val1, Val2;
  input Cin;
  output reg C;
  output N;
  output reg V;
  output Z;
  output reg [31:0] ALU_Res;

  always @(Val1, Val2, EXE_CMD, Cin) begin
    V = 1'b0;
    C = 1'b0;
    case (EXE_CMD)
      4'b0001: ALU_Res = Val2;
      4'b1001: ALU_Res = ~Val2;
      4'b0010: begin
        {C, ALU_Res} = Val1 + Val2;
        V = (~Val1[31] & ~Val2[31] & ALU_Res[31]) | (Val1[31] & Val2[31] & ~ALU_Res[31]);
      end
      4'b0011: begin
        {C, ALU_Res} = Val1 + Val2 + Cin;
        V = (~Val1[31] & ~Val2[31] & ALU_Res[31]) | (Val1[31] & Val2[31] & ~ALU_Res[31]);
      end
      4'b0100: begin
        {C, ALU_Res} = Val1 - Val2;
        V = (~Val1[31] & Val2[31] & ALU_Res[31]) | (Val1[31] & ~Val2[31] & ~ALU_Res[31]); // Subtract
      end
      4'b0101: begin
        {C, ALU_Res} = Val1 - Val2 - !Cin;
        V = (~Val1[31] & Val2[31] & ALU_Res[31]) | (Val1[31] & ~Val2[31] & ~ALU_Res[31]); // SubtractC
      end
      4'b0110: ALU_Res = Val1 & Val2;
      4'b0111: ALU_Res = Val1 | Val2;
      4'b1000: ALU_Res = Val1 ^ Val2;
      default: begin
        ALU_Res = 32'b0;
      end
    endcase
  end
  assign Z = (ALU_Res == 32'd0) ? 1 : 0;
  assign N = ALU_Res[31];
endmodule
