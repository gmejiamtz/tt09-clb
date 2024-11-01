module sdram_controller(
  input         clock,
  input         reset,
  input  [11:0] io_read_row_addresses_0, // @[src/main/scala/fsm.scala 138:14]
  input  [11:0] io_read_col_addresses_0, // @[src/main/scala/fsm.scala 138:14]
  output        io_read_data_valid_0, // @[src/main/scala/fsm.scala 138:14]
  input         io_read_start_0, // @[src/main/scala/fsm.scala 138:14]
  input  [11:0] io_write_row_addresses_0, // @[src/main/scala/fsm.scala 138:14]
  input  [11:0] io_write_col_addresses_0, // @[src/main/scala/fsm.scala 138:14]
  output        io_write_data_valid_0, // @[src/main/scala/fsm.scala 138:14]
  input         io_write_start_0, // @[src/main/scala/fsm.scala 138:14]
  output        io_sdram_control_cs, // @[src/main/scala/fsm.scala 138:14]
  output        io_sdram_control_ras, // @[src/main/scala/fsm.scala 138:14]
  output        io_sdram_control_cas, // @[src/main/scala/fsm.scala 138:14]
  output        io_sdram_control_we, // @[src/main/scala/fsm.scala 138:14]
  output [11:0] io_sdram_control_address_bus, // @[src/main/scala/fsm.scala 138:14]
  output [3:0]  io_state_out // @[src/main/scala/fsm.scala 138:14]
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
`endif // RANDOMIZE_REG_INIT
  reg [3:0] state; // @[src/main/scala/fsm.scala 140:22]
  reg  stated_read; // @[src/main/scala/fsm.scala 143:28]
  reg  started_write; // @[src/main/scala/fsm.scala 144:30]
  reg [1:0] cas_counter_value; // @[src/main/scala/chisel3/util/Counter.scala 61:40]
  reg [1:0] terminate_write_value; // @[src/main/scala/chisel3/util/Counter.scala 61:40]
  reg [13:0] hundred_micro_sec_counter_value; // @[src/main/scala/chisel3/util/Counter.scala 61:40]
  reg [1:0] active_to_rw_counter_value; // @[src/main/scala/chisel3/util/Counter.scala 61:40]
  reg [11:0] refresh_counter_value; // @[src/main/scala/chisel3/util/Counter.scala 61:40]
  reg  refresh_outstanding; // @[src/main/scala/fsm.scala 163:36]
  wire  wrap = refresh_counter_value == 12'hf40; // @[src/main/scala/chisel3/util/Counter.scala 73:24]
  wire [11:0] _value_T_1 = refresh_counter_value + 12'h1; // @[src/main/scala/chisel3/util/Counter.scala 77:24]
  wire  _GEN_1 = wrap | refresh_outstanding; // @[src/main/scala/fsm.scala 164:32 165:25 163:36]
  wire  wrap_1 = hundred_micro_sec_counter_value == 14'h30d7; // @[src/main/scala/chisel3/util/Counter.scala 73:24]
  wire [13:0] _value_T_3 = hundred_micro_sec_counter_value + 14'h1; // @[src/main/scala/chisel3/util/Counter.scala 77:24]
  wire [13:0] _GEN_2 = wrap_1 ? 14'h0 : _value_T_3; // @[src/main/scala/chisel3/util/Counter.scala 77:15 87:{20,28}]
  wire  _T_6 = hundred_micro_sec_counter_value == 14'h30d5 | hundred_micro_sec_counter_value == 14'h30d6; // @[src/main/scala/fsm.scala 250:74]
  wire  _GEN_4 = wrap_1 ? 1'h0 : 1'h1; // @[src/main/scala/fsm.scala 171:26 193:26 255:81]
  wire [13:0] _GEN_6 = wrap_1 ? 14'h0 : _GEN_2; // @[src/main/scala/fsm.scala 255:81 src/main/scala/chisel3/util/Counter.scala 98:11]
  wire [3:0] _GEN_7 = wrap_1 ? 4'h2 : state; // @[src/main/scala/fsm.scala 255:81 269:17 140:22]
  wire  _GEN_9 = _T_6 ? 1'h0 : _GEN_4; // @[src/main/scala/fsm.scala 251:11 185:26]
  wire  _GEN_10 = _T_6 | _GEN_4; // @[src/main/scala/fsm.scala 251:11 187:25]
  wire  _GEN_16 = hundred_micro_sec_counter_value == 14'h30d4 ? 1'h0 : _GEN_9; // @[src/main/scala/fsm.scala 178:26 247:68]
  wire  _GEN_17 = hundred_micro_sec_counter_value == 14'h30d4 | _GEN_9; // @[src/main/scala/fsm.scala 179:26 247:68]
  wire  _GEN_18 = hundred_micro_sec_counter_value == 14'h30d4 ? 1'h0 : _GEN_10; // @[src/main/scala/fsm.scala 180:25 247:68]
  wire  go_to_active = io_read_start_0 | io_write_start_0; // @[src/main/scala/fsm.scala 276:40]
  wire  _GEN_23 = io_write_start_0 | started_write; // @[src/main/scala/fsm.scala 289:53 290:25 144:30]
  wire  _GEN_25 = io_read_start_0 | stated_read; // @[src/main/scala/fsm.scala 285:46 286:23 143:28]
  wire [1:0] _GEN_26 = io_read_start_0 ? 2'h0 : cas_counter_value; // @[src/main/scala/fsm.scala 285:46 src/main/scala/chisel3/util/Counter.scala 98:11 61:40]
  wire [11:0] _GEN_27 = io_read_start_0 ? io_read_row_addresses_0 : io_write_row_addresses_0; // @[src/main/scala/fsm.scala 285:46 288:40]
  wire  _GEN_28 = io_read_start_0 ? started_write : _GEN_23; // @[src/main/scala/fsm.scala 144:30 285:46]
  wire [1:0] _GEN_29 = go_to_active ? 2'h3 : 2'h2; // @[src/main/scala/fsm.scala 273:13 281:33 282:15]
  wire  _GEN_31 = go_to_active ? 1'h0 : 1'h1; // @[src/main/scala/fsm.scala 171:26 200:26 281:33]
  wire  _GEN_33 = go_to_active ? _GEN_25 : stated_read; // @[src/main/scala/fsm.scala 143:28 281:33]
  wire [1:0] _GEN_34 = go_to_active ? _GEN_26 : cas_counter_value; // @[src/main/scala/fsm.scala 281:33 src/main/scala/chisel3/util/Counter.scala 61:40]
  wire  _GEN_36 = go_to_active ? _GEN_28 : started_write; // @[src/main/scala/fsm.scala 144:30 281:33]
  wire  _GEN_38 = refresh_outstanding ? 1'h0 : _GEN_31; // @[src/main/scala/fsm.scala 185:26 279:34]
  wire  _GEN_39 = refresh_outstanding ? 1'h0 : 1'h1; // @[src/main/scala/fsm.scala 186:26 279:34]
  wire  _GEN_41 = refresh_outstanding ? 1'h0 : _GEN_1; // @[src/main/scala/fsm.scala 188:25 279:34]
  wire [1:0] _GEN_42 = refresh_outstanding ? 2'h2 : _GEN_29; // @[src/main/scala/fsm.scala 273:13 279:34]
  wire  wrap_2 = active_to_rw_counter_value == 2'h3; // @[src/main/scala/chisel3/util/Counter.scala 73:24]
  wire [1:0] _value_T_5 = active_to_rw_counter_value + 2'h1; // @[src/main/scala/chisel3/util/Counter.scala 77:24]
  wire  _T_17 = stated_read & wrap_2; // @[src/main/scala/fsm.scala 306:24]
  wire  wrap_3 = cas_counter_value == 2'h3; // @[src/main/scala/chisel3/util/Counter.scala 73:24]
  wire [1:0] _value_T_7 = cas_counter_value + 2'h1; // @[src/main/scala/chisel3/util/Counter.scala 77:24]
  wire  _T_19 = started_write & wrap_2; // @[src/main/scala/fsm.scala 317:24]
  wire [2:0] _GEN_50 = _T_19 ? 3'h7 : 3'h3; // @[src/main/scala/fsm.scala 296:13 318:9 319:15]
  wire  _GEN_51 = _T_19 ? 1'h0 : started_write; // @[src/main/scala/fsm.scala 318:9 321:23 144:30]
  wire  _GEN_54 = _T_19 | _GEN_39; // @[src/main/scala/fsm.scala 214:26 318:9]
  wire  _GEN_55 = _T_19 ? 1'h0 : _GEN_39; // @[src/main/scala/fsm.scala 215:26 318:9]
  wire  _GEN_56 = _T_19 ? 1'h0 : 1'h1; // @[src/main/scala/fsm.scala 216:25 318:9]
  wire [11:0] _GEN_57 = _T_19 ? io_write_col_addresses_0 : io_read_row_addresses_0; // @[src/main/scala/fsm.scala 304:36 318:9 325:38]
  wire  _GEN_58 = _T_19 ? _GEN_1 : _GEN_41; // @[src/main/scala/fsm.scala 318:9]
  wire [2:0] _GEN_59 = _T_17 ? 3'h6 : _GEN_50; // @[src/main/scala/fsm.scala 307:9 308:15]
  wire  _GEN_61 = _T_17 | _GEN_54; // @[src/main/scala/fsm.scala 207:26 307:9]
  wire  _GEN_62 = _T_17 ? 1'h0 : _GEN_55; // @[src/main/scala/fsm.scala 208:26 307:9]
  wire  _GEN_63 = _T_17 | _GEN_56; // @[src/main/scala/fsm.scala 209:25 307:9]
  wire  _GEN_65 = _T_17 ? 1'h0 : stated_read; // @[src/main/scala/fsm.scala 307:9 312:21 143:28]
  wire [11:0] _GEN_66 = _T_17 ? io_read_col_addresses_0 : _GEN_57; // @[src/main/scala/fsm.scala 307:9 314:38]
  wire [1:0] _GEN_67 = _T_17 ? _value_T_7 : cas_counter_value; // @[src/main/scala/fsm.scala 307:9 src/main/scala/chisel3/util/Counter.scala 77:15 61:40]
  wire  _GEN_68 = _T_17 ? started_write : _GEN_51; // @[src/main/scala/fsm.scala 144:30 307:9]
  wire  _GEN_69 = _T_17 ? _GEN_1 : _GEN_58; // @[src/main/scala/fsm.scala 307:9]
  wire  _GEN_72 = wrap_3 ? 1'h0 : 1'h1; // @[src/main/scala/fsm.scala 171:26 178:26 335:51]
  wire [2:0] _GEN_74 = wrap_3 ? 3'h2 : 3'h6; // @[src/main/scala/fsm.scala 331:13 335:51 341:15]
  wire  wrap_5 = terminate_write_value == 2'h2; // @[src/main/scala/chisel3/util/Counter.scala 73:24]
  wire [1:0] _value_T_11 = terminate_write_value + 2'h1; // @[src/main/scala/chisel3/util/Counter.scala 77:24]
  wire [1:0] _GEN_75 = wrap_5 ? 2'h0 : _value_T_11; // @[src/main/scala/chisel3/util/Counter.scala 77:15 87:{20,28}]
  wire  _GEN_77 = wrap_5 ? 1'h0 : 1'h1; // @[src/main/scala/fsm.scala 171:26 178:26 348:55]
  wire [3:0] _GEN_80 = wrap_5 ? 4'h2 : state; // @[src/main/scala/fsm.scala 348:55 352:15 140:22]
  wire [1:0] _GEN_81 = 4'h7 == state ? _GEN_75 : terminate_write_value; // @[src/main/scala/fsm.scala 236:17 src/main/scala/chisel3/util/Counter.scala 61:40]
  wire [3:0] _GEN_86 = 4'h7 == state ? _GEN_80 : state; // @[src/main/scala/fsm.scala 236:17 140:22]
  wire [3:0] _GEN_87 = 4'h6 == state ? {{1'd0}, _GEN_74} : _GEN_86; // @[src/main/scala/fsm.scala 236:17]
  wire [1:0] _GEN_88 = 4'h6 == state ? _value_T_7 : cas_counter_value; // @[src/main/scala/fsm.scala 236:17 src/main/scala/chisel3/util/Counter.scala 77:15 61:40]
  wire  _GEN_90 = 4'h6 == state ? _GEN_72 : _GEN_77; // @[src/main/scala/fsm.scala 236:17]
  wire [1:0] _GEN_93 = 4'h6 == state ? terminate_write_value : _GEN_81; // @[src/main/scala/fsm.scala 236:17 src/main/scala/chisel3/util/Counter.scala 61:40]
  wire  _GEN_94 = 4'h6 == state ? 1'h0 : 4'h7 == state & wrap_5; // @[src/main/scala/fsm.scala 236:17 235:26]
  wire  _GEN_98 = 4'h3 == state ? _GEN_61 : _GEN_90; // @[src/main/scala/fsm.scala 236:17]
  wire  _GEN_99 = 4'h3 == state ? _GEN_62 : 1'h1; // @[src/main/scala/fsm.scala 236:17]
  wire  _GEN_100 = 4'h3 == state ? _GEN_63 : _GEN_90; // @[src/main/scala/fsm.scala 236:17]
  wire  _GEN_107 = 4'h3 == state ? 1'h0 : 4'h6 == state & wrap_3; // @[src/main/scala/fsm.scala 236:17 234:25]
  wire  _GEN_109 = 4'h3 == state ? 1'h0 : _GEN_94; // @[src/main/scala/fsm.scala 236:17 235:26]
  wire  _GEN_112 = 4'h2 == state ? _GEN_38 : _GEN_98; // @[src/main/scala/fsm.scala 236:17]
  wire  _GEN_113 = 4'h2 == state ? _GEN_39 : _GEN_99; // @[src/main/scala/fsm.scala 236:17]
  wire [11:0] _GEN_118 = 4'h2 == state ? _GEN_27 : _GEN_66; // @[src/main/scala/fsm.scala 236:17]
  wire  _GEN_122 = 4'h2 == state ? 1'h0 : _GEN_107; // @[src/main/scala/fsm.scala 236:17 234:25]
  wire  _GEN_124 = 4'h2 == state ? 1'h0 : _GEN_109; // @[src/main/scala/fsm.scala 236:17 235:26]
  assign io_read_data_valid_0 = 4'h1 == state ? 1'h0 : _GEN_122; // @[src/main/scala/fsm.scala 236:17 234:25]
  assign io_write_data_valid_0 = 4'h1 == state ? 1'h0 : _GEN_124; // @[src/main/scala/fsm.scala 236:17 235:26]
  assign io_sdram_control_cs = 1'h0; // @[src/main/scala/fsm.scala 236:17]
  assign io_sdram_control_ras = 4'h1 == state ? _GEN_16 : _GEN_112; // @[src/main/scala/fsm.scala 236:17]
  assign io_sdram_control_cas = 4'h1 == state ? _GEN_17 : _GEN_113; // @[src/main/scala/fsm.scala 236:17]
  assign io_sdram_control_we = 4'h1 == state ? _GEN_18 : 4'h2 == state | _GEN_100; // @[src/main/scala/fsm.scala 236:17]
  assign io_sdram_control_address_bus = 4'h1 == state ? 12'h30 : _GEN_118; // @[src/main/scala/fsm.scala 236:17]
  assign io_state_out = state; // @[src/main/scala/fsm.scala 233:16]
  always @(posedge clock) begin
    if (reset) begin // @[src/main/scala/fsm.scala 140:22]
      state <= 4'h1; // @[src/main/scala/fsm.scala 140:22]
    end else if (4'h1 == state) begin // @[src/main/scala/fsm.scala 236:17]
      if (!(hundred_micro_sec_counter_value == 14'h30d4)) begin // @[src/main/scala/fsm.scala 247:68]
        if (!(_T_6)) begin // @[src/main/scala/fsm.scala 251:11]
          state <= _GEN_7;
        end
      end
    end else if (4'h2 == state) begin // @[src/main/scala/fsm.scala 236:17]
      state <= {{2'd0}, _GEN_42};
    end else if (4'h3 == state) begin // @[src/main/scala/fsm.scala 236:17]
      state <= {{1'd0}, _GEN_59};
    end else begin
      state <= _GEN_87;
    end
    if (reset) begin // @[src/main/scala/fsm.scala 143:28]
      stated_read <= 1'h0; // @[src/main/scala/fsm.scala 143:28]
    end else if (!(4'h1 == state)) begin // @[src/main/scala/fsm.scala 236:17]
      if (4'h2 == state) begin // @[src/main/scala/fsm.scala 236:17]
        if (!(refresh_outstanding)) begin // @[src/main/scala/fsm.scala 279:34]
          stated_read <= _GEN_33;
        end
      end else if (4'h3 == state) begin // @[src/main/scala/fsm.scala 236:17]
        stated_read <= _GEN_65;
      end
    end
    if (reset) begin // @[src/main/scala/fsm.scala 144:30]
      started_write <= 1'h0; // @[src/main/scala/fsm.scala 144:30]
    end else if (!(4'h1 == state)) begin // @[src/main/scala/fsm.scala 236:17]
      if (4'h2 == state) begin // @[src/main/scala/fsm.scala 236:17]
        if (!(refresh_outstanding)) begin // @[src/main/scala/fsm.scala 279:34]
          started_write <= _GEN_36;
        end
      end else if (4'h3 == state) begin // @[src/main/scala/fsm.scala 236:17]
        started_write <= _GEN_68;
      end
    end
    if (reset) begin // @[src/main/scala/chisel3/util/Counter.scala 61:40]
      cas_counter_value <= 2'h0; // @[src/main/scala/chisel3/util/Counter.scala 61:40]
    end else if (!(4'h1 == state)) begin // @[src/main/scala/fsm.scala 236:17]
      if (4'h2 == state) begin // @[src/main/scala/fsm.scala 236:17]
        if (!(refresh_outstanding)) begin // @[src/main/scala/fsm.scala 279:34]
          cas_counter_value <= _GEN_34;
        end
      end else if (4'h3 == state) begin // @[src/main/scala/fsm.scala 236:17]
        cas_counter_value <= _GEN_67;
      end else begin
        cas_counter_value <= _GEN_88;
      end
    end
    if (reset) begin // @[src/main/scala/chisel3/util/Counter.scala 61:40]
      terminate_write_value <= 2'h0; // @[src/main/scala/chisel3/util/Counter.scala 61:40]
    end else if (!(4'h1 == state)) begin // @[src/main/scala/fsm.scala 236:17]
      if (!(4'h2 == state)) begin // @[src/main/scala/fsm.scala 236:17]
        if (!(4'h3 == state)) begin // @[src/main/scala/fsm.scala 236:17]
          terminate_write_value <= _GEN_93;
        end
      end
    end
    if (reset) begin // @[src/main/scala/chisel3/util/Counter.scala 61:40]
      hundred_micro_sec_counter_value <= 14'h0; // @[src/main/scala/chisel3/util/Counter.scala 61:40]
    end else if (4'h1 == state) begin // @[src/main/scala/fsm.scala 236:17]
      if (hundred_micro_sec_counter_value == 14'h30d4) begin // @[src/main/scala/fsm.scala 247:68]
        hundred_micro_sec_counter_value <= _GEN_2;
      end else if (_T_6) begin // @[src/main/scala/fsm.scala 251:11]
        hundred_micro_sec_counter_value <= _GEN_2;
      end else begin
        hundred_micro_sec_counter_value <= _GEN_6;
      end
    end
    if (reset) begin // @[src/main/scala/chisel3/util/Counter.scala 61:40]
      active_to_rw_counter_value <= 2'h0; // @[src/main/scala/chisel3/util/Counter.scala 61:40]
    end else if (!(4'h1 == state)) begin // @[src/main/scala/fsm.scala 236:17]
      if (!(4'h2 == state)) begin // @[src/main/scala/fsm.scala 236:17]
        if (4'h3 == state) begin // @[src/main/scala/fsm.scala 236:17]
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
    if (reset) begin // @[src/main/scala/fsm.scala 163:36]
      refresh_outstanding <= 1'h0; // @[src/main/scala/fsm.scala 163:36]
    end else if (4'h1 == state) begin // @[src/main/scala/fsm.scala 236:17]
      if (hundred_micro_sec_counter_value == 14'h30d4) begin // @[src/main/scala/fsm.scala 247:68]
        refresh_outstanding <= _GEN_1;
      end else if (_T_6) begin // @[src/main/scala/fsm.scala 251:11]
        refresh_outstanding <= 1'h0; // @[src/main/scala/fsm.scala 188:25]
      end else begin
        refresh_outstanding <= _GEN_1;
      end
    end else if (4'h2 == state) begin // @[src/main/scala/fsm.scala 236:17]
      if (refresh_outstanding) begin // @[src/main/scala/fsm.scala 279:34]
        refresh_outstanding <= 1'h0; // @[src/main/scala/fsm.scala 188:25]
      end else begin
        refresh_outstanding <= _GEN_1;
      end
    end else if (4'h3 == state) begin // @[src/main/scala/fsm.scala 236:17]
      refresh_outstanding <= _GEN_69;
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
  cas_counter_value = _RAND_3[1:0];
  _RAND_4 = {1{`RANDOM}};
  terminate_write_value = _RAND_4[1:0];
  _RAND_5 = {1{`RANDOM}};
  hundred_micro_sec_counter_value = _RAND_5[13:0];
  _RAND_6 = {1{`RANDOM}};
  active_to_rw_counter_value = _RAND_6[1:0];
  _RAND_7 = {1{`RANDOM}};
  refresh_counter_value = _RAND_7[11:0];
  _RAND_8 = {1{`RANDOM}};
  refresh_outstanding = _RAND_8[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
