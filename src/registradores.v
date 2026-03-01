/*====================================================
  Module: registradores
  Description:
    Banco de registradores do processador MIPS.

    Implementa 32 registradores de 32 bits:
      - Dois ports de leitura (combinacionais)
      - Um port de escrita (síncrono com o clock)

    O registrador 0 ($zero) é fixo em zero e
    nunca pode ser sobrescrito.

  Input:
    readRegister1 : endereço do primeiro registrador de leitura
    readRegister2 : endereço do segundo registrador de leitura
    WriteRegister : endereço do registrador de escrita
    WriteData     : dado a ser escrito
    RegWrite      : habilita escrita no banco
  output:
    ReadData1     : dado lido do registrador 1
    ReadData2     : dado lido do registrador 2
=====================================================*/
module registradores (

    input clk,
    input [4:0] readRegister1, // endereço do registrador 1 para leitura
    input [4:0] readRegister2 ,// endereço do registrador 2 para leitura
    input [4:0] WriteRegister, // endereço do registrador para escritra
    input [31:0] WriteData, // Dados a serem escritos
    input Regwrite, // Habilitador de escrita
    
    output [31:0] ReadData1,
    output [31:0] ReadData2


);

    reg [31:0] registradores [31:0]; //32 registradores de 32 bits

    //Inicialização dos registradores para simulação
    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1)begin

            registradores[i] = 32'b0;

        end
    end


    // Leitura dos registradores
    assign ReadData1 = registradores[readRegister1];
    assign ReadData2 = registradores[readRegister2];


    //Habilitação da escrita caso RegWrite = 1 e o enderço seja diferente de zero
    always @(posedge clk) begin
        
        if(Regwrite && WriteRegister != 5'b0)begin

            registradores[WriteRegister] <= WriteData;

        end 

    end


endmodule