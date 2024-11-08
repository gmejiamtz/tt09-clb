`timescale 1ns / 1ps
module sdram_controller(
  input         clock,
  input         reset,
  input  [13:0] io_read_row_address, // @[src/main/scala/fsm.scala 9:14]
  input  [13:0] io_read_col_address, // @[src/main/scala/fsm.scala 9:14]
  output [7:0]  io_read_data, // @[src/main/scala/fsm.scala 9:14]
  output        io_read_data_valid, // @[src/main/scala/fsm.scala 9:14]
  input         io_read_start, // @[src/main/scala/fsm.scala 9:14]
  input  [13:0] io_write_row_address, // @[src/main/scala/fsm.scala 9:14]
  input  [13:0] io_write_col_address, // @[src/main/scala/fsm.scala 9:14]
  input  [7:0]  io_write_data, // @[src/main/scala/fsm.scala 9:14]
  output        io_write_data_valid, // @[src/main/scala/fsm.scala 9:14]
  input         io_write_start, // @[src/main/scala/fsm.scala 9:14]
  output        io_sdram_control_cs, // @[src/main/scala/fsm.scala 9:14]
  output        io_sdram_control_ras, // @[src/main/scala/fsm.scala 9:14]
  output        io_sdram_control_cas, // @[src/main/scala/fsm.scala 9:14]
  output        io_sdram_control_we, // @[src/main/scala/fsm.scala 9:14]
  output        io_sdram_control_dqm, // @[src/main/scala/fsm.scala 9:14]
  output [13:0] io_sdram_control_address_bus, // @[src/main/scala/fsm.scala 9:14]
  inout  [7:0]  io_sdram_control_dq, // @[src/main/scala/fsm.scala 9:14]
  output [3:0]  io_state_out // @[src/main/scala/fsm.scala 9:14]
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
  reg [31:0] _RAND_9;
`endif // RANDOMIZE_REG_INIT
  wire [7:0] handle_analog_read_data; // @[src/main/scala/fsm.scala 41:29]
  wire [7:0] handle_analog_write_data; // @[src/main/scala/fsm.scala 41:29]
  wire  handle_analog_oen; // @[src/main/scala/fsm.scala 41:29]
  reg [3:0] state; // @[src/main/scala/fsm.scala 12:22]
  reg  stated_read; // @[src/main/scala/fsm.scala 16:28]
  reg  started_write; // @[src/main/scala/fsm.scala 17:30]
  reg  oen_reg; // @[src/main/scala/fsm.scala 18:24]
  reg [1:0] cas_counter_value; // @[src/main/scala/chisel3/util/Counter.scala 61:40]
  reg [1:0] terminate_write_value; // @[src/main/scala/chisel3/util/Counter.scala 61:40]
  reg [13:0] hundred_micro_sec_counter_value; // @[src/main/scala/chisel3/util/Counter.scala 61:40]
  reg [1:0] active_to_rw_counter_value; // @[src/main/scala/chisel3/util/Counter.scala 61:40]
  reg [11:0] refresh_counter_value; // @[src/main/scala/chisel3/util/Counter.scala 61:40]
  reg  refresh_outstanding; // @[src/main/scala/fsm.scala 36:36]
  wire  wrap = refresh_counter_value == 12'hf40; // @[src/main/scala/chisel3/util/Counter.scala 73:24]
  wire [11:0] _value_T_1 = refresh_counter_value + 12'h1; // @[src/main/scala/chisel3/util/Counter.scala 77:24]
  wire  _GEN_1 = wrap | refresh_outstanding; // @[src/main/scala/fsm.scala 37:32 38:25 36:36]
  wire  wrap_1 = hundred_micro_sec_counter_value == 14'h30d7; // @[src/main/scala/chisel3/util/Counter.scala 73:24]
  wire [13:0] _value_T_3 = hundred_micro_sec_counter_value + 14'h1; // @[src/main/scala/chisel3/util/Counter.scala 77:24]
  wire [13:0] _GEN_2 = wrap_1 ? 14'h0 : _value_T_3; // @[src/main/scala/chisel3/util/Counter.scala 77:15 87:{20,28}]
  wire  _T_6 = hundred_micro_sec_counter_value == 14'h30d5 | hundred_micro_sec_counter_value == 14'h30d6; // @[src/main/scala/fsm.scala 64:74]
  wire  _GEN_4 = wrap_1 ? 1'h0 : 1'h1; // @[src/main/scala/fsm.scala 70:81 src/main/scala/general/general.scala 107:17 140:17]
  wire [13:0] _GEN_6 = wrap_1 ? 14'h0 : _GEN_2; // @[src/main/scala/fsm.scala 70:81 src/main/scala/chisel3/util/Counter.scala 98:11]
  wire [3:0] _GEN_7 = wrap_1 ? 4'h2 : state; // @[src/main/scala/fsm.scala 70:81 84:17 12:22]
  wire  _GEN_9 = _T_6 ? 1'h0 : _GEN_4; // @[src/main/scala/fsm.scala 65:11 src/main/scala/general/general.scala 123:17]
  wire  _GEN_10 = _T_6 | _GEN_4; // @[src/main/scala/fsm.scala 65:11 src/main/scala/general/general.scala 125:16]
  wire  _GEN_16 = hundred_micro_sec_counter_value == 14'h30d4 ? 1'h0 : _GEN_9; // @[src/main/scala/fsm.scala 61:68 src/main/scala/general/general.scala 115:17]
  wire  _GEN_17 = hundred_micro_sec_counter_value == 14'h30d4 | _GEN_9; // @[src/main/scala/fsm.scala 61:68 src/main/scala/general/general.scala 116:17]
  wire  _GEN_18 = hundred_micro_sec_counter_value == 14'h30d4 ? 1'h0 : _GEN_10; // @[src/main/scala/fsm.scala 61:68 src/main/scala/general/general.scala 117:16]
  wire  go_to_active = io_read_start | io_write_start; // @[src/main/scala/fsm.scala 91:23]
  wire  _GEN_23 = io_write_start | started_write; // @[src/main/scala/fsm.scala 105:36 106:25 17:30]
  wire  _GEN_24 = io_read_start | stated_read; // @[src/main/scala/fsm.scala 103:29 104:23 16:28]
  wire  _GEN_25 = io_read_start ? started_write : _GEN_23; // @[src/main/scala/fsm.scala 103:29 17:30]
  wire [1:0] _GEN_26 = go_to_active ? 2'h3 : 2'h2; // @[src/main/scala/fsm.scala 88:13 97:33 98:15]
  wire  _GEN_28 = go_to_active ? 1'h0 : 1'h1; // @[src/main/scala/fsm.scala 97:33 src/main/scala/general/general.scala 107:17 132:17]
  wire [1:0] _GEN_31 = go_to_active ? 2'h0 : cas_counter_value; // @[src/main/scala/fsm.scala 97:33 src/main/scala/chisel3/util/Counter.scala 98:11 61:40]
  wire  _GEN_32 = go_to_active ? _GEN_24 : stated_read; // @[src/main/scala/fsm.scala 16:28 97:33]
  wire  _GEN_33 = go_to_active ? _GEN_25 : started_write; // @[src/main/scala/fsm.scala 17:30 97:33]
  wire  _GEN_35 = refresh_outstanding ? 1'h0 : _GEN_28; // @[src/main/scala/fsm.scala 94:34 src/main/scala/general/general.scala 123:17]
  wire  _GEN_36 = refresh_outstanding ? 1'h0 : 1'h1; // @[src/main/scala/fsm.scala 94:34 src/main/scala/general/general.scala 124:17]
  wire  _GEN_39 = refresh_outstanding ? 1'h0 : _GEN_1; // @[src/main/scala/fsm.scala 94:34 96:29]
  wire [1:0] _GEN_40 = refresh_outstanding ? 2'h2 : _GEN_26; // @[src/main/scala/fsm.scala 88:13 94:34]
  wire [1:0] _value_T_5 = active_to_rw_counter_value + 2'h1; // @[src/main/scala/chisel3/util/Counter.scala 77:24]
  wire  _T_14 = active_to_rw_counter_value == 2'h3; // @[src/main/scala/fsm.scala 119:53]
  wire  _T_15 = stated_read & active_to_rw_counter_value == 2'h3; // @[src/main/scala/fsm.scala 119:24]
  wire [1:0] _value_T_7 = cas_counter_value + 2'h1; // @[src/main/scala/chisel3/util/Counter.scala 77:24]
  wire  _T_17 = started_write & _T_14; // @[src/main/scala/fsm.scala 131:24]
  wire [2:0] _GEN_47 = _T_17 ? 3'h7 : 3'h3; // @[src/main/scala/fsm.scala 111:13 132:9 133:15]
  wire  _GEN_48 = _T_17 ? 1'h0 : started_write; // @[src/main/scala/fsm.scala 132:9 136:23 17:30]
  wire  _GEN_49 = _T_17 ? 1'h0 : oen_reg; // @[src/main/scala/fsm.scala 132:9 137:17 18:24]
  wire  _GEN_51 = _T_17 | _GEN_36; // @[src/main/scala/fsm.scala 132:9 src/main/scala/general/general.scala 156:17]
  wire  _GEN_52 = _T_17 ? 1'h0 : _GEN_36; // @[src/main/scala/fsm.scala 132:9 src/main/scala/general/general.scala 157:17]
  wire  _GEN_53 = _T_17 ? 1'h0 : 1'h1; // @[src/main/scala/fsm.scala 132:9 src/main/scala/general/general.scala 158:16]
  wire  _GEN_55 = _T_17 ? _GEN_1 : _GEN_39; // @[src/main/scala/fsm.scala 132:9]
  wire [2:0] _GEN_56 = _T_15 ? 3'h6 : _GEN_47; // @[src/main/scala/fsm.scala 120:9 121:15]
  wire  _GEN_58 = _T_15 | _GEN_51; // @[src/main/scala/fsm.scala 120:9 src/main/scala/general/general.scala 148:17]
  wire  _GEN_59 = _T_15 ? 1'h0 : _GEN_52; // @[src/main/scala/fsm.scala 120:9 src/main/scala/general/general.scala 149:17]
  wire  _GEN_60 = _T_15 | _GEN_53; // @[src/main/scala/fsm.scala 120:9 src/main/scala/general/general.scala 150:16]
  wire [13:0] _GEN_61 = _T_15 ? io_read_col_address : io_write_col_address; // @[src/main/scala/fsm.scala 120:9 128:38]
  wire  _GEN_62 = _T_15 | _GEN_49; // @[src/main/scala/fsm.scala 120:9 125:17]
  wire  _GEN_63 = _T_15 ? 1'h0 : stated_read; // @[src/main/scala/fsm.scala 120:9 126:21 16:28]
  wire [1:0] _GEN_64 = _T_15 ? _value_T_7 : cas_counter_value; // @[src/main/scala/fsm.scala 120:9 src/main/scala/chisel3/util/Counter.scala 77:15 61:40]
  wire  _GEN_65 = _T_15 ? started_write : _GEN_48; // @[src/main/scala/fsm.scala 120:9 17:30]
  wire  _GEN_66 = _T_15 ? _GEN_1 : _GEN_55; // @[src/main/scala/fsm.scala 120:9]
  wire  _T_21 = cas_counter_value == 2'h3; // @[src/main/scala/fsm.scala 151:30]
  wire  _GEN_69 = cas_counter_value == 2'h3 ? 1'h0 : 1'h1; // @[src/main/scala/fsm.scala 151:51 src/main/scala/general/general.scala 107:17 115:17]
  wire [2:0] _GEN_71 = cas_counter_value == 2'h3 ? 3'h2 : 3'h6; // @[src/main/scala/fsm.scala 147:13 151:51 157:15]
  wire  wrap_5 = terminate_write_value == 2'h2; // @[src/main/scala/chisel3/util/Counter.scala 73:24]
  wire [1:0] _value_T_11 = terminate_write_value + 2'h1; // @[src/main/scala/chisel3/util/Counter.scala 77:24]
  wire [1:0] _GEN_72 = wrap_5 ? 2'h0 : _value_T_11; // @[src/main/scala/chisel3/util/Counter.scala 77:15 87:{20,28}]
  wire  _GEN_74 = wrap_5 ? 1'h0 : 1'h1; // @[src/main/scala/fsm.scala 164:55 src/main/scala/general/general.scala 107:17 115:17]
  wire [3:0] _GEN_77 = wrap_5 ? 4'h2 : state; // @[src/main/scala/fsm.scala 164:55 168:15 12:22]
  wire [1:0] _GEN_78 = 4'h7 == state ? _GEN_72 : terminate_write_value; // @[src/main/scala/fsm.scala 50:17 src/main/scala/chisel3/util/Counter.scala 61:40]
  wire [3:0] _GEN_83 = 4'h7 == state ? _GEN_77 : state; // @[src/main/scala/fsm.scala 50:17 12:22]
  wire [3:0] _GEN_84 = 4'h6 == state ? {{1'd0}, _GEN_71} : _GEN_83; // @[src/main/scala/fsm.scala 50:17]
  wire [1:0] _GEN_85 = 4'h6 == state ? _value_T_7 : cas_counter_value; // @[src/main/scala/fsm.scala 50:17 src/main/scala/chisel3/util/Counter.scala 77:15 61:40]
  wire  _GEN_87 = 4'h6 == state ? _GEN_69 : _GEN_74; // @[src/main/scala/fsm.scala 50:17]
  wire [1:0] _GEN_90 = 4'h6 == state ? terminate_write_value : _GEN_78; // @[src/main/scala/fsm.scala 50:17 src/main/scala/chisel3/util/Counter.scala 61:40]
  wire  _GEN_91 = 4'h6 == state ? 1'h0 : 4'h7 == state & wrap_5; // @[src/main/scala/fsm.scala 50:17 49:23]
  wire  _GEN_95 = 4'h3 == state ? _GEN_58 : _GEN_87; // @[src/main/scala/fsm.scala 50:17]
  wire  _GEN_96 = 4'h3 == state ? _GEN_59 : 1'h1; // @[src/main/scala/fsm.scala 50:17]
  wire  _GEN_97 = 4'h3 == state ? _GEN_60 : _GEN_87; // @[src/main/scala/fsm.scala 50:17]
  wire  _GEN_104 = 4'h3 == state ? 1'h0 : 4'h6 == state & _T_21; // @[src/main/scala/fsm.scala 50:17 48:22]
  wire  _GEN_106 = 4'h3 == state ? 1'h0 : _GEN_91; // @[src/main/scala/fsm.scala 50:17 49:23]
  wire  _GEN_109 = 4'h2 == state ? _GEN_35 : _GEN_95; // @[src/main/scala/fsm.scala 50:17]
  wire  _GEN_110 = 4'h2 == state ? _GEN_36 : _GEN_96; // @[src/main/scala/fsm.scala 50:17]
  wire [13:0] _GEN_112 = 4'h2 == state ? io_read_row_address : _GEN_61; // @[src/main/scala/fsm.scala 50:17]
  wire  _GEN_119 = 4'h2 == state ? 1'h0 : _GEN_104; // @[src/main/scala/fsm.scala 50:17 48:22]
  wire  _GEN_121 = 4'h2 == state ? 1'h0 : _GEN_106; // @[src/main/scala/fsm.scala 50:17 49:23]
  AnalogConnection handle_analog ( // @[src/main/scala/fsm.scala 41:29]
    .data_inout(io_sdram_control_dq),
    .read_data(handle_analog_read_data),
    .write_data(handle_analog_write_data),
    .oen(handle_analog_oen)
  );
  assign io_read_data = handle_analog_read_data; // @[src/main/scala/fsm.scala 45:16]
  assign io_read_data_valid = 4'h1 == state ? 1'h0 : _GEN_119; // @[src/main/scala/fsm.scala 50:17 48:22]
  assign io_write_data_valid = 4'h1 == state ? 1'h0 : _GEN_121; // @[src/main/scala/fsm.scala 50:17 49:23]
  assign io_sdram_control_cs = 1'h0; // @[src/main/scala/fsm.scala 50:17]
  assign io_sdram_control_ras = 4'h1 == state ? _GEN_16 : _GEN_109; // @[src/main/scala/fsm.scala 50:17]
  assign io_sdram_control_cas = 4'h1 == state ? _GEN_17 : _GEN_110; // @[src/main/scala/fsm.scala 50:17]
  assign io_sdram_control_we = 4'h1 == state ? _GEN_18 : 4'h2 == state | _GEN_97; // @[src/main/scala/fsm.scala 50:17]
  assign io_sdram_control_dqm = 1'h0;
  assign io_sdram_control_address_bus = 4'h1 == state ? 14'h30 : _GEN_112; // @[src/main/scala/fsm.scala 50:17]
  assign io_state_out = state; // @[src/main/scala/fsm.scala 47:16]
  assign handle_analog_write_data = io_write_data; // @[src/main/scala/fsm.scala 43:31]
  assign handle_analog_oen = oen_reg; // @[src/main/scala/fsm.scala 44:24]
  always @(posedge clock) begin
    if (reset) begin // @[src/main/scala/fsm.scala 12:22]
      state <= 4'h1; // @[src/main/scala/fsm.scala 12:22]
    end else if (4'h1 == state) begin // @[src/main/scala/fsm.scala 50:17]
      if (!(hundred_micro_sec_counter_value == 14'h30d4)) begin // @[src/main/scala/fsm.scala 61:68]
        if (!(_T_6)) begin // @[src/main/scala/fsm.scala 65:11]
          state <= _GEN_7;
        end
      end
    end else if (4'h2 == state) begin // @[src/main/scala/fsm.scala 50:17]
      state <= {{2'd0}, _GEN_40};
    end else if (4'h3 == state) begin // @[src/main/scala/fsm.scala 50:17]
      state <= {{1'd0}, _GEN_56};
    end else begin
      state <= _GEN_84;
    end
    if (reset) begin // @[src/main/scala/fsm.scala 16:28]
      stated_read <= 1'h0; // @[src/main/scala/fsm.scala 16:28]
    end else if (!(4'h1 == state)) begin // @[src/main/scala/fsm.scala 50:17]
      if (4'h2 == state) begin // @[src/main/scala/fsm.scala 50:17]
        if (!(refresh_outstanding)) begin // @[src/main/scala/fsm.scala 94:34]
          stated_read <= _GEN_32;
        end
      end else if (4'h3 == state) begin // @[src/main/scala/fsm.scala 50:17]
        stated_read <= _GEN_63;
      end
    end
    if (reset) begin // @[src/main/scala/fsm.scala 17:30]
      started_write <= 1'h0; // @[src/main/scala/fsm.scala 17:30]
    end else if (!(4'h1 == state)) begin // @[src/main/scala/fsm.scala 50:17]
      if (4'h2 == state) begin // @[src/main/scala/fsm.scala 50:17]
        if (!(refresh_outstanding)) begin // @[src/main/scala/fsm.scala 94:34]
          started_write <= _GEN_33;
        end
      end else if (4'h3 == state) begin // @[src/main/scala/fsm.scala 50:17]
        started_write <= _GEN_65;
      end
    end
    if (reset) begin // @[src/main/scala/fsm.scala 18:24]
      oen_reg <= 1'h0; // @[src/main/scala/fsm.scala 18:24]
    end else if (!(4'h1 == state)) begin // @[src/main/scala/fsm.scala 50:17]
      if (!(4'h2 == state)) begin // @[src/main/scala/fsm.scala 50:17]
        if (4'h3 == state) begin // @[src/main/scala/fsm.scala 50:17]
          oen_reg <= _GEN_62;
        end
      end
    end
    if (reset) begin // @[src/main/scala/chisel3/util/Counter.scala 61:40]
      cas_counter_value <= 2'h0; // @[src/main/scala/chisel3/util/Counter.scala 61:40]
    end else if (!(4'h1 == state)) begin // @[src/main/scala/fsm.scala 50:17]
      if (4'h2 == state) begin // @[src/main/scala/fsm.scala 50:17]
        if (!(refresh_outstanding)) begin // @[src/main/scala/fsm.scala 94:34]
          cas_counter_value <= _GEN_31;
        end
      end else if (4'h3 == state) begin // @[src/main/scala/fsm.scala 50:17]
        cas_counter_value <= _GEN_64;
      end else begin
        cas_counter_value <= _GEN_85;
      end
    end
    if (reset) begin // @[src/main/scala/chisel3/util/Counter.scala 61:40]
      terminate_write_value <= 2'h0; // @[src/main/scala/chisel3/util/Counter.scala 61:40]
    end else if (!(4'h1 == state)) begin // @[src/main/scala/fsm.scala 50:17]
      if (!(4'h2 == state)) begin // @[src/main/scala/fsm.scala 50:17]
        if (!(4'h3 == state)) begin // @[src/main/scala/fsm.scala 50:17]
          terminate_write_value <= _GEN_90;
        end
      end
    end
    if (reset) begin // @[src/main/scala/chisel3/util/Counter.scala 61:40]
      hundred_micro_sec_counter_value <= 14'h0; // @[src/main/scala/chisel3/util/Counter.scala 61:40]
    end else if (4'h1 == state) begin // @[src/main/scala/fsm.scala 50:17]
      if (hundred_micro_sec_counter_value == 14'h30d4) begin // @[src/main/scala/fsm.scala 61:68]
        hundred_micro_sec_counter_value <= _GEN_2;
      end else if (_T_6) begin // @[src/main/scala/fsm.scala 65:11]
        hundred_micro_sec_counter_value <= _GEN_2;
      end else begin
        hundred_micro_sec_counter_value <= _GEN_6;
      end
    end
    if (reset) begin // @[src/main/scala/chisel3/util/Counter.scala 61:40]
      active_to_rw_counter_value <= 2'h0; // @[src/main/scala/chisel3/util/Counter.scala 61:40]
    end else if (!(4'h1 == state)) begin // @[src/main/scala/fsm.scala 50:17]
      if (!(4'h2 == state)) begin // @[src/main/scala/fsm.scala 50:17]
        if (4'h3 == state) begin // @[src/main/scala/fsm.scala 50:17]
          active_to_rw_counter_value <= _value_T_5; // @[src/main/scala/chisel3/util/Counter.scala 77:15]
        end
      end
    end
    if (reset) begin // @[src/main/scala/chisel3/util/Counter.scala 61:40]
      refresh_counter_value <= 12'h0; // @[src/main/scala/chisel3/util/Counter.scala 61:40]
    end else if (wrap) begin // @[src/main/scala/chisel3/util/Counter.scala 87:20]
      refresh_counter_value <= 12'h0; // @[src/main/scala/chisel3/util/Counter.scala 87:28]
    end else begin
      refresh_counter_value <= _value_T_1; // @[src/main/scala/chisel3/util/Counter.scala 77:15]
    end
    if (reset) begin // @[src/main/scala/fsm.scala 36:36]
      refresh_outstanding <= 1'h0; // @[src/main/scala/fsm.scala 36:36]
    end else if (4'h1 == state) begin // @[src/main/scala/fsm.scala 50:17]
      if (hundred_micro_sec_counter_value == 14'h30d4) begin // @[src/main/scala/fsm.scala 61:68]
        refresh_outstanding <= _GEN_1;
      end else if (_T_6) begin // @[src/main/scala/fsm.scala 65:11]
        refresh_outstanding <= 1'h0; // @[src/main/scala/fsm.scala 68:31]
      end else begin
        refresh_outstanding <= _GEN_1;
      end
    end else if (4'h2 == state) begin // @[src/main/scala/fsm.scala 50:17]
      if (refresh_outstanding) begin // @[src/main/scala/fsm.scala 94:34]
        refresh_outstanding <= 1'h0; // @[src/main/scala/fsm.scala 96:29]
      end else begin
        refresh_outstanding <= _GEN_1;
      end
    end else if (4'h3 == state) begin // @[src/main/scala/fsm.scala 50:17]
      refresh_outstanding <= _GEN_66;
    end else begin
      refresh_outstanding <= _GEN_1;
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  state = _RAND_0[3:0];
  _RAND_1 = {1{`RANDOM}};
  stated_read = _RAND_1[0:0];
  _RAND_2 = {1{`RANDOM}};
  started_write = _RAND_2[0:0];
  _RAND_3 = {1{`RANDOM}};
  oen_reg = _RAND_3[0:0];
  _RAND_4 = {1{`RANDOM}};
  cas_counter_value = _RAND_4[1:0];
  _RAND_5 = {1{`RANDOM}};
  terminate_write_value = _RAND_5[1:0];
  _RAND_6 = {1{`RANDOM}};
  hundred_micro_sec_counter_value = _RAND_6[13:0];
  _RAND_7 = {1{`RANDOM}};
  active_to_rw_counter_value = _RAND_7[1:0];
  _RAND_8 = {1{`RANDOM}};
  refresh_counter_value = _RAND_8[11:0];
  _RAND_9 = {1{`RANDOM}};
  refresh_outstanding = _RAND_9[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
