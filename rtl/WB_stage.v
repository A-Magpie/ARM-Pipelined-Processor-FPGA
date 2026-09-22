module WB_stage (
    ALU_Result,
    MEM_Result,
    MEM_R_EN,
    out_WB
);

  input [31:0] ALU_Result, MEM_Result;
  input MEM_R_EN;
  output [31:0] out_WB;
  assign out_WB = MEM_R_EN ? MEM_Result : ALU_Result;
endmodule
