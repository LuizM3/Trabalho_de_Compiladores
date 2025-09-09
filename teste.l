%option noyywrap
%{
/* −−−−−−−−−−−−−−−−−−−−−−−−−− D e f i n i t i o n s −−−−−−−−−−−−−−−−−−−−−−−−−− */
#include<stdio.h>
%}

digit [0-9]
number {digit}+(\.{digit}+)?
letter [a-zA-Z]
word {letter}+
comment "//"[^\n]*[\n]|"/*"[^"*/"]*"*/"
other .

%%
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