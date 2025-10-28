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
    int id; 
    struct simbolo *prox;
} Simbolo;

Simbolo* tabela_simbolos = NULL;
int proximo_id_disponivel = 1; 

void imprimir_ordenado(Simbolo* s); // <--- MOVIDO: Protótipo da função

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
    novo->id = 0; 
    
    if (strcmp(categoria, "IDENTIFIER") == 0) {
        novo->id = proximo_id_disponivel;
        proximo_id_disponivel++; 
    }
    
    novo->prox = tabela_simbolos;
    tabela_simbolos = novo;
}

%}

%token NUMBER IDENTIFIER SEMI INT BOOL COMMA EQUALS
%token FALSE TRUE IF ELSE WHILE PRINT READ RETURN MAIN
%token PLUS MINUS TIMES DIVIDE ELEVA RESTO
%token LT MT LE ME ET DT AND OR NOT
%token OP CP OC CC

%define parse.error verbose

%%
/* ===================================================================
 * Ponto de Partida (Regra Inicial)
 * =================================================================== */

linhaP:
      linha
    ;

/* ===================================================================
 * Estruturas de Alto Nível (Comandos)
 * =================================================================== */

linha:
      declaracao 
    | condicao
    | laco
    | entradaOuSaida
    | lista SEMI linha  /* Atribuição */
    |                   /* Linha vazia */
    ;

declaracao:
      tipo lista SEMI linha
    ;

condicao:
      IF OP verificacao CP restoDaCondicao linha
    | IF OP verificacao error restoDaCondicao linha  /* CORREÇÃO: Trata 'if (expr { ...' */
    ;

laco:
      WHILE OP verificacao CP restoDoLaco linha
    | WHILE OP verificacao error restoDoLaco linha  /* CORREÇÃO: Trata 'while (expr { ...' */
    ;
    
entradaOuSaida:
      PRINT OP listaPrint CP SEMI linha
    | PRINT OP listaPrint CP error linha
    | READ OP listaRead CP SEMI linha
    | READ OP listaRead CP error linha
    ;

/* ===================================================================
 * Sub-Regras de Comandos (Blocos, Listas, etc.)
 * =================================================================== */

restoDaCondicao:
      OC linha CC possivelElse
    | OC linha error possivelElse  /* CORREÇÃO: Trata 'if (...) { ... else ...' */
    ; 
    
possivelElse:
      ELSE OC linha CC
    | /* Vazio (sem else) */
    ;

restoDoLaco:
      OC linha CC
    | OC linha error              /* CORREÇÃO: Trata 'while (...) { ...' */
    ;
    
lista:
      variavel atribuir listaLinha
    ;

listaLinha:
      COMMA variavel atribuir listaLinha { $$ = $2; }
    | error variavel atribuir listaLinha
    | /* Fim da lista */
    ;

listaPrint:
        expr listaPrintLinha
    ;

listaPrintLinha:
        COMMA expr listaPrintLinha 
    |   error expr listaPrintLinha
    |   /* Fim da lista */
    ;

listaRead:
        IDENTIFIER listaReadLinha
    ;

listaReadLinha:
      COMMA IDENTIFIER listaReadLinha
    | error IDENTIFIER listaReadLinha
    | /* Fim da lista */
    ;

tipo:
      INT 
    | BOOL 
    ;

atribuir:
      EQUALS valor
    | /* Sem atribuição */
    ;

/* ===================================================================
 * Gramáticas de Expressão
 * =================================================================== */

verificacao:
      expr ET expr opLogico
    | expr LT expr opLogico
    | expr MT expr opLogico
    | expr ME expr opLogico
    | expr LE expr opLogico
    | expr DT expr opLogico
    ;

opLogico:
      AND verificacao
    | OR verificacao
    | NOT verificacao
    | /* Fim da expressão lógica */
    ;

expr:
      expr PLUS t { $$ = $1 + $3; }
    | expr MINUS t { $$ = $1 - $3; }
    | t
    ;

t:
      t TIMES f { $$ = $1 * $3; }
    | t DIVIDE f { $$ = $1 / $3; }
    | f
    ;

f:
      OP expr CP         { $$ = $2; }
    | MINUS NUMBER       { $$ = -$2; }
    | MINUS IDENTIFIER   { $$ = -$2; }
    | NUMBER
    | IDENTIFIER
    ;

/* ===================================================================
 * Regras Atômicas e de Finalização
 * =================================================================== */

valor:
      expr 
    | TRUE 
    | FALSE 
    ;

variavel:
      IDENTIFIER
    ;


%%

void imprimir_ordenado(Simbolo* s) {
    if (s == NULL) {
        return;
    }
    imprimir_ordenado(s->prox);

    if (strcmp(s->categoria, "IDENTIFIER") == 0) {
        /* Ajustei a formatação para bater com seu novo cabeçalho */
        printf("%-5d %-10s %s\n", s->id, s->lexema, s->categoria);
    }
}


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
    printf("\n--- TABELA DE SIMBOLOS ---\n"); 
    /* Ajustei o cabeçalho para bater com a impressão */
    printf("\nID    Lexema      Token\n");
    printf("--------------------------\n");

    imprimir_ordenado(tabela_simbolos);

    fclose(yyin);
    return 0;
}

/* DEFINIÇÃO DA FUNÇÃO DE ERRO */
void yyerror(const char *s) {
    fprintf(stderr, "==============================\n");
    fprintf(stderr, "Analise Sintatica Falhou\n");
    fprintf(stderr, "  > Local: Linha %d, Coluna %d\n", yylineno, column_number);
    fprintf(stderr, "  > Motivo: %s\n", s);
    fprintf(stderr, "==============================\n");
}