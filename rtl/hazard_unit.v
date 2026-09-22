module Hazard (
    input [3:0] Src1, Src2,
    input two_src,
    input EXE_WB_EN,
    input [3:0] EXE_Dest,
    input MEM_WB_EN,
    input EN,
    input EXE_MEM_R_EN,
    input [3:0] MEM_Dest,
    output reg HAZARD
);
  always @(*) begin
    HAZARD = 1'b0;
    if (EN) begin                                   // w/ forwarding
      if (EXE_MEM_R_EN && EXE_WB_EN) begin
        if (Src1 == EXE_Dest) HAZARD = 1'b1;
        if (two_src && Src2 == EXE_Dest) HAZARD = 1'b1;
      end
    end else begin                                  // w/o forwading 
      if (EXE_WB_EN && (Src1 == EXE_Dest || (two_src && Src2 == EXE_Dest))) HAZARD = 1'b1;
      if (MEM_WB_EN && (Src1 == MEM_Dest || (two_src && Src2 == MEM_Dest))) HAZARD = 1'b1;
    end
  end
endmodule
