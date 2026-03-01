/*====================================================
  Module: multiplicador
  Description:
    Implementa um multiplicador sequencial de 32 bits
    baseado no algoritmo clássico de soma e deslocamento
    (shift-and-add).

    O módulo opera por múltiplos ciclos de clock e utiliza
    uma máquina de estados finitos (FSM) para controlar
    cada etapa da multiplicação.

    Resultado:
      - A (registrador acumulador)        -> parte alta (HI)
      - Q (registrador do multiplicador)  -> parte baixa (LO)

    O sinal 'done' indica o término da multiplicação.

  Inputs:
    clk   : clock do sistema
    reset : reset assíncrono do multiplicador
    start : inicia a operação de multiplicação
    rs    : operando multiplicando (registrador rs)
    rt    : operando multiplicador (registrador rt)

  Outputs:
    a_out : parte alta do resultado da multiplicação (HI)
    q_out : parte baixa do resultado da multiplicação (LO)
    done  : indica que a multiplicação foi concluída
=====================================================*/
module multiplicador(

    input clk,
    input reset,
    input start,
    input [31:0] rs,
    input [31:0] rt,

    output [31:0] a_out,
    output [31:0] q_out,
    output reg done

);

reg [31:0] A;
reg [31:0] M;
reg [31:0] Q;
reg [4:0] Count;

localparam IDLE  =  3'b0  ;
localparam INIT  =  3'b001;
localparam CHECK =  3'b010;
localparam ADD   =  3'b011;
localparam SHIFT =  3'b100;
localparam DONE  =  3'b101;

reg [3:0] state;
reg [3:0] next_state;

assign a_out = A;
assign q_out = Q;


always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

always @(posedge clk or posedge reset) begin

    if(reset)begin 
        A <= 0;
        M <= 0;
        Q <= 0;
        Count <= 0;
        done <= 0;

    end else begin 

        case (state)
            INIT: begin 
                A <= 0;
                M <= rs;
                Q <= rt;
                Count <= 0;
                done <= 0;
            end
            ADD: begin 

                A <= A + M;

            end

            SHIFT: begin
            
            {A,Q} <= {A,Q} >> 1;
            Count <= Count + 1;
            end

            DONE: begin
                done <= 1;
            end
        endcase

    end


end

always @(*) begin

    next_state <= state;

    case (state)
        IDLE: begin
           if (start)begin
                next_state <= INIT;
           end 
        end
        INIT: begin
            next_state <= CHECK;
        end
        CHECK: begin
            next_state <= (Q[0]) ? ADD : SHIFT;
        end
        ADD: begin
            next_state <= SHIFT;
        end
        SHIFT: begin
            next_state <= (Count == 5'b11111) ? DONE : CHECK;
        end
    endcase
end




endmodule