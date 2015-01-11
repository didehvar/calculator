%{
  #include "parser.tab.h"
%}

%option noyywrap
%option yylineno

%%

[0-9]+ {
  yylval.node.type = "int";
  yylval.node.element = atoi(yytext);
  return NUMBER;
}

"(" { return LP; }
")" { return RP; }

"*" { return MUL; }
"/" { return DIV; }

"+" { return ADD; }
"-" { return SUB; }

"<" { return LT; }
">" { return GT; }
"<=" { return LE; }
">=" { return GE; }

"!=" { return NE; }
"==" { return EQ; }

\n { return EOL; }
[ \t] { }

. { fprintf(stderr, "unknown character %c\n", *yytext); }

%%
