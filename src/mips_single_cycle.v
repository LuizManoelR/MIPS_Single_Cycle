/*====================================================
  Module: mips_single_cycle
  Description:
    Implementação de um processador MIPS de ciclo único
    com suporte às seguintes instruções:

      - Tipo R: add, sub, and, or, nor, slt
      - Tipo I: addi, slti, lw, sw, beq
      - Tipo J: j
      - Multiplicação: mult, multu, mfhi, mflo

    O processador segue a arquitetura clássica do MIPS,
    integrando os seguintes blocos:
      - Instruction Memory
      - Register File
      - ALU + ALU Control
      - Data Memory
      - Unidade de Controle
      - Unidade de Fetch (PC, branch e jump)
      - Unidade de multiplicação com controle de busy
      - Registradores HI e LO

    A multiplicação é multi-ciclo e gera stall no PC
    enquanto o multiplicador está ocupado.

  Inputs:
    clk   : Clock do sistema
    reset : Reset global do processador
=====================================================*/


module mips_sigle_cycle (

    input clk,
    input reset


); 

// =======================
// Sinais de instrução e PC
// =======================
    wire [31:0] instruction;
    wire zero_flag;
    wire [31:0] signExtend;

// =======================
// Sinais da unidade de controle
// =======================
    wire RegDst;
    wire Branch;
    wire Jump;
    wire MemRead;
    wire [1:0]MemtoReg;
    wire [1:0] ALUOp;
    wire MemWrite;
    wire ALUSrc;
    wire RegWrite;
    wire HiLoWrite;

// =================================================
// Dados do Banco de Registradores
// ===============================================
    wire [31:0] ReadData1;
    wire [31:0] ReadData2;
    wire [31:0] ReadDataMemory;

// =================================================
// Controle e saídas da ALU
// =================================================
    wire [3:0] entrada_ctrl;
    wire [31:0] result;   // Resultado da operação selecionada          
    wire carry_out;       // Flag CARRY (ADD/SUB)
    wire overflow;  
// =================================================
// Sinais da Unidade de Multiplicação
// =================================================
    wire [31:0] A;
    wire [31:0] Q;
    wire done; 

    wire reset_mult;
    wire start;
    wire mult_busy;

    wire [31:0] hi;

    wire [31:0] lo;
 
// =================================================
// Unidade de Controle Principal
// =================================================
    controller controller(

    .Opcode(instruction[31:26]),
    .funct(instruction[5:0]),

    .RegDst(RegDst),
    .Branch(Branch),
    .Jump(Jump),
    .MemRead(MemRead),
    .MemtoReg(MemtoReg),
    .ALUOp(ALUOp),
    .MemWrite(MemWrite),
    .ALUSrc(ALUSrc),
    .RegWrite(RegWrite),
    .HiLoWrite(HiLoWrite)

    );
// =================================================
// Controle da ALU
// =================================================
    alu_ctrl alu_ctrl(

    .aluOp(ALUOp),
    .funct(instruction[5:0]),

    .entrada_ctrl(entrada_ctrl)
    );
// =================================================
// Unidade de Fetch (PC + Instruction Memory)
// =================================================
// O PC é travado quando o multiplicador está ocupado
    fetchUnit fetch(

    .clk(clk),
    .reset(reset),
    .branch(Branch),
    .zero_flag(zero_flag),
    .jump(Jump),
    .pcWrite(~mult_busy),
    .signExtend(signExtend), 

    .instruction(instruction)



    );
// =================================================
// Extensão de sinal do imediato
// =================================================
    SignExtend signExtend_inst(

        .in(instruction[15:0]),

        .out(signExtend)

    );

// =================================================
// Banco de Registradores
// =================================================
    registradores registradores(
    .clk(clk),
    .readRegister1(instruction[25:21]), // endereço do registrador 1 para leitura
    .readRegister2(instruction[20:16]) ,// endereço do registrador 2 para leitura
    .WriteRegister((RegDst)? instruction[15:11]:instruction[20:16]), // endereço do registrador para escritra
    .WriteData( 

        (MemtoReg == 2'b01) ? ReadDataMemory:
        (MemtoReg == 2'b10) ? hi:
        (MemtoReg == 2'b11) ? lo:
        result
    ), // Dados a serem escritos
    .Regwrite(RegWrite), // Habilitador de escrita
    
    .ReadData1(ReadData1),
    .ReadData2(ReadData2)

    );
// =================================================
// ALU
// =================================================
    alu_32 alu(

        
    // Operandos de entrada (32 bits)
    .A(ReadData1),
    .B((ALUSrc) ? signExtend : ReadData2),

    // Código de controle da ALU (seleciona a operação)
    .entrada_ctrl(entrada_ctrl), 

    // Saídas da ALU
    .result(result),   // Resultado da operação selecionada
    .zero(zero_flag),            // Flag ZERO: resultado == 0
    .carry_out(carry_out),       // Flag CARRY (ADD/SUB)
    .overflow(overflow)         // Flag OVERFLOW (ADD/SUB)

    );
// =================================================
// Controle da Multiplicação
// =================================================
    mult_ctrl mult_ctrl(

    .clk(clk),
    .reset(reset),
    .ALUOp(ALUOp),
    .funct(instruction[5:0]),
    .done(done),

    .reset_mult(reset_mult),
    .start(start),
    .mult_busy(mult_busy)

    );
// =================================================
// Unidade de Multiplicação
// =================================================
    multiplicador multiplicador(

    .clk(clk),
    .reset(reset_mult),
    .start(start),
    .rs(ReadData1),
    .rt(ReadData2),

    .a_out(A),
    .q_out(Q),
    .done(done)

    );
// =================================================
// Registradores HI e LO
// =================================================
    HiLo hilo(

    .clk(clk),
    .reset(reset),
    .A(A),
    .Q(Q),
    .HiLoWrite((HiLoWrite && (~mult_busy))),
    
    .hi(hi),
    .lo(lo)

    );

// =================================================
// Memória de Dados
// =================================================  
DataMemory dataMemory(

    .clk(clk),
    .MemWrite(MemWrite),
    .MemRead(MemRead),
    .adress(result),
    .WriteData(ReadData2),

    .ReadData(ReadDataMemory)

);





endmodule


