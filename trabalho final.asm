; Trabalho para a disciplina Arquitetura de Computadores - 2024/01
; Laura Ferraz Pelisson e Michele Cristina Otta

; O programa lê uma string e transforma a primeira letra de cada 
; palavra em maiúscula (caso esteja minúscula). Em seguida, 
; imprime a string com essa alteração ao contrário!

%include "io64.inc"

section .data
    fmt_in: db '%s', 0 ; String de entrada
    prompt: db 'Enter a string: ', 0 ; Mensagem inicial
    str: times 100 db 0  ; Alocar espaço para a string de entrada
    msg1: db 'String com as primeiras letras maiusculas: ', 0
    msg2: db '+ String reversa: ', 0

section .bss
    length: resb 1  ; Para armazenar o comprimento da string
    var: resb 4;

section .text
global main

main:
    mov rbp, rsp; For correct debugging
    push rbp
    mov rbp, rsp

    ; Imprimir prompt
    PRINT_STRING prompt ;
    NEWLINE ;

    ; Ler a string de entrada
    mov rsi, str
    mov rdi, fmt_in
    
    push var
    push fmt_in
        
    ; Scanf
    GET_STRING fmt_in, 256

    ; Inicializar índices
    xor rcx, rcx     ; Contador de caracteres rcx = 0
    mov rbx, fmt_in  ; Ponteiro para a string de entrada
    
PRIMEIRA_LETRA:
    mov al, byte[rbx] ; Carrega o caracter atual
    
    cmp al, ' '       ; Checa se é espaço
    je EH_ESPACO      ; Se sim, vai pro EH_ESPACO

    jmp TO_UPPER      ; Caso contrário, pula pro TO_UPPER
    

FOR_CHAR:
    mov al, byte[rbx] ; Carrega o caracter atual
    
    cmp al, 0         ; Checa se é fim da string
    je IMPRIME_CONTRARIO ; Se sim, termina o loop
    
    cmp al, ' '       ; Checa se é espaço
    je EH_ESPACO      ; Se sim, vai pro EH_ESPACO
    
    jmp PRINTCHAR     ; Caso contrário, pula para o PRINTCHAR
    

EH_ESPACO:    
    inc rbx           ; Vai pro proximo caracter da string
    inc rcx           ; Incrementa o contador de caracteres
    
    mov al, byte[rbx] ; Carrega caracter
    cmp al, 0         ; Checa se é fim da string
    je IMPRIME_CONTRARIO ; Se sim, termina o loop
    
    cmp al, ' '       ; Checa se é espaço
    je EH_ESPACO      ; Se sim, vai pro EH_ESPACO
    
    jmp TO_UPPER      ; Caso contrário, pula para o TO_UPPER
    
TO_UPPER:
    ; Verifica se o caracter atual é uma letra minúscula
    cmp al, 'a'
    jb PRINTCHAR
    cmp al, 'z'
    ja PRINTCHAR
    
    ; Transforma em maiúscula
    sub al, 'a'
    add al, 'A'
    
    ; Substitui pelo caracter em maiúscula
    mov byte[rbx], al
    jmp PRINTCHAR
    
PRINTCHAR:
    inc rbx        ; Vai pro proximo caracter da string
    inc rcx        ; Incrementa o contador de caracteres

    jmp FOR_CHAR   ; Volta pro loop
    
IMPRIME_CONTRARIO:
    NEWLINE
    PRINT_STRING msg1
    NEWLINE
    PRINT_STRING fmt_in
    NEWLINE
    NEWLINE
    PRINT_STRING msg2
    NEWLINE
    mov rbx, fmt_in ; Ponteiro para a string de entrada
    add rbx, rcx
    dec rbx         ; Acerta para a última posição da string

REV_CHAR:
    cmp rcx, 0        ; Confere se já leu toda string
    je END_FOR_CHAR   ; Se sim, encerra o programa
    
    mov al, byte[rbx] ; Carrega caracter
    PRINT_CHAR al     ; Imprime na tela
    
    dec rbx           ; Passa para o caracter anterior
    dec rcx           ; Decrementa o contador de caracteres
    jmp REV_CHAR      ; Volta pro loop

END_FOR_CHAR:
    ; Encerra o programa
    restoregs
    leave 
    ret