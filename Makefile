all:
	/usr/local/Cellar/bison/3.0.2/bin/bison -d parser.y
	flex scanner.l
	gcc parser.tab.c lex.yy.c -ll -o jampile

clean:
	rm -rf parser.tab.c
	rm -rf parser.tab.h
	rm -rf lex.yy.c
	rm -rf jampile
