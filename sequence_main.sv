package alsu_sequence_main_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import alsu_shared_pkg::*;
import alsu_sequence_item_pkg::*;

class  alsu_sequence_main extends  uvm_sequence#(alsu_sequence_item);
`uvm_object_utils(alsu_sequence_main)
alsu_sequence_item seq_item;
function new (string name ="alsu_sequence_main");
super.new(name);
endfunction
task body;
 opcode_e opcode;
   seq_item=alsu_sequence_item::type_id::create("seq_item");
 seq_item.EXTRA.constraint_mode(0);  //turning my extra constrain off
repeat(10000) begin
  seq_item=alsu_sequence_item::type_id::create("seq_item");
    start_item(seq_item);
    assert(seq_item.randomize());
    finish_item(seq_item);
end
  seq_item=alsu_sequence_item::type_id::create("seq_item");
 seq_item.EXTRA.constraint_mode(1); 
  opcode =opcode_e'(0) ;
            for (opcode = opcode_e'(0); opcode <=opcode_e'(5); opcode = opcode_e'(int'(opcode) + 1)) begin //casting&iterating through values of opcode
                seq_item = alsu_sequence_item::type_id::create("seq_item"); 
                seq_item.opcode.rand_mode(0);  
                start_item(seq_item);
                seq_item.opcode = opcode;
                assert(seq_item.randomize());//randomization
                finish_item(seq_item); 
end

endtask
endclass
endpackage