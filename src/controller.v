/*====================================================
  Module: controller
  Description:
    Unidade de controle do MIPS.
    Decodifica a instrução (Opcode/Funct) e gera os
    sinais de controle que coordenam o datapath.

  Inputs:
    Opcode : Define a classe da instrução
    funct  : Define a operação (apenas para R-type)

  Outputs:
    RegDst     : Seleciona registrador destino (rt ou rd)
    Branch     : Indica instrução de desvio condicional
    Jump       : Indica instrução de salto incondicional
    MemRead    : Habilita leitura da memória de dados
    MemtoReg   : Seleciona a fonte do WriteData
    ALUOp      : Código da operação para a ALU Control
    MemWrite   : Habilita escrita na memória de dados
    ALUSrc     : Seleciona a fonte do operando B da ALU
    RegWrite   : Habilita escrita no banco de registradores
    HiLoWrite  : Habilita escrita nos registradores HI/LO
=====================================================*/


module controller(

    input [5:0] Opcode,
    input [5:0] funct,

    output RegDst,
    output Branch,
    output Jump,
    output MemRead,
    output [1:0]MemtoReg,
    output [1:0] ALUOp,
    output MemWrite,
    output ALUSrc,
    output RegWrite,
    output HiLoWrite


); 

    //Parametros Opcode
    localparam OP_RTYPE = 6'b000000;
    localparam OP_ADDI  = 6'b001000;
    localparam OP_SLTI  = 6'b001010;
    localparam OP_BEQ   = 6'b000100;
    localparam OP_J     = 6'b000010;
    localparam OP_LW    = 6'b100011;
    localparam OP_SW    = 6'b101011;
    
    // Parametros Funct
    localparam FUNCT_MFHI  = 6'b010000;
    localparam FUNCT_MFLO  = 6'b010010;
    localparam FUNCT_MULT  = 6'b011000;
    localparam FUNCT_MULTU = 6'b011001;

//Codificação do ALUOp
// 00 -> SOMA(ADDI, LW, SW)
// 01 -> SUBTRAÇÂO(BEQ)
// 10 -> Rtype(usa funct)
// 11 -> SLTI(Set Less Than Imm)
    assign ALUOp = 
            (Opcode == OP_RTYPE) ? 2'b10: 
            (Opcode == OP_LW || Opcode == OP_SW || Opcode == OP_ADDI) ? 2'b00:
            (Opcode == OP_BEQ) ? 2'b01 :
            (Opcode == OP_SLTI) ? 2'b11 :
            2'b00;


    assign Jump = (Opcode == OP_J); 

    assign RegDst = (Opcode == OP_RTYPE);
    
    assign Branch = (Opcode == OP_BEQ);

    assign ALUSrc =   
            (Opcode == OP_SW || Opcode == OP_ADDI || Opcode == OP_LW ||Opcode == OP_SLTI);
   
// RegWrite ativo Para:
// -LW, ADDI, SLTI
// Rtype com exceção de Mult e Multu
    assign RegWrite = 
            (Opcode == OP_LW || 
            Opcode == OP_ADDI ||
            Opcode == OP_SLTI ||
            (Opcode == OP_RTYPE && 
            (funct != FUNCT_MULT && funct != FUNCT_MULTU)));
           

    
    assign MemRead  = (Opcode == OP_LW);

//Seleção da origem do WriteData
// 00 -> Resultado da ALU
// 01 -> Dado da memória
// 10 -> registrador hi (MFHI)
// 11 -> registrador lo (MFLO)
    assign MemtoReg = (Opcode == OP_LW) ? 2'b01:
                      (Opcode == OP_RTYPE && funct == FUNCT_MFHI) ? 2'b10:
                      (Opcode == OP_RTYPE && funct == FUNCT_MFLO) ? 2'b11: 
                       2'b0;

     assign HiLoWrite =   (Opcode == OP_RTYPE && (funct == FUNCT_MULT || funct == FUNCT_MULTU));

    assign MemWrite = (Opcode == OP_SW);
            




endmodule