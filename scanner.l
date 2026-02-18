
/* definitions */

%{
#include <stdio.h>
#include <stdlib.h>
#include "tokendef.h"

 /* integers to track line and column numbers */
int scancol = 1;
int yycol = 1;
int scanlineno = 1;

 /* char pointer to pass error messages to driver.c */
char *yyerror;

 /* TODO: functions to update line and column numbers */
void updateCol();
void countLines();

 /* TODO: function to process a string literal */
int processString();

void updateCol(int size=1){
    scancol+=size;
}

void countLines(){
    yycol++;
}
%}

newline        \n  //TODO
whitespace      [\t ] //TODO
integer [0]|[1-9][0-9]*        //TODO
character       '[.\n]' //TODO

 /* String can contain any characters between the double quotes */
 /* other than a newline or unescaped doublequotes */
*/
string       "[^\n"]*" //TODO


 /* If the end quote is not found in the same line the string is unterminated */
untermstring "[^"]\n //TODO

comment \/\*.*\*\/         //TODO
multlncomment \/\*(.|\n)*(\n)\*\/   //TODO
untermcomment  \/\*(.|\n)*<<EOF>> //TODO

identifier [a-zA-Z][a-zA-Z0-9]*      //TODO
illidentifier   [a-zA-Z][^a-zA-Z0-9]|[^a-zA-Z].*//TODO: regular expression for an illegal identifier

yylineno = 1;

%%

 /* rules */

 /* Keywords */
 /* TODO: Support all keywords in mC */
if {
    return KWD_IF;
 }
else {
    return KWD_ELSE;
 }
while {
    return KWD_WHILE;

}
int {
    return KWD_INT;
}
string {
    return KWD_STRING;
}
char {
    return KWD_CHAR;
}
return {
    return KWD_RETURN;
}
void {
    return KWD_VOID;
}
 /* Operators */
 /* TODO: Support all operators in mC */
 +{

 }
 *{

 }
 /{

 }
 %{

 }
 <{

 }
 >{

 }
 <={

 }
 >={

 }
 =={

 }
 !={

 }
 ={

 }
 [{

 }
 ]{

 }
 {{

 }
 }{

 }
 ({

 }
 ){

 }
 ,{

 }
 ;{

 }
 @{

 }
 ++{

 }
 --{

 }
 &&{

 }
 ||{

 }
 !{

 }

 /* Identifiers */;
{identifier}    //TODO
{illidentifier} //TODO

 /* Constants */;
{integer}       //TODO
{integerlead0}  //TODO: "Integers may not have leading zeros"
{character}     //TODO
{string}        {updateCol(); return processString();}
{untermstring}  {updateCol(); yyerror = "Unterminated string"; return ERROR;}

 /* Comments */
{comment}       //TODO
{untermcomment} //TODO
{multlncomment} //TODO

 /* Other */
{newline}       //TODO
{whitespace}    //TODO
.               {return ILLEGAL_TOK;}

%%

/* user routines */

/* TODO:
Implement this function to keep track of column numbers
*/
void updateCol(){
}

/* TODO:
Implement this function to keep track of line numbers
*/
void countLines(){
}


/* TODO:
Implement this function to
check for illegal escape sequences in string literals
and
convert valid escape sequences into escaped characters
(string[0] == '\\' and string[1] == 'n', then string[0] should be '\n')
*/
int processString(){
}
