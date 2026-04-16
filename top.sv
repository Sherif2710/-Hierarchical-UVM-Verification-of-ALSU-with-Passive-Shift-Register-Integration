import alsu_reg_test_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
module top();
bit clk;
  // Clock generation
  initial begin
     clk=0;  
    forever begin
      #1 clk =~clk;
    end
  end
  ALSU_interface alsu_if(clk);
    shift_reg_if shift_if();
  ALSU DUT(alsu_if.A, alsu_if.B, alsu_if.cin, alsu_if.serial_in, alsu_if.red_op_A, alsu_if.red_op_B, alsu_if.opcode, alsu_if.bypass_A, alsu_if.bypass_B, alsu_if.clk, alsu_if.rst, alsu_if.direction, alsu_if.leds, alsu_if.out);


shift_reg DUT_shift(shift_if.serial_in, shift_if.direction,shift_if.mode, shift_if.datain, shift_if.dataout);
ALSU_GOLDEN golden(alsu_if.A, alsu_if.B, alsu_if.cin, alsu_if.serial_in, alsu_if.red_op_A, alsu_if.red_op_B, alsu_if.opcode, alsu_if.bypass_A, alsu_if.bypass_B, alsu_if.clk, alsu_if.rst, alsu_if.direction, alsu_if.leds_gn, alsu_if.out_gn);
assign shift_if.serial_in = DUT.serial_in_reg ;
assign shift_if.direction = DUT.direction_reg;
assign shift_if.mode = DUT.opcode_reg;
assign shift_if.datain = DUT.out;
assign DUT.out_shift_reg = shift_if.dataout ;
  
  bind ALSU alsu_sva my_ass(alsu_if.sva);
  initial begin
uvm_config_db #(virtual ALSU_interface) :: set (null , "uvm_test_top" ,"alsu_key" ,alsu_if );
uvm_config_db #(virtual shift_reg_if) :: set (null , "uvm_test_top" ,"shift_key" ,shift_if );
run_test("alsu_reg_test");
  end 
endmodule