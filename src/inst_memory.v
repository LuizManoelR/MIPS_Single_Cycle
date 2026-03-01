/*====================================================
  Module: inst_memory
  Description:
    Memória de instruções do processador MIPS.

    Armazena até 256 instruções de 32 bits, carregadas
    a partir de um arquivo hexadecimal (.hex) durante
    a simulação.

    A memória é somente leitura durante a execução

    O endereço de entrada é o PC, sendo alinhado
    por palavra (PC[9:2]) para indexar a memória.

  Inputs:
    adress : Endereço do PC 

  Outputs:
    instruction : Instrução de 32 bits lida da memória
=====================================================*/
module inst_memory (

input [31:0] adress, // endereço do pc

output [31:0] instruction // instrução 


);

reg [31:0] memory [0:255]; // 256 memorias de 32 bits

// inicializando valores na memoria a partir de um arquivo .hex 
integer i;
initial begin
    
    for(i = 0; i < 256; i = i + 1)
        memory[i] = 32'b0;
        
    $readmemh("instrucoes.hex", memory);

end


// Instrução que foi buscada em memoria alinhada com o pc
assign instruction = memory[adress[9:2]];



endmodule