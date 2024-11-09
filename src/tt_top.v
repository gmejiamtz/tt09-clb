/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_gmejiamtz (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);
  wire comb_out;
  reg is_sync_r,comb_out_r, out_r;

  //make a lut 3
  LUT3 lut (.clk_i(clk),.resetn(rst_n),.new_seed_i(ui_in[3]),.args_i(ui_in[2:0]),.seed_i(uio_in),.out_o(comb_out));
  //setting the lut to me "synchronous" eg a 2 cycle read instead of 1
  always @(posedge clk) begin
    if(!rst_n) begin
      is_sync_r <= 1'b0;
    end else if(ui_in[3]) begin 
      is_sync_r <= ui_in[4];
    end
  end

  //ff for a sync clk - will be a 2 cycle delay with this LUT design
  always @(posedge clk) begin
    if(!rst_n) begin
      comb_out_r <= '0;
    end else begin
      comb_out_r <= comb_out;
    end
  end

  always @(*) begin
    if (is_sync_r) begin
      out_r = comb_out_r;
    end else begin
      out_r = comb_out;
    end
  end
  assign uo_out = {7'b0,out_r};
  assign uio_oe = '0;
  wire _unused = &{ena, ui_in[7:5],1'b0};
  assign uio_out = '0;
endmodule
