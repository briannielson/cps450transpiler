%{
#include <cstdio>
#include <iostream>
#include <fstream>

using namespace std;

extern "C" int yylex();
extern "C" int yyparse();
extern "C" FILE *yyin;


void yyerror(const char *s);
ofstream outfile;
%}

%union
{
   int ival;
   char *sval;
}
%left '+' '-'
%left '*' '/' '%'


%token DIGIT
%token INT_KEYWORD
%token MAIN_KEYWORD
%token BOOL
%token TRUE
%token FALSE


%token <ival> INT
%token <sval> IDENTIFIER



%%


program:  INT_KEYWORD MAIN_KEYWORD '(' ')' '{' Declarations Statements '}' { outfile << "Program encountered" << endl; }
	 ;

Declarations:
	     | Declarations Declaration
	     ;

Declaration:  Type IDENTIFIER ';'  { outfile << "Id=" << $2 << endl;}
	      | Type IDENTIFIER '[' INT ']' ';' { outfile << "Id=" << $2 << endl ;
					      outfile << "Size=" << $4   << endl;}
	      ;

Type: INT_KEYWORD { outfile << "Int declaration encountered" << endl; }
      | BOOL { outfile << "Boolean declaration encountered" << endl;}
	;

Statements:
	    | Statements statement
	    ;

statement:
	    Assignment
	    | ';'
	    ;

Assignment: IDENTIFIER '=' Expression ';' { outfile << "Assignment operation encountered" << endl; }
	    | IDENTIFIER '[' Expression ']' '=' Expression ';' { outfile << "Assignment operation encountered" << endl; }
	    ;

Expression: Term Third
	    ;
Third:
	| Third '+' Term {  outfile << "Addition expression encountered" << endl; }
	| Third '-' Term  {  outfile << "Subtraction expression encountered" << endl; }
	;

Term: Factor Second
	;

Second:
	| Second '*' Factor {outfile << "Multiplication expression encountered" << endl; }
	| Second '/' Factor {outfile << "Division expression encountered" << endl; }
	| Second '%' Factor  {outfile << "Modulus expression encountered" << endl; }
	;



Factor:  IDENTIFIER '[' Expression ']'
	| IDENTIFIER
	| Literal
	| '(' Expression ')'
	;

Literal: INT { outfile << "Integer literal encountered" << endl;
		outfile << "Value=" << $1 << endl; }
	| Boolean
	;
Boolean: TRUE { outfile << "Boolean literal encountered" << endl;
		outfile << "Value=true" << endl; }
	| FALSE { outfile << "Boolean literal encountered" << endl;
		outfile << "Value=false" << endl; }
	;

//my code

If statement:  if(Expression) statement[else statement]
  ;

While statement: while (Expression) statement
  ;

conjunction: Equality {&& Equality }
	;

Equality: Relation [EquOp Relation]
	;




EquOp:
	;




relation: Addition [RelOp Addition]
  ;

Addition: Term {AddOp Term}
	;

UnaryOp:
  ;

Primary: Identifier [[Expression]]
  | Literal
  | (Expression)
  | Type (Expression)
  ;

float: Integer. Integer
	;

Char: 
	;



  %%





int main(int, char**) {
	FILE *myfile = fopen("test_input.txt", "r");
	// Input file
	if (!myfile) {
		cout <<"Input file not found!" << endl;
		return -1;
	}
	// output file bison_output.txt
	outfile.open("bison_output.txt");

	// set flex to read from it instead of defaulting to STDIN:
	yyin = myfile;

	// parse through the input until there is no more:
	do {
		yyparse();
	} while (!feof(yyin));

	// close output file
	outfile.close();
	cout << "Successful parse" << endl;
}

void yyerror(const char *s) {
	// Some Invalid syntax
	cout << "Invalid Program" << endl;
	exit(-1);
}
