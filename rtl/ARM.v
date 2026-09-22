module ARM (
    input clk,
    input rst,
    input forwarding_en
);
//-----------------------IF------------------------

  wire frz;
  wire B_ID_reg;
  wire Branch_taken;
  assign Branch_taken = B_ID_reg;

  wire [31:0] Br_Addr_out_EXE;
  wire [31:0] Inst_if;
  wire [31:0] PC_out_if;
  wire [ 3:0] Status_out_EXE;

  IF_stage IF_stage_inst (
      .clk(clk),
      .rst(rst),
      .frz(frz),
      .Br_Adder(Br_Addr_out_EXE),
      .B(Branch_taken),
      // Output
      .Inst(Inst_if),
      .PC_out(PC_out_if)
  );

  wire [31:0] Inst;
  wire [31:0] PC_out;


  //IF_stage_reg
  IF_stage_Reg IF_stage_reg_inst (
      .clk(clk),
      .rst(rst),
      .PC_in_IF(PC_out_if),
      .PC_out_IF(PC_out),
      .instruction_in(Inst_if),
      .instruction_out(Inst),
      .freeze(frz),
      .flush(Branch_taken)
  );

//-----------------------ID------------------------

  wire [31:0] WB_value = 32'd0;
  wire WB_EN_EN = 0;
  wire [3:0] WB_dest = 4'd0;
  wire Hzrd = 0;
  wire WB_EN_MEM_Reg;
  wire [3:0] Dest_out_MEM_Reg;
  wire [31:0] WB_out_WB;

  wire WB_EN;
  wire MEM_R_EN;
  wire MEM_W_EN;
  wire B;
  wire S;

  wire [3:0] EXE_CMD, Dest, Src1, Src2;
  wire [31:0] Val_Rn, Val_Rm;
  wire Imm, Two_src;
  wire [11:0] Shift_Operand;
  wire [23:0] Signed_Imm_24;


  ID_stage ID_stage_inst (
      .clk(clk),
      .rst(rst),
      .Instruction(Inst),
      .Result_WB(WB_out_WB),
      .Write_Back_EN(WB_EN_MEM_Reg),
      .Dest_WB(Dest_out_MEM_Reg),
      .Hazard(frz),
      .SR(Status_out_EXE),
      // Output
      .WB_EN(WB_EN),
      .MEM_R_EN(MEM_R_EN),
      .MEM_W_EN(MEM_W_EN),
      .B(B),
      .S(S),
      .EXE_CMD(EXE_CMD),
      .Val_Rn(Val_Rn),
      .Val_Rm(Val_Rm),
      .Imm(Imm),
      .Shift_Operand(Shift_Operand),
      .Signed_Imm_24(Signed_Imm_24),
      .Dest(Dest),
      .Src1(Src1),
      .Src2(Src2),
      .Two_src(Two_src)
  );

  wire WB_EN_ID_reg, MEM_R_EN_ID_reg, MEM_W_EN_ID_reg, S_ID_reg, Imm_ID_reg;
  wire [3:0] EXE_CMD_ID_reg, Dest_ID_reg, SR_OUT_ID_reg;
  wire [31:0] PC_ID_reg, Val_Rn_ID_reg, Val_Rm_ID_reg;
  wire [11:0] Shift_Operand_ID_reg;
  wire [31:0] Signed_Imm_24_ID_reg;
  wire [3:0] Src1_ID_reg, Src2_ID_reg;
  wire SRAM_Ready;

  ID_stage_reg ID_stage_reg_inst (
      .clk(clk),
      .rst(rst),
      .flush(Branch_taken),
      .WB_EN_IN(WB_EN),
      .MEM_R_EN_IN(MEM_R_EN),
      .MEM_W_EN_IN(MEM_W_EN),
      .B_IN(B),
      .S_IN(S),
      .EXE_CMD_IN(EXE_CMD),
      .PC_IN(PC_out),
      .Val_Rn_IN(Val_Rn),
      .Val_Rm_IN(Val_Rm),
      .Imm_IN(Imm),
      .Shift_Operand_IN(Shift_Operand),
      .Signed_Imm_24_IN(Signed_Imm_24),
      .Dest_IN(Dest),
      .Src1_IN(Src1),  // ID_stage
      .Src2_IN(Src2),  // ID_stage
      .freeze(~SRAM_Ready),
      .WB_EN(WB_EN_ID_reg),  //out
      .MEM_R_EN(MEM_R_EN_ID_reg),
      .MEM_W_EN(MEM_W_EN_ID_reg),
      .B(B_ID_reg),
      .S(S_ID_reg),
      .EXE_CMD(EXE_CMD_ID_reg),
      .PC(PC_ID_reg),
      .Val_Rn(Val_Rn_ID_reg),
      .Val_Rm(Val_Rm_ID_reg),
      .Imm(Imm_ID_reg),
      .Shift_Operand(Shift_Operand_ID_reg),
      .Signed_Imm_24(Signed_Imm_24_ID_reg),
      .Dest(Dest_ID_reg),
      .SR_IN(Status_out_EXE),
      .SR_OUT(SR_OUT_ID_reg),
      .Src1(Src1_ID_reg),  // Forwarding
      .Src2(Src2_ID_reg)  // Forwarding
  );

//-------------------------FU---------------------

  wire WB_EN_EXE_Reg, MEM_R_EN_EXE_Reg, MEM_W_EN_EXE_Reg;
  wire [31:0] ALU_Result_EXE_Reg, Val_Rm_EXE_Reg;
  wire [3:0] SR_Val_EXE_Reg;
  wire [3:0] Dest_EXE_Reg;

  wire [1:0] sel_src1_forw, sel_src2_forw;
  wire [31:0] Val_Rn_Ready, Val_Rm_Ready;
  //wire forwarding_en = 1'b1;  // or VIO

  Forwarding_Unit FU_Inst (
      .en(forwarding_en),
      .src1(Src1_ID_reg),
      .src2(Src2_ID_reg),
      .wb_en_mem(WB_EN_EXE_Reg),
      .dest_mem(Dest_EXE_Reg),
      .wb_en_wb(WB_EN_MEM_Reg),
      .dest_wb(Dest_out_MEM_Reg),  // WB
      .sel_src1(sel_src1_forw),
      .sel_src2(sel_src2_forw)
  );

  // Mux Src1 (Rn)
  Mux3to1_32 Mux_Src1 (
      .a  (Val_Rn_ID_reg),       // sel=00: 
      .b  (ALU_Result_EXE_Reg),  // sel=01:
      .c  (WB_out_WB),           // sel=10:
      .sel(sel_src1_forw),
      .out(Val_Rn_Ready)         // <--- EXE
  );

  // Mux Src2 (Rm)
  Mux3to1_32 Mux_Src2 (
      .a  (Val_Rm_ID_reg),
      .b  (ALU_Result_EXE_Reg),
      .c  (WB_out_WB),
      .sel(sel_src2_forw),
      .out(Val_Rm_Ready)         // <--- EXE
  );

//-------------------------EXE---------------------

  wire [31:0] ALU_Result_out_EXE;


  EXE_stage EXE_stage_inst (
      .clk(clk),
      .rst(rst),
      .EXE_CMD(EXE_CMD_ID_reg),
      .MEM_R_EN(MEM_R_EN_ID_reg),
      .MEM_W_EN(MEM_W_EN_ID_reg),
      .PC(PC_ID_reg),
      .S_load(S_ID_reg),
      .Val_Rn(Val_Rn_Ready),  // Val_Rn_ID_reg
      .Val_Rm(Val_Rm_Ready),  // Val_Rm_ID_reg
      .Imm(Imm_ID_reg),
      .Shift_Operand(Shift_Operand_ID_reg),
      .Signed_Imm_24(Signed_Imm_24_ID_reg),
      .SR(SR_OUT_ID_reg),
      .ALU_Result(ALU_Result_out_EXE),  //out
      .Br_Addr(Br_Addr_out_EXE),
      .SR_out(Status_out_EXE)
  );



  EXE_stage_Reg EXE_stage_Reg_inst (
      .clk(clk),
      .rst(rst),
      .WB_EN_IN(WB_EN_ID_reg),
      .MEM_R_EN_IN(MEM_R_EN_ID_reg),
      .MEM_W_EN_IN(MEM_W_EN_ID_reg),
      .ALU_Result_IN(ALU_Result_out_EXE),
      .SR_Val_IN(SR_OUT_ID_reg),
      .Dest_IN(Dest_ID_reg),
      .Val_Rm(Val_Rm_ID_reg),
      .freeze(~SRAM_Ready),
      .WB_EN(WB_EN_EXE_Reg),  //out
      .MEM_R_EN(MEM_R_EN_EXE_Reg),
      .MEM_W_EN(MEM_W_EN_EXE_Reg),
      .ALU_Result(ALU_Result_EXE_Reg),
      .Val_Rm_OUT(Val_Rm_EXE_Reg),
      .SR_Val(SR_Val_EXE_Reg),
      .Dest(Dest_EXE_Reg)
  );

//-------------------------SRAM Model----------------------

  wire [10:0] SRAM_Addr;
  wire [ 7:0] SRAM_DQ;
  wire SRAM_CS_n, SRAM_OE_n, SRAM_WE_n;
  wire Hazard_Signal;

  SRAM_Model SRAM_inst (
      .clk(clk),
      .CS_n(SRAM_CS_n),
      .OE_n(SRAM_OE_n),
      .WE_n(SRAM_WE_n),
      .Address(SRAM_Addr),
      .DataIO(SRAM_DQ)
  );

  assign frz = Hazard_Signal || ~SRAM_Ready;  //goes to IF/IF_reg
  //~SRAM_Ready goes to rest of ID/... reg

//-------------------------MEM----------------------

  wire WB_EN_out_MEM, MEM_R_out_MEM;
  wire [31:0] ALU_Result_out_MEM, MEM_out_MEM;
  wire [3:0] Dest_out_MEM;

  MEM_Stage MEM_stage_inst (
      .clk(clk),
      .rst(rst),
      .MEM_W_EN(MEM_W_EN_EXE_Reg),
      .ALU_Res(ALU_Result_EXE_Reg),
      .MEM_Data(Val_Rm_EXE_Reg),
      .WB_EN(WB_EN_EXE_Reg),
      .MEM_R_EN(MEM_R_EN_EXE_Reg),
      .Dest(Dest_EXE_Reg),

      .WB_EN_OUT(WB_EN_out_MEM),  //out
      .MEM_R_OUT(MEM_R_out_MEM),
      .ALU_Res_OUT(ALU_Result_out_MEM),
      .MEM_OUT(MEM_out_MEM),
      .Dest_OUT(Dest_out_MEM),

      .ready_out(SRAM_Ready),
      .sram_addr(SRAM_Addr),
      .sram_data(SRAM_DQ),
      .sram_cs_n(SRAM_CS_n),
      .sram_oe_n(SRAM_OE_n),
      .sram_we_n(SRAM_WE_n)
  );

  wire MEM_R_MEM_Reg;
  wire [31:0] ALU_Result_MEM_Reg, MEM_out_MEM_Reg;


  MEM_stage_Reg MEM_stage_Reg_inst (
      .clk(clk),
      .rst(rst),
      .WB_EN_IN(WB_EN_out_MEM),
      .MEM_R_EN_IN(MEM_R_out_MEM),
      .ALU_Result_IN(ALU_Result_out_MEM),
      .MEM_OUT_IN(MEM_out_MEM),
      .Dest_IN(Dest_out_MEM),
      .freeze(~SRAM_Ready),
      .WB_EN(WB_EN_MEM_Reg),  //out
      .MEM_R_EN(MEM_R_MEM_Reg),
      .ALU_Result(ALU_Result_MEM_Reg),
      .MEM_OUT(MEM_out_MEM_Reg),
      .Dest(Dest_out_MEM_Reg)
  );

//-------------------------WB---------------------


  WB_stage WB_stage_int (
      .ALU_Result(ALU_Result_MEM_Reg),
      .MEM_Result(MEM_out_MEM_Reg),
      .MEM_R_EN(MEM_R_MEM_Reg),
      .out_WB(WB_out_WB)
  );

//-------------------------HZ---------------------
  wire EN = 1'b1;
  Hazard Hazard_inst (
      .Src1(Inst[19:16]),
      .Src2(Src2),
      .two_src(Two_src),
      .EXE_WB_EN(WB_EN_ID_reg),
      .EXE_Dest(Dest_ID_reg),
      .MEM_WB_EN(WB_EN_EXE_Reg),
      .EN(forwarding_en),
      .EXE_MEM_R_EN(MEM_R_EN_ID_reg),
      .MEM_Dest(Dest_EXE_Reg),
      .HAZARD(Hazard_Signal)
  );

endmodule
