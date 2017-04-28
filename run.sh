rm lex.yy.c tran.tab.c tran.tab.h
bison -d tran.y
flex tran.l
gcc tran.tab.c lex.yy.c -lfl -o test
./test < test_input.txt
