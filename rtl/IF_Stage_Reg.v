module IF_stage_Reg (
    clk,
    rst,
    PC_in_IF,
    PC_out_IF,
    instruction_in,
    instruction_out,
    freeze,
    flush
);
  input clk, rst, freeze, flush;
  input [31:0] PC_in_IF, instruction_in;

  output reg [31:0] PC_out_IF, instruction_out;



  always @(posedge clk, posedge rst) begin
    if (rst) begin
      PC_out_IF <= 32'd0;
      instruction_out <= 32'd0;
    end else if (freeze) begin
      PC_out_IF <= PC_out_IF;
      instruction_out <= instruction_out;
    end else if (flush) begin
      PC_out_IF <= 32'd0;
      instruction_out <= 32'd0;
    end else begin
      PC_out_IF <= PC_in_IF;
      instruction_out <= instruction_in;

    end
  end
endmodule

