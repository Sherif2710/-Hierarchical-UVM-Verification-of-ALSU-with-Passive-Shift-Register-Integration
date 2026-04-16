package alsu_sequence_item_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import alsu_shared_pkg::*;
class  alsu_sequence_item extends uvm_sequence_item;
`uvm_object_utils(alsu_sequence_item)
 rand bit cin;   
 rand bit rst; 
   rand bit  red_op_A; 
 rand bit  red_op_B; 
 rand bit  bypass_A; 
 rand bit  bypass_B; 
  rand bit direction; 
 rand bit  serial_in; 
  rand opcode_e opcode; 
 rand bit signed [2:0] A; 
 rand bit signed [2:0] B; 
 // 
 rand opcode_e op_arr[6]; 
  logic [15:0] leds,leds_gn;
  logic signed [5:0] out,out_gn;

function new (string name ="alsu_sequence_item");
super.new(name);
endfunction
constraint RESET{rst_n dist{0:=10 ,1:=90};} //
 constraint A_B1 {
   if (opcode == ADD || opcode == MULT){A dist{MAXPOS :=30 ,ZERO:=30,MAXNEG:=30 ,[-3:2]:=10};B dist{MAXPOS :=30 ,ZERO:=30,MAXNEG:=30 ,[-3:2]:=10};}
} 
    constraint A_B2{
      if( (opcode == OR || opcode == XOR)&&(red_op_A && !red_op_B)){A dist{1 :=30 ,2 :=30 ,-4:=30,0:=2,3:=2,-1:=2,-2:=2,-3:=2};B dist{0:=100};}
      } 
 constraint A_B3{if( (opcode == OR || opcode == XOR)&&(red_op_B && !red_op_A)){B dist{1:=30 ,2 :=30 ,-4:=30,0:=2,3:=2,-1:=2,-2:=2,-3:=2};A dist{0:=100};}} 
 //000 0 // 001 1 // 010 2//   011  3 //111 -1//110 -2//101 -3//100 -4 
 constraint INVALID {opcode dist {[0:5] :=90,[6:7] :=10};} 
 constraint BYPASSA{bypass_A dist{1:=10 ,0:=90};} 
  constraint BYPASSB{bypass_B dist{1:=10 ,0:=90};} 
constraint EXTRA { 
    foreach (op_arr[i])  
op_arr[i] inside {OR, XOR, ADD, MULT, SHIFT, ROTATE}; 
    foreach (op_arr[i])  
      foreach (op_arr[j]) 
        if (i != j) op_arr[i] != op_arr[j];  
} 

function string convert2string();
return $sformatf("%s cin=0b%0b,rst=0b%0b,red_op_A=0b%0b,red_op_B=0b%0b,bypass_A=0b%0b,bypass_B=%0s,direction=%0b,serial_in=0b%0b,opcode=%0s,A=0b%0b,B=0b%0b,leds=0b%0b,out=0b%0b,leds_gn=0b%0b,out_gn=0b%0b",super.convert2string(),cin,rst,red_op_A,red_op_B,bypass_A,bypass_B,direction,serial_in, opcode, A,B,leds,out,leds_gn,out_gn);
endfunction

function string convert2string_stimulus();
return $sformatf("cin=0b%0b,rst=0b%0b,red_op_A=0b%0b,red_op_B=0b%0b,bypass_A=0b%0b,bypass_B=%0s,direction=%0s,serial_in=0b%0b,opcode=%0s,A=0b%0b,B=0b%0b",cin,rst,red_op_A,red_op_B,bypass_A,bypass_B,direction,serial_in, opcode, A,B);
endfunction
endclass
endpackage



