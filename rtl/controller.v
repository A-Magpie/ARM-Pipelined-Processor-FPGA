module controller (
    cond,
    mode,
    opcode,
    S_IN,
    WB_EN,
    MEM_R_EN,
    MEM_W_EN,
    EXE_CMD,
    B,
    S_OUT
);

  input [3:0] cond;
  input [1:0] mode;
  input [3:0] opcode;
  input S_IN;
  output reg WB_EN, MEM_R_EN, MEM_W_EN, B, S_OUT;
  output reg [3:0] EXE_CMD;

  always @(opcode, mode, S_IN) begin
    {MEM_R_EN, MEM_W_EN, B, EXE_CMD} = 7'd0;
    S_OUT = S_IN;
    WB_EN = 1'b0;
    case (mode)
      2'b00: begin
        case (opcode)
          4'b1101: begin
            WB_EN = 1'b1;
            EXE_CMD = 4'b0001;
            B = 1'b0;
          end
          4'b1111: begin
            WB_EN = 1'b1;
            EXE_CMD = 4'b1001;
            B = 1'b0;
          end
          4'b0100: begin
            WB_EN   = 1'b1;
            EXE_CMD = 4'b0010;
          end
          4'b0101: begin
            WB_EN   = 1'b1;
            EXE_CMD = 4'b0011;
          end
          4'b0010: begin
            WB_EN   = 1'b1;
            EXE_CMD = 4'b0100;
          end
          4'b0110: begin
            WB_EN = 1'b1;
            EXE_CMD = 4'b0101;
            B = 1'b0;
          end
          4'b0000: begin
            if (cond != 4'b1110) begin
              WB_EN = 1'b0;
            end else begin
              WB_EN = 1'b1;
              EXE_CMD = 4'b0110;
              B = 1'b0;
            end
          end
          4'b1100: begin
            WB_EN = 1'b1;
            EXE_CMD = 4'b0111;
            B = 1'b0;
          end
          4'b0001: begin
            WB_EN = 1'b1;
            EXE_CMD = 4'b1000;
            B = 1'b0;
          end
          4'b1010: begin
            WB_EN = 1'b0;
            EXE_CMD = 4'b0100;
            B = 1'b0;
          end
          4'b1000: begin
            WB_EN = 1'b0;
            EXE_CMD = 4'b0110;
            B = 1'b0;
          end
        endcase
      end
      2'b01: begin
        if (opcode == 4'b0100) begin
          if (S_IN == 1) begin
            WB_EN = 1'b1;
            EXE_CMD = 4'b0010;
            MEM_R_EN = 1'b1;
            B = 1'b0;
          end else begin
            WB_EN = 1'b0;
            EXE_CMD = 4'b0010;
            MEM_W_EN = 1'b1;
            B = 1'b0;
          end
        end
      end
      2'b10: begin
        B = 1'b1;
      end
    endcase
  end
endmodule




