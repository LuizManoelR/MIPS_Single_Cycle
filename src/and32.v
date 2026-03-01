/*====================================================
  Module: and32
  Description:
    Operação logica AND bit a bit com operandos de 32bits
 
   Inputs:
    
    A      : Operando 1
    B      : Operando 2
    Enable : Habilitador do output
  
   Outputs:
     out   : A & B
=======================================================*/


module and32( 

    input [31:0] A,
    input [31:0] B,

    input Enable,

    output [31:0] out

);

wire [31:0] out_int; // sinal interno junto do enable para habilitação do output

//instanciação dos modulos and
genvar i;

generate 


    for(i = 0; i < 32; i = i + 1)begin : enableand


        and (out_int[i], A[i], B[i]);

        and (out[i], out_int[i], Enable);


    end
endgenerate

endmodule