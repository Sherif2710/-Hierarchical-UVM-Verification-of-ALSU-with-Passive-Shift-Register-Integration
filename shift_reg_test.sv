////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: UVM Example
// 
////////////////////////////////////////////////////////////////////////////////
package shift_reg_test_pkg;
import shift_sequence_main_pkg::*;
import shift_sequence_reset_pkg::*;
import shift_reg_env_pkg::*;
import shift_reg_config ::*;
import uvm_pkg::*;
`include "uvm_macros.svh"


class shift_reg_test extends uvm_test;
`uvm_component_utils(shift_reg_test)
  // Example 1
  // Do the essentials (factory register & Constructor)
shift_reg_env env;
shift_reg_config shift_cfg;
shift_sequence_reset seq1;
shift_sequence_main seq2;
function new (string name ="shift_reg_test", uvm_component parent =null);
super.new(name,parent);
endfunction
  // Build the enviornment in the build phase
  function void build_phase (uvm_phase phase );
  super.build_phase (phase);
  env =shift_reg_env :: type_id:: create ("env",this);
  shift_cfg = shift_reg_config :: type_id:: create ("shift_cfg");
  seq1= shift_sequence_reset :: type_id:: create ("seq1");
  seq2= shift_sequence_main :: type_id:: create ("seq2");
  //
  if (!uvm_config_db #(virtual shift_reg_if)::get(this,"","key_shift",shift_cfg.shift_reg_vif )) //get virtual interface wy7oto f al virtual bta3 al configuration object
  `uvm_fatal("build_phase","failed");
  //
  uvm_config_db#(shift_reg_config)::set(this,"*","CFG",shift_cfg); //ha7ot al cofig object f al data base
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
endclass: shift_reg_test
endpackage