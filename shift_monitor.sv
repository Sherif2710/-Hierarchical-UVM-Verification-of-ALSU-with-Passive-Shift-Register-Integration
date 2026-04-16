package shift_reg_monitor_pkg;
import shift_sequence_item_pkg::*;
import shift_shared_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class shift_reg_monitor extends uvm_monitor;
`uvm_component_utils(shift_reg_monitor)
virtual shift_reg_if shift_reg_vif;
shift_sequence_item seq_item;
uvm_analysis_port #(shift_sequence_item)mon_ap;

function new (string name ="shift_reg_monitor", uvm_component parent =null);
super.new(name,parent);
endfunction
function void build_phase (uvm_phase phase );
  super.build_phase (phase);
  mon_ap = new ("mon_ap",this);
  endfunction
task run_phase(uvm_phase phase);
super.run_phase(phase);
forever begin 
      seq_item=shift_sequence_item::type_id::create("seq_item");
#2;
 seq_item.serial_in=shift_reg_vif.serial_in;
 seq_item.direction=direction_e'(shift_reg_vif.direction);
 seq_item.mode=mode_e'(shift_reg_vif.mode ) ;
 seq_item.datain=shift_reg_vif.datain     ;
  seq_item.dataout= shift_reg_vif.dataout;
  mon_ap.write(seq_item);
`uvm_info("runphase",seq_item.convert2string_stimulus(),UVM_HIGH)
end
endtask

endclass
endpackage