module SRAM_Controller (
    input clk,
    input rst,
    // Processor Interface
    input [31:0] cpu_addr,
    input [31:0] cpu_wdata,
    input cpu_mem_read,
    input cpu_mem_write,
    output reg [31:0] cpu_rdata,
    output reg cpu_ready,
    // SRAM Interface
    output reg [10:0] sram_addr,
    inout [7:0] sram_data,
    output reg sram_cs_n,
    output reg sram_oe_n,
    output reg sram_we_n
);

  // States
  localparam IDLE = 3'd0;
  localparam BYTE0 = 3'd1;
  localparam BYTE1 = 3'd2;
  localparam BYTE2 = 3'd3;
  localparam BYTE3 = 3'd4;
  localparam DONE = 3'd5;

  reg [2:0] current_state, next_state;
  reg [31:0] read_data_temp;  // Temporary register to hold read bytes
  // Address Counter Logic (2 bits for byte offset)
  reg [ 1:0] counter;
  // Tri-state buffer logic
  reg [ 7:0] data_to_write;
  assign sram_data = (!sram_we_n) ? data_to_write : 8'bz;
  // Next State Logic
  always @(posedge clk, posedge rst) begin
    if (rst) current_state <= IDLE;
    else current_state <= next_state;
  end

  // FSM Logic
  always @(*) begin
    next_state = current_state;
    case (current_state)
      IDLE: begin
        if (cpu_mem_read || cpu_mem_write) next_state = BYTE0;
      end
      BYTE0: next_state = BYTE1;
      BYTE1: next_state = BYTE2;
      BYTE2: next_state = BYTE3;
      BYTE3: next_state = DONE;
      DONE:  next_state = IDLE;
    endcase
  end

  // Output & Data Logic
  always @(posedge clk, posedge rst) begin
    if (rst) begin
      cpu_ready <= 1'b1;
      counter <= 2'b00;
      sram_cs_n <= 1'b1;
      sram_oe_n <= 1'b1;
      sram_we_n <= 1'b1;
      cpu_rdata <= 32'd0;
      read_data_temp <= 32'd0;
    end else begin
      // Defaults
      sram_cs_n <= 1'b0;  // Chip Select Always Active during operation
      sram_oe_n <= 1'b1;
      sram_we_n <= 1'b1;
      cpu_ready <= 1'b0;  // Not ready by default during operation

      case (current_state)
        IDLE: begin
          cpu_ready <= 1'b1;
          counter   <= 2'b00;
          sram_cs_n <= 1'b1;  // Deselect when idle
          if (cpu_mem_read || cpu_mem_write) begin
            cpu_ready <= 1'b0;  // Start operation
            sram_cs_n <= 1'b0;  // Select when idle
            sram_addr <= {cpu_addr[8:0], 2'b00};
          end
        end
        BYTE0: begin
          // Setup Address 0
          sram_addr <= {cpu_addr[8:0], 2'b01};
          if (cpu_mem_write) begin
            sram_we_n <= 1'b0;
            data_to_write <= cpu_wdata[7:0];
          end else begin  // Read
            sram_oe_n <= 1'b0;
          end
        end
        BYTE1: begin
          // Setup Address 1
          sram_addr <= {cpu_addr[8:0], 2'b10};
          // Capture previous Read Data (Byte 0) - Latency 1
          if (cpu_mem_read) read_data_temp[7:0] <= sram_data;
          if (cpu_mem_write) begin
            sram_we_n <= 1'b0;
            data_to_write <= cpu_wdata[15:8];
          end else begin
            sram_oe_n <= 1'b0;
          end
        end
        BYTE2: begin
          // Setup Address 2
          sram_addr <= {cpu_addr[8:0], 2'b11};
          // Capture previous Read Data (Byte 1)
          if (cpu_mem_read) read_data_temp[15:8] <= sram_data;
          if (cpu_mem_write) begin
            sram_we_n <= 1'b0;
            data_to_write <= cpu_wdata[23:16];
          end else begin
            sram_oe_n <= 1'b0;
          end
        end
        BYTE3: begin
          // Setup Address 3
          // sram_addr <= {cpu_addr[10:2], 2'b11};
          // Capture previous Read Data (Byte 2)
          if (cpu_mem_read) read_data_temp[23:16] <= sram_data;
          if (cpu_mem_write) begin
            sram_we_n <= 1'b0;
            data_to_write <= cpu_wdata[31:24];
          end else begin
            sram_oe_n <= 1'b0;
          end
        end
        DONE: begin
          sram_cs_n <= 1'b1;  // Finish
          cpu_ready <= 1'b1;  // Operation Done
          // Capture previous Read Data (Byte 3)
          if (cpu_mem_read) begin
            read_data_temp[31:24] <= sram_data;
            cpu_rdata <= {sram_data, read_data_temp[23:0]};  // Update final output
          end
        end
      endcase
    end
  end
endmodule
