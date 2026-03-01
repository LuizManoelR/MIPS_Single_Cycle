/*====================================================
  Module: mult_ctrl
  Description:
    Unidade de controle da multiplicação no MIPS.

    Implementa uma máquina de estados finitos (FSM)
    responsável por:
      - Detectar instruções MULT/MULTU (R-type)
      - Inicializar o multiplicador
      - Aguardar o término da operação
      - Sinalizar quando o multiplicador está ocupado
      - Gerar sinais de start e reset para o multiplicador

    Enquanto a multiplicação não termina, o processador
    deve ser travado (stall), indicado por mult_busy.

  Inputs:
    clk     : clock do sistema
    reset   : reset assíncrono do controlador
    ALUOp   : código da operação da ALU (define R-type)
    funct   : campo funct da instrução (define MULT/MULTU)
    done    : sinal do multiplicador indicando término

  Outputs:
    reset_mult : reseta o módulo multiplicador
    start      : inicia a operação de multiplicação
    mult_busy  : indica que a multiplicação está em andamento
=====================================================*/

module mult_ctrl(
    input clk,
    input reset,
    input [1:0] ALUOp,
    input [5:0] funct,
    input done,

    output reg reset_mult,
    output reg start,
    output mult_busy


); 

    localparam FUNCT_MULT  = 6'b011000;
    localparam FUNCT_MULTU = 6'b011001;

    localparam IDLE  =  2'b00 ;
    localparam INIT  =  2'b01;
    localparam WAIT  =  2'b10;
    localparam DONE  =  2'b11;

    reg [1:0] state;
    reg [1:0] next_state;
    wire is_mult;

    assign is_mult = (ALUOp == 2'b10 && funct == FUNCT_MULTU) ;

    assign mult_busy = (is_mult && ~done);

    always @(posedge clk or posedge reset) begin
        
        if(reset)begin
            state <= IDLE;
            next_state <= IDLE;
        end else begin
            state <= next_state;
        end

    end
    
    always @(posedge clk or posedge reset) begin

        if(reset)begin
            reset_mult <= 1'b1;
            start <= 0;
        end else begin
            
            case (state)
                IDLE: begin
                    reset_mult <= 1'b0;
                    if(is_mult)begin
                        start <= 1;
                    end else begin
                        start <= 1'b0;
                        
                    end
                end
                INIT: begin
                    start <= 1'b1;
                    reset_mult <= 0;
                end
                WAIT: begin
                    start <= 1'b0;
                    reset_mult <= 0;
                end
                DONE: begin
                    reset_mult <= 1'b1;
                    start <= 1'b0;
                end
            
            endcase
            
        end

        
    end

    always @(*) begin


        case (state)
            
            IDLE: begin
                next_state <= (is_mult) ? INIT : IDLE;
            end
            INIT: begin
                next_state <= WAIT;
            end
            WAIT: begin
                next_state <= (done)? DONE : WAIT;
            end
            DONE: begin
                next_state <= IDLE;
            end
            
        endcase
        
    end

endmodule