module Val2_Generate (
    Val_Rm,
    Shift_operand,
    imm,
    Out_or,
    Val2
);
  input [31:0] Val_Rm;
  input [11:0] Shift_operand;
  input imm;
  input Out_or;
  output reg [31:0] Val2;

  wire [63:0] temp_rotate;
  assign temp_rotate = {24'b0, Shift_operand[7:0], 24'b0, Shift_operand[7:0]};
  wire [63:0] temp_Rm;
  assign temp_Rm = {Val_Rm, Val_Rm};
  always @(*) begin
    if (Out_or) Val2 = {20'b0, Shift_operand};
    else begin
      if (imm == 1) Val2 = temp_rotate[31+(Shift_operand[11:8]<<1)-:32];
      else begin
        case (Shift_operand[6:5])
          2'b00: Val2 = Val_Rm << Shift_operand[11:7];            // LSL
          2'b01: Val2 = Val_Rm >> Shift_operand[11:7];            // LSR
          2'b10: Val2 = $signed(Val_Rm) >>> Shift_operand[11:7];  // ASR
          2'b11: Val2 = temp_Rm[31+(Shift_operand[11:7])-:32];    // ROR
        endcase
      end
    end
  end
endmodule
