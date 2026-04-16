package shift_sequence_main_pkg;
import uvm_pkg::*;
import shift_shared_pkg::*;
import shift_sequence_item_pkg::*;
`include "uvm_macros.svh"
class  shift_sequence_main extends  uvm_sequence#(shift_sequence_item);
`uvm_object_utils(shift_sequence_main)
shift_sequence_item seq_item;
function new (string name ="shift_sequence_main");
super.new(name);
endfunction
task body;

repeat(10000) begin
    seq_item=shift_sequence_item::type_id::create("seq_item");
    start_item(seq_item);
    assert(seq_item.randomize());
    finish_item(seq_item);
end
endtask
endclass
endpackage