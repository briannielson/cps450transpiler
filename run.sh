bison -d tran.y
flex tran.l
gcc tran.tab.c lex.yy.c -lfl
./test < test_input.txt
