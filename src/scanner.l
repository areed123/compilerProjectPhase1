
/* definitions */

%{
#include <stdio.h>
#include <stdlib.h>
#include "tokendef.h"

 /* integers to track line and column numbers */
int scancol = 1;
int yycol = 1;
int scanlineno = 1;

 
char *yyerror;

void updateCol();
void countLines();

int processString();


%}

newline \n
whitespace [\t ]+
integer [0]|[1-9][0-9]*
integerlead0 [0]+[0-9]*
character \'(.|\\n|\\t|\\|\")\'

string \"([^"\n]|(\"))*\"
untermstring \"[^"\n]*\n

commentstart \/\*

identifier [a-zA-Z][a-zA-Z0-9]*
illidentifier [a-zA-Z][^a-zA-Z0-9]


%%

if {
   updateCol();
   return KWD_IF;
 }
else {
   updateCol();
   return KWD_ELSE;
 }
while {
   updateCol();
   return KWD_WHILE;

}
int {
   updateCol();
   return KWD_INT;
}

string {
   updateCol();
   return KWD_STRING;
}
char {
   updateCol();
   return KWD_CHAR;
}
return {
   updateCol();
   return KWD_RETURN;
}
void {
   updateCol();
   return KWD_VOID;
}
\+ {
   updateCol();
   return OPER_ADD;
 }
\* {
   updateCol();
   return OPER_MUL;
 }
\/ {
   updateCol();
   return OPER_DIV;
 }
% {
   updateCol();
   return OPER_MOD;
 }
\< {
   updateCol();
    return OPER_LT;
 }
\> {
   updateCol();
    return OPER_GT;
 }
\<= {
   updateCol();
    return OPER_LTE;
 }
>= {
   updateCol();
    return OPER_GTE;
 }
== {
   updateCol();
    return OPER_EQ;
 }
!= {
   updateCol();
    return OPER_NEQ;
 }
= {
   updateCol();
    return OPER_ASGN;
 }
\[ {
   updateCol();
    return LSQ_BRKT;
 }
\] {
   updateCol();
    return RSQ_BRKT;
 }
\{ {
   updateCol();
    return LCRLY_BRKT;
 }
\} {
   updateCol();
    return RCRLY_BRKT;
 }
\( {
   updateCol();
    return LPAREN;
 }
\) {
   updateCol();
    return RPAREN;
 }
, {
   updateCol();
    return COMMA;
 }
; {
   updateCol();
    return SEMICLN;
 }
@ {
   updateCol();
    return OPER_AT;
 }
\+\+ {
   updateCol();
    return OPER_INC;
 }
-- {
   updateCol();
    return OPER_DEC;
 }
&& {
   updateCol();
   return OPER_AND;
 }
\|\| {
   updateCol();
   return OPER_OR;
 }
! {
   updateCol();
    return OPER_NOT;
 }

{identifier} {
		updateCol(); 
		return ID;
}

{illidentifier} {
		updateCol();
 		yyerror="Ill Identifier";
		return ERROR;
}

{integer} {
		updateCol();
		return INTCONST;
}
{integerlead0} {
		updateCol(); 
		yyerror= "Integers may not have leading zeros";
		return ERROR;
}
{character} {
		updateCol(); 
		return CHARCONST;
}
{string}        {
		updateCol(); 
		return processString();
}
{untermstring}  {
		updateCol(); 
		yyerror = "Unterminated string constant"; 
		return ERROR;
}

{commentstart} {
   int c;
   int prev = 0;
   while (1) {
      c = input();
      if (c == EOF) {
         updateCol();
         yyerror = "Unterminated comment";
         return ERROR;
      }
      if (c == '*' && prev == '/') {
         break;
      }
      prev = c;
   }
}

{newline}       {
		countLines();
}
{whitespace} {
	updateCol();
}
.	{
   yyerror="Illegal token";
	return ILLEGAL_TOK;
}


%%


void updateCol(){
    yycol=scancol;
    scancol+=yyleng;
}


void countLines(){
    scancol=1;
    scanlineno++;
    yylineno=scanlineno;
}


/* TODO:
Implement this function to
check for illegal escape sequences in string literals
and
convert valid escape sequences into escaped characters
(string[0] == '\\' and string[1] == 'n', then string[0] should be '\n')
*/
int processString(){
    int i = 1;
    int j = 0;
    char q = yytext[0];
    while (q != '\0'){
        //TODO: Identify valid escape sequences and return ERROR or ILLEGAL if invalid escape sequences exist in the string

        //Valid escape sequences \\, \n, \t, \"   ALL OTHERS ARE ILLEGAL
        if( q == '\\'){
            switch(yytext[++i]){
                case '\\':
                    yytext[j]='\\';
                    break;
                case 'n':
                    yytext[j]='\n';
                    break;
                case 't':
                    yytext[j]='\t';
                    break;
                case '\"':
                    yytext[j]='\"';
                    break;
                default:
                    yyerror="Unrecognized escape character in String";
		    yycol+=i;
                    return ERROR;
                }
        }
        else{
            yytext[j]=yytext[i];
        }
        q=yytext[++i];
        j++;
    }
    yytext[j-1]='\0';
    return STRCONST;
}
