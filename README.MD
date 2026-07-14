TRABALHO 2 - SOFTWARE BÁSICO (CALCULADORA IA-32)

SISTEMA OPERACIONAL UTILIZADO:
Linux (Ubuntu via WSL)

REQUISITOS E INSTALAÇÃO:
Para que o ambiente possua o montador e as bibliotecas de 32 bits necessárias,
execute o seguinte comando no terminal antes de compilar:

    sudo apt update && sudo apt install nasm make gcc-multilib g++-multilib libc6-i386

COMO COMPILAR E GERAR O EXECUTÁVEL:
Para compilar todos os módulos e ligar o binário final, execute:

    make clean && make

COMO EXECUTAR O PROGRAMA:
Após a compilação, o binário "montador_calc" será gerado. Inicie-o com:

    ./montador_calc

COMO UTILIZAR E EXEMPLO DE TESTE:
1. Digite seu nome e escolha a precisão:
   - "0" para trabalhar em 16 bits 
   - "1" para trabalhar em 32 bits
2. Selecione a operação no menu e insira os dois números.
3. O resultado será exibido. Pressione ENTER para retornar ao menu.

OBSERVAÇÃO:
Nas operações de MULTIPLICAÇÃO e EXPONENCIACAO, caso o resultado ultrapasse o limite da precisão escolhida (16 ou 32 bits), o programa exibirá "OCORREU OVERFLOW." e será encerrado imediatamente, conforme especificado no roteiro.

INTEGRANTES DO GRUPO:
- João Pedro Fernandes Santos - 222025342
