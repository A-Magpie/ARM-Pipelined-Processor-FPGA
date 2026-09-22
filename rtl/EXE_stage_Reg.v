
module EXE_stage_Reg (
    clk,
    rst,
    WB_EN_IN,
    MEM_R_EN_IN,
    MEM_W_EN_IN,
    ALU_Result_IN,
    SR_Val_IN,
    freeze,

    Dest_IN,//out
    Val_Rm,
    WB_EN,
    MEM_R_EN,
    MEM_W_EN,
    ALU_Result,
    Val_Rm_OUT,
    SR_Val,
    Dest
);


  input clk, rst, WB_EN_IN, MEM_R_EN_IN, MEM_W_EN_IN, freeze;
  input [3:0] Dest_IN;
  input [31:0] ALU_Result_IN, Val_Rm;
  input [3:0] SR_Val_IN;
  output reg WB_EN, MEM_R_EN, MEM_W_EN;
  output reg [31:0] ALU_Result, Val_Rm_OUT;
  output reg [3:0] SR_Val;
  output reg [3:0] Dest;



  always @(posedge clk, posedge rst) begin
    if (rst) begin
      WB_EN <= 1'b0;
      MEM_R_EN <= 1'b0;
      MEM_W_EN <= 1'b0;
      ALU_Result <= 32'd0;
      Val_Rm_OUT <= 32'd0;
      SR_Val <= 4'd0;
      Dest <= 4'd0;

    end else if(freeze) begin 
      WB_EN <= WB_EN;
      MEM_R_EN <= MEM_R_EN;
      MEM_W_EN <= MEM_W_EN;
      ALU_Result <= ALU_Result;
      Val_Rm_OUT <= Val_Rm_OUT;
      SR_Val <= SR_Val;
      Dest <= Dest;

    end else begin
      WB_EN <= WB_EN_IN;
      MEM_R_EN <= MEM_R_EN_IN;
      MEM_W_EN <= MEM_W_EN_IN;
      ALU_Result <= ALU_Result_IN;
      Val_Rm_OUT <= Val_Rm;
      SR_Val <= SR_Val_IN;
      Dest <= Dest_IN;
    end
  end
endmodule
