package alsu_shared_pkg;
parameter MAXPOS =3 ; 
parameter MAXNEG =-4 ; 
parameter ZERO =0 ; 
parameter INPUT_PRIORITY = "A"; 
parameter FULL_ADDER = "ON"; 
typedef enum logic [2:0] {OR,XOR,ADD,MULT,SHIFT,ROTATE,INVALID_6,INVALID_7} opcode_e; 

endpackage