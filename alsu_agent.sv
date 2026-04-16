package alsu_reg_agent_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import alsu_reg_config_pkg::*;
import alsu_shared_pkg::*;
import alsu_sequence_item_pkg::*;
import  alsu_reg_monitor_pkg::*;
import alsu_reg_driver_pkg::*;
import alsu_sequencer_pkg::*;

class alsu_reg_agent extends uvm_agent;
`uvm_component_utils(alsu_reg_agent)
alsu_sequencer sqr; //driver b al sequence
alsu_reg_monitor mon;
alsu_reg_driver drv;
alsu_reg_config cfg;
uvm_analysis_port #(alsu_sequence_item)agt_ap;
function new (string name ="alsu_reg_agent", uvm_component parent =null);
super.new(name,parent);
endfunction
function void build_phase (uvm_phase phase );
  super.build_phase (phase);
   if (!uvm_config_db #(alsu_reg_config)::get(this,"","CFG",cfg ))
  `uvm_fatal("build_phase","failed");
   if (cfg.is_active==UVM_ACTIVE)begin
sqr=alsu_sequencer::type_id::create("sqr",this);
drv=alsu_reg_driver::type_id::create("drv",this);
end 

mon=alsu_reg_monitor::type_id::create("mon",this);
agt_ap=new("agt_ap",this);
endfunction
function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
if (cfg.is_active==UVM_ACTIVE)begin
drv.alsu_reg_vif=cfg.alsu_config_vif;  
drv.seq_item_port.connect(sqr.seq_item_export);
end 
mon.alsu_reg_vif=cfg.alsu_config_vif; 
mon.mon_ap.connect(agt_ap);                       //monitor/analysis port agent
endfunction

endclass
endpackage