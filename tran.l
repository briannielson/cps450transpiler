%{
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include "tran.tab.h"

int invalid = 0;

void printkey();
void printcmp();
void printop();
void comment();
void print(char *s, char *q);
%}

%%

\/\/.*\n			{ print("Inline comment: ", yytext); }
"/*"	{ print("Multiline comment: ", yytext); comment(); }

"bool"		{ printkey(); return TYPE_BOOL;  }
"char" 		{ printkey(); return TYPE_CHAR;  }
"float"		{ printkey(); return TYPE_FLOAT; }
"int"		{ printkey(); return TYPE_INT;   }

"if"		{ printkey(); return RESV_IF;	 }
"else"		{ printkey(); return RESV_ELSE;	 }
"while"		{ printkey(); return RESV_WHILE; }
"main"		{ printkey(); return RESV_MAIN;	 }

"&&" { printop(); return LOG_AND; }
"||" { printop(); return LOG_OR;  }

"==" { printcmp(); return CMP_EQUAL; }
"!=" { printcmp(); return CMP_NOTEQUAL; }
">=" { printcmp(); return CMP_GREQ; }
"<=" { printcmp(); return CMP_LTEQ; }

"true"  { print("Boolean literal: ",  yytext); return RESV_TRUE; }
"false" { print("Boolean literal: ", yytext); return RESV_FALSE; }

[0-9]+	{ 
			  print("Integer: ", yytext); 
			  yylval.ival = atoi(yytext);
			  return INTEGER;
			}

[[0-9]*\.[0-9]+|[0-9]+\.[0-9]*] {
			  print("Float: ", yytext); 
			  yylval.fval = atof(yytext);
			  return FLOAT;
			}

			
\'[^']{1}\'	{ //'
			  print("Character: ", yytext); 
			  yylval.cval = yytext[0];
			  return CHAR;
}

[A-Za-z_][A-Za-z_0-9]*  {
		print("Identifier: ", yytext);
		yylval.sval = strdup(yytext);
		return IDENTIFIER;
	}

[>|<] { printcmp(); return yytext[0]; }

"(" { print("Open paranthesis", yytext); return yytext[0]; }
")" { print("Close paranthesis", yytext); return yytext[0]; }
"{" { print("Open bracket", yytext); return yytext[0]; }
"}" { print("Close bracket", yytext); return yytext[0]; }
";" { print("Semicolon", yytext); return EOL; }
"="	{ print("AssignmentOp", yytext); return yytext[0]; }

[*|/|%|+|-|!] { printop(); return yytext[0]; }

[ \t\n]			{ }
.               { invalid = 1; }
%%

void printkey() { print("Keyword: ", yytext);  }
void printcmp() { print("Comparison: ", yytext); }
void printop () { print("Operator: ", yytext); }

void comment()
{
	/* Taken from http://www.lysator.liu.se/c/ANSI-C-grammar-l.html */
	char c1, c2;

	loop:
		while ((c1 = input()) != '*' && c1 != 0);

		if ((c2 = input()) != '/' && c1 != 0)
			goto loop;
}

int yywrap(void)
{
	return 1;
}