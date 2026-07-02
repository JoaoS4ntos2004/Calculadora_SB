# Calculadora Multi-Precisão IA-32

**Sistema Operacional Utilizado:** Linux (Ubuntu 22.04 LTS / i386 emulado)  
**Ferramentas:** NASM Compiler & GNU Gold Linker (ld)

## Como Compilar e Rodar

Para compilar todo o projeto automaticamente e gerar o único executável unificado, execute o comando na raiz da pasta:

```bash
make clean && make

./montador_calc

sudo apt update && sudo apt install nasm make gcc-multilib g++-multilib libc6-i386