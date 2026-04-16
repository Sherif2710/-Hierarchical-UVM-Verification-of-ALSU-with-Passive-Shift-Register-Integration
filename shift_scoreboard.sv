package shift_scoreboard_pkg;
import shift_shared_pkg::*;
import shift_sequence_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class shift_scoreboard extends uvm_scoreboard;
`uvm_component_utils(shift_scoreboard)
uvm_analysis_export #(shift_sequence_item) sb_export;
uvm_tlm_analysis_fifo  #(shift_sequence_item) sb_fifo;
shift_sequence_item seq_item;
logic [5:0] dataout_golden;
int correct_count=0;
int error_count=0;
function new (string name ="shift_scoreboard", uvm_component parent =null);
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
golden(seq_item);
if(seq_item.dataout!=dataout_golden)begin
    `uvm_error("run_phase",$sformatf("failed,transaction recieved by dut:%s while the refrence out :0b%0b",seq_item.convert2string(),dataout_golden));
error_count++;
end
else begin
    `uvm_info("run_phase",$sformatf(" by dut:%s" ,seq_item.convert2string()),UVM_HIGH)
correct_count++;
end
end
endtask
task golden(shift_sequence_item data_seq);

   case (data_seq.mode)
   ROTATE: begin
   case(data_seq.direction) 
  LEFT:   dataout_golden= {data_seq.datain[4:0], data_seq.datain[5]};
        RIGHT: dataout_golden= {data_seq.datain[0], data_seq.datain[5:1]};
         endcase
   end

  SHIFT: begin 
    case(data_seq.direction)
  LEFT:
           dataout_golden= {data_seq.datain[4:0], data_seq.serial_in};
      RIGHT: dataout_golden={data_seq.serial_in, data_seq.datain[5:1]};
endcase
   end
   endcase
endtask
endclass
endpackage