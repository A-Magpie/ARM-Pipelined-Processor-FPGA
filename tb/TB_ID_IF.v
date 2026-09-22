`timescale 1ns / 1ps
module tb_IF_ID;

  reg clk=0;
  reg rst=0;
  reg FU_en=1;


  // Instantiate the DUT (Device Under Test)
  ARM uut (
      .clk(clk),
      .rst(rst),
      .forwarding_en(FU_en)
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

    // Run the simulation for a while
    #3500;

    // Finish simulation
    $stop;
  end

endmodule
