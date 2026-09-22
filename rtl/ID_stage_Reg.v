module ID_stage_reg (
    clk,
    rst,
    flush,
    WB_EN_IN,
    MEM_R_EN_IN,
    MEM_W_EN_IN,
    B_IN,
    S_IN,
    EXE_CMD_IN,
    PC_IN,
    Val_Rn_IN,
    Val_Rm_IN,
    Imm_IN,
    Shift_Operand_IN,
    Signed_Imm_24_IN,
    Dest_IN,
    Src1_IN,
    Src2_IN,
    freeze,
    WB_EN,//out
    MEM_R_EN,
    MEM_W_EN,
    B,
    S,
    EXE_CMD,
    PC,
    Val_Rn,
    Val_Rm,
    Imm,
    Shift_Operand,
    Signed_Imm_24,
    Dest,
    SR_IN,
    SR_OUT,
    Src1,
    Src2
);


  input clk, rst, flush, WB_EN_IN, MEM_R_EN_IN, MEM_W_EN_IN, B_IN, S_IN, Imm_IN, freeze;
  input [3:0] EXE_CMD_IN, Dest_IN, SR_IN, Src1_IN, Src2_IN;
  input [31:0] PC_IN, Val_Rn_IN, Val_Rm_IN;
  input [11:0] Shift_Operand_IN;
  input [23:0] Signed_Imm_24_IN;

  output reg WB_EN, MEM_R_EN, MEM_W_EN, B, S, Imm;
  output reg [3:0] EXE_CMD, Dest, SR_OUT, Src1, Src2;
  output reg [31:0] PC, Val_Rn, Val_Rm;
  output reg [11:0] Shift_Operand;
  output reg [31:0] Signed_Imm_24;



  always @(posedge clk, posedge rst) begin
    if (rst) begin
      WB_EN <= 1'b0;
      MEM_R_EN <= 1'b0;
      MEM_W_EN <= 1'b0;
      B <= 1'b0;
      S <= 1'b0;
      Imm <= 1'b0;
      EXE_CMD <= 4'b0000;
      Dest <= 4'b0000;
      Shift_Operand <= 12'd0;
      Signed_Imm_24 <= 32'd0;
      PC <= 32'd0;
      Val_Rn <= 32'd0;
      Val_Rm <= 32'd0;
      SR_OUT <= 4'd0;
      Src1 <= 4'd0; Src2 <= 4'd0;

    end else if (flush) begin
      WB_EN <= 1'b0;
      MEM_R_EN <= 1'b0;
      MEM_W_EN <= 1'b0;
      B <= 1'b0;
      S <= 1'b0;
      Imm <= 1'b0;
      EXE_CMD <= 4'b0000;
      Dest <= 4'b0000;
      Shift_Operand <= 12'd0;
      Signed_Imm_24 <= 32'd0;
      PC <= 32'd0;
      Val_Rn <= 32'd0;
      Val_Rm <= 32'd0;
      SR_OUT <= 4'd0;
      Src1 <= 4'd0; Src2 <= 4'd0;

    end else if (freeze) begin
      WB_EN <= WB_EN;
      MEM_R_EN <= MEM_R_EN;
      MEM_W_EN <= MEM_W_EN;
      B <= B;
      S <= S;
      Imm <= Imm;
      EXE_CMD <= EXE_CMD;
      Dest <= Dest;
      Shift_Operand <= Shift_Operand;
      Signed_Imm_24 <= Signed_Imm_24;
      Val_Rn <= Val_Rn;
      Val_Rm <= Val_Rm;
      PC <= PC;
      SR_OUT <= SR_OUT;
      Src1 <= Src1;
      Src2 <= Src2;

    end else begin
      WB_EN <= WB_EN_IN;
      MEM_R_EN <= MEM_R_EN_IN;
      MEM_W_EN <= MEM_W_EN_IN;
      B <= B_IN;
      S <= S_IN;
      Imm <= Imm_IN;
      EXE_CMD <= EXE_CMD_IN;
      Dest <= Dest_IN;
      Shift_Operand <= Shift_Operand_IN;
      Signed_Imm_24 <= {{8{Signed_Imm_24_IN[23]}}, Signed_Imm_24_IN};
      Val_Rn <= Val_Rn_IN;
      Val_Rm <= Val_Rm_IN;
      PC <= PC_IN;
      SR_OUT <= SR_IN;
      Src1 <= Src1_IN;
      Src2 <= Src2_IN;
    end
  end



endmodule
