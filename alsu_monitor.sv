package alsu_reg_monitor_pkg;
import alsu_sequence_item_pkg::*;
import alsu_shared_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class alsu_reg_monitor extends uvm_monitor;
`uvm_component_utils(alsu_reg_monitor )
virtual ALSU_interface alsu_reg_vif;
alsu_sequence_item seq_item;
uvm_analysis_port #(alsu_sequence_item )mon_ap;

function new (string name ="alsu_reg_monitor", uvm_component parent =null);
super.new(name,parent);
endfunction
function void build_phase (uvm_phase phase );
  super.build_phase (phase);
  mon_ap = new ("mon_ap",this);
  endfunction
task run_phase(uvm_phase phase);
super.run_phase(phase);
forever begin 
      seq_item=alsu_sequence_item::type_id::create("seq_item");
@(negedge alsu_reg_vif.clk );
 seq_item.rst=alsu_reg_vif.rst ;
 seq_item.cin= alsu_reg_vif.cin;
seq_item.opcode=opcode_e'(alsu_reg_vif.opcode);
seq_item.red_op_A =alsu_reg_vif.red_op_A  ; 
 seq_item.red_op_B=alsu_reg_vif.red_op_B  ; 

seq_item.bypass_A=alsu_reg_vif.bypass_A;
seq_item.bypass_B=alsu_reg_vif.bypass_B;
 seq_item.direction=alsu_reg_vif.direction  ; 
 seq_item.serial_in=alsu_reg_vif.serial_in ; 
seq_item.A =alsu_reg_vif.A ;
seq_item.B=alsu_reg_vif.B;
seq_item.out=alsu_reg_vif.out;
seq_item.leds=alsu_reg_vif.leds;
seq_item.out_gn=alsu_reg_vif.out_gn;
seq_item.leds_gn=alsu_reg_vif.leds_gn;
  mon_ap.write(seq_item);
`uvm_info("runphase",seq_item.convert2string_stimulus(),UVM_HIGH)
end
endtask

endclass
endpackage