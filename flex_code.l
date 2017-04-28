%{
#include <stdio.h>
#include "y.tab.h"

int output = open("lex_output.txt", "w");
int invalid = 0;

void printkey();
void printcmp();
void printop();
%}

%%

\/\/.*\n			{ fprintf(outfile, "Inline comment: %s\n", yytext); }
[/*][^(*/)]*[*/] 	{ fprintf(outfile, "Multiline comment: \n\n%s\n\n", yytext);}

"bool"		{ printkey(); return TYPE_BOOL;  }
"char" 		{ printkey(); return TYPE_CHAR;  }
"float"		{ printkey(); return TYPE_FLOAT; }
"int"		{ printkey(); return TYPE_INT;   }

"if"		{ printkey(); return RESV_IF;	 }
"else"		{ printkey(); return RESV_ELSE;	 }
"while"		{ printkey(); return RESV_WHILE; }
"return"	{ printkey(); return RESV_RET;	 }
"main"		{ printkey(); return RESV_MAIN;	 }

"&&" { printop(); return LOG_AND; }
"||" { printop(); return LOG_OR;  }

"==" { printcmp(); return CMP_EQUAL; }
"!=" { printcmp(); return CMP_NOTEQUAL; }
">=" { printcmp(); return CMP_GREQ; }
"<=" { printcmp(); return CMP_LTEQ; }

"true"  { fprintf(outfile, "Boolean literal: true\n",  yytext); return RESV_TRUE; }
"false" { fprintf(outfile, "Boolean literal: false\n", yytext); return RESV_FALSE; }

[([0-9]*\.[0-9]+)|([0-9]+\.[0-9]*)] {
			  fprintf(outfile, "Float: %s\n", yytext); 
			  yylval = atoi(yytext);
			  return FLOAT;
			}

[0-9]+	{ 
			  fprintf(outfile, "Integer: %s\n", yytext); 
			  yylval = atoi(yytext);
			  return INTEGER;
			}

[A-Za-z_][A-Za-z_0-9]*  {
		fprintf(outfile, "Identifier: %s", yytext);
		yylval.sval = strdup(yytext);
		return IDENTIFIER;
	}

[>|<] { printcmp(); return yytext[0]; }

"(" { fprintf(outfile, "Open paranthesis\n"); return yytext[0]; }
")" { fprintf(outfile, "Close paranthesis\n"); return yytext[0]; }
"{" { fprintf(outfile, "Open bracket\n"); return yytext[0]; }
"}" { fprintf(outfile, "Close bracket\n"); return yytext[0]; }
";" { fprintf(outfile, "Semicolon\n"); return yytext[0]; }
"="	{ fprintf(outfile, "AssignmentOp\n"); return yytext[0]; }

[*|/|%|+|-|!] { printop(); return yytext[0]; }

[ \t\n]			{ }
.               { invalid = 1; }
%%

void printkey() { fprintf(outfile, "Keyword: %s\n", yytext);  }
void printcmp() { fprintf(outfile, "Comparison: %s\n", yytext); }
void printop () { fprintf(outfile, "Operator: %s\n", yytext); }

int yyerror(char *s) {
	fprintf(stderr, "%s\n", s);
	return 0;
}

int main(void)
{
	outfile = open("flex_output.txt", "w");

	if (outfile < 0) {
		fprintf(stderr, "Could not open output file \"flex_output.txt\" for output\n");
		return 2;
	}

	yylex();
	close(outfile);

	if (invalid) {
		fprintf(stderr, "Syntax error\n");
		return 4;
	}
	fprintf(stderr, "Success\n");
	return 0;
}