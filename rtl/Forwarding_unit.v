module Forwarding_Unit (
    input en,
    input [3:0] src1, src2,
    input wb_en_mem,
    input [3:0] dest_mem,
    input wb_en_wb,
    input [3:0] dest_wb,
    output reg [1:0] sel_src1, sel_src2
);
  always @(*) begin
    sel_src1 = 2'b00;
    sel_src2 = 2'b00;
    if (en) begin
      // Forwarding for Src1
      if (wb_en_mem && dest_mem == src1) sel_src1 = 2'b01; // From MEM
      else if (wb_en_wb && dest_wb == src1) sel_src1 = 2'b10; // From WB

      // Forwarding for Src2
      if (wb_en_mem && dest_mem == src2) sel_src2 = 2'b01; // From MEM
      else if (wb_en_wb && dest_wb == src2) sel_src2 = 2'b10; // From WB
    end
  end
endmodule
