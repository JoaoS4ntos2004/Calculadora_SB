global op_exponenciacao
extern msg_overflow
extern print_string
extern len_overflow

section .text
op_exponenciacao:
    push ebp
    mov ebp, esp
    push ebx
    push esi

    ; Pilha: [ebp+8]=precisao, [ebp+12]=Num2 (Expoente), [ebp+16]=Num1 (Base)
    mov ecx, [ebp + 12]     ; ECX é contador do loop (expoente)
    mov esi, [ebp + 16]     ; ESI guarda a base constante
    
    ; qalquer n elevado a 0 é 1
    cmp ecx, 0
    jne .checa_precisao
    mov eax, 1
    jmp .fim

.checa_precisao:
    mov edx, [ebp + 8]      ; Checa a precisao
    cmp edx, 1
    je .exp_32_bits

.exp_16_bits:
    mov eax, esi            ; Começa com o valor da base em AX
    dec ecx                 ; Como ja começamos com a base, diminui 1 iteração
    cmp ecx, 0
    jle .fim_16

.loop_exp_16:
    imul ax, si             ; Multiplica o acumulador pela base
    jo .erro_overflow       ; Valida overflow
    loop .loop_exp_16

.fim_16:
    movsx eax, ax           ; Ajusta retorno
    jmp .fim

.exp_32_bits:
    mov eax, esi            ; Começa com o valor da base em EAX
    dec ecx
    cmp ecx, 0
    jle .fim

.loop_exp_32:
    imul eax, esi           ; Multiplica acumulador de 32 bits pela base
    jo .erro_overflow       ; Valida overflow
    loop .loop_exp_32
    jmp .fim

.erro_overflow:
    push dword [len_overflow]
    push dword msg_overflow
    call print_string
    add esp, 8

    mov eax, 1
    mov ebx, 1
    int 0x80

.fim:
    pop esi
    pop ebx
    pop ebp
    ret