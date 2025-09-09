%option noyywrap yylineno
%{
/* −−−−−−−−−−−−−−−−−−−−−−−−−− D e f i n i t i o n s −−−−−−−−−−−−−−−−−−−−−−−−−− */
#include<stdio.h>

int column_number = 1;
%}

digit. [0-9]
number {digit}+(\.{digit}+)?
letter [a-zA-Z]
word {letter}+
comment "//"[.*]
delim [ \t\n]
ws {delim}+
other .

%%  
%{
/* −−−−−−−−−−−−−−−−−−−−−−−−−−−−− Rules −−−−−−−−−−−−−−−−−−−−−−−−−−−−− */
%}
{number} { fprintf(yyout,"%d(%d): %s (NUMBER)\n", yylineno,column_number,yytext); column_number+=yyleng; }
{comment} { fprintf(yyout,"%d(%d): %s (COMMENT)\n", yylineno,column_number,yytext); column_number+=yyleng; }
{ws} {}
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