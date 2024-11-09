module LUT3(
    input clk_i,
    input resetn,
    input new_seed_i,
    input [2:0] args_i,
    input [7:0] seed_i,
    output out_o);

  reg [7:0] lookup_table_r;
  reg out_r;
  always @(posedge clk_i) begin
    if(!resetn) begin
      lookup_table_r <= '0;
    end
    else if (new_seed_i) begin
      lookup_table_r <= seed_i; 
    end
  end
  always @(*) begin
    case (args_i)
    3'b000:
      out_r = lookup_table_r[0];
    3'b001:
      out_r = lookup_table_r[1];
    3'b010:
      out_r = lookup_table_r[2];
    3'b011:
      out_r = lookup_table_r[3];
    3'b100:
      out_r = lookup_table_r[4];
    3'b101:
      out_r = lookup_table_r[5];
    3'b110:
      out_r = lookup_table_r[6];
    3'b111:
      out_r = lookup_table_r[7];
    endcase
  end
  assign out_o = out_r;
endmodule