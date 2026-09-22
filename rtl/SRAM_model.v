`timescale 1ns / 1ps

module SRAM_Model (
    input wire        clk,
    input wire [10:0] Address,  // 2^11 = 2048 Locations
    input wire        CS_n,     // Chip Select (Active Low)
    input wire        OE_n,     // Output Enable (Active Low)
    input wire        WE_n,     // Write Enable (Active Low)
    inout wire [ 7:0] DataIO    // Bidirectional Data Bus
);
  wire [7:0] read_data;

  assign DataIO = (!CS_n && !OE_n) ? read_data : 8'bz;

  xpm_memory_spram #(
      .ADDR_WIDTH_A       (11),               // 9 bits = 512 depth
      .AUTO_SLEEP_TIME    (0),
      .BYTE_WRITE_WIDTH_A (8),                // 8 bits = writing full byte at once
      .ECC_MODE           ("no_ecc"),
      .MEMORY_INIT_FILE   ("none"),           // ** No Init File **
      .MEMORY_OPTIMIZATION("true"),
      .MEMORY_PRIMITIVE   ("block"),
      .MEMORY_SIZE        (16384),            // ** 8 bits * 512 depth = 4096 bits **
      .MESSAGE_CONTROL    (0),
      .READ_DATA_WIDTH_A  (8),                // 8 bits
      .READ_LATENCY_A     (1),                // 1 Cycle Latency
      .READ_RESET_VALUE_A ("0"),
      .RST_MODE_A         ("SYNC"),
      .USE_MEM_INIT       (0),                // ** 0 = Do not initialize memory **
      .WAKEUP_TIME        ("disable_sleep"),
      .WRITE_DATA_WIDTH_A (8),                // 8 bits
      .WRITE_MODE_A       ("write_first")
  ) xpm_memory_spram_inst (
      .dbiterra      (),
      .douta         (read_data),
      .sbiterra      (),
      .addra         (Address),
      .clka          (clk),
      .dina          (DataIO),
      .ena           (!CS_n),      // Always Enabled
      .injectdbiterra(1'b0),
      .injectsbiterra(1'b0),
      .regcea        (!CS_n),      // Output register clock enable always on
      .rsta          (1'b0),
      .sleep         (1'b0),
      .wea           (!WE_n)       // 1-bit Write Enable
  );

endmodule
