package shift_reg_coverage_pkg;
import shift_shared_pkg::*;
import shift_sequence_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class shift_reg_coverage extends uvm_component;
`uvm_component_utils(shift_reg_coverage)
uvm_analysis_export #(shift_sequence_item) cov_export;
uvm_tlm_analysis_fifo  #(shift_sequence_item) cov_fifo;
shift_sequence_item seq_item;
//input clk, reset, serial_in, direction, mode;
//input [5:0] datain;
covergroup cvr_group;
//reset_cvr:coverpoint seq_item.reset; reset removed
serial_in_cvr:coverpoint seq_item.serial_in;
direction_cvr:coverpoint seq_item.direction;
mode_cvr:coverpoint seq_item.mode;
datain_cvr:coverpoint seq_item.datain;
endgroup

function new (string name ="shift_reg_coverage", uvm_component parent =null);
super.new(name,parent);
cvr_group=new;
endfunction
function void build_phase (uvm_phase phase );
  super.build_phase (phase);
cov_export=new("cov_export",this);
cov_fifo=new("cov_fifo",this);
endfunction
function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
cov_export.connect(cov_fifo.analysis_export);   // 
endfunction
task run_phase(uvm_phase phase);
super.run_phase(phase);
forever begin
    cov_fifo.get(seq_item);
    cvr_group.sample();

end
endtask
endclass
endpackage