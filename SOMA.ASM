global op_soma

section .text
op_soma:
    push ebp
    mov ebp, esp
    push ebx                ; Preserva ebx 
    
    ; Estrutura da Pilha:
    ; [ebp + 8]  -> precisao (Último a entrar)
    ; [ebp + 12] -> Num2     (Segundo a entrar)
    ; [ebp + 16] -> Num1     (Primeiro a entrar)

    mov ecx, [ebp + 8]      ; Recupera precisao
    cmp ecx, 1
    je .soma_32_bits

.soma_16_bits:
    mov eax, [ebp + 16]     
    mov ebx, [ebp + 12]     
    add ax, bx              ; Soma os 16 bits menos signi.
    movsx eax, ax           ; bota o sinal de AX pra EAX 
    jmp .fim

.soma_32_bits:
    mov eax, [ebp + 16]     
    add eax, [ebp + 12]     

.fim:
    pop ebx
    pop ebp
    ret