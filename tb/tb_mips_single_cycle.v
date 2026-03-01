`timescale 1ns/1ps
/*====================================================
  Testbench: tb_mips_single_cycle
  Description:
    Testbench para o processador MIPS single-cycle.

    Responsabilidades:
      - Gerar sinal de clock
      - Gerar reset assíncrono
      - Instanciar o módulo mips_single_cycle
      - Gerar arquivo VCD para análise no GTKWave

    Clock:
      - Período: 2 ns (500 MHz)
      - Toggle a cada 1 ns

    Reset:
      - Ativo em nível alto
      - Aplicado no início da simulação
=====================================================*/

module tb_mips_single_cycle(); 

reg clk;
reg reset;


mips_sigle_cycle mips(

    .clk(clk),
    .reset(reset)

);

always #1 clk = ~clk;

initial begin
    $dumpfile("mips.vcd");
    $dumpvars();

    reset = 1;
    clk = 0;

    #1

    reset = 0;

    #1000 
    $finish;
end

endmodule