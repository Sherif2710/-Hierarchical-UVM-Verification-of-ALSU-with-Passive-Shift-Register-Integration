package shift_sequencer_pkg;
import uvm_pkg::*;
import shift_sequence_item_pkg::*;
`include "uvm_macros.svh"
class  shift_sequencer extends  uvm_sequencer#(shift_sequence_item);
`uvm_component_utils(shift_sequencer)
function new (string name ="shift_sequencer", uvm_component parent =null);
super.new(name,parent);
endfunction
endclass
endpackage