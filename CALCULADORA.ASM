global _start
extern op_soma          ; Declaração da função contida em SOMA.ASM

section .data
    ; Mensagens globais 
    msg_nome      db "Bem-vindo. Digite seu nome: ", 0
    len_nome      equ $ - msg_nome
    msg_boas_vind db "Hola, ", 0
    len_boas_vind equ $ - msg_boas_vind
    msg_boas_2    db ", bem-vindo ao programa de CALC IA-32", 10, 0
    len_boas_2    equ $ - msg_boas_2
    msg_precisao  db "Vai trabalhar com 16 ou 32 bits (digite 0 para 16, e 1 para 32): ", 0
    len_precisao  equ $ - msg_precisao

section .bss
    nome_user     resb 50
    precisao      resd 1    ; 0 para 16-bits, 1 para 32-bits
    opcao_menu    resd 1

section .text
_start:
    ; 1. Solicita o nome do usuário
    push dword len_nome
    push dword msg_nome
    call print_string
    add esp, 8

    ; 2. Lê o nome do usuário (Syscall Read)
    mov eax, 3          ; sys_read
    mov ebx, 0          ; stdin
    mov ecx, nome_user
    mov edx, 50
    int 0x80
    
    ; Armazena quantos bytes foram lidos (remover o '\n' se necessário)
    mov edi, eax
    dec edi             ; descarta o enter

    ; 3. Mensagem de boas-vindas modular
    push dword len_boas_vind
    push dword msg_boas_vind
    call print_string
    add esp, 8

    push dword edi
    push dword nome_user
    call print_string
    add esp, 8

    push dword len_boas_2
    push dword msg_boas_2
    call print_string
    add esp, 8

    ; 4. Pergunta a precisão
    push dword len_precisao
    push dword msg_precisao
    call print_string
    add esp, 8

    ; teste da soma
    mov dword [precisao], 1

    ; EXEMPLO DA SOMA 
    ; Passando os argumentos pela pilha (duas precisões)
    push dword [precisao]  ; Tipo da precisão (0 ou 1)
    push dword 20          ; Num2 (pode ser negativo/variável local)
    push dword 15          ; Num1
    call op_soma
    add esp, 12            ; Limpa os 3 parâmetros da pilha após o retorno

    ; O resultado final da soma volta obrigatoriamente em EAX


Sair:
    mov eax, 1          ; sys_exit
    mov ebx, 0          ; status 0
    int 0x80

; FUNÇÃO OBRIGATÓRIA: Saída Única de Strings
; Recebe pela pilha: [ebp+8] -> Ponteiro da String, [ebp+12] -> Tamanho

print_string:
    push ebp
    mov ebp, esp
    push ebx            ; Preserva ebx

    mov eax, 4          ; sys_write
    mov ebx, 1          ; stdout
    mov ecx, [ebp+8]    ; Ponteiro do string
    mov edx, [ebp+12]   ; Quantidade de bytes
    int 0x80

    pop ebx
    pop ebp
    ret