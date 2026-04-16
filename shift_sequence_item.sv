package shift_sequence_item_pkg;
import uvm_pkg::*;
import shift_shared_pkg::*;
`include "uvm_macros.svh"
class  shift_sequence_item extends uvm_sequence_item;
`uvm_object_utils(shift_sequence_item)
rand bit serial_in;
rand direction_e direction;
 rand mode_e mode;
rand bit[5:0] datain;
logic [5:0] dataout;
function new (string name ="shift_sequence_item");
super.new(name);
endfunction

function string convert2string();
return $sformatf("%s,serial_in=0b%0b,direction=%0s,mode=%0s,datain=0b%0b,dataout=0b%0b",super.convert2string(), serial_in, direction, mode,datain,dataout);
endfunction

function string convert2string_stimulus();
return $sformatf("serial_in=0b%0b,direction=%0s,mode=%0s,datain=0b%0b", serial_in, direction, mode,datain);
endfunction
endclass
endpackage















