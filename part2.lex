%{

/* declarations */
#include <stdio.h>
#include <stdlib.h>
#include "part2_helpers.h"
#include "part2.h"
#include "part2.tab.h"
%}
/* definitions */
%option outfile="part2_lex.c"
%option yylineno
%option noyywrap

digit        ([0-9])
letter       ([a-zA-Z])
whitespace   ([ \t\n])
keyword      int|float|void|write|read|va_arg|while|do|if|then|else|return
symbol       [(){},;:]|\.{3}
id           {letter}({letter}|{digit}|_)*
integernum   {digit}+
realnum      {digit}+\.{digit}+
str          \"([^"\\\n\r]|\\[tn"])*\"
relop        "=="|"<>"|"<"|"<="|">"|">="
addop        "+"|"-"
mulop        "*"|"/"
assign       "="
and          "&&"
or           "||"
not          "!"
comment      "#"[^\n]*

/* rules */
%%

int	{
	yylval = makeNode("int", NULL, NULL);
	return tk_int;
}

float {
	yylval = makeNode("float", NULL, NULL);
	return tk_float;
}

void {
	yylval = makeNode("void", NULL, NULL);
	return tk_void;
}

write {
	yylval = makeNode("write", NULL, NULL);
	return tk_write;
}

read {
	yylval = makeNode("read", NULL, NULL);
	return tk_read;
}

va_arg {
	yylval = makeNode("va_arg", NULL, NULL);
	return tk_va_arg;
}

while {
	yylval = makeNode("while", NULL, NULL);
	return tk_while;
}

do {
	yylval = makeNode("do", NULL, NULL);
	return tk_do;
}

if {
	yylval = makeNode("if", NULL, NULL);
	return tk_if;
}

then {
	yylval = makeNode("then", NULL, NULL);
	return tk_then;
}

else {
	yylval = makeNode("else", NULL, NULL);
	return tk_else;
}

return {
	yylval = makeNode("return", NULL, NULL);
	return tk_return;
}

{symbol} {
	yylval = makeNode(yytext, NULL, NULL);
	if (yytext[0] != '.') {
		return yytext[0];
	} else {
		return tk_ellipsis;
	}
}

{integernum} {
	yylval = makeNode("integernum", yytext, NULL);
	return tk_integernum;
}

{realnum} {
	yylval = makeNode("realnum", yytext, NULL);
	return tk_realnum;
}

{id} {
	yylval = makeNode("id", yytext, NULL);
	return tk_id;
}

{relop} {
	yylval = makeNode("relop", yytext, NULL);
	return tk_relop;
}

{addop} {
	yylval = makeNode("addop", yytext, NULL);
	return tk_addop;
}

{mulop} {
	yylval = makeNode("mulop", yytext, NULL);
	return tk_mulop;
}

{assign} {
	yylval = makeNode("assign", yytext, NULL);
	return tk_assign;
}

{and} {
	yylval = makeNode("and", yytext, NULL);
	return tk_and;
}

{or} {
	yylval = makeNode("or", yytext, NULL);
	return tk_or;
}

{not} {
	yylval = makeNode("not", yytext, NULL);
	return tk_not;
}

{str}	{
			char* trim = yytext;
			trim[yyleng-1] = 0; /* remove ending " */
			trim++; /* remove starting " */
			yylval = makeNode("str", trim, NULL);
			return tk_str;
}

{comment}			;
{whitespace}		;

.   { printf("\nLexical error: '%s' in line number %d\n", yytext, yylineno);
	  exit(1);
	}

%% 
