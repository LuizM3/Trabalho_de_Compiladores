%option noyywrap yylineno
%{
/* −−−−−−−−−−−−−−−−−−−−−−−−−− D e f i n i t i o n s −−−−−−−−−−−−−−−−−−−−−−−−−− */
#include<stdio.h>
#include<string.h> // Adicionado para strcmp e strdup
#include<stdlib.h>  // Adicionado para mallo
#include "parser.h"

extern void inserir(const char*, const char*, int, int);

int column_number = 1;

%}

/* Definições de regra */
digit       [0-9]
number      {digit}+
letter      [a-zA-Z_]
identifier  {letter}({letter}|{digit})*
ws          [ \t]+
comment     "//"[^\n]*|"/*"[^"*/"]*"*/"

%%

%{
/* −−−−−−−−−−−−−−−−−−−−−−−−−−−−− Palavras reservadas −−−−−−−−−−−−−−−−−−−−−−−−−−−−− */
%}

"if"       { inserir(yytext, "RESERVADA", yylineno, column_number); column_number+=yyleng; return IF; }
"else"     { inserir(yytext, "RESERVADA", yylineno, column_number); column_number+=yyleng; return ELSE; }
"while"    { inserir(yytext, "RESERVADA", yylineno, column_number); column_number+=yyleng; return WHILE; }
"print"    { inserir(yytext, "RESERVADA", yylineno, column_number); column_number+=yyleng; return PRINT; }
"read"     { inserir(yytext, "RESERVADA", yylineno, column_number); column_number+=yyleng; return READ; }
"true"     { inserir(yytext, "RESERVADA", yylineno, column_number); column_number+=yyleng; return TRUE;  }
"false"    { inserir(yytext, "RESERVADA", yylineno, column_number); column_number+=yyleng; return FALSE; }
"return"   { inserir(yytext, "RESERVADA", yylineno, column_number); column_number+=yyleng; return RETURN; }
"main"     { inserir(yytext, "RESERVADA", yylineno, column_number); column_number+=yyleng; return MAIN; }


%{
/* −−−−−−−−−−−−−−−−−−−−−−−−−−−−− Declaração de tipos −−−−−−−−−−−−−−−−−−−−−−−−−−−−− */
%}

"int"      { inserir(yytext, "TIPO", yylineno, column_number); column_number+=yyleng; return INT; }
"bool"     { inserir(yytext, "TIPO", yylineno, column_number); column_number+=yyleng; return BOOL;  }

%{
/* −−−−−−−−−−−−−−−−−−−−−−−−−−−−− Operadores Aritméticos −−−−−−−−−−−−−−−−−−−−−−−−−−−−− */
%}

"+" { inserir(yytext, "OPER_ARIT", yylineno, column_number); column_number+=yyleng; return PLUS; }
"-" { inserir(yytext, "OPER_ARIT", yylineno, column_number); column_number+=yyleng; return MINUS; }
"*" { inserir(yytext, "OPER_ARIT", yylineno, column_number); column_number+=yyleng; return TIMES; }
"/" { inserir(yytext, "OPER_ARIT", yylineno, column_number); column_number+=yyleng; return DIVIDE; }
"^" { inserir(yytext, "OPER_ARIT", yylineno, column_number); column_number+=yyleng; return ELEVA; }
"%" { inserir(yytext, "OPER_ARIT", yylineno, column_number); column_number+=yyleng; return RESTO; }
"=" { inserir(yytext, "OPER_ARIT", yylineno, column_number); column_number+=yyleng; return EQUALS; }

%{
/* −−−−−−−−−−−−−−−−−−−−−−−−−−−−− Operadores Relacionais −−−−−−−−−−−−−−−−−−−−−−−−−−−−− */
%}

"<"  { inserir(yytext, "OPER_RELA", yylineno, column_number); column_number+=yyleng; return LT; }
">"  { inserir(yytext, "OPER_RELA", yylineno, column_number); column_number+=yyleng; return MT; }
"<=" { inserir(yytext, "OPER_RELA", yylineno, column_number); column_number+=yyleng; return LE; }
">=" { inserir(yytext, "OPER_RELA", yylineno, column_number); column_number+=yyleng; return ME; }
"==" { inserir(yytext, "OPER_RELA", yylineno, column_number); column_number+=yyleng; return ET; }
"!=" { inserir(yytext, "OPER_RELA", yylineno, column_number); column_number+=yyleng; return DT; }

%{
/* −−−−−−−−−−−−−−−−−−−−−−−−−−−−− Operadores Lógicos −−−−−−−−−−−−−−−−−−−−−−−−−−−−− */
%}

"&" { inserir(yytext, "OPER_LOGI", yylineno, column_number); column_number+=yyleng; return AND; }
"|" { inserir(yytext, "OPER_LOGI", yylineno, column_number); column_number+=yyleng; return OR; }
"!" { inserir(yytext, "OPER_LOGI", yylineno, column_number); column_number+=yyleng; return NOT; }

%{
/* −−−−−−−−−−−−−−−−−−−−−−−−−−−−− Símbolos de Pontuação −−−−−−−−−−−−−−−−−−−−−−−−−−−−− */
%}

";" { inserir(yytext, "PONTUACAO", yylineno, column_number); column_number+=yyleng; return SEMI; }
"," { inserir(yytext, "PONTUACAO", yylineno, column_number); column_number+=yyleng; return COMMA; }
"(" { inserir(yytext, "PONTUACAO", yylineno, column_number); column_number+=yyleng; return OP; }
")" { inserir(yytext, "PONTUACAO", yylineno, column_number); column_number+=yyleng; return CP; }
"{" { inserir(yytext, "PONTUACAO", yylineno, column_number); column_number+=yyleng; return OC; }
"}" { inserir(yytext, "PONTUACAO", yylineno, column_number); column_number+=yyleng; return CC; }

%{
/* −−−−−−−−−−−−−−−−−−−−−−−−−−−−− Rules −−−−−−−−−−−−−−−−−−−−−−−−−−−−− */
%}

{number} { inserir(yytext, "NUMBER", yylineno, column_number); column_number+=yyleng; return NUMBER;}

{identifier} { inserir(yytext, "IDENTIFIER", yylineno, column_number); column_number+=yyleng; return IDENTIFIER; }

{comment} { }
{ws} { column_number += yyleng; }
\n { column_number = 1; } //reseta a contagem de colunas
.   { fprintf(yyout, "Lexical error. Input -> \"%d(%d): %s\"\n", yylineno,column_number,yytext);
      column_number+=yyleng; }

%%

/* −−−−−−−−−−−−−−−−−−−−−−−− User s u b r o t i n e s −−−−−−−−−−−−−−−−−−−−−−−− */

