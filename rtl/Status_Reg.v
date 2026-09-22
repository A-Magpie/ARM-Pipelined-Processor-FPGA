module Status_Reg (
    clk,
    rst,
    Status_bits_IN,
    S_load,
    Status_bits_OUT
);


  input [3:0] Status_bits_IN;
  input S_load, clk, rst;

  output reg [3:0] Status_bits_OUT;


  always @(negedge clk, posedge rst) begin
    if (rst) begin
      Status_bits_OUT <= 4'b0000;
    end else begin
      if (S_load) Status_bits_OUT <= Status_bits_IN;

    end
  end
endmodule
