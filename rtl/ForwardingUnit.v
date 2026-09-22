module ForwardingUnit (
    input [3:0] WB_Dest,
    input WB_WB_EN,
    input MEM_WB_EN,
    input [3:0] MEM_Dest,
    input [3:0] src1,
    input [3:0] src2,
    output reg Sel_src1,
    output reg Sel_src2
);

  always @(*) begin
    // default: no forwarding
    Sel_src1 = 1'b0;
    Sel_src2 = 1'b0;

    // ---------- src1 ----------
    if (MEM_WB_EN && (MEM_Dest != 4'b0000) && (MEM_Dest == src1)) Sel_src1 = 1'b1;
    else if (WB_WB_EN && (WB_Dest != 4'b0000) && (WB_Dest == src1)) Sel_src1 = 1'b1;

    // ---------- src2 ----------
    if (MEM_WB_EN && (MEM_Dest != 4'b0000) && (MEM_Dest == src2)) Sel_src2 = 1'b1;
    else if (WB_WB_EN && (WB_Dest != 4'b0000) && (WB_Dest == src2)) Sel_src2 = 1'b1;
  end



endmodule
