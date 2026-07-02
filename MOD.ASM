global op_mod

section .text
op_mod:
    push ebp
    mov ebp, esp
    push ebx

    ; Pilha: [ebp+8]=precisao, [ebp+12]=Num2, [ebp+16]=Num1
    mov ecx, [ebp + 8]
    cmp ecx, 1
    je .mod_32_bits

.mod_16_bits:
    mov eax, [ebp + 16]     ; num1
    mov ebx, [ebp + 12]     ; num2
    cwd                     ; Estende AX para DX
    idiv bx                 ; AX = quociente DX = resto
    mov ax, dx              ; Move o resto (DX) para AX para o retorno
    movsx eax, ax           ; Estende o sinal para EAX
    jmp .fim

.mod_32_bits:
    mov eax, [ebp + 16]     ; num1
    mov ebx, [ebp + 12]     ; num2
    cdq                     ; Estende EAX para EDX:EAX
    idiv ebx                ; EAX = quociente EDX = resto
    mov eax, edx            ; Move o resto (EDX) para EAX para o retorno

.fim:
    pop ebx
    pop ebp
    ret