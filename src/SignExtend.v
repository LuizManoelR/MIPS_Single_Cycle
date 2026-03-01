/*====================================================
  Module: SignExtend
  Description:
    Realiza a extensão de sinal de 16 bits para 32 bits.

    Utilizado em instruções do tipo imediato (I-type),
    como:
      - addi
      - lw
      - sw
      - beq
      - slti

    O bit mais significativo da entrada (in[15]) é
    replicado para os 16 bits mais altos da saída,
    preservando o sinal do número.
  
  Inputs:
    in  : valor imediato de 16 bits extraído da instrução

  Outputs:
    out : valor imediato estendido para 32 bits com sinal
=====================================================*/
module SignExtend(
    input [15:0] in,

    output [31:0] out

);

    assign out = {{16{in[15]}},in};

endmodule