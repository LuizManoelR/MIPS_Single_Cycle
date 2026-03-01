/*====================================================
  Module: addPC
  Description:
    Somador do ProgramCounter
 
   Inputs:
    in        : pc atual
    signExtend: Imediato com o sinal extendido
    pcsrc     : Indica que houve um branch verdadeiro
  
   Outputs:
     out      : pc incrementado
=======================================================*/

module addPc(
    input wire [31:0] in,        
    input wire [31:0] signExtend,        
    input pcsrc,      
    output wire [31:0] out
);
        
assign out = (pcsrc) ? in + 32'd4 + (signExtend << 2) : in + 32'd4;     // Pcsrc = 1 : signextend é deslocado 2
                                                                        // bits a esquerda e somado pc + 4
                                                                    


endmodule