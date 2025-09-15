%option noyywrap yylineno
%{
/* −−−−−−−−−−−−−−−−−−−−−−−−−− D e f i n i t i o n s −−−−−−−−−−−−−−−−−−−−−−−−−− */
#include<stdio.h>

int column_number = 1;

#define TAM_TABELA 211  // tamanho da hash, número primo ajuda na dispersão

/* Estrutura do símbolo */
typedef struct simbolo {
    char *lexema;           // texto do token
    char *categoria;        // IDENTIFIER, NUMBER, OPER_ARIT, etc
    int linha;              // linha onde apareceu
    int coluna;             // coluna
    struct simbolo *prox;   // para colisões da hash
} Simbolo;

Simbolo* tabela[TAM_TABELA] = {NULL};

/* Função hash */
unsigned int hash(const char *s) {
    unsigned int h = 0;
    while (*s) {
        h = (h << 4) + *s++;
        unsigned int g = h & 0xF0000000L;
        if (g) h ^= g >> 24;
        h &= ~g;
    }
    return h % TAM_TABELA;
}

/* Busca símbolo */
Simbolo* buscar(const char* lexema) {
    unsigned int h = hash(lexema);
    for (Simbolo* s = tabela[h]; s != NULL; s = s->prox) {
        if (strcmp(s->lexema, lexema) == 0) return s;
    }
    return NULL;
}

/* Insere símbolo */
void inserir(const char* lexema, const char* categoria, int linha, int coluna) {
    if (buscar(lexema) != NULL) return; // evita duplicatas
    unsigned int h = hash(lexema);
    Simbolo* novo = (Simbolo*) malloc(sizeof(Simbolo));
    novo->lexema = strdup(lexema);
    novo->categoria = strdup(categoria);
    novo->linha = linha;
    novo->coluna = coluna;
    novo->prox = tabela[h];
    tabela[h] = novo;
}

%}

/* Definições de regex */
digit       [0-9]
number      [+-]?{digit}+
letter      [a-zA-Z_]
identifier  {letter}({letter}|{digit})*
ws          [ \t]+
comment     "//"[^\n]*

%%

%{
/* −−−−−−−−−−−−−−−−−−−−−−−−−−−−− Palavras reservadas −−−−−−−−−−−−−−−−−−−−−−−−−−−−− */
%}

"if"       { fprintf(yyout, "%d(%d): %s (RESERVADA)\n", yylineno,column_number,yytext); 
              inserir(yytext, "RESERVADA", yylineno, column_number); column_number+=yyleng; }
"else"     { fprintf(yyout, "%d(%d): %s (RESERVADA)\n", yylineno,column_number,yytext); 
              inserir(yytext, "RESERVADA", yylineno, column_number); column_number+=yyleng; }
"while"    { fprintf(yyout, "%d(%d): %s (RESERVADA)\n", yylineno,column_number,yytext); 
              inserir(yytext, "RESERVADA", yylineno, column_number); column_number+=yyleng; }
"print"    { fprintf(yyout, "%d(%d): %s (RESERVADA)\n", yylineno,column_number,yytext); 
              inserir(yytext, "RESERVADA", yylineno, column_number); column_number+=yyleng; }
"read"     { fprintf(yyout, "%d(%d): %s (RESERVADA)\n", yylineno,column_number,yytext); 
              inserir(yytext, "RESERVADA", yylineno, column_number); column_number+=yyleng; }
"true"     { fprintf(yyout, "%d(%d): %s (RESERVADA)\n", yylineno,column_number,yytext); 
              inserir(yytext, "RESERVADA", yylineno, column_number); column_number+=yyleng; }
"false"    { fprintf(yyout, "%d(%d): %s (RESERVADA)\n", yylineno,column_number,yytext); 
              inserir(yytext, "RESERVADA", yylineno, column_number); column_number+=yyleng; }

%{
/* −−−−−−−−−−−−−−−−−−−−−−−−−−−−− Declaração de tipos −−−−−−−−−−−−−−−−−−−−−−−−−−−−− */
%}

"int"      { fprintf(yyout, "%d(%d): %s (TIPO)\n", yylineno,column_number,yytext); 
              inserir(yytext, "TIPO", yylineno, column_number); column_number+=yyleng; }
"bool"     { fprintf(yyout, "%d(%d): %s (TIPO)\n", yylineno,column_number,yytext); 
              inserir(yytext, "TIPO", yylineno, column_number); column_number+=yyleng; }

%{
/* −−−−−−−−−−−−−−−−−−−−−−−−−−−−− Operadores Aritméticos −−−−−−−−−−−−−−−−−−−−−−−−−−−−− */
%}

"+" { fprintf(yyout, "%d(%d): %s (OPER_ARIT)\n", yylineno,column_number,yytext);
      inserir(yytext, "OPER_ARIT", yylineno, column_number); column_number+=yyleng; }
"-" { fprintf(yyout, "%d(%d): %s (OPER_ARIT)\n", yylineno,column_number,yytext);
      inserir(yytext, "OPER_ARIT", yylineno, column_number); column_number+=yyleng; }
"*" { fprintf(yyout, "%d(%d): %s (OPER_ARIT)\n", yylineno,column_number,yytext);
      inserir(yytext, "OPER_ARIT", yylineno, column_number); column_number+=yyleng; }
"/" { fprintf(yyout, "%d(%d): %s (OPER_ARIT)\n", yylineno,column_number,yytext);
      inserir(yytext, "OPER_ARIT", yylineno, column_number); column_number+=yyleng; }
"^" { fprintf(yyout, "%d(%d): %s (OPER_ARIT)\n", yylineno,column_number,yytext);
      inserir(yytext, "OPER_ARIT", yylineno, column_number); column_number+=yyleng; }
"%" { fprintf(yyout, "%d(%d): %s (OPER_ARIT)\n", yylineno,column_number,yytext);
      inserir(yytext, "OPER_ARIT", yylineno, column_number); column_number+=yyleng; }
"=" { fprintf(yyout, "%d(%d): %s (OPER_ARIT)\n", yylineno,column_number,yytext);
      inserir(yytext, "OPER_ARIT", yylineno, column_number); column_number+=yyleng; }

%{
/* −−−−−−−−−−−−−−−−−−−−−−−−−−−−− Operadores Relacionais −−−−−−−−−−−−−−−−−−−−−−−−−−−−− */
%}

"<"  { fprintf(yyout, "%d(%d): %s (OPER_RELA)\n", yylineno,column_number,yytext);
        inserir(yytext, "OPER_RELA", yylineno, column_number); column_number+=yyleng; }
">"  { fprintf(yyout, "%d(%d): %s (OPER_RELA)\n", yylineno,column_number,yytext);
        inserir(yytext, "OPER_RELA", yylineno, column_number); column_number+=yyleng; }
"<=" { fprintf(yyout, "%d(%d): %s (OPER_RELA)\n", yylineno,column_number,yytext);
        inserir(yytext, "OPER_RELA", yylineno, column_number); column_number+=yyleng; }
">=" { fprintf(yyout, "%d(%d): %s (OPER_RELA)\n", yylineno,column_number,yytext);
        inserir(yytext, "OPER_RELA", yylineno, column_number); column_number+=yyleng; }
"==" { fprintf(yyout, "%d(%d): %s (OPER_RELA)\n", yylineno,column_number,yytext);
        inserir(yytext, "OPER_RELA", yylineno, column_number); column_number+=yyleng; }
"!=" { fprintf(yyout, "%d(%d): %s (OPER_RELA)\n", yylineno,column_number,yytext);
        inserir(yytext, "OPER_RELA", yylineno, column_number); column_number+=yyleng; }

%{
/* −−−−−−−−−−−−−−−−−−−−−−−−−−−−− Operadores Lógicos −−−−−−−−−−−−−−−−−−−−−−−−−−−−− */
%}

"&" { fprintf(yyout, "%d(%d): %s (OPER_LOGI)\n", yylineno,column_number,yytext);
      inserir(yytext, "OPER_LOGI", yylineno, column_number); column_number+=yyleng; }
"|" { fprintf(yyout, "%d(%d): %s (OPER_LOGI)\n", yylineno,column_number,yytext);
      inserir(yytext, "OPER_LOGI", yylineno, column_number); column_number+=yyleng; }
"!" { fprintf(yyout, "%d(%d): %s (OPER_LOGI)\n", yylineno,column_number,yytext);
      inserir(yytext, "OPER_LOGI", yylineno, column_number); column_number+=yyleng; }

%{
/* −−−−−−−−−−−−−−−−−−−−−−−−−−−−− Símbolos de Pontuação −−−−−−−−−−−−−−−−−−−−−−−−−−−−− */
%}

";" { fprintf(yyout, "%d(%d): %s (PONTUACAO)\n", yylineno,column_number,yytext);
      inserir(yytext, "PONTUACAO", yylineno, column_number); column_number+=yyleng; }
"," { fprintf(yyout, "%d(%d): %s (PONTUACAO)\n", yylineno,column_number,yytext);
      inserir(yytext, "PONTUACAO", yylineno, column_number); column_number+=yyleng; }
"(" { fprintf(yyout, "%d(%d): %s (PONTUACAO)\n", yylineno,column_number,yytext);
      inserir(yytext, "PONTUACAO", yylineno, column_number); column_number+=yyleng; }
")" { fprintf(yyout, "%d(%d): %s (PONTUACAO)\n", yylineno,column_number,yytext);
      inserir(yytext, "PONTUACAO", yylineno, column_number); column_number+=yyleng; }
"{" { fprintf(yyout, "%d(%d): %s (PONTUACAO)\n", yylineno,column_number,yytext);
      inserir(yytext, "PONTUACAO", yylineno, column_number); column_number+=yyleng; }
"}" { fprintf(yyout, "%d(%d): %s (PONTUACAO)\n", yylineno,column_number,yytext);
      inserir(yytext, "PONTUACAO", yylineno, column_number); column_number+=yyleng; }

%{
/* −−−−−−−−−−−−−−−−−−−−−−−−−−−−− Rules −−−−−−−−−−−−−−−−−−−−−−−−−−−−− */
%}

{number} { fprintf(yyout,"%d(%d): %s (NUMBER)\n", yylineno,column_number,yytext);
           inserir(yytext, "NUMBER", yylineno, column_number); column_number+=yyleng; }

{identifier} { fprintf(yyout, "%d(%d): %s (IDENTIFIER)\n", yylineno, column_number, yytext);
               inserir(yytext, "IDENTIFIER", yylineno, column_number); column_number+=yyleng; }

{comment} { /* ignora */ }
{ws} { column_number += yyleng; }
\n { column_number = 1; }
.   { fprintf(yyout, "Lexical error. Input -> \"%d(%d): %s\"\n", yylineno,column_number,yytext);
      column_number+=yyleng; }

%%

/* −−−−−−−−−−−−−−−−−−−−−−−− User s u b r o t i n e s −−−−−−−−−−−−−−−−−−−−−−−− */

int main(int argc, char *argv[]){
    if (argc < 2) {
        fprintf(stderr, "Erro: Nenhum arquivo fornecido.\n");
        return 1;
    }
    yyin = fopen(argv[1], "r");
    if (!yyin) { perror("Erro ao abrir arquivo"); return 1; }
    yyout = stdout;

    yylex();

    printf("\n--- TABELA DE SÍMBOLOS ---\n");
    printf("\nToken         Lexema\n");
    printf("----------------------\n");
    for (int i = 0; i < TAM_TABELA; i++) {
        for (Simbolo* s = tabela[i]; s != NULL; s = s->prox) {
            printf("%-13s %s\n", s->categoria, s->lexema);
        }
    }

    fclose(yyin);
    return 0;
}
