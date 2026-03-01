/*====================================================
  Module: somador_32bits
  Description:
    Implementa um somador completo de 32 bits baseado
    em ripple-carry, utilizando 32 instâncias de
    full_adder de 1 bit.

    O módulo suporta:
      - Carry-in externo (Cin)
      - Carry-out (Cout)
      - Detecção de overflow aritmético
      - Sinal Enable para habilitar/desabilitar a saída

    Quando Enable = 0, todas as saídas são forçadas a 0.

  Inputs:
    A       : operando A (32 bits)
    B       : operando B (32 bits)
    Cin     : carry-in inicial (bit 0)
    Enable  : habilita a saída do somador

  Outputs:
    Sum      : resultado da soma A + B + Cin
    Cout     : carry-out do bit mais significativo
    Overflow : indica overflow aritmético com sinal
=====================================================*/

module somador_32bits(

    input [31:0] A,
    input [31:0] B,
    input Cin,
    input Enable,

    output [31:0] Sum,
    output Cout,
    output Overflow

);

wire [31:0] sum_int;
wire cout_int;
wire overflow_int;



assign overflow_int = (A[31] == B[31]) && (sum_int[31] != A[31]);

wire [31:0] C;

full_adder fa(

    .A(A[0]),
    .B(B[0]),
    .Cin(Cin),
    .Sum(sum_int[0]),
    .Cout(C[0])
);

genvar i;

generate

    for(i = 1; i < 32; i = i + 1) begin : full_adders


            full_adder fa(

                .A(A[i]),
                .B(B[i]),
                .Cin(C[i-1]),
                .Sum(sum_int[i]),
                .Cout(C[i])
            );

    end
    

endgenerate

assign cout_int = C[31];

assign Sum      = Enable ? sum_int      : 32'b0;
assign Cout     = Enable ? cout_int     : 1'b0;
assign Overflow = Enable ? overflow_int : 1'b0;

endmodule
