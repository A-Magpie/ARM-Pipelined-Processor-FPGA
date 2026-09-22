module ID_stage (
    clk,
    rst,
    Instruction,
    Result_WB,
    Write_Back_EN,
    Dest_WB,
    Hazard,
    SR,
    WB_EN,  //out
    MEM_R_EN,
    MEM_W_EN,
    B,
    S,
    EXE_CMD,
    Val_Rn,
    Val_Rm,
    Imm,
    Shift_Operand,
    Signed_Imm_24,
    Dest,
    Src1,
    Src2,
    Two_src
);
  input clk, rst, Write_Back_EN, Hazard;
  input [31:0] Instruction, Result_WB;
  input [3:0] Dest_WB, SR;

  output WB_EN, MEM_R_EN, MEM_W_EN, B, S, Two_src, Imm;
  output [3:0] EXE_CMD, Dest, Src1, Src2;
  output [31:0] Val_Rn, Val_Rm;
  output [11:0] Shift_Operand;
  output [23:0] Signed_Imm_24;


  wire CC_OUT, Sel_Mux2to1_9;
  wire [3:0] Mux4_OUT;                     //src2

  wire [8:0] CT_OUT, Mux9_OUT;
  wire CT_WB_EN, CT_MEM_R_EN, CT_MEM_W_EN, CT_B, CT_S;
  wire [3:0] CT_EXE_CMD;
  assign CT_OUT = {CT_WB_EN, CT_MEM_R_EN, CT_MEM_W_EN, CT_B, CT_S, CT_EXE_CMD};

  controller CT (
      .cond(Instruction[31:28]),
      .mode(Instruction[27:26]),
      .opcode(Instruction[24:21]),
      .S_IN(Instruction[20]),
      .WB_EN(CT_WB_EN),
      .MEM_R_EN(CT_MEM_R_EN),
      .MEM_W_EN(CT_MEM_W_EN),
      .EXE_CMD(CT_EXE_CMD),
      .B(CT_B),
      .S_OUT(CT_S)
  );

  Condition_Check CC (
      .cond  (Instruction[31:28]),
      .status(SR),
      .out   (CC_OUT)
  );

  Register_File RF (
      .clk          (clk),
      .rst          (rst),
      .Src1         (Instruction[19:16]),  // Rn
      .Src2         (Mux4_OUT),
      .Dest_WB      (Dest_WB),
      .Result_WB    (Result_WB),
      .Write_Back_EN(Write_Back_EN),
      .Reg1         (Val_Rn),
      .Reg2         (Val_Rm)
  );

  nor1 NOR_inst (
      Instruction[25],                     // I
      MEM_W_EN,                            // CT_MEM_R_EN?
      Two_src
  );

  Mux2 #(4) M1 (
      .a  (Instruction[3:0]),              // Rm
      .b  (Instruction[15:12]),            // Rd
      .sel(MEM_W_EN),                      // CT_MEM_W_EN?
      .out(Mux4_OUT)
  );

  or1 OR_inst (
      ~CC_OUT,
      Hazard,
      Sel_Mux2to1_9
  );

  Mux2 #(9) M2 (
      .b  (9'b000000000),
      .a  (CT_OUT),
      .sel(Sel_Mux2to1_9),
      .out(Mux9_OUT)                       // ----> goes to ID_reg
  );

  assign WB_EN = Mux9_OUT[8];
  assign MEM_R_EN = Mux9_OUT[7];
  assign MEM_W_EN = Mux9_OUT[6];
  assign B = Mux9_OUT[5];
  assign S = Mux9_OUT[4];
  assign EXE_CMD = Mux9_OUT[3:0];

  assign Signed_Imm_24 = Instruction[23:0];
  assign Imm = Instruction[25];
  assign Src1 = Instruction[19:16];
  assign Dest = Instruction[15:12];
  assign Shift_Operand = Instruction[11:0];

  assign Src2 = Mux4_OUT;
endmodule
