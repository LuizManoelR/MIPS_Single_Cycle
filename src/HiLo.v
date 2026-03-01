/*====================================================
  Module: HiLo
  Description:
    Registradores especiais HI e LO do MIPS.

    Armazenam o resultado de operações de multiplicação:
      - HI recebe a parte mais significativa
      - LO recebe a parte menos significativa

    A escrita ocorre somente quando o sinal HiLoWrite
    está ativo, tipicamente após a conclusão do
    multiplicador.

    Reset zera ambos os registradores.

  Inputs:
    clk        : Clock do sistema
    reset      : Reset assíncrono
    A          : Valor a ser escrito em HI
    Q          : Valor a ser escrito em LO
    HiLoWrite  : Habilita escrita nos registradores HI/LO

  Outputs:
    hi : Conteúdo do registrador HI
    lo : Conteúdo do registrador LO
=====================================================*/

module HiLo(

    input clk,
    input reset,
    input [31:0] A,
    input [31:0] Q,
    input HiLoWrite,
    
    output [31:0]hi,
    output [31:0]lo

); 

    reg [31:0] hi_reg;
    reg [31:0] lo_reg;

    assign hi = hi_reg;
    assign lo = lo_reg;

    always @(posedge clk or posedge reset) begin

        if(reset)begin
            
            hi_reg <= 32'b0;
            lo_reg <= 32'b0;

        end else begin
            
            if (HiLoWrite)begin
                
            hi_reg <= A;
            lo_reg <= Q;

            end


        end
        
    end



endmodule