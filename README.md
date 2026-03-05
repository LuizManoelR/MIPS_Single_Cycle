# Processador MIPS de ciclo único

Implementação de um processador MIPS baseado na arquitetura de ciclo único, desenvolvido em Verilog.

O projeto integra datapath completo, unidade de controle e uma unidade de multiplicação `multu` implementada por meio de algoritmo sequencial shift-and-add.

- Arquitetura: Ciclo único com multiplicador multi-ciclo
- Linguagem: Verilog
- Simulação: Icarus Verilog + GTKWave


## Visão Geral

Na disciplina de Arquitetura de Computadores foi proposto o desenvolvimento de um modelo acadêmico de um processador MIPS de ciclo único.

<div align="center">

  <img width="600" alt="image" src="https://github.com/user-attachments/assets/337ade7a-98a2-4820-af5f-26e507c5409f" />

</div>

<br>

O projeto teve como base o datapath clássico apresentado na literatura, sendo necessário complementar os módulos ausentes e implementar integralmente a unidade de controle. Como demonstração de funcionamento, foi desenvolvido um programa em linguagem Assembly, utilizando Icarus Verilog para simulação e GTKWave para análise dos sinais.


O processador contempla o modelo clássico de ciclo único, no qual cada instrução é concluída em um único pulso de clock. Entre as instruções suportadas estão operações aritméticas do tipo R, instruções do tipo I, além de acesso à memória (lw e sw). A instrução lw foi implementada de forma totalmente combinacional, sendo concluída dentro de um único ciclo.

Como diferencial, a instrução multu foi implementada por meio de uma unidade sequencial baseada no algoritmo shift-and-add, utilizando registradores HI e LO para armazenamento do resultado.

Trata-se de um modelo acadêmico com finalidade didática, não contemplando técnicas como pipeline, cache ou execução fora de ordem.     

## Arquitetura do Processador

### As 5 etapas do Processador 

Embora o processador seja de ciclo único, o fluxo da instrução segue conceitualmente as cinco fases clássicas da arquitetura MIPS (IF, ID, EX, MEM e WB), todas executadas dentro de um único ciclo de clock.

1. **IF** (Instruction Fetch - Busca de Instrução):
   - O processador lê a instrução da memória de instruções usando o endereço contido no Program Counter (PC).
     
2. **ID** (Instruction Decode - Decodificação e Leitura de Registradores):
   - O processador identifica a operação a ser realizada e, simultaneamente, lê os conteúdos dos registradores de origem no banco de registradores.
     
3. **EX** (Execution - Execução ou Cálculo de Endereço):
   - A Unidade Lógica e Aritmética (ALU) opera sobre os dados lidos do banco de registradores ou sobre o valor imediato.
     
4. **MEM** (Memory Access - Acesso à Memória):
   - Etapa de acesso à memoria, podendo carregar ou armazenar dados em memoria.
     
5. **WB** (Write-Back - Escrita de Retorno):
   - O resultado final da operação (seja ele vindo da ALU ou da memória de dados) é escrito de volta no banco de registradores.
     
## Instruções Implementadas

### Tipo R
- add
- sub
- and
- or
- slt
- multu
- mfhi
- mflo

### Tipo I
- lw
- sw
- beq
- addi
- slti

### Tipo J
- j

## Sinais de Controle

- RegDst 

  - seleciona registrador destino (rd ou rt)

- ALUSrc
 
  - define se ALU usa registrador ou imediato

- MemtoReg 

  - define de qual fonte será a escrita do registrador

- RegWrite 
 
  - habilita escrita no banco de registradores

- MemRead 

  - leitura da memória

- MemWrite 

  - escrita na memória

- Branch 
 
   - habilita branch

- Jump 

   - habilita jump

- HiLoWrite

  - habilita escrita nos registradores Hi/Lo
 
- Start

  - inicia a multiplicação
 
- Reset_mult

  - reinicializa o modulo de multiplicação
 
- PcWrite

   - habiita a escrita no pc

- ALUOp

  - operação da ALU (controla o ALU Control

 <br>

| Instrução | RegDst | ALUSrc | MemtoReg | RegWrite | MemRead | MemWrite | Branch | Jump | ALUOp | PcWrite|
|:----------:|:--------:|:--------:|:----------:|:----------:|:---------:|:----------:|:--------:|:------:|:-------:|:--------:|
| R-type   |   1    |   0    |    00    |    1     |   0     |    0     |   0    |  0   | 10    |  1     |
| lw       |   0    |   1    |    01    |    1     |   1     |    0     |   0    |  0   | 00    |  1     |
| sw       |   X    |   1    |    XX    |    0     |   0     |    1     |   0    |  0   | 00    |  1     |
| beq      |   X    |   0    |    XX    |    0     |   0     |    0     |   1    |  0   | 01    |  1     |
| addi     |   0    |   1    |    00    |    1     |   0     |    0     |   0    |  0   | 00    |  1     |
| slti     |   0    |   1    |    00    |    1     |   0     |    0     |   0    |  0   | 11    |  1     |
| j        |   X    |   X    |    XX    |    0     |   0     |    0     |   0    |  1   | XX    |  1     |
| multu    |   X    |   0    |    XX    |    0     |   0     |    0     |   0    |  0   | 00    |  0     |
| mfhi     |   1    |   X    |    10    |    1     |   0     |    0     |   0    |  0   | XX    |  1     |
| mflo     |   1    |   X    |    11    |    1     |   0     |    0     |   0    |  0   | XX    |  1     |

 
## Fluxo de Execução
## Decisões de Projeto
## Programa Assembly

```assembly

addi $a0, $zero, 5
addi $t1,$zero, 1
add $t0, $zero, $a0
addi $t4, $zero, 1
j iteração


fatorial:
multu $t4, $t0
mflo $t4
sub $t0, $t0, $t1

j iteração

iteração:
slti $t2,$t0,2
beq $t2,$zero,fatorial

add $v0,$t4,$zero

```

| HEX       | BINÁRIO                                | opcode | rs    | rt    | rd    | shamt | funct  | Tipo | Instrução          |
|-----------|----------------------------------------|--------|-------|-------|-------|-------|--------|------|--------------------|
| 20040005  | 00100000000001000000000000000101       | 001000 | 00000 | 00100 | ----- | ----- | -----  | I    | addi $4,$0,5       |
| 20090001  | 00100000000010010000000000000001       | 001000 | 00000 | 01001 | ----- | ----- | -----  | I    | addi $9,$0,1       |
| 00044020  | 00000000000001000100000000100000       | 000000 | 00000 | 00100 | 01000 | 00000 | 100000 | R    | add  $8,$0,$4      |
| 200C0001  | 00100000000011000000000000000001       | 001000 | 00000 | 01100 | ----- | ----- | -----  | I    | addi $12,$0,1      |
| 08100009  | 00001000000100000000000000001001       | 000010 | ----- | ----- | ----- | ----- | -----  | J    | j 0x00400009       |
| 01880019  | 00000001100010000000000000011001       | 000000 | 01100 | 01000 | 00000 | 00000 | 011001 | R    | multu $12,$8       |
| 00006012  | 00000000000000000110000000010010       | 000000 | 00000 | 00000 | 01100 | 00000 | 010010 | R    | mflo $12           |
| 01094022  | 00000001000010010100000000100010       | 000000 | 01000 | 01001 | 01000 | 00000 | 100010 | R    | sub  $8,$8,$9      |
| 08100009  | 00001000000100000000000000001001       | 000010 | ----- | ----- | ----- | ----- | -----  | J    | j 0x00400009       |
| 290A0002  | 00101001000010100000000000000010       | 001010 | 01000 | 01010 | ----- | ----- | -----  | I    | slti $10,$8,2      |
| 1140FFFA  | 00010001010000001111111111111010       | 000100 | 01010 | 00000 | ----- | ----- | -----  | I    | beq  $10,$0,-6     |
| 01801020  | 00000001100000000100000000100000       | 000000 | 01100 | 00000 | 01000 | 00000 | 100000 | R    | add  $8,$12,$0     |
## Simulação e Validação
## Como Executar
