package shift_reg_driver_pkg;
//import shift_reg_config::*;
import shift_sequence_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class shift_reg_driver extends uvm_driver#(shift_sequence_item);
`uvm_component_utils(shift_reg_driver)
virtual shift_reg_if shift_reg_vif;
shift_sequence_item seq_item;
//shift_reg_config shift_cfg;
function new (string name ="shift_reg_driver", uvm_component parent =null);
super.new(name,parent);
endfunction
task run_phase(uvm_phase phase);
super.run_phase(phase);
forever begin
  seq_item=shift_sequence_item::type_id::create("seq_item");
  seq_item_port.get_next_item(seq_item);
shift_reg_vif.serial_in= seq_item.serial_in;
shift_reg_vif.direction= seq_item.direction;
shift_reg_vif.mode     = seq_item.mode    ; 
shift_reg_vif.datain   = seq_item.datain  ; 
#2;
seq_item_port.item_done();
`uvm_info("runphase",seq_item.convert2string_stimulus(),UVM_HIGH)
end

endtask

endclass
endpackage