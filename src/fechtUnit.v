/*====================================================
  Module: fetchUnit
  Description:
    Unidade de busca de instruções (Instruction Fetch)
    do processador MIPS single-cycle.

    Responsável por:
    - Manter e atualizar o PC
    - Buscar a instrução na memória
    - Selecionar o próximo PC (PC+4, branch ou jump)
    - Suportar stall do PC (pcWrite)

  Inputs:
    clk        : Clock do sistema
    reset      : Reset do PC
    branch     : Indica instrução de branch
    zero_flag  : Flag ZERO da ALU (usada em BEQ)
    jump       : Indica instrução de jump
    pcWrite    : Habilita atualização do PC
    signExtend : Offset do branch (imediato estendido)

  Output:
    instruction: Instrução buscada na memória
=====================================================*/

module fetchUnit(
    input clk,
    input reset,
    input branch,
    input zero_flag,
    input jump,
    input pcWrite,
    input [31:0] signExtend, // entrada para o offset
    

    output [31:0] instruction

);
    wire [25:0] jump_index;

    assign jump_index = instruction[25:0];

    wire pcsrc;
    wire [31:0]jumpAddr;

    assign jumpAddr = {pc_incrementado[31:28] , (jump_index << 2)} ;
    
    assign pcsrc = (branch && zero_flag) ? 1'b1 : 1'b0;

    reg [31:0] pc;

    wire [31:0] pc_incrementado;

    addPc add (

        .in(pc),
        .signExtend(signExtend),
        .pcsrc(pcsrc),
        .out(pc_incrementado)


    );
    
    inst_memory memory(

        .adress(pc),
        .instruction(instruction)

    );

    
    always @(posedge clk or posedge reset) begin

        if(reset) begin
            pc <= 32'b0;
        end else begin 
            
        if (jump) begin
            
            pc <= jumpAddr;

        end else begin
            
            if(pcWrite)begin

                pc <= pc_incrementado;
                
            end

        end
        

        end
        
    end





endmodule