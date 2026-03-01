/*====================================================
  Module: full_adder
  Description:
    Somador completo de 1 bit.

    Realiza a soma de dois bits (A e B) juntamente com
    o carry de entrada (Cin), produzindo:
      - Sum  : bit de soma
      - Cout : carry de saída

  Inputs:
    A   : Bit de entrada
    B   : Bit de entrada
    Cin : Carry de entrada

  Outputs:
    Sum  : Resultado da soma
    Cout : Carry de saída
=====================================================*/

module full_adder(

    // Entradas
    input A,
    input B,
    input Cin,

    // Saídas
    output Sum,
    output Cout
);

    // Sinais intermediários
    wire x1, x2, x3;

    // Soma
    xor (x1, A, B);
    xor (Sum, x1, Cin);

    // Carry
    and (x2, A, B);
    and (x3, x1, Cin);
    or  (Cout, x2, x3);

endmodule
