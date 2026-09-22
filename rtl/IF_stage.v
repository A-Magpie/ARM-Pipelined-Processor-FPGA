module IF_stage (
    input clk,
    input rst,
    input frz,
    input [31:0] Br_Adder,
    input B,
    output [31:0] Inst,
    PC_out
);
  wire [31:0] pcin;
  wire [31:0] pc_o;
  wire [10:0] pc_DEC = pc_o[10:0];

  MUX2to1 MUX_2_1_inst (
      .inA(PC_out),
      .inB(Br_Adder),
      .sel(B),
      .out(pcin)
  );

  PC PC_inst (
      .PC_in(pcin),
      .PC_out(pc_o),
      .clk(clk),
      .rst(rst),
      .frz(frz)
  );

  Adder Adder_IF_inst (
      .inA(32'd1),
      .inB(pc_o),
      .out(PC_out)
  );

  Instmem Instmem_inst (
      .a  (pc_o[10:0]),  // input wire [10 : 0] a
      .spo(Inst)         // output wire [31 : 0] spo
  );
endmodule



