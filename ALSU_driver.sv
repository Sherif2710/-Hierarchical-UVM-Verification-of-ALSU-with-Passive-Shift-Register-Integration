package alsu_reg_driver_pkg;
//import alsu_reg_config::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
import alsu_sequence_item_pkg::*;

class alsu_reg_driver extends uvm_driver#(alsu_sequence_item);
`uvm_component_utils(alsu_reg_driver)
virtual ALSU_interface alsu_reg_vif;
alsu_sequence_item seq_item;
//shift_reg_config shift_cfg;
function new (string name ="alsu_reg_driver", uvm_component parent =null);
super.new(name,parent);
endfunction
task run_phase(uvm_phase phase);
super.run_phase(phase);
forever begin
  seq_item=alsu_sequence_item::type_id::create("seq_item");
  seq_item_port.get_next_item(seq_item);
alsu_reg_vif.rst     = seq_item.rst      ;
alsu_reg_vif.cin= seq_item.cin;
alsu_reg_vif.opcode= seq_item.opcode;
alsu_reg_vif.red_op_A     = seq_item.red_op_A  ; 
alsu_reg_vif.red_op_B   = seq_item.red_op_B ; 

alsu_reg_vif.bypass_A= seq_item.bypass_A;
alsu_reg_vif.bypass_B=seq_item.bypass_B;
alsu_reg_vif.direction     = seq_item.direction  ; 
alsu_reg_vif.serial_in   = seq_item.serial_in ; 
alsu_reg_vif.A   =seq_item.A ;
alsu_reg_vif.B   =seq_item.B;
@( negedge alsu_reg_vif.clk );
seq_item_port.item_done();
`uvm_info("runphase",seq_item.convert2string_stimulus(),UVM_HIGH)
end

endtask

endclass
endpackage