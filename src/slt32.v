 /*====================================================
  Module: slt32
  Description:
    Operação logica SLT com operandos de 32bits
 
   Inputs:
    
    A      : Operando 1
    B      : Operando 2
    Enable : Habilitador do output
  
   Outputs:
     out   : A < B
=======================================================*/

 
 module slt32(

    input signed [31:0] A,
    input signed [31:0] B,
    input Enable,   

    output [31:0] out



 );

 assign out = ((A < B) && Enable) ? 32'd1 : 32'd0;

 endmodule