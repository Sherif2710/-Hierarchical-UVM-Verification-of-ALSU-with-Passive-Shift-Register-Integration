package alsu_reg_test_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import alsu_sequence_main_pkg::*;
import alsu_sequence_rst_pkg::*;
import shift_reg_env_pkg::*;
import alsu_reg_env_pkg::*;
import shift_reg_config::*;
import  alsu_reg_config_pkg ::*;
import alsu_shared_pkg::*;


class alsu_reg_test extends uvm_test;
`uvm_component_utils(alsu_reg_test)

alsu_reg_env env;
shift_reg_env env_shift;
alsu_reg_config alsu_cfg;
shift_reg_config shift_cfg;
alsu_sequence_reset seq1;
alsu_sequence_main seq2;
function new (string name ="alsu_reg_test", uvm_component parent =null);
super.new(name,parent);
endfunction
  // Build the enviornment in the build phase
  function void build_phase (uvm_phase phase );
  super.build_phase (phase);
  env =alsu_reg_env :: type_id:: create ("env",this);
  env_shift =shift_reg_env :: type_id:: create ("env2",this);
 alsu_cfg = alsu_reg_config :: type_id:: create ("alsu_cfg");
 shift_cfg = shift_reg_config :: type_id:: create ("shift_cfg");
  seq1= alsu_sequence_reset :: type_id:: create ("seq1");
  seq2= alsu_sequence_main :: type_id:: create ("seq2");
alsu_cfg.is_active     = UVM_ACTIVE;
shift_cfg.is_active = UVM_PASSIVE;
  //
  if (!uvm_config_db #(virtual ALSU_interface)::get(this,"","alsu_key",alsu_cfg.alsu_config_vif )) 
  `uvm_fatal("build_phase","failed");
  //
  uvm_config_db#(alsu_reg_config)::set(this,"*","CFG",alsu_cfg); //ha7ot al cofig object f al data base
      if (!uvm_config_db #(virtual shift_reg_if)::get(this,"","shift_key",shift_cfg.shift_reg_vif )) //get virtual interface wy7oto f al virtual bta3 al configuration object
  `uvm_fatal("build_phase","failed");

  uvm_config_db#(shift_reg_config)::set(this,"*","CFG2",shift_cfg); 
  endfunction
  //
   // Run sin the test in the run phase, raise objection, add #100 delay then display a message using `uvm_info, then drop the objection
task run_phase(uvm_phase phase);
super.run_phase(phase);
phase.raise_objection(this);
`uvm_info("run_phase","reset asserted",UVM_LOW)
seq1.start(env.agt.sqr); //reset sequence
`uvm_info("run_phase","reset deasserted",UVM_LOW)
//mainsequence
`uvm_info("run_phase","main started",UVM_LOW)
seq2.start(env.agt.sqr); //reset sequence
`uvm_info("run_phase","main finished",UVM_LOW)
phase.drop_objection(this);
endtask
endclass: alsu_reg_test
endpackage