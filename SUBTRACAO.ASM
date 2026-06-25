global op_subtracao

section .text
op_subtracao:
    push ebp
    mov ebp, esp
    push ebx

    ; Estrutura da Pilha:
    ; [ebp + 8]  -> precisao
    ; [ebp + 12] -> Num2
    ; [ebp + 16] -> Num1

    mov ecx, [ebp + 8]      ; Checa a precisao
    cmp ecx, 1
    je .sub_32_bits

.sub_16_bits:
    mov eax, [ebp + 16]     ; num1
    mov ebx, [ebp + 12]     ; num2
    sub ax, bx              ; realiza a subtracao em 16 bits
    movsx eax, ax           ; estende o sinal para o retorno
    jmp .fim

.sub_32_bits:
    mov eax, [ebp + 16]     ; num1
    sub eax, [ebp + 12]     ; num2 (eax = num1 - num2)

.fim:
    pop ebx
    pop ebp
    ret