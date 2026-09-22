module MEM_Stage (
    clk,
    rst,
    MEM_W_EN,
    ALU_Res,
    MEM_Data,
    WB_EN,
    MEM_R_EN,
    Dest,
    WB_EN_OUT,
    MEM_R_OUT,
    ALU_Res_OUT,
    MEM_OUT,
    Dest_OUT,
    ready_out,
    sram_addr,
    sram_data,
    sram_cs_n,
    sram_oe_n,
    sram_we_n
);
  input clk, rst, MEM_W_EN;
  input [31:0] ALU_Res;
  input [31:0] MEM_Data;
  input WB_EN;
  input MEM_R_EN;
  input [3:0] Dest;

  output wire WB_EN_OUT;
  output wire MEM_R_OUT;
  output wire [31:0] ALU_Res_OUT;
  output [31:0] MEM_OUT;
  output [3:0] Dest_OUT;

  //SRAM compatible ports
    output wire ready_out;
    output wire [10:0] sram_addr;
    inout  wire [7:0]  sram_data;
    output wire sram_cs_n;
    output wire sram_oe_n;
    output wire sram_we_n;

SRAM_Controller SRAM_Controller_inst (
      .clk(clk),
      .rst(rst),
      // CPU Side
      .cpu_addr(ALU_Res),          // Memory address from ALU output
      .cpu_wdata(MEM_Data),        // Write data from register Val_Rm
      .cpu_mem_read(MEM_R_EN),
      .cpu_mem_write(MEM_W_EN),
      .cpu_rdata(MEM_OUT),         // Read data output
      .cpu_ready(ready_out),       // Ready handshake signal
      // SRAM Side
      .sram_addr(sram_addr),
      .sram_data(sram_data),
      .sram_cs_n(sram_cs_n),
      .sram_oe_n(sram_oe_n),
      .sram_we_n(sram_we_n)
  );

  // Data_Memory Data_Memory_inst (
  //     .a  (ALU_Res[10:0]),  // input wire [10 : 0] a
  //     .d  (MEM_Data),       // input wire [31 : 0] d
  //     .clk(clk),            // input wire clk
  //     .we (MEM_W_EN),       // input wire we
  //     .spo(MEM_OUT)         // output wire [31 : 0] spo
  // );

  assign WB_EN_OUT =  WB_EN;
  assign MEM_R_OUT =  MEM_R_EN;
  assign ALU_Res_OUT =  ALU_Res;
  assign Dest_OUT = Dest; 
endmodule

