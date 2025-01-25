%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "parser.tab.h"

/*
  IMPORTANT: Declare yylex(void) here to avoid the implicit declaration warning.
  Bison uses YYLEX which expands to yylex(), so having this prototype is crucial.
*/
int yylex(void);

/* Bison's error reporting function. */
void yyerror(const char *s) {
    fprintf(stderr, "Parse Error: %s\n", s);
}

/* Define reverseNumber exactly once here */
int reverseNumber(int num) {
    int rev = 0;
    int sign = (num < 0) ? -1 : 1;
    num = abs(num);
    while (num != 0) {
        rev = rev * 10 + (num % 10);
        num /= 10;
    }
    return rev * sign;
}

/* For generating temporary variable names, e.g. t0, t1, t2... */
static int tempCount = 0;
char* newTemp() {
    char buf[16];
    sprintf(buf, "t%d", tempCount++);
    return strdup(buf);
}
%}

/* The union for our semantic values */
%union {
    int ival;     /* For NUM */
    char* sval;   /* For ID */
    struct {
        int val;
        char* addr;
    } info;
}

/* Tokens with their union fields */
%token <sval> ID
%token <ival> NUM
%token ASSIGN SEMICOL LPAREN RPAREN PLUS MINUS MUL DIV

/*
  Reverse precedence:
  %left MUL DIV   => lowest, left-associative
  %right PLUS MINUS => highest, right-associative
*/
%left MUL DIV
%right PLUS MINUS

%type <info> E
%start S

%%
S : ID ASSIGN E SEMICOL
    {
      printf("\n--- Three-Address Code ---\n");
      printf("%s = %s;\n", $1, $3.addr);
      printf("Result: %d\n", $3.val);
    }
  ;

/* Expression grammar with reversed precedence */
E : E PLUS E
    {
      int r = $1.val + $3.val;
      if (r % 10 != 0) r = reverseNumber(r);
      char* t = newTemp();
      printf("%s = %s+%s;\n", t, $1.addr, $3.addr);
      $$.val = r;
      $$.addr = t;
    }
  | E MINUS E
    {
      int r = $1.val - $3.val;
      if (r % 10 != 0) r = reverseNumber(r);
      char* t = newTemp();
      printf("%s = %s-%s;\n", t, $1.addr, $3.addr);
      $$.val = r;
      $$.addr = t;
    }
  | E MUL E
    {
      int r = $1.val * $3.val;
      if (r % 10 != 0) r = reverseNumber(r);
      char* t = newTemp();
      printf("%s = %s*%s;\n", t, $1.addr, $3.addr);
      $$.val = r;
      $$.addr = t;
    }
  | E DIV E
    {
      if ($3.val == 0) {
          fprintf(stderr, "Error: divide by zero!\n");
          exit(1);
      }
      int r = $1.val / $3.val;
      if (r % 10 != 0) r = reverseNumber(r);
      char* t = newTemp();
      printf("%s = %s/%s;\n", t, $1.addr, $3.addr);
      $$.val = r;
      $$.addr = t;
    }
  | LPAREN E RPAREN
    {
      $$.val  = $2.val;
      $$.addr = $2.addr;
    }
  | NUM
    {
      char* t = newTemp();
      printf("%s = %d;\n", t, $1);
      $$.val = $1;
      $$.addr = t;
    }
  ;
%%
/* A main function that calls yyparse(). */
int main(void) {
    printf("Type an assignment (e.g.: x = 30+21/6*14; )\n");
    return yyparse();
}
