# ==========================================
# Projeto: MIPS Single Cycle
# Simulador: Icarus Verilog + GTKWave
# ==========================================

# Ferramentas
IVERILOG = iverilog
VVP      = vvp
GTKWAVE  = gtkwave

# Arquivos
SRC = src/*.v
TB  = tb/tb_mips_single_cycle.v
GTKW = mips.gtkw

# Saídas
OUT = mips.out
VCD = mips.vcd


# Regra padrão
all: sim

# Compilação
compile:
	$(IVERILOG) -o $(OUT) $(SRC) $(TB)

# Simulação
sim: compile
	$(VVP) $(OUT)

# Abrir waveform
wave:
	$(GTKWAVE) $(VCD) $(GTKW)

# Limpeza
clean:
	rm -f $(OUT) $(VCD)
