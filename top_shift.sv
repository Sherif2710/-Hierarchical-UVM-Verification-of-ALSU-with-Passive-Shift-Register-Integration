////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: UVM Example
// 
////////////////////////////////////////////////////////////////////////////////


import shift_reg_test_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
module shift_top();
bit clk;
  // Example 1
  // Clock generation
  initial begin
    forever begin
      #1 clk =~clk;
    end
  end
  // Instantiate the interface and DUT
shift_reg_if shift_if(clk);
shift_reg DUT (shift_if.clk, shift_if.reset, shift_if.serial_in, shift_if.direction, shift_if.mode, shift_if.datain, shift_if.dataout);
initial
begin
  // run test using run_test task
uvm_config_db #(virtual shift_reg_if) :: set (null , "uvm_test_top" ,"key_shift" ,shift_if ); //ha7ot pointer al interface fy al config data base
  // Example 2
  run_test("shift_reg_test");
  // Set the virtual interface for the uvm test
end 
endmodule