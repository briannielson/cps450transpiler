/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_TRAN_TAB_H_INCLUDED
# define YY_YY_TRAN_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    CMP_EQUAL = 258,
    CMP_NOTEQUAL = 259,
    CMP_GREQ = 260,
    CMP_LTEQ = 261,
    UMINUS = 262,
    RESV_IF = 263,
    RESV_WHILE = 264,
    RESV_TRUE = 265,
    RESV_FALSE = 266,
    RESV_MAIN = 267,
    LPARAN = 268,
    TYPE_BOOL = 269,
    TYPE_CHAR = 270,
    TYPE_FLOAT = 271,
    TYPE_INT = 272,
    LOG_AND = 273,
    LOG_OR = 274,
    INTEGER = 275,
    IDENTIFIER = 276,
    CHAR = 277,
    FLOAT = 278,
    EOL = 279,
    RESV_ELSE = 280,
    RPARAN = 281
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 28 "tran.y" /* yacc.c:1909  */

   int ival;
   float fval;
   char *sval;
   char cval;

#line 88 "tran.tab.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_TRAN_TAB_H_INCLUDED  */
