/*====================================================
  Module: sub32
  Description:
    Implementa um subtrator de 32 bits utilizando
    complemento de dois.

    A subtração é realizada da forma:
        A - B = A + (~B) + 1

    O módulo reutiliza o somador_32bits, garantindo:
      - Carry-out
      - Detecção de overflow
      - Controle por sinal Enable

    Quando Enable = 0, as saídas são forçadas a zero.

  Inputs:
    A      : minuendo (32 bits)
    B      : subtraendo (32 bits)
    Enable : habilita a operação

  Outputs:
    Sum      : resultado da subtração A - B
    Cout     : carry-out do somador
    Overflow : indica overflow aritmético com sinal
=====================================================*/

module sub32(

    input [31:0] A,
    input [31:0] B,
    input Enable,

    output [31:0] Sum,
    output Cout,
    output Overflow

);


wire [31:0] B_mod = ~B;

somador_32bits somador(

    .A(A),
    .B(B_mod),
    .Cin(1'b1),
    .Enable(Enable),

    .Sum(Sum),
    .Cout(Cout),
    .Overflow(Overflow)


);


endmodule