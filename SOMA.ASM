global op_soma

section .text
op_soma:
    push ebp
    mov ebp, esp
    
    ; Estrutura da Pilha recebida:
    ; [ebp + 8]  -> Num1
    ; [ebp + 12] -> Num2
    ; [ebp + 16] -> Precisao (0 = 16-bits, 1 = 32-bits)

    mov ecx, [ebp + 16]     ; Lê o indicador de precisão
    cmp ecx, 1
    je .soma_32_bits

.soma_16_bits:
    ; Operação em 16 bits usando registradores parciais (AX, DX)
    mov ax, [ebp + 8]       ; Pega apenas os 16 bits inferiores de Num1
    add ax, [ebp + 12]      ; Soma com os 16 bits inferiores de Num2
    cwde                    ; Estende o sinal de AX para EAX (retorno padrão do roteiro)
    jmp .fim

.soma_32_bits:
    ; Operação nativa em 32 bits
    mov eax, [ebp + 8]
    add eax, [ebp + 12]

.fim:
    pop ebp
    ret