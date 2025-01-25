%option noyywrap

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "parser.tab.h"

/* 'extern' reference to reverseNumber, defined in parser.y */
extern int reverseNumber(int num);

%}

/* Rules section */
%%
[ \t\r\n]+             {  }
[a-zA-Z_][a-zA-Z0-9_]* { yylval.sval = strdup(yytext); return ID; }
"="                    { return ASSIGN; }
";"                    { return SEMICOL; }
"("                    { return LPAREN; }
")"                    { return RPAREN; }
"+"                    { return PLUS; }
"-"                    { return MINUS; }
"*"                    { return MUL; }
"/"                    { return DIV; }
[0-9]+                 {
    int val = atoi(yytext);
    if (val % 10 != 0) {
        val = reverseNumber(val);
    }
    yylval.ival = val;
    return NUM;
}
.                      {
    fprintf(stderr, "Lexical Error: unknown token '%s'\n", yytext);
    exit(1);
}
%%
