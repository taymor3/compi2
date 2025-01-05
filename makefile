all: part2

part2: part2_lex.o part2.tab.o part2_helper.o  
	gcc -o $@ $^

part2.tab.o: part2.tab.c part2.tab.h
part2_lex.o: part2_lex.c part2.tab.h

part2_helper.o: part2_helpers.c part2_helpers.h
	gcc -c -o $@ part2_helpers.c

part2_lex.c: part2.lex part2.tab.h
	flex part2.lex

part2.tab.c part2.tab.h: part2.y
	bison -d part2.y 

clean:
	rm -f part2 part2_lex.c *.o part2.tab.c part2.tab.h
