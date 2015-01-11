%{
  #include <stdlib.h>
  #include <stdio.h>
  #include <string.h>

  void yyerror(char const*);
  int yylex(void);
  extern int yylineno;
  void yyrestart (FILE*);
%}

%union {
  struct {
    int element;
    const char* type;
  } node;
}

%left EQ NE
%left LT LE GT GE
%left ADD SUB
%left MUL DIV
%left LP RP
%type <node> term expr
%token <node> NUMBER TRUE FALSE
%token EOL

%%

statement:
  | statement EOL {}
  | statement expr EOL {
      printf("result = %d\n\n", $2.element);
    }
  ;

expr: term { $$ = $1; }
  | expr EQ expr { $$.type = "bool"; $$.element = $1.element == $3.element; }
  | expr NE expr { $$.type = "bool"; $$.element = $1.element != $3.element; }
  | expr LT expr { $$.type = "bool"; $$.element = $1.element < $3.element; }
  | expr LE expr { $$.type = "bool"; $$.element = $1.element <= $3.element; }
  | expr GT expr { $$.type = "bool"; $$.element = $1.element > $3.element; }
  | expr GE expr { $$.type = "bool"; $$.element = $1.element >= $3.element; }
  | expr ADD expr { $$.type = "int"; $$.element = $1.element + $3.element; }
  | expr SUB expr { $$.type = "int"; $$.element = $1.element - $3.element; }
  | expr MUL expr { $$.type = "int"; $$.element = $1.element * $3.element; }
  | expr DIV expr {
      if ($3.element != 0) {
        $$.type = "int";
        $$.element = $1.element / $3.element;
      } else {
        yyerror("integer division by zero");
        exit(0);
      }
    }
  ;

term: NUMBER
 | TRUE
 | FALSE { $$ = $1; }
 | LP expr RP { $$ = $2; }
 ;

%%

int main(int argc, char *argv[])
{
  if (argc == 1)
  {
    yyparse();
  }
  else
  {
    for (int i = 1; i < argc; ++i)
    {
      FILE *f = fopen(argv[i], "r");
      yyrestart(f);
      yyparse();
      fclose(f);
    }
  }

  return 0;
}

void yyerror(char const *s) {
  fprintf(stderr, "error: %s at %d\n", s, yylineno);
}
