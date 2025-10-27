%{
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>

int yylex(void);
extern int yylineno;
extern int column_number;
extern FILE *yyin, *yyout;

void yyerror(const char *s);

typedef struct simbolo {
    char *lexema;
    char *categoria;
    int linha;
    int coluna;
    struct simbolo *prox;
} Simbolo;

Simbolo* tabela_simbolos = NULL;

Simbolo* buscar(const char* lexema) {
    for (Simbolo* s = tabela_simbolos; s != NULL; s = s->prox) {
        if (strcmp(s->lexema, lexema) == 0) return s;
    }
    return NULL;
}

void inserir(const char* lexema, const char* categoria, int linha, int coluna) {
    if (buscar(lexema) != NULL) return; 
    
    Simbolo* novo = (Simbolo*) malloc(sizeof(Simbolo));
    novo->lexema = strdup(lexema);
    novo->categoria = strdup(categoria);
    novo->linha = linha;
    novo->coluna = coluna;
    
    novo->prox = tabela_simbolos;
    tabela_simbolos = novo;
}

%}

%token NUMBER IDENTIFIER SEMI INT BOOL COMMA EQUALS
%token FALSE TRUE IF ELSE WHILE PRINT READ RETURN MAIN
%token PLUS MINUS TIMES DIVIDE ELEVA RESTO
%token LT MT LE ME ET DT AND OR NOT
%token OP CP OC CC

%%
/* ===================================================================
 * Ponto de Partida (Regra Inicial)
 * ===================================================================
 */

/* 'linhaP' é a regra inicial da gramática. */
linhaP:
      linha { printf("Aceita"); }
    ;

/* ===================================================================
 * Estruturas de Alto Nível (Comandos)
 * ===================================================================
 */

/* 'linha' é a regra principal que define um único comando ou linha de código. */
linha:
      declaracao 
    | condicao
    | laco
    | entradaOuSaida
    | lista fim          /* Atribuição */
    |                    /* Linha vazia */
    ;

/* Regra para declaração de variável. */
declaracao:
      tipo lista fim
    ;

/* Regra para o if. */
condicao:
      IF OP verificacao CP restoDaCondicao linha
    ;

/* Regra para while. */
laco:
      WHILE OP verificacao CP restoDoLaco linha
    ;
    
/* Regra para Entrada (read) e Saída (print). */
entradaOuSaida:
      PRINT OP listaPrint CP fim
    | READ OP listaRead CP fim
    ;

/* ===================================================================
 * Sub-Regras de Comandos (Blocos, Listas, etc.)
 * ===================================================================
 */

/* Define o bloco { ... } para um 'if'. */
restoDaCondicao:
      OC linha CC possivelElse
    ; 
    
/* Define o 'else' opcional. */
possivelElse:
      ELSE OC linha CC
    | /* Vazio (sem else) */
    ;

/* Define o bloco { ... } para um 'while'. */
restoDoLaco:
      OC linha CC
    ;
    
/* 'lista' é usada para definir uma ou mais variáveis */
lista:
      variavel atribuir listaLinha
    ;

/* Regra recursiva para a 'lista' */
listaLinha:
      COMMA variavel atribuir listaLinha { $$ = $2; }
    | /* Fim da lista */
    ;

/* 'listaPrint' é usado para definir que expressões e constantes podem ser impressas */
listaPrint:
       expr listaPrintLinha
    ;

/* Regra recursiva para a 'listaPrint' */
listaPrintLinha:
       COMMA expr listaPrintLinha
    |  /* Fim da lista */
    ;

/* 'listaRead' é usada para definir que apenas identificadores podem receber leituras */
listaRead:
       IDENTIFIER listaReadLinha
    ;

/* Regra recursiva para a 'listaRead' */
listaReadLinha:
      COMMA IDENTIFIER listaReadLinha
    | /* Fim da lista */
    ;

/* Define o tipo da variável */
tipo:
      INT 
    | BOOL 
    ;

/* 'atribuir' define uma atribuição opcional */
atribuir:
      EQUALS valor
    | /* Sem atribuição */
    ;

/* ===================================================================
 * Gramáticas de Expressão
 * ===================================================================
 */

/* 'verificacao' é a gramática de expressão para 'if' e 'while'. */
verificacao:
      expr ET expr opLogico
    | expr LT expr opLogico
    | expr MT expr opLogico
    | expr ME expr opLogico
    | expr LE expr opLogico
    | expr DT expr opLogico
    ;

/* 'opLogico' permite encadear múltiplas verificações (ex: ... & a < b | c > d) */
opLogico:
      AND verificacao
    | OR verificacao
    | NOT verificacao
    | /* Fim da expressão lógica */
    ;

/* 'expr' é a gramática de expressão aritmética (soma/subtração). */
expr:
      expr PLUS t { $$ = $1 + $3; }
    | expr MINUS t { $$ = $1 - $3; }
    | t
    ;

/* 't' é o "termo" (multiplicação/divisão) */
t:
      t TIMES f { $$ = $1 * $3; }
    | t DIVIDE f { $$ = $1 / $3; }
    | f
    ;

/* 'f' é o "fator" (átomos da expressão) */
f:
      OP expr CP     { $$ = $2; }
    | MINUS NUMBER   { $$ = -$2; }
    | NUMBER
    | IDENTIFIER
    ;

/* ===================================================================
 * Regras Atômicas e de Finalização
 * ===================================================================
 */

/* 'valor' é o que pode vir depois de um '=' (expressão, true ou false) */
valor:
      expr 
    | TRUE 
    | FALSE 
    ;

/* Um 'variavel' é um IDENTIFIER */
variavel:
      IDENTIFIER
    ;

/* 'fim' é a regra que define o fim de um comando. */
fim:
      SEMI linha
    ;

%%

int main(int argc, char *argv[]){
    if (argc < 2) {
        fprintf(stderr, "Erro: Nenhum arquivo fornecido.\n");
        return 1;
    }
    yyin = fopen(argv[1], "r");
    if (!yyin) { perror("Erro ao abrir arquivo"); return 1; }
    yyout = stdout;

    /* CHAMA O ANALISADOR SINTÁTICO (que chama o léxico) */
    yyparse();

    /* Imprime a tabela de símbolos no final */
    printf("\n--- TABELA DE SIMBOLOS (Apenas Identificadores) ---\n"); 
    printf("\nToken          Lexema\n");
    printf("----------------------\n");

    for (Simbolo* s = tabela_simbolos; s != NULL; s = s->prox) {
        if (strcmp(s->categoria, "IDENTIFIER") == 0) {
            printf("%-13s %s\n", s->categoria, s->lexema);
        }
    }

    fclose(yyin);
    return 0;
}

/* DEFINIÇÃO DA FUNÇÃO DE ERRO */
void yyerror(const char *s) {
    fprintf(stderr, "Erro Sintatico na linha %d, coluna %d: %s\n", yylineno, column_number, s);
}
