global op_divisao

section .text
op_divisao:
    push ebp
    mov ebp, esp
    push ebx

    ; Pilha: [ebp+8]=precisao, [ebp+12]=Num2, [ebp+16]=Num1
    mov ecx, [ebp + 8]
    cmp ecx, 1
    je .div_32_bits

.div_16_bits:
    mov eax, [ebp + 16]     ; num1
    mov ebx, [ebp + 12]     ; num2
    cwd                     ; Estende o sinal de AX para DX
    idiv bx                 ; AX = quociente DX = resto
    movsx eax, ax           
    jmp .fim

.div_32_bits:
    mov eax, [ebp + 16]     ; num1
    mov ebx, [ebp + 12]     ; num2
    cdq                     ; Estende o sinal de EAX p EDX:EAX 
    idiv ebx                ; EAX = quociente EDX = resto

.fim:
    pop ebx
    pop ebp
    ret