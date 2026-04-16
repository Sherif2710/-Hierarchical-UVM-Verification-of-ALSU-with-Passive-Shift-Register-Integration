interface ALSU_interface(clk);
input clk;
  logic  rst,cin, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
   logic  [2:0] opcode;
  logic  signed [2:0] A, B;
  logic [15:0] leds,leds_gn;
  logic signed [5:0] out,out_gn;
   modport sva (input A, B, cin, serial_in, red_op_A, red_op_B, opcode, bypass_A, bypass_B, clk, rst, direction,output leds ,out);
endinterface