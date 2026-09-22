`timescale 1ns / 1ps
module tb_IF;

  reg clk=0;
  reg rst=0;
  reg frz=0;
  reg Br_Adder;
  reg B;
  wire [31:0] Inst, PC_out;

  // Instantiate the DUT (Device Under Test)
  IF_stage uut (
      .clk(clk),
      .rst(rst),
      .frz(frz),
      .Br_Adder(Br_Adder),
      .B(B),
      .Inst(Inst),
      .PC_out(PC_out)
  );

  // Clock generator: 10ns period (100 MHz)
  always #5 clk = ~clk;

  initial begin
    // Initialize signals
    clk = 0;
    rst = 1;

    // Hold reset for a few cycles
    #15;
    rst = 0;
    frz = 0;
    B   = 0;
    // Run the simulation for a while
    #200;

    // Finish simulation
    $stop;
  end

endmodule
