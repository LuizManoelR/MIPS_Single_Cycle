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

## Estrutura do Projeto

- **src/** – Implementação dos módulos do processador em Verilog (datapath, ALU, controle, memória e multiplicador).
- **tb/** – Testbench utilizado para simulação do processador.
- **instrucoes.hex** – Programa em formato hexadecimal carregado na memória de instruções.
- **Makefile** – Automatiza compilação e execução da simulação.
- **mips.gtkw** – Arquivo de configuração do GTKWave para visualização dos sinais.


```
MIPS_Single_Cycle/
│
├── instrucoes.hex
├── Makefile
├── mips.gtkw
├── README.md
│
├── src/
│   ├── addPc.v
│   ├── alu_32.v
│   ├── alu_ctrl.v
│   ├── and32.v
│   ├── controller.v
│   ├── DataMemory.v
│   ├── fechtUnit.v
│   ├── full_adder.v
│   ├── HiLo.v
│   ├── inst_memory.v
│   ├── mips_single_cycle.v
│   ├── multiplicador.v
│   ├── mult_ctrl.v
│   ├── nor32.v
│   ├── or32.v
│   ├── registradores.v
│   ├── SignExtend.v
│   ├── slt32.v
│   ├── somador_32bits.v
│   └── sub32.v
│
└── tb/
    └── tb_mips_single_cycle.v
```

## Arquitetura do Processador

### Datapath

<img width="2232" height="2180" alt="Diagrama" src="https://github.com/user-attachments/assets/ee957a45-7116-48cf-b6f4-d178809c5899" />

### Sinais de Controle

- RegDst 

  - Seleciona registrador destino (rd ou rt).

- ALUSrc
 
  - Define se ALU usa registrador ou imediato como segundo operando.

- MemtoReg 

  - Seleciona de qual fonte será o dado a ser escrito no registrador.

- RegWrite 
 
  - Habilita escrita no banco de registradores

- MemRead 

  - Habilita leitura da memória.

- MemWrite 

  - Habilita escrita em memória.

- Branch 
 
   - Habilita branch.

- Jump 

   - habilita Jump.

- HiLoWrite

  - Habilita escrita nos registradores Hi/Lo.
 
- Start

  - Inicia a multiplicação
 
- Reset_mult

  - Reinicializa o módulo de multiplicação.
 
- PcWrite

   - Habiita a escrita no registrador Program Counter.

- ALUOp

  - Indica para o `AluControl` qual operação deverá ser executada na `ALU` de acordo com a instrução buscada.
    

### Sinais de Estado

Como a instrução `multu` foi implementada por meio de uma unidade sequencial baseada no algoritmo **shift-and-add**, foi necessário implentar alguns sinais de estado em sua construção.

Diferentemente das demais instruções do processador, que são concluídas em um único ciclo, a multiplicação é realizada ao longo de múltiplos ciclos. Dessa forma, esses sinais permitem que a unidade de controle acompanhe o progresso da operação e saiba quando o resultado está disponível.

- **MultBusy**

  - Indica que a unidade de multiplicação está ocupada executando uma operação.

- **Done**

  - Indica que a operação de multiplicação foi finalizada.

### Estados da Multiplicação

A execução da multiplicação é controlada por uma pequena máquina de estados finitos (FSM), responsável por iniciar o cálculo, acompanhar sua execução e armazenar o resultado final.

 <br>
 
| Estado | PcWrite | MultReset | Start | HiLoWrite | MultBusy | Done | Descrição |
|:------:|:-------:|:---------:|:-----:|:---------:|:--------:|:----:|:-----------|
| Idle | 1 | 1 | 0 | 0 | 0 | 0 | Estado inicial. O módulo aguarda a execução da instrução `multu`. |
| Start | 0 | 0 | 1 | 0 | 1 | 0 | A multiplicação é iniciada e os operandos são carregados nos registradores internos. |
| Execute | 0 | 0 | 0 | 0 | 1 | 0 | O algoritmo de multiplicação é executado ao longo de vários ciclos. |
| Done | 1 | 0 | 0 | 1 | 0 | 1 | A multiplicação foi concluída e o resultado é escrito nos registradores **HI** e **LO**. |

 <br>
 
### Instruções Implementadas

 <br>

| Tipo | Instrução | Opcode | Funct | Descrição |
|:---:|:---:|:---:|:---:|:---|
| R | add | 000000 | 100000 | Soma o conteúdo de dois registradores (`rs + rt`) e armazena o resultado em `rd`. |
| R | sub | 000000 | 100010 | Subtrai o conteúdo de dois registradores (`rs - rt`) e armazena o resultado em `rd`. |
| R | and | 000000 | 100100 | Realiza a operação lógica AND bit a bit entre `rs` e `rt`. |
| R | or | 000000 | 100101 | Realiza a operação lógica OR bit a bit entre `rs` e `rt`. |
| R | slt | 000000 | 101010 | Compara `rs` e `rt`. Se `rs < rt`, grava `1` em `rd`; caso contrário grava `0`. |
| R | multu | 000000 | 011001 | Multiplica dois registradores sem sinal. O resultado de 64 bits é armazenado nos registradores `HI` e `LO`. |
| R | mfhi | 000000 | 010000 | Move o conteúdo do registrador especial `HI` para um registrador geral. |
| R | mflo | 000000 | 010010 | Move o conteúdo do registrador especial `LO` para um registrador geral. |
| I | lw | 100011 | — | Carrega uma palavra da memória (`Memory[rs + offset]`) para um registrador. |
| I | sw | 101011 | — | Armazena uma palavra de um registrador na memória (`Memory[rs + offset]`). |
| I | beq | 000100 | — | Realiza desvio se `rs` for igual a `rt`. |
| I | addi | 001000 | — | Soma um valor imediato ao registrador `rs` e armazena o resultado em `rt`. |
| I | slti | 001010 | — | Compara `rs` com um valor imediato. Se `rs` for menor, `rt` recebe `1`; caso contrário `0`. |
| J | j | 000010 | — | Realiza salto incondicional para um endereço de destino. |

 <br>

 ### Sinais de Controle por Instrução

A tabela a seguir apresenta a configuração dos principais sinais de controle gerados pela unidade de controle para cada instrução suportada pelo processador.

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
| multu    |   X    |   0    |    XX    |    0     |   0     |    0     |   0    |  0   | 10    |  0     |
| mfhi     |   1    |   X    |    10    |    1     |   0     |    0     |   0    |  0   | XX    |  1     |
| mflo     |   1    |   X    |    11    |    1     |   0     |    0     |   0    |  0   | XX    |  1     |

<br>

### Fluxo de Execução

Embora o processador seja de ciclo único, o fluxo da instrução segue conceitualmente as cinco fases clássicas da arquitetura MIPS (IF, ID, EX, MEM e WB), todas executadas dentro de um único ciclo de clock com exceção da instrução `multu`.

<br>

<img width="2232" height="2190" alt="digrama por etapas  url drawio" src="https://github.com/user-attachments/assets/bf8aff77-4367-4fba-8e1a-f59114a2146c" />


## Programa Assembly

Para validar o datapath completo do processador, foi desenvolvido um algoritmo em Assembly MIPS que calcula o fatorial de um número (ex: `5! = 120`). Este programa foi escolhido especificamente para estressar a arquitetura e testar os seguintes pontos:

* **Acesso à Memória:** Utiliza `lw` para buscar o valor inicial e `sw` para gravar o resultado, respeitando o alinhamento de 4 bytes.
* **Saltos e Desvios:** Valida o recálculo do PC através de saltos incondicionais (`j`) e ramificações condicionais (`beq`).
* **Sincronização (Stall):** Força o uso intensivo da instrução `multu` dentro de um laço de repetição, garantindo que a atualização do Program Counter seja inibida enquanto o cálculo de múltiplos ciclos é executado.

### Código Assembly
```assembly
# Inicialização e leitura da memória
lw   $a0, 4($zero)        # Carrega o valor base (N) do endereço 4
addi $t1, $zero, 1        # Constante de decremento (1)
add  $t0, $zero, $a0      # Cópia iterativa de N
addi $t4, $zero, 1        # Acumulador do fatorial
j iteração                # Inicia o laço

fatorial:
multu $t4, $t0            # Acumulador = Acumulador * N (Gera Stall no PC)
mflo $t4                  # Recupera o resultado de 32 bits do registrador LO
sub  $t0, $t0, $t1        # N = N - 1
j iteração                # Retorna ao laço

iteração:
slti $t2, $t0, 2          # Condição de parada: verifica se N < 2
beq  $t2, $zero, fatorial # Se N >= 2, continua multiplicando

# Finalização e escrita na memória
add  $v0, $t4, $zero      # Move o resultado final para o registrador de retorno
sw   $v0, 8($zero)        # Salva o resultado no endereço 8 da Memória de Dados

```

### Tradução para Hexdecimal/Binário
(A coluna Índice mapeia a instrução diretamente para a sua posição no array da Memória de Instruções).

| Índice | HEX      | BINÁRIO                          | opcode | rs    | rt    | rd    | shamt | funct  | imm (bin / dec)             | addr                       | Tipo | Instrução                      |
|:------:|----------|----------------------------------|:------:|:-----:|:-----:|:-----:|:-----:|:------:|:---------------------------:|:--------------------------:|:----:|--------------------------------|
| 0      | 8C040004 | 10001100000001000000000000000100 | 100011 | 00000 | 00100 | ----- | ----- | -----  | 0000000000000100&nbsp;(4)   | -------------------------- | I    | lw&nbsp;$4,&nbsp;4($0)         |
| 1      | 20090001 | 00100000000010010000000000000001 | 001000 | 00000 | 01001 | ----- | ----- | -----  | 0000000000000001&nbsp;(1)   | -------------------------- | I    | addi&nbsp;$9,&nbsp;$0,&nbsp;1  |
| 2      | 00044020 | 00000000000001000100000000100000 | 000000 | 00000 | 00100 | 01000 | 00000 | 100000 | -------------------------- | -------------------------- | R    | add&nbsp;$8,&nbsp;$0,&nbsp;$4  |
| 3      | 200C0001 | 00100000000011000000000000000001 | 001000 | 00000 | 01100 | ----- | ----- | -----  | 0000000000000001&nbsp;(1)   | -------------------------- | I    | addi&nbsp;$12,&nbsp;$0,&nbsp;1 |
| 4      | 08100009 | 00001000000100000000000000001001 | 000010 | ----- | ----- | ----- | ----- | -----  | -------------------------- | 00000100000000000000001001 | J    | j&nbsp;0x00400009              |
| 5      | 01880019 | 00000001100010000000000000011001 | 000000 | 01100 | 01000 | 00000 | 00000 | 011001 | -------------------------- | -------------------------- | R    | multu&nbsp;$12,&nbsp;$8        |
| 6      | 00006012 | 00000000000000000110000000010010 | 000000 | 00000 | 00000 | 01100 | 00000 | 010010 | -------------------------- | -------------------------- | R    | mflo&nbsp;$12                  |
| 7      | 01094022 | 00000001000010010100000000100010 | 000000 | 01000 | 01001 | 01000 | 00000 | 100010 | -------------------------- | -------------------------- | R    | sub&nbsp;$8,&nbsp;$8,&nbsp;$9  |
| 8      | 08100009 | 00001000000100000000000000001001 | 000010 | ----- | ----- | ----- | ----- | -----  | -------------------------- | 00000100000000000000001001 | J    | j&nbsp;0x00400009              |
| 9      | 290A0002 | 00101001000010100000000000000010 | 001010 | 01000 | 01010 | ----- | ----- | -----  | 0000000000000010&nbsp;(2)   | -------------------------- | I    | slti&nbsp;$10,&nbsp;$8,&nbsp;2 |
| 10     | 1140FFFA | 00010001010000001111111111111010 | 000100 | 01010 | 00000 | ----- | ----- | -----  | 1111111111111010&nbsp;(-6)  | -------------------------- | I    | beq&nbsp;$10,&nbsp;$0,&nbsp;-6 |
| 11     | 01801020 | 00000001100000000100000000100000 | 000000 | 01100 | 00000 | 00010 | 00000 | 100000 | -------------------------- | -------------------------- | R    | add&nbsp;$2,&nbsp;$12,&nbsp;$0 |
| 12     | AC020008 | 10101100000000100000000000001000 | 101011 | 00000 | 00010 | ----- | ----- | -----  | 0000000000001000&nbsp;(8)   | -------------------------- | I    | sw&nbsp;$2,&nbsp;8($0)       |


## Simulação e Validação

## Como Executar

### Requisitos

Antes de iniciar, certifique-se de ter as seguintes ferramentas instaladas no seu ambiente:
* **Icarus Verilog**: Compilar e simular.
* **GTKWave**: Visualizar as formas de onda (waveforms).
* **Makefile (Opcional)**: Utilitário para automação.

----

### Usando Icarus Verilog diretamente

1.  **Compilar**:  
    Execute o comando abaixo na raiz do projeto para gerar o executável:
    ```powershell
    iverilog -o mips.out src/*.v tb/tb_mips_single_cycle.v
    ```

2.  **Simular**:
    ```powershell
    vvp mips.out
    ```

3. **Visualizar Waveforms**:

    ```poweshell
    gtkwave mips.vcd mips.gtkw
    ```

---

### Usando Makefile (Recomendado)


1.  **Compilar e Simular**:
    ```powershell
    make
    ```

2.  **Visualizar Waveforms**:
    ```powershell
    make wave
    ```

3.  **Limpar arquivos**:
    ```powershell
    make clean
    ```

