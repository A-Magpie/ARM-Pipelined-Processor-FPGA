module ARM_wrapper (
    input clk,
    input key1
);

  wire deb_out, rst;
  debouncer deb_inst (
      .SIGNAL_I(key1),
      .CLK_I(clk),
      .SIGNAL_O(deb_out)
  );
  assign rst = ~deb_out;

  ARM ARM_inst (
      .clk(clk),
      .rst(rst)
  );


  ila_0 ILA_inst (
      .clk(clk),  // input wire clk


      .probe0(rst),  // input wire [0:0]  probe0  
      .probe1(ARM_inst.EXE_stage_inst.SR),  // input wire [3:0]  probe1 
      .probe2(ARM_inst.EXE_stage_inst.Status),  // input wire [3:0]  probe2 
      .probe3(ARM_inst.EXE_stage_inst.ALU_Result)  // input wire [31:0]  probe3
  );

endmodule
