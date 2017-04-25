%{
#include <cstdio>
#include <iostream>
using namespace std;
#define YY_DECL extern "C" int yylex()

// to get the token types that we return
#include "parser.tab.h"  

int linenum=1;
int c=1;


%}


%%



[ \t\n]			;
[\(\)\{\}\[\]\;=]    { 
			 // shortcut for characters ( , ) ,{ ,} ..etc their values will be returned. 
			 return yytext[0];
		       }
[*]      {
		return yytext[0];
	 }

[/]      { 
		return yytext[0];
	 }

[%]      {
		return yytext[0];
	 }

[+]      { 
		return yytext[0];
	 }

[-]      {
		return yytext[0];
	 }

int 	 { 
		return INT_KEYWORD;
	 }

main     {
		return MAIN_KEYWORD;
	 }

bool     {
		return BOOL;
	 }

true     {
		return TRUE;
	 }

false	 { 
		return FALSE;
	 }

[0-9]+   { 
		yylval.ival = atoi(yytext); 
		return INT;
	 }

[a-zA-Z][a-zA-Z0-9]*  {
		// we have to copy because we can't rely on yytext not changing underneath us:
		yylval.sval = strdup(yytext);
		return IDENTIFIER;
	}

.                ;
%%
