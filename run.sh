bison -d parser.y
flex flex_code.l
g++ parser.tab.c lex.yy.c -lfl
./a.out 
