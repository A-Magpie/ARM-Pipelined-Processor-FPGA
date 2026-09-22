module PC (
    PC_in,
    PC_out,
    clk,
    rst,
    frz
);

  input clk, rst, frz;
  input [31:0] PC_in;
  output reg [31:0] PC_out;

  always @(posedge clk, posedge rst) begin

    if (rst) PC_out <= 32'd0;
    else if (frz) PC_out <= PC_out;
    else PC_out <= PC_in;

  end

endmodule
