global _start
extern op_soma          ; SOMA.ASM

section .data
    msg_nome      db "Bem-vindo. Digite seu nome: ", 0
    len_nome      equ $ - msg_nome
    msg_boas_vind db "Hola, ", 0
    len_boas_vind equ $ - msg_boas_vind
    msg_boas_2    db ", bem-vindo ao programa de CALC IA-32", 10, 0
    len_boas_2    equ $ - msg_boas_2
    msg_precisao  db "Vai trabalhar com 16 ou 32 bits (digite 0 para 16, e 1 para 32): ", 0
    len_precisao  equ $ - msg_precisao

    ; Strings do Menu 
    menu_tit      db 10, "--- ESCOLHA UMA OPÇÃO ---", 10, 0
    len_m_tit     equ $ - menu_tit
    menu_opt1     db "1: SOMA", 10, 0
    len_m_opt1    equ $ - menu_opt1
    menu_opt7     db "7: SAIR", 10, 0
    len_m_opt7    equ $ - menu_opt7
    menu_cmd      db "Opção > ", 0
    len_m_cmd     equ $ - menu_cmd

    msg_num1      db "Digite o primeiro número: ", 0
    len_num1      equ $ - msg_num1
    msg_num2      db "Digite o segundo número: ", 0
    len_num2      equ $ - msg_num2
    msg_res       db "Resultado: ", 0
    len_res       equ $ - msg_res
    msg_nl        db 10, 0
    len_nl        equ $ - msg_nl

section .bss
    nome_user     resb 50
    precisao      resd 1    
    opcao_menu    resd 1

section .text
_start:
    ; 1. Solicita o nome
    push dword len_nome
    push dword msg_nome
    call print_string
    add esp, 8

    ; 2. Lê o nome
    push dword 50
    push dword nome_user
    call ler_string
    add esp, 8
    dec eax
    mov edi, eax

    ; 3. Boas vindas
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

    call ler_num_32
    mov [precisao], eax  


v_menu:
    ; Exibe o Menu Linha por Linha
    push dword len_m_tit
    push dword menu_tit
    call print_string
    push dword len_m_opt1
    push dword menu_opt1
    call print_string
    push dword len_m_opt7
    push dword menu_opt7
    call print_string
    push dword len_m_cmd
    push dword menu_cmd
    call print_string
    add esp, 32

    ; Lê a opção do menu
    call ler_num_32
    mov [opcao_menu], eax

    cmp dword [opcao_menu], 7
    je Sair

    cmp dword [opcao_menu], 1
    jne v_menu            

.executa_soma:
    ; Pede Num 1
    push dword len_num1
    push dword msg_num1
    call print_string
    add esp, 8

    mov ecx, [precisao]
    cmp ecx, 1
    je .soma_32
    call ler_num_16
    push eax            ; Empilha Num 1 (16 bits)
    jmp .pede_num2

.soma_32:
    call ler_num_32
    push eax            ; Empilha Num 1 (32 bits)

.pede_num2:
    ; Pede Num 2
    push dword len_num2
    push dword msg_num2
    call print_string
    add esp, 8

    mov ecx, [precisao]
    cmp ecx, 1
    je .soma2_32
    call ler_num_16
    push eax            ; Empilha Num 2 (16 bits)
    jmp .chama_soma

.soma2_32:
    call ler_num_32
    push eax            ; Empilha Num 2 (32 bits)

.chama_soma:
    push dword [precisao] ; Terceiro argumento: precisão
    call op_soma
    add esp, 12           ; Limpa a pilha

    push eax              ; mantem o resultado da soma de EAX 

    ; Exibe o texto "Resultado: "
    push dword len_res
    push dword msg_res
    call print_string
    add esp, 8

    pop eax               ; Recupera o resultado da soma para EAX
    push eax              ; Passa o número obtido para a função de exibir
    call print_num
    add esp, 4

    ; Nova linha 
    push dword len_nl
    push dword msg_nl
    call print_string
    add esp, 8

    jmp v_menu

Sair:
    mov eax, 1          
    mov ebx, 0          
    int 0x80


print_string:
    push ebp
    mov ebp, esp
    push eax            ; Salva todos os registradores
    push ebx
    push ecx
    push edx

    mov eax, 4          ; sys_write
    mov ebx, 1          ; stdout
    mov ecx, [ebp+8]    ; Ponteiro da string
    mov edx, [ebp+12]   ; Tamanho
    int 0x80

    pop edx
    pop ecx
    pop ebx
    pop eax
    pop ebp
    ret


ler_string:
    push ebp
    mov ebp, esp
    push ebx
    push ecx
    push edx

    mov eax, 3          ; sys_read
    mov ebx, 0          ; stdin
    mov ecx, [ebp+8]    ; Buffer destino
    mov edx, [ebp+12]   ; Tamanho máximo
    int 0x80

    pop edx
    pop ecx
    pop ebx
    pop ebp
    ret


ler_num_32:
    push ebp
    mov ebp, esp
    sub esp, 16         ; reserva espaço local alinhado
    push ebx
    push ecx
    push edx
    push esi
    push edi

    ; enche o buffer local com zeros para evitar lixo de memória
    mov dword [ebp-16], 0
    mov dword [ebp-12], 0
    mov dword [ebp-8], 0
    mov dword [ebp-4], 0

    lea eax, [ebp-16]   
    push dword 12
    push eax
    call ler_string
    add esp, 8          ; EAX tem o número de bytes lidos pelo sys_read

    lea esi, [ebp-16]   
    mov ecx, eax        
    xor eax, eax        
    xor edx, edx        
    xor edi, edi        

    cmp ecx, 0
    je .fim_leitura

.limpa_entrada:
    mov dl, [esi]
    cmp dl, '-'
    jne .loop_conversao
    mov edi, 1          ; Flag de negativo ativa
    inc esi
    dec ecx

.loop_conversao:
    cmp ecx, 0
    jle .aplica_sinal
    
    mov dl, [esi]
    
    ; Se Enter encerra a conversão 
    cmp dl, 10          
    je .aplica_sinal
    cmp dl, 13          
    je .aplica_sinal
    
    ; Ignora qualquer outro caractere que não seja dígito válido
    cmp dl, '0'         
    jb .proximo_char
    cmp dl, '9'
    ja .proximo_char

    ; Algoritmo: resultado = (resultado * 10) + (char - '0')
    imul eax, 10
    sub dl, '0'
    add eax, edx

.proximo_char:
    inc esi
    dec ecx
    jmp .loop_conversao

.aplica_sinal:
    cmp edi, 1
    jne .fim_leitura
    neg eax             

.fim_leitura:
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    mov esp, ebp        
    pop ebp
    ret


ler_num_16:
    push ebp
    mov ebp, esp

    call ler_num_32     ; retorna o valor em EAX
    
    ; Pega os 16 bits inferiores (AX) e bota o sinal em EAX tirando qualquer lixo nos 16 bits superiores.
    movsx eax, ax       

    pop ebp
    ret


print_num:
    push ebp
    mov ebp, esp
    sub esp, 12         ; Buffer local de 12 bytes na pilha para montar o string
    push ebx

    mov eax, [ebp+8]    ; Pega o número inteiro recebido por argumento [cite: 652]
    lea ecx, [ebp-1]    ; ECX aponta para o final do buffer local (montagem de trás pra frente)
    mov byte [ecx], 10  ; Coloca quebra de linha inicial se desejado (usaremos apenas os caracteres)
    
    xor edi, edi        ; Flag de sinal negativo
    cmp eax, 0
    jge .prepara_divisao
    mov edi, 1          ; É negativo
    neg eax             ; Torna positivo para processar os caracteres

.prepara_divisao:
    mov ebx, 10         ; Divisor básico

.loop_divisao:
    xor edx, edx
    div ebx             ; Divide EAX por 10. Quociente em EAX, Resto em EDX
    add dl, '0'         ; Converte o resto numérico para caractere ASCII
    dec ecx             ; Recua o ponteiro do buffer local
    mov [ecx], dl       ; Grava o caractere
    cmp eax, 0
    jne .loop_divisao

    ; Se for negativo, coloca o sinal de '-' na frente
    cmp edi, 1
    jne .imprime_resultado
    dec ecx
    mov byte [ecx], '-'

.imprime_resultado:
    ; Calcula o tamanho da string calculando a distância de EBP até ECX
    lea edx, [ebp]
    sub edx, ecx
    
    ; Exibe utilizando a função padrão do projeto (passando parâmetros por pilha) [cite: 635, 663]
    push edx            ; Tamanho
    push ecx            ; Ponteiro do buffer local na pilha
    call print_string
    add esp, 8

    pop ebx
    mov esp, ebp
    pop ebp
    ret