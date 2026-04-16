
module alsu_sva (ALSU_interface.sva alsu_if);
parameter INPUT_PRIORITY = "A";
parameter FULL_ADDER = "ON";
//active high asynchronus
    always_comb begin 
        if (alsu_if.rst) begin
            a_reset: assert final (alsu_if.out==0&&alsu_if.leds==0);
            a_cvr: cover final (alsu_if.out==0&&alsu_if.leds==0);
        end
    end

    ////Invalid handling
//assign invalid_red_op = (red_op_A_reg | red_op_B_reg) & !(opcode_reg==0 | opcode_reg==1); //2- red_op_A or red_op_B are set to high and the opcode is not OR or XOR operation means ! opcode =0 or !opcode=1

//by_passA&B
 property pass_A_B;
        @(posedge alsu_if.clk) disable iff(alsu_if.rst) (alsu_if.opcode!==6 &&alsu_if.opcode!==7 &&alsu_if.bypass_A && alsu_if.bypass_B&&INPUT_PRIORITY=="A"&& !alsu_if.red_op_A && !alsu_if.red_op_B) |-> ##2 ((alsu_if.out == $past(alsu_if.A,2)) && alsu_if.leds == 0);
    endproperty


//bypass_A
 property pass_A;
        @(posedge alsu_if.clk) disable iff(alsu_if.rst) (alsu_if.opcode!==6 &&alsu_if.opcode!==7 &&alsu_if.bypass_A && !alsu_if.bypass_B&& !alsu_if.red_op_A && !alsu_if.red_op_B) |-> ##2 ((alsu_if.out == $past(alsu_if.A,2)) && alsu_if.leds == 0);
    endproperty

//by_passB

 property pass_B;
        @(posedge alsu_if.clk) disable iff(alsu_if.rst) (alsu_if.opcode!==6 &&alsu_if.opcode!==7 &&!alsu_if.bypass_A && alsu_if.bypass_B&& !alsu_if.red_op_A && !alsu_if.red_op_B) |-> ##2 ((alsu_if.out == $past(alsu_if.B,2)) && alsu_if.leds == 0);
    endproperty

    property bitwise_or;
        @(posedge alsu_if.clk) disable iff(alsu_if.rst) (alsu_if.opcode==0 && !alsu_if.red_op_A && !alsu_if.red_op_B && !alsu_if.bypass_A && !alsu_if.bypass_B) |-> ##2 ((alsu_if.out == $past(alsu_if.A,2) | $past(alsu_if.B,2))  && alsu_if.leds == 0);
    endproperty


   property red_orA;
        @(posedge alsu_if.clk) disable iff(alsu_if.rst) (alsu_if.opcode==0 && alsu_if.red_op_A && !alsu_if.red_op_B && !alsu_if.bypass_A && !alsu_if.bypass_B) |-> ##2 ((alsu_if.out == |$past(alsu_if.A,2))  && alsu_if.leds == 0);
    endproperty

    property red_orB;
        @(posedge alsu_if.clk) disable iff(alsu_if.rst) (alsu_if.opcode==0 && !alsu_if.red_op_A && alsu_if.red_op_B && !alsu_if.bypass_A && !alsu_if.bypass_B) |-> ##2 ((alsu_if.out == |$past(alsu_if.B,2))  && alsu_if.leds == 0);
    endproperty

  property opp_add;

    @(posedge alsu_if.clk) disable iff (alsu_if.rst) (alsu_if.opcode == 2&&!alsu_if.bypass_A && !alsu_if.bypass_B && !alsu_if.red_op_A&&!alsu_if.red_op_B) |-> ##2 (alsu_if.out == {{3{$past(alsu_if.A[2],2)}}, $past(alsu_if.A,2)} + {{3{$past(alsu_if.B[2],2)}}, $past(alsu_if.B,2)} + $past(alsu_if.cin,2));
endproperty

    

    property bitwise_xor;
        @(posedge alsu_if.clk) disable iff(alsu_if.rst) (alsu_if.opcode==1 && !alsu_if.red_op_A && !alsu_if.red_op_B && !alsu_if.bypass_A && !alsu_if.bypass_B) |-> ##2 ((alsu_if.out == $past(alsu_if.A,2) ^ $past(alsu_if.B,2))  && alsu_if.leds == 0);
    endproperty
   property red_xorA;
        @(posedge alsu_if.clk) disable iff(alsu_if.rst) (alsu_if.opcode==1 && alsu_if.red_op_A && !alsu_if.red_op_B && !alsu_if.bypass_A && !alsu_if.bypass_B) |-> ##2 ((alsu_if.out == ^$past(alsu_if.A,2))  && alsu_if.leds == 0);
    endproperty
  property red_xorB;
        @(posedge alsu_if.clk) disable iff(alsu_if.rst) (alsu_if.opcode==1 && !alsu_if.red_op_A && alsu_if.red_op_B && !alsu_if.bypass_A && !alsu_if.bypass_B) |-> ##2 ((alsu_if.out == ^$past(alsu_if.B,2))  && alsu_if.leds == 0);
    endproperty

    property opp_mul;
        @(posedge alsu_if.clk) disable iff(alsu_if.rst) (alsu_if.opcode==3 && !alsu_if.bypass_A && !alsu_if.bypass_B&& !alsu_if.red_op_A && !alsu_if.red_op_B) |-> ##2 ((alsu_if.out == $past(alsu_if.A,2) * $past(alsu_if.B,2)) && alsu_if.leds == 0);
    endproperty


 //3'h4: begin        if (direction_reg)
         //     out <= {out[4:0], serial_in_reg};    else
        //      out <= {serial_in_reg, out[5:1]}; end
        //past 1 cycle ll output
       // past 2 cycle l input

    property shift1;
        @(posedge alsu_if.clk) disable iff(alsu_if.rst) (alsu_if.opcode==4 && alsu_if.direction &&!alsu_if.red_op_A && !alsu_if.red_op_B && !alsu_if.bypass_A && !alsu_if.bypass_B) |-> ##2 ((alsu_if.out == {$past(alsu_if.out[4:0],1),$past(alsu_if.serial_in,2)}) && alsu_if.leds == 0);
    endproperty

    property shift2;
        @(posedge alsu_if.clk) disable iff(alsu_if.rst) (alsu_if.opcode==4 && !alsu_if.direction && !alsu_if.red_op_A && !alsu_if.red_op_B && !alsu_if.bypass_A && !alsu_if.bypass_B) |-> ##2 ((alsu_if.out == {$past(alsu_if.serial_in,2),$past(alsu_if.out[5:1],1)}) && alsu_if.leds == 0);
    endproperty

//3'h5: begin  if (direction_reg) out <= {out[4:0], out[5]};
    property left;
        @(posedge alsu_if.clk) disable iff(alsu_if.rst) (alsu_if.opcode==5 && alsu_if.direction && !alsu_if.red_op_A && !alsu_if.red_op_B && !alsu_if.bypass_A && !alsu_if.bypass_B) |-> ##2 ((alsu_if.out == {$past(alsu_if.out[4:0],1),$past(alsu_if.out[5],1)}) && alsu_if.leds == 0);
    endproperty
//else  out <= {out[0], out[5:1]};end
property right; 
           @(posedge alsu_if.clk) disable iff(alsu_if.rst) (alsu_if.opcode==5 && !alsu_if.direction && !alsu_if.red_op_A && !alsu_if.red_op_B && !alsu_if.bypass_A && !alsu_if.bypass_B) |-> ##2 ((alsu_if.out == {$past(alsu_if.out[0],1),$past(alsu_if.out[5:1],1)}) && alsu_if.leds == 0);
    endproperty
/////////////////////


  property invalid;
    @ (posedge alsu_if.clk) disable iff (alsu_if.rst) (!alsu_if.bypass_A && !alsu_if.bypass_B && ((alsu_if.red_op_A || alsu_if.red_op_B) && (alsu_if.opcode[1] || alsu_if.opcode[2]) || (alsu_if.red_op_A || alsu_if.red_op_B) && (alsu_if.opcode!==0 && alsu_if.opcode!==1))) |-> ##2  (alsu_if.out == 0);
  endproperty






////////////
assert property (pass_A); 
cover  property (pass_A);
assert property (pass_B); 
cover  property (pass_B); 
assert property (bitwise_or); 
cover  property (bitwise_or); 
assert property (bitwise_xor); 
cover  property (bitwise_xor); 
assert property (red_orA); 
cover  property (red_orA);
assert property (red_xorA); 
cover  property (red_xorA);
assert property (red_orB); 
cover  property (red_orB);
assert property (red_xorB); 
cover  property (red_xorB);
 assert property (opp_mul); 
cover  property (opp_mul); 
assert property (shift1); 
cover  property (shift1); 
assert property (shift2); 
cover  property (shift2); 
assert property (right); 
cover  property (right); 
assert property (left); 
cover  property (left); 
assert property (pass_A_B); 
cover  property (pass_A_B); 
  assert property (invalid);
  cover property (invalid);

assert property (opp_add); 
cover  property (opp_add);


endmodule