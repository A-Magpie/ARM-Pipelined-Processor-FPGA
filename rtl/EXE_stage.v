module EXE_stage (
    clk,
    rst,
    EXE_CMD,
    MEM_R_EN,
    MEM_W_EN,
    PC,
    S_load,
    Val_Rn,
    Val_Rm,
    Imm,
    Shift_Operand,
    Signed_Imm_24,
    SR,
    // Output
    ALU_Result,
    Br_Addr,
    SR_out
);
  input clk, rst, MEM_R_EN, MEM_W_EN, Imm;
  input S_load;
  input [3:0] EXE_CMD, SR;
  input [11:0] Shift_Operand;
  input [31:0] Signed_Imm_24;
  input [31:0] PC, Val_Rm, Val_Rn;

  output [31:0] ALU_Result, Br_Addr;
  output [3:0] SR_out;

  wire [3:0] Status;

  wire Out_or;
  wire [31:0] Val2;
  wire N, Z, C, V;

  ALU A1 (
      .EXE_CMD(EXE_CMD),
      .Val1(Val_Rn),
      .Val2(Val2),
      .Cin(SR[1]),
      .C(C),
      .ALU_Res(ALU_Result),
      .N(N),
      .Z(Z),
      .V(V)
  );
  Val2_Generate V1 (
      .Val_Rm(Val_Rm),
      .Shift_operand(Shift_Operand),
      .imm(Imm),
      .Out_or(Out_or),
      .Val2(Val2)
  );
  Adder A2 (
      .inA(PC),
      .inB(Signed_Imm_24),
      .out(Br_Addr)
  );
  or1 O1 (
      MEM_W_EN,
      MEM_R_EN,
      Out_or
  );
//   assign Status = {Z, C, N, V};

  Status_Reg SR_inst (
      .clk(clk),
      .rst(rst),
      .Status_bits_IN({Z, C, N, V}),
      .S_load(S_load),
      .Status_bits_OUT(SR_out)
  );

endmodule
