module Element(
  input        clock,
  input  [7:0] io_ins_down, // @[src/test/scala/MockArray.scala 49:9]
  input  [7:0] io_ins_right, // @[src/test/scala/MockArray.scala 49:9]
  input  [7:0] io_ins_up, // @[src/test/scala/MockArray.scala 49:9]
  input  [7:0] io_ins_left, // @[src/test/scala/MockArray.scala 49:9]
  output [7:0] io_outs_down, // @[src/test/scala/MockArray.scala 49:9]
  output [7:0] io_outs_right, // @[src/test/scala/MockArray.scala 49:9]
  output [7:0] io_outs_up, // @[src/test/scala/MockArray.scala 49:9]
  output [7:0] io_outs_left, // @[src/test/scala/MockArray.scala 49:9]
  input        io_lsbIns_1, // @[src/test/scala/MockArray.scala 49:9]
  input        io_lsbIns_2, // @[src/test/scala/MockArray.scala 49:9]
  input        io_lsbIns_3, // @[src/test/scala/MockArray.scala 49:9]
  input        io_lsbIns_4, // @[src/test/scala/MockArray.scala 49:9]
  input        io_lsbIns_5, // @[src/test/scala/MockArray.scala 49:9]
  input        io_lsbIns_6, // @[src/test/scala/MockArray.scala 49:9]
  input        io_lsbIns_7, // @[src/test/scala/MockArray.scala 49:9]
  output       io_lsbOuts_0, // @[src/test/scala/MockArray.scala 49:9]
  output       io_lsbOuts_1, // @[src/test/scala/MockArray.scala 49:9]
  output       io_lsbOuts_2, // @[src/test/scala/MockArray.scala 49:9]
  output       io_lsbOuts_3, // @[src/test/scala/MockArray.scala 49:9]
  output       io_lsbOuts_4, // @[src/test/scala/MockArray.scala 49:9]
  output       io_lsbOuts_5, // @[src/test/scala/MockArray.scala 49:9]
  output       io_lsbOuts_6, // @[src/test/scala/MockArray.scala 49:9]
  output       io_lsbOuts_7 // @[src/test/scala/MockArray.scala 49:9]
);
  reg [7:0] REG; // @[src/test/scala/MockArray.scala 60:56]
  reg [7:0] REG_1; // @[src/test/scala/MockArray.scala 60:56]
  reg [7:0] REG_2; // @[src/test/scala/MockArray.scala 60:56]
  reg [7:0] REG_3; // @[src/test/scala/MockArray.scala 60:56]
  assign io_outs_down = REG_3; // @[src/test/scala/MockArray.scala 60:87]
  assign io_outs_right = REG_2; // @[src/test/scala/MockArray.scala 60:87]
  assign io_outs_up = REG_1; // @[src/test/scala/MockArray.scala 60:87]
  assign io_outs_left = REG; // @[src/test/scala/MockArray.scala 60:87]
  assign io_lsbOuts_0 = io_lsbIns_1; // @[src/test/scala/MockArray.scala 63:16]
  assign io_lsbOuts_1 = io_lsbIns_2; // @[src/test/scala/MockArray.scala 63:16]
  assign io_lsbOuts_2 = io_lsbIns_3; // @[src/test/scala/MockArray.scala 63:16]
  assign io_lsbOuts_3 = io_lsbIns_4; // @[src/test/scala/MockArray.scala 63:16]
  assign io_lsbOuts_4 = io_lsbIns_5; // @[src/test/scala/MockArray.scala 63:16]
  assign io_lsbOuts_5 = io_lsbIns_6; // @[src/test/scala/MockArray.scala 63:16]
  assign io_lsbOuts_6 = io_lsbIns_7; // @[src/test/scala/MockArray.scala 63:16]
  assign io_lsbOuts_7 = io_outs_left[0]; // @[src/test/scala/MockArray.scala 63:62]
  always @(posedge clock) begin
    REG <= io_ins_down; // @[src/test/scala/MockArray.scala 60:56]
    REG_1 <= io_ins_right; // @[src/test/scala/MockArray.scala 60:56]
    REG_2 <= io_ins_up; // @[src/test/scala/MockArray.scala 60:56]
    REG_3 <= io_ins_left; // @[src/test/scala/MockArray.scala 60:56]
  end
endmodule
