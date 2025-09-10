%option noyywrap
%{
/* −−−−−−−−−−−−−−−−−−−−−−−−−− D e f i n i t i o n s −−−−−−−−−−−−−−−−−−−−−−−−−− */
#include<stdio.h>
%}

digit [0-9]
number [+-]?{digit}+(\.{digit}+)?
letter [a-zA-Z]
word {letter}+
comment "//"[^\n]*[\n]|"/*"[^"*/"]*"*/"
other .

%%

%{
/* −−−−−−−−−−−−−−−−−−−−−−−−−−−−− Palavras reservadas −−−−−−−−−−−−−−−−−−−−−−−−−−−−− */
%}

"if" { fprintf(yyout, "%s (RESERVADA)\n", yytext); }
"else" { fprintf(yyout, "%s (RESERVADA)\n", yytext); }
"while" { fprintf(yyout, "%s (RESERVADA)\n", yytext); }
"print" { fprintf(yyout, "%s (RESERVADA)\n", yytext); }
"read" { fprintf(yyout, "%s (RESERVADA)\n", yytext); }
"true" { fprintf(yyout, "%s (RESERVADA)\n", yytext); }
"false" { fprintf(yyout, "%s (RESERVADA)\n", yytext); }

%{
/* −−−−−−−−−−−−−−−−−−−−−−−−−−−−− Declaração de tipos −−−−−−−−−−−−−−−−−−−−−−−−−−−−− */
%}

"int" { fprintf(yyout, "%s (TIPO)\n", yytext); }
"bool" { fprintf(yyout, "%s (TIPO)\n", yytext); }

%{
/* −−−−−−−−−−−−−−−−−−−−−−−−−−−−− Operadores Aritméticos −−−−−−−−−−−−−−−−−−−−−−−−−−−−− */
%}

"+" { fprintf(yyout, "%s (OPER_ARIT)\n", yytext); }
"-" { fprintf(yyout, "%s (OPER_ARIT)\n", yytext); }
"*" { fprintf(yyout, "%s (OPER_ARIT)\n", yytext); }
"/" { fprintf(yyout, "%s (OPER_ARIT)\n", yytext); }
"^" { fprintf(yyout, "%s (OPER_ARIT)\n", yytext); }
"%" { fprintf(yyout, "%s (OPER_ARIT)\n", yytext); }

%{
/* −−−−−−−−−−−−−−−−−−−−−−−−−−−−− Operadores Relacionais −−−−−−−−−−−−−−−−−−−−−−−−−−−−− */
%}
"<" { fprintf(yyout, "%s (OPER_RELA)\n", yytext); }
">" { fprintf(yyout, "%s (OPER_RELA)\n", yytext); }
"<=" { fprintf(yyout, "%s (OPER_RELA)\n", yytext); }
">=" { fprintf(yyout, "%s (OPER_RELA)\n", yytext); }
"==" { fprintf(yyout, "%s (OPER_RELA)\n", yytext); }
"!=" { fprintf(yyout, "%s (OPER_RELA)\n", yytext); }

%{
/* −−−−−−−−−−−−−−−−−−−−−−−−−−−−− Operadores Lógicos −−−−−−−−−−−−−−−−−−−−−−−−−−−−− */
%}
"&" { fprintf(yyout, "%s (OPER_LOGI)\n", yytext); }
"|" { fprintf(yyout, "%s (OPER_LOGI)\n", yytext); }
"!" { fprintf(yyout, "%s (OPER_LOGI)\n", yytext); }

%{
/* −−−−−−−−−−−−−−−−−−−−−−−−−−−−− Símbolos de Pontuação −−−−−−−−−−−−−−−−−−−−−−−−−−−−− */
%}
";" { fprintf(yyout, "%s (Pontuação)\n", yytext); }
"," { fprintf(yyout, "%s (Pontuação)\n", yytext); }
"(" { fprintf(yyout, "%s (Pontuação)\n", yytext); }
")" { fprintf(yyout, "%s (Pontuação)\n", yytext); }
"{" { fprintf(yyout, "%s (Pontuação)\n", yytext); }
"}" { fprintf(yyout, "%s (Pontuação)\n", yytext); }


%{
/* −−−−−−−−−−−−−−−−−−−−−−−−−−−−− Rules −−−−−−−−−−−−−−−−−−−−−−−−−−−−− */
%}

{number} { fprintf(yyout,"%s (NUMBER)\n", yytext); }
{word} { fprintf(yyout, "%s (WORD)\n", yytext); }
{comment} { fprintf(yyout, "%s (COMMENT)\n", yytext); }
{other} { fprintf(yyout, "Lexical error. Input -> \"%s\"\n", yytext); }

%%
/* −−−−−−−−−−−−−−−−−−−−−−−− User s u b r o t i n e s −−−−−−−−−−−−−−−−−−−−−−−− */
int main(int argc, char *argv[]){
yyin = fopen(argv[1], "r"); /* Se não sabe o que é , estude argumentos de l i n h a de comando em C */
yyout=stdout;
yylex();
fclose(yyin);
return 0;
}