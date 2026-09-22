module MEM_stage_Reg (
    clk,
    rst,
    WB_EN_IN,
    MEM_R_EN_IN,
    ALU_Result_IN,
    MEM_OUT_IN,
    Dest_IN,
    freeze,

    WB_EN,  //out
    MEM_R_EN,
    ALU_Result,
    MEM_OUT,
    Dest
);

  input clk, rst, WB_EN_IN, MEM_R_EN_IN, freeze;
  input [3:0] Dest_IN;
  input [31:0] ALU_Result_IN, MEM_OUT_IN;
  output reg WB_EN, MEM_R_EN;
  output reg [31:0] ALU_Result, MEM_OUT;
  output reg [3:0] Dest;


  always @(posedge clk, posedge rst) begin
    if (rst) begin
      WB_EN <= 1'b0;
      MEM_R_EN <= 1'b0;
      ALU_Result <= 32'd0;
      MEM_OUT <= 32'd0;
      Dest <= 4'd0;

    end else if (freeze) begin
      WB_EN <= WB_EN;
      MEM_R_EN <= MEM_R_EN;
      ALU_Result <= ALU_Result;
      MEM_OUT <= MEM_OUT;
      Dest <= Dest;

    end else begin
      WB_EN <= WB_EN_IN;
      MEM_R_EN <= MEM_R_EN_IN;
      ALU_Result <= ALU_Result_IN;
      MEM_OUT <= MEM_OUT_IN;
      Dest <= Dest_IN;
    end
  end

endmodule
