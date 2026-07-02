global op_multiplicacao
extern msg_overflow     
extern print_string
extern len_overflow

section .text
op_multiplicacao:
    push ebp
    mov ebp, esp
    push ebx

    ; Pilha: [ebp+8]=precisao, [ebp+12]=Num2, [ebp+16]=Num1
    mov ecx, [ebp + 8]
    cmp ecx, 1
    je .mult_32_bits

.mult_16_bits:
    mov eax, [ebp + 16]     ; num1
    mov ebx, [ebp + 12]     ; num2
    imul ax, bx             ; ax = ax * bx
    jo .erro_overflow       ; Desvia se o resultado estourar 16 bits
    movsx eax, ax           ; Estende sinal
    jmp .fim

.mult_32_bits:
    mov eax, [ebp + 16]     ; num1
    mov ebx, [ebp + 12]     ; num2
    imul eax, ebx           ; eax = eax * ebx
    jo .erro_overflow       ; Desvia se o resultado estourar 32 bits
    jmp .fim

.erro_overflow:
    ; Exibe a mensagem de overflow e encerra 
    push dword [len_overflow]
    push dword msg_overflow
    call print_string
    add esp, 8

    ; Syscall d saida
    mov eax, 1
    mov ebx, 1              ; Status de erro
    int 0x80

.fim:
    pop ebx
    pop ebp
    ret