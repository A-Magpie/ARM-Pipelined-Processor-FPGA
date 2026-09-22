module Register_File (
    clk,
    rst,
    Src1,
    Src2,
    Dest_WB,
    Result_WB,
    Write_Back_EN,
    Reg1,
    Reg2
);
  input clk, rst, Write_Back_EN;
  input [3:0] Src1, Src2, Dest_WB;
  input [31:0] Result_WB;
  output [31:0] Reg1, Reg2;

  reg [31:0] RF[15:0];
  //read 
  assign Reg1 = RF[Src1];
  assign Reg2 = RF[Src2];
  integer i;
  //write
  always @(negedge clk, posedge rst)
    if (rst) begin
      RF[0] <= 32'd0;
      for (i = 1; i < 16; i = i + 1) RF[i] <= i;
    end else if (Write_Back_EN) begin
      RF[Dest_WB] <= Result_WB;
    end
endmodule
