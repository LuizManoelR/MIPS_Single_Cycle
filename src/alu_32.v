/*====================================================
  Module: alu_32
  Description:
    Responsável pela operação lógica ou aritimética
        ADD
        SUB
        AND
        OR
        NOR
        SLT
 
   Inputs:
    A                : Operando 1
    B                : Operando 2
    entrada_ctrl     : Código de controle da ALU (seleciona a operação)
  
   Outputs:
     Result          : Resultado da operação selecionada
     zero            : Flag ZERO: resultado == 0
     carry_out       : Flag CARRY (ADD/SUB)
     overflow        : Flag OVERFLOW (ADD/SUB)
=======================================================*/


module alu_32(

    // Entradas da ALU
    input [31:0] A,
    input [31:0] B,
    input [3:0] entrada_ctrl, 

    // Saídas da ALU
    output [31:0] result,   
    output zero,            
    output carry_out,       
    output overflow         

);

    // Sinais one-hot gerados pelo decodificador de controle
    // Cada bit habilita uma operação da ALU

    // Vetor de resultados intermediários das operações
    // out[0] = AND
    // out[1] = OR
    // out[2] = ADD
    // out[3] = SUB
    // out[4] = SLT
    // out[5] = NOR
    wire [5:0][31:0] out;

    wire [5:0] op_en;

    assign op_en[0] = (entrada_ctrl == 4'b0000); //and
    assign op_en[1] = (entrada_ctrl == 4'b0001);//or
    assign op_en[2] = (entrada_ctrl == 4'b0010);//add
    assign op_en[3] = (entrada_ctrl == 4'b0110);//sub
    assign op_en[4] = (entrada_ctrl == 4'b0111);//slt
    assign op_en[5] = (entrada_ctrl == 4'b1100);//nor

    // Carry e overflow separados para ADD (0) e SUB (1)
    wire [1:0] cout;
    wire [1:0] overf;


    // Operação AND
    and32 a(
        .A(A),
        .B(B),
        .Enable(op_en[0]),
        .out(out[0])
    );

    // Operação OR
    or32 o(
        .A(A),
        .B(B),
        .Enable(op_en[1]),
        .out(out[1])
    );

    // Operação ADD (soma)
    somador_32bits somador(
        .A(A),
        .B(B),
        .Cin(1'b0),
        .Enable(op_en[2]),
        .Sum(out[2]),
        .Cout(cout[0]),
        .Overflow(overf[0])
    );

    // Operação SUB (subtração)
    sub32 sub(
        .A(A),
        .B(B),
        .Enable(op_en[3]),
        .Sum(out[3]),
        .Cout(cout[1]),
        .Overflow(overf[1])
    );

    // Operação SLT (set less than)
    slt32 slt(
        .A(A),
        .B(B),
        .Enable(op_en[4]),
        .out(out[4])
    );

    // Operação NOR
    nor32 nor32(
        .A(A),
        .B(B),
        .Enable(op_en[5]),
        .out(out[5])
    );

    // Seleção correta do carry_out
    // Apenas ADD ou SUB podem gerar carry
    assign carry_out =
        op_en[2] ? cout[0] :
        op_en[3] ? cout[1] :
        1'b0;

    // Seleção correta do overflow
    // Apenas ADD ou SUB podem gerar overflow
    assign overflow =
        op_en[2] ? overf[0] :
        op_en[3] ? overf[1] :
        1'b0;

    // MUX final da ALU
    // Combina as saídas das operações habilitadas
    assign result =
        out[0] |
        out[1] |
        out[2] |
        out[3] |
        out[4] |
        out[5];

    // Flag ZERO
    // Ativada quando o resultado da ALU é igual a zero
    assign zero = (result == 32'b0);

endmodule
