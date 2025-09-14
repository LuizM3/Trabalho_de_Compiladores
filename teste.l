%option noyywrap yylineno
%{
/* −−−−−−−−−−−−−−−−−−−−−−−−−− D e f i n i t i o n s −−−−−−−−−−−−−−−−−−−−−−−−−− */
#include<stdio.h>

int column_number = 1;
%}

digit [0-9]
number [+-]?{digit}+(\.{digit}+)?
letter [a-zA-Z]
delim [ \t\n]
ws {delim}+
word {letter}+
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
{word} { fprintf(yyout, "%d(%d): %s (WORD)\n", yylineno,column_number,yytext); column_number+=yyleng; }
{comment} { }
{ws} { }
{other} { fprintf(yyout, "Lexical error. Input -> \"%d(%d): %s\"\n", yylineno,column_number,yytext); column_number+=yyleng; }
\n { column_number = 1; }

%%
/* −−−−−−−−−−−−−−−−−−−−−−−− User s u b r o t i n e s −−−−−−−−−−−−−−−−−−−−−−−− */
int main(int argc, char *argv[]){
yyin = fopen(argv[1], "r"); /* Se não sabe o que é , estude argumentos de l i n h a de comando em C */
yyout=stdout;
yylex();
fclose(yyin);
return 0;
}