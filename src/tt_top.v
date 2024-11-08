/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none
`timescale 1ns / 1ps

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
  wire [3:0] sdram_state,sdram_crtl;
  wire [15:0] sdram_out; 
  wire [13:0] address;
  wire dqm, read_valid, write_valid;
  wire [7:0] dq,read_data,write_data;
  reg [7:0]  read_r,write_r;
  //just instantiate sdram
  sdram_controller controller (.clock(clk),.reset(!rst_n),
                              .io_read_row_address(ui_in[0]),
                              .io_read_col_address(ui_in[1]),
                              .io_read_data_valid(read_valid),
                              .io_read_start(ui_in[2]),
                              .io_read_data(uio_out),
                              .io_write_row_address(ui_in[3]),
                              .io_write_data(ui_in[7:6]),
                              .io_write_col_address(ui_in[4]),
                              .io_write_data_valid(write_valid),
                              .io_write_start(ui_in[5]),
                              .io_sdram_control_cs(sdram_crtl[3]),
                              .io_sdram_control_ras(sdram_crtl[2]),
                              .io_sdram_control_cas(sdram_crtl[1]),
                              .io_sdram_control_we(sdram_crtl[0]),
                              .io_sdram_control_address_bus(address),
                              .io_sdram_control_dqm(dqm),
                              .io_sdram_control_dq(dq),
                              .io_state_out(sdram_state));
  //write and read data multiplex
  always @(*) begin
    read_r = '0;
    write_r = '0;
    if(read_valid) begin
      read_r = dq;
    end
    if(write_r) begin
      write_r = dq;
    end
  end

  //output and inout multiplex
  
endmodule
