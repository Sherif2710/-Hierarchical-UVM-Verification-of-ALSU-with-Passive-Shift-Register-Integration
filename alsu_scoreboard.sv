package alsu_scoreboard_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import alsu_shared_pkg::*;
import alsu_sequence_item_pkg::*;

class alsu_scoreboard extends uvm_scoreboard;
`uvm_component_utils(alsu_scoreboard)
uvm_analysis_export #(alsu_sequence_item) sb_export;
uvm_tlm_analysis_fifo  #(alsu_sequence_item) sb_fifo;
alsu_sequence_item seq_item;
int correct_count=0;
int error_count=0;
function new (string name ="alsu_scoreboard", uvm_component parent =null);
super.new(name,parent);
endfunction
function void build_phase (uvm_phase phase );
  super.build_phase (phase);
sb_export=new("sb_export",this);
sb_fifo=new("sb_fifo",this);
endfunction
//connectphase
function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
sb_export.connect(sb_fifo.analysis_export);   // 
endfunction
task run_phase(uvm_phase phase);
super.run_phase(phase);
forever begin
sb_fifo.get(seq_item); 
if(seq_item.out!=seq_item.out_gn||seq_item.leds!=seq_item.leds_gn)begin
    `uvm_error("run_phase",$sformatf("failed,transaction recieved by dut:%s while the refrence out :0b%0b and refrence led :0b%0b",seq_item.convert2string(),seq_item.out_gn,seq_item.leds_gn));
error_count++;
end
else begin
    `uvm_info("run_phase",$sformatf(" by dut:%s" ,seq_item.convert2string()),UVM_HIGH)
correct_count++;
end
end
endtask
endclass
endpackage