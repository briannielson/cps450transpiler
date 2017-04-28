%{
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>

int outfile;
void yyerror(const char *s);
extern int yylex();
extern int yyparse();
extern FILE *yyin;
%}

%left '+' '-'
%left '*' '/' '%'
%left CMP_EQUAL CMP_NOTEQUAL CMP_GREQ CMP_LTEQ '>' '<'

%token RESV_WHILE RESV_TRUE RESV_FALSE RESV_MAIN
%token TYPE_BOOL TYPE_CHAR TYPE_FLOAT TYPE_INT
%token LOG_AND LOG_OR CMP_EQUAL CMP_NOTEQUAL CMP_GREQ CMP_LTEQ '>' '<'

%union 
{
   int ival;
   float fval;
   char *sval;
   char cval;
}

%token <ival> INTEGER
%token <sval> IDENTIFIER
%token <cval> CHAR
%token <fval> FLOAT

%nonassoc RESV_ELSE
%nonassoc RESV_IF

%%

Program  	: TYPE_INT RESV_MAIN '(' ')' '{' Declarations Statements '}' { dprintf(outfile, "Found program\n"); }

Declarations: Declaration Declarations { dprintf(outfile, "Found Declarations...\n"); }
			| ;

Declaration: Type IDENTIFIER ';' { dprintf(outfile, "identifier: %s\n", $2); }
			| Type IDENTIFIER '[' INTEGER ']' ';' { dprintf(outfile, "identifier: %s, size: %d\n", $2, $4); }

Type  		: TYPE_BOOL { dprintf(outfile, "type: boolean\n"); }
			| TYPE_CHAR { dprintf(outfile, "type: character\n"); }
			| TYPE_FLOAT { dprintf(outfile, "type: float\n"); }
			| TYPE_INT { dprintf(outfile, "type: int\n"); };

Statements 	: Statement Statements { dprintf(outfile, "found statement block\n"); }
			| { dprintf(outfile, "No more statements...\n"); }

Statement 	: ';' { dprintf(outfile, "End of line (;)\n"); }
			| Block { dprintf(outfile, "Code block found\n"); }
			| Assignment { dprintf(outfile, "Assignment found\n"); }
			| Ifstate { dprintf(outfile, "If statement found\n"); }
			| Whilestate { dprintf(outfile, "While statement found\n"); }

Block		: '{' Statements '}' {}

Assignment	: IDENTIFIER '=' Expression ';' { dprintf(outfile, "identifier: %s\n", $1); }
			| IDENTIFIER '[' Expression ']' '=' Expression ';' { 
				dprintf(outfile, "identifier: %s\n", $1); 
			}

Ifstate		: RESV_IF '(' Expression ')' Statement { dprintf(outfile, "If statement\n"); } 
			| RESV_IF '(' Expression ')' Statement RESV_ELSE Statement { dprintf(outfile, "If else statement\n"); }

Whilestate	: RESV_WHILE '(' Expression ')' Statement { dprintf(outfile, "While statement\n"); }

Expression	: Conjunction {}
			| Conjunction LOG_OR Conjunction { dprintf(outfile, "OR statement\n"); }

Conjunction : Equality {}
			| Equality LOG_AND Equality { dprintf(outfile, "AND statement\n"); };

Equality	: Relation {}
			| Relation EquOp Relation { dprintf(outfile, "Compare\n"); };

EquOp		: CMP_EQUAL | CMP_NOTEQUAL;

Relation	: Addition {}
			| Addition RelOp Addition { dprintf(outfile, "Relation\n"); };

RelOp		: '<' | CMP_LTEQ | CMP_GREQ | '>';

Addition	: Term {}
			| Term AddOp Term { dprintf(outfile, "Adding terms\n"); };

AddOp		: '+' | '-' {}

Term		: Factor {}
			| Factor MulOp Factor { dprintf(outfile, "Multiplying terms\n"); };

MulOp		: '*' | '/' | '%' {}

Factor		: Primary {}
			| UnaryOp Primary { dprintf(outfile, "Unary Op found\n"); }

UnaryOp		: '-' | '!' {}

Primary 	: IDENTIFIER '[' Expression ']' { dprintf(outfile, "Array %s\n", $1); }
			| Literal
			| '(' Expression ')' { dprintf(outfile, "EXTREME RECURSION (primary --> Expression)\n"); }
			| Type '(' Expression ')' { dprintf(outfile, "Casting\n"); }

Literal		: INTEGER { dprintf(outfile, "Integer found: %d\n", $1); }
			| FLOAT { dprintf(outfile, "Float found: %f\n", $1); }
			| CHAR { dprintf(outfile, "Character found: %c\n", $1); }
			| RESV_TRUE { dprintf(outfile, "boolean TRUE found\n"); }
			| RESV_FALSE { dprintf(outfile, "boolean FALSE found\n"); }

%%

void print(char *s, char *text)
{
	dprintf(outfile, "Lex: %s %s\n", s, text);
}

int main(void) {

	outfile = open("output.txt", O_WRONLY | O_CREAT);
	
	if (outfile < 0) {
		fprintf(stderr, "Yacc: Could not open output file\n");
		return 1;
	}
	yyparse();

	close(outfile);
	return 0;
}

void yyerror(const char *s) {
	fprintf(stderr, "%s\n", s);
	exit(-1);
}
