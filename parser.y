%{
#include <stdio.h>
%}

%left '+' '-'
%left '*' '/' '%'
%left CMP_EQUAL CMP_NOTEQUAL CMP_GREQ CMP_LTEQ '>' '<'

%token CHAR FLOAT INTEGER BOOLEAN IDENTIFIER
%token RESV_IF RESV_ELSE RESV_WHILE RESV_RET RESV_TRUE RESV_FALSE
%token TYPE_BOOL TYPE_CHAR TYPE_FLOAT TYPE_INT
%token LOG_AND LOG_OR CMP_EQUAL CMP_NOTEQUAL CMP_GREQ CMP_LTEQ '>' '<'

%%

Program  	: TYPE_INT "main" '(' ')' '{' Declarations Statements '}' {};
Declarations: Declaration Declarations {}
			| ;
Declaration: Type IDENTIFIER {} ';'
			| Type IDENTIFIER '[' INTEGER ']' ';' {};
Type  		: TYPE_BOOL {}
			| TYPE_CHAR {}
			| TYPE_FLOAT {}
			| TYPE_INT {};
Statements 	: Statement Statements {}
			| ;
Statement 	: ';' {}
			| Block {}
			| Assignment {}
			| Ifstate {}
			| Whilestate {};
Block		: '{' Statements '}' {};
Assignment	: IDENTIFIER '=' Expression ';' {}
			| IDENTIFIER '[' Expression ']' '=' Expression ';' {};
Ifstate		: RESV_IF '(' Expression ')' Statement {}
			| RESV_IF '(' Expression ')' Statement RESV_ELSE Statement {};
Whilestate	: RESV_WHILE '(' Expression ')' Statement {};
Expression	: Conjunction {}
			| Conjunction LOG_OR Conjunction {};
Conjunction : Equality {}
			| Equality LOG_AND Equality {};
Equality	: Relation {}
			| Relation EquOp Relation {};
EquOp		: CMP_EQUAL | CMP_NOTEQUAL;
Relation	: Addition {}
			| Addition RelOp Addition {};
RelOp		: '<' | CMP_LTEQ | CMP_GREQ | '>';
Addition	: Term {}
			| Term AddOp Term {};
AddOp		: '+' | '-' {};
Term		: Factor {}
			| Factor MulOp Factor {};
MulOp		: '*' | '/' | '%' {};
Factor		: UnaryOp Primary {}
			| Primary {};
UnaryOp		: '-' | '!' {};
Primary 	: IDENTIFIER '[' Expression ']' {}
			| Literal
			| '(' Expression ')'
			| Type '(' Expression ')';
Literal		: INTEGER | FLOAT | CHAR | Boolean {};
Boolean 	: RESV_TRUE | RESV_FALSE {};

%%

int main(void) {
	yyparse();
	return 0;
}

void yyerror(const char *s) {
	fprintf(stderr, "%s\n", s);
	exit(-1);
}
