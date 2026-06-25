# Variáveis do Compilador e Linker
NASM = nasm
LD = ld
FLAGS_NASM = -f elf32
FLAGS_LD = -m elf_i386

# Nome do Executável Final
TARGET = montador_calc

# Objetos que serão ligados juntos
OBJS = CALCULADORA.o SOMA.o

all: $(TARGET)

$(TARGET): $(OBJS)
	$(LD) $(FLAGS_LD) $(OBJS) -o $(TARGET)

CALCULADORA.o: CALCULADORA.ASM
	$(NASM) $(FLAGS_NASM) CALCULADORA.ASM -o CALCULADORA.o

SOMA.o: SOMA.ASM
	$(NASM) $(FLAGS_NASM) SOMA.ASM -o SOMA.o

clean:
	rm -f *.o $(TARGET)