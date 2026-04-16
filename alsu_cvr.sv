package alsu_reg_coverage_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import alsu_shared_pkg::*;
import alsu_sequence_item_pkg::*;

class alsu_reg_coverage extends uvm_component;
`uvm_component_utils(alsu_reg_coverage)
uvm_analysis_export #(alsu_sequence_item) cov_export;
uvm_tlm_analysis_fifo  #(alsu_sequence_item) cov_fifo;
alsu_sequence_item seq_item;
 covergroup cvr_group; 
A_cp:coverpoint seq_item.A{ 
    bins A_data_0={ZERO}; 
     bins A_data_max={MAXPOS}; 
      bins A_data_min={MAXNEG}; 
       bins A_data_default=default; 
         bins A_data_walkingones[] ={3'b001, 3'b010, 3'b100}iff(seq_item.red_op_A); 
} 
 A_cp1:coverpoint  seq_item.A{ 
       bins A_data_default=default; 
         bins A_data_walkingones[] ={3'b001, 3'b010, 3'b100}iff( seq_item.red_op_A); 
}
   B_cp1:coverpoint seq_item.B{ 
       bins B_data_default=default; 
         bins B_data_walkingones[] ={3'b001, 3'b010, 3'b100}iff( seq_item.red_op_B&&! seq_item.red_op_A); 
}  
B_cp:coverpoint seq_item.B{ 
    bins B_data_0={ZERO}; 
     bins B_data_max={MAXPOS}; 
      bins B_data_min={MAXNEG}; 
       bins B_data_default=default; 
         bins B_data_walkingones[] ={3'b001, 3'b010, 3'b100}iff(seq_item.red_op_B&&!seq_item.red_op_A); 
} 
 ALU_cp: coverpoint seq_item.opcode{ 
bins Bins_shift[]={SHIFT,ROTATE}; 
bins not_or_xor[]= {ADD,MULT,SHIFT,ROTATE,INVALID_6,INVALID_7}; 
bins Bins_arith[] ={ADD,MULT}; 
bins Bins_bitwise[] ={OR,XOR}; 
illegal_bins Bins_invalid ={INVALID_6,INVALID_7}; 
bins Bins_trans =(OR=>XOR=>ADD=>MULT=>SHIFT=>ROTATE); 

 } 
  ALU_cp1: coverpoint seq_item.opcode{ 
    bins Bins_arith[] ={ADD,MULT}; 
  } 
  //add_for_crossing 
    add: coverpoint seq_item.opcode{ 
    bins addd ={ADD}; 
  } 
//shift_for_crossing 
    shiftinggggg: coverpoint seq_item.opcode{ 
    bins shiftt ={SHIFT}; 
  } 
 
c_in: coverpoint seq_item.cin{ 
bins cinn={1'b0,1'b1} ; 
} 
 
dir: coverpoint seq_item.direction{ 
bins direc={1'b0,1'b1} ; 
} 
shift: coverpoint seq_item.serial_in{ 
bins shifting={1'b0,1'b1} ; 
} 
//redop A 
redopa: coverpoint seq_item.red_op_A{ 
bins redA= {1'b1}; 
} 
//redop B 
redopb: coverpoint seq_item.red_op_B{ 
bins redB= {1'b1}; 
} 

 cross2 : cross add , c_in { bins add_cin = (binsof (c_in.cinn)&&binsof (add.addd)); 
 } 
//3. When the ALSU is shifting or rotating, then direction must take 0 or 1  
cross3 : cross ALU_cp , dir { 
  option.cross_auto_bin_max = 0; 
bins cross33 = (binsof (dir.direc)&&binsof (ALU_cp.Bins_shift)); 
} 
//4. When the ALSU is shifting, then shift_in must take 0 or 1  
cross4:cross shift , shiftinggggg{ 
  option.cross_auto_bin_max = 0; 
bins cross44 = (binsof (shift.shifting)&&binsof (shiftinggggg.shiftt)); 
 
} 
//5. When the ALSU is OR or XOR and red_op_A is asserted, then A took all walking one 
//patterns (001, 010, and 100) while B is taking the value 0  
cross5: cross A_cp1 , redopa, ALU_cp , B_cp { 
  option.cross_auto_bin_max = 0; 
  bins cross55 =(binsof( ALU_cp.Bins_bitwise)&&binsof(redopa.redA)&&binsof(A_cp1.A_data_walkingones)&&binsof( B_cp.B_data_0));  
} 
//6. When the ALSU is OR or XOR and red_op_B is asserted, then B took all walking one 
//patterns (001, 010, and 100) while A is taking the value 0  
cross6: cross B_cp1 ,redopb,  ALU_cp , A_cp{ 
  option.cross_auto_bin_max = 0; 
bins cross66 =(binsof( 
ALU_cp.Bins_bitwise)&&binsof(redopb.redB)&&binsof(B_cp1.B_data_walkingones)&&binsof( A_cp.A_data_0))iff(seq_item.red_op_B);  
} 
//7. Covering the invalid case: reduction operation is activated while the opcode is 
//not OR or XOR 
cross7: cross redopa ,redopb , ALU_cp{ 
option.cross_auto_bin_max = 0; 
bins cross_invalid1 = (binsof( ALU_cp.not_or_xor)&&binsof(redopa.redA)); 
bins cross_invalid2 =  (binsof( ALU_cp.not_or_xor)&&binsof(redopb.redB)); 
} 


endgroup

function new (string name ="alsu_reg_coverage", uvm_component parent =null);
super.new(name,parent);
cvr_group=new();
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