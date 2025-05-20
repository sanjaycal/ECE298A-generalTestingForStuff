/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_testing_area (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  reg [7:0] data1 = 8'b0;
  reg [7:0] data2 = 8'b0;
  reg [7:0] output = 8'b0;

  always @(posedge clk) begin
    if (!rst_n) begin // If reset is active (low)
      output[7:0] <= 0;
      data1[7:0] <= 0;
      data2[7:0] <= 0;
    end else if (uio_in == 1) begin
      data1[7:0] <= ui_in;
    end else if (uio_in == 2) begin
      data2[7:0] <= ui_in;
    end else if (uio_in == 4) begin
      output[7:0] <= data1 + data2;
    end else if (uio_in == 5) begin
      output[7:0] <= data1 - data2;
    end else if (uio_in == 6) begin
      output[7:0] <= data1 & data2;
    end else if (uio_in == 7) begin
      output[7:0] <= data1 | data2;
    end else begin     
      output[7:0] <= output[7:0]; // Increment counter
    end
  end



  // All output pins must be assigned. If not used, assign to 0.
  assign uo_out  = output;  // Example: ou_out is the sum of ui_in and uio_in
  assign uio_out = 0;
  assign uio_oe  = 0;

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, clk, rst_n, 1'b0};

endmodule
