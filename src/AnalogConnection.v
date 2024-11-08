`timescale 1ns / 1ps
module AnalogConnection(
     inout [7:0] data_inout,
     output [7:0] read_data,
     input [7:0] write_data,
     input oen);

   assign data_inout = (oen == 'b0) ? write_data : 'bzzzzzzzzzzzzzzzz;
   assign read_data = data_inout;
endmodule