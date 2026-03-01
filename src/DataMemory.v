/*====================================================
  Module: DataMemory
  Description:
    Memória de dados do processador MIPS.
    Utilizada pelas instruções LW (load word)
    e SW (store word).

    - Escrita síncrona (na borda de subida do clock)
    - Leitura combinacional
    - Endereçamento por palavra (word-aligned)

  Inputs:
    clk       : Clock do sistema
    MemWrite  : Habilita escrita (SW)
    MemRead   : Habilita leitura (LW)
    adress    : Endereço gerado pela ALU
    WriteData : Dado a ser armazenado na memória

  Output:
    ReadData  : Dado lido da memória
=====================================================*/

module DataMemory (

    input clk,
    input MemWrite,
    input MemRead,
    input [31:0] adress,
    input [31:0] WriteData,

    output [31:0] ReadData


);

reg [31:0] memory [255:0];

integer i;
initial begin

    for(i = 0 ; i < 256; i = i + 1)begin 

        memory[i] = 32'b0;

    end
end

assign ReadData = (MemRead) ? memory[adress[9:2]] : 32'b0;

always @(posedge clk)begin 

    if (MemWrite)begin 

        memory[adress[9:2]] <= WriteData;

    end

end


endmodule