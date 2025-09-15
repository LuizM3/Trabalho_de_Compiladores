%option noyywrap yylineno
%{
/* −−−−−−−−−−−−−−−−−−−−−−−−−− D e f i n i t i o n s −−−−−−−−−−−−−−−−−−−−−−−−−− */
#include<stdio.h>

int column_number = 1;
%}

digit [0-9]
number [+-]?{digit}+(\.{digit}+)?([eE][+-]?{digit}+)?
letter [a-zA-Z_]
delim [ \t]
ws {delim}+
identifier {letter}({letter}|{digit})*
comment "//"[^\n]*|"/*"[^"*/"]*"*/"
other .

%%

%{
/* −−−−−−−−−−−−−−−−−−−−−−−−−−−−− Palavras reservadas −−−−−−−−−−−−−−−−−−−−−−−−−−−−− */
%}

"if" { fprintf(yyout, "%d(%d): %s (RESERVADA)\n", yylineno,column_number,yytext); column_number+=yyleng; }
"else" { fprintf(yyout, "%d(%d): %s (RESERVADA)\n", yylineno,column_number,yytext); column_number+=yyleng; }
"while" { fprintf(yyout, "%d(%d): %s (RESERVADA)\n", yylineno,column_number,yytext); column_number+=yyleng; }
"print" { fprintf(yyout, "%d(%d): %s (RESERVADA)\n", yylineno,column_number,yytext); column_number+=yyleng; }
"read" { fprintf(yyout, "%d(%d): %s (RESERVADA)\n", yylineno,column_number,yytext); column_number+=yyleng; }
"true" { fprintf(yyout, "%d(%d): %s (RESERVADA)\n", yylineno,column_number,yytext); column_number+=yyleng; }
"false" { fprintf(yyout, "%d(%d): %s (RESERVADA)\n", yylineno,column_number,yytext); column_number+=yyleng; }

%{
/* −−−−−−−−−−−−−−−−−−−−−−−−−−−−− Declaração de tipos −−−−−−−−−−−−−−−−−−−−−−−−−−−−− */
%}

"int" { fprintf(yyout, "%d(%d): %s (TIPO)\n", yylineno,column_number,yytext); column_number+=yyleng; }
"bool" { fprintf(yyout, "%d(%d): %s (TIPO)\n", yylineno,column_number,yytext); column_number+=yyleng; }

%{
/* −−−−−−−−−−−−−−−−−−−−−−−−−−−−− Operadores Aritméticos −−−−−−−−−−−−−−−−−−−−−−−−−−−−− */
%}

"+" { fprintf(yyout, "%d(%d): %s (OPER_ARIT)\n", yylineno,column_number,yytext); column_number+=yyleng; }
"-" { fprintf(yyout, "%d(%d): %s (OPER_ARIT)\n", yylineno,column_number,yytext); column_number+=yyleng; }
"*" { fprintf(yyout, "%d(%d): %s (OPER_ARIT)\n", yylineno,column_number,yytext); column_number+=yyleng; }
"/" { fprintf(yyout, "%d(%d): %s (OPER_ARIT)\n", yylineno,column_number,yytext); column_number+=yyleng; }
"^" { fprintf(yyout, "%d(%d): %s (OPER_ARIT)\n", yylineno,column_number,yytext); column_number+=yyleng; }
"%" { fprintf(yyout, "%d(%d): %s (OPER_ARIT)\n", yylineno,column_number,yytext); column_number+=yyleng; }
"=" { fprintf(yyout, "%d(%d): %s (OPER_ARIT)\n", yylineno,column_number,yytext); column_number+=yyleng; }

%{
/* −−−−−−−−−−−−−−−−−−−−−−−−−−−−− Operadores Relacionais −−−−−−−−−−−−−−−−−−−−−−−−−−−−− */
%}
"<" { fprintf(yyout, "%d(%d): %s (OPER_RELA)\n", yylineno,column_number,yytext); column_number+=yyleng; }
">" { fprintf(yyout, "%d(%d): %s (OPER_RELA)\n", yylineno,column_number,yytext); column_number+=yyleng; }
"<=" { fprintf(yyout, "%d(%d): %s (OPER_RELA)\n", yylineno,column_number,yytext); column_number+=yyleng; }
">=" { fprintf(yyout, "%d(%d): %s (OPER_RELA)\n", yylineno,column_number,yytext); column_number+=yyleng; }
"==" { fprintf(yyout, "%d(%d): %s (OPER_RELA)\n", yylineno,column_number,yytext); column_number+=yyleng; }
"!=" { fprintf(yyout, "%d(%d): %s (OPER_RELA)\n", yylineno,column_number,yytext); column_number+=yyleng; }

%{
/* −−−−−−−−−−−−−−−−−−−−−−−−−−−−− Operadores Lógicos −−−−−−−−−−−−−−−−−−−−−−−−−−−−− */
%}
"&" { fprintf(yyout, "%d(%d): %s (OPER_LOGI)\n", yylineno,column_number,yytext); column_number+=yyleng; }
"|" { fprintf(yyout, "%d(%d): %s (OPER_LOGI)\n", yylineno,column_number,yytext); column_number+=yyleng; }
"!" { fprintf(yyout, "%d(%d): %s (OPER_LOGI)\n", yylineno,column_number,yytext); column_number+=yyleng; }

%{
/* −−−−−−−−−−−−−−−−−−−−−−−−−−−−− Símbolos de Pontuação −−−−−−−−−−−−−−−−−−−−−−−−−−−−− */
%}
";" { fprintf(yyout, "%d(%d): %s (Pontuação)\n", yylineno,column_number,yytext); column_number+=yyleng; }
"," { fprintf(yyout, "%d(%d): %s (Pontuação)\n", yylineno,column_number,yytext); column_number+=yyleng; }
"(" { fprintf(yyout, "%d(%d): %s (Pontuação)\n", yylineno,column_number,yytext); column_number+=yyleng; }
")" { fprintf(yyout, "%d(%d): %s (Pontuação)\n", yylineno,column_number,yytext); column_number+=yyleng; }
"{" { fprintf(yyout, "%d(%d): %s (Pontuação)\n", yylineno,column_number,yytext); column_number+=yyleng; }
"}" { fprintf(yyout, "%d(%d): %s (Pontuação)\n", yylineno,column_number,yytext); column_number+=yyleng; }


%{
/* −−−−−−−−−−−−−−−−−−−−−−−−−−−−− Rules −−−−−−−−−−−−−−−−−−−−−−−−−−−−− */
%}

{number} { fprintf(yyout,"%d(%d): %s (NUMBER)\n", yylineno,column_number,yytext); column_number+=yyleng; }
{identifier} { fprintf(yyout, "%d(%d): %s (identifier)\n", yylineno,column_number,yytext); column_number+=yyleng; }
{comment} { }
{ws} { column_number += yyleng; }
{other} { fprintf(yyout, "Lexical error. Input -> \"%d(%d): %s\"\n", yylineno,column_number,yytext); column_number+=yyleng; }
\n { column_number = 1; }

%%
/* −−−−−−−−−−−−−−−−−−−−−−−− User s u b r o t i n e s −−−−−−−−−−−−−−−−−−−−−−−− */
int main(int argc, char *argv[]){
    // Verifica se o usuário passou o nome do arquivo como argumento
    if (argc < 2) {
        fprintf(stderr, "Erro: Nenhum arquivo de entrada fornecido.\n");
        fprintf(stderr, "Modo de uso: %s <nome_do_arquivo>\n", argv[0]);
        return 1; // Retorna um código de erro
    }

    // Tenta abrir o arquivo fornecido em argv[1]
    yyin = fopen(argv[1], "r");

    // Verifica se o arquivo foi aberto com sucesso
    if (yyin == NULL) { // Ou simplesmente if (!yyin)
        fprintf(stderr, "Erro: Não foi possível abrir o arquivo '%s'.\n", argv[1]);
        perror("Motivo"); // perror imprime a razão do erro (ex: "No such file or directory")
        return 1; // Retorna um código de erro
    }

    yyout = stdout; // A saída continuará sendo no terminal (padrão)
    
    printf("Analisando o arquivo: %s\n", argv[1]);
    printf("----------------------------------------\n");
    yylex(); // Inicia a análise léxica
    printf("----------------------------------------\n");
    printf("Análise concluída.\n");
    
    fclose(yyin);
    return 0;
}