
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


%}

newline        \n  //TODO
whitespace      [\t ] //TODO
integer [0]|[1-9][0-9]*        //TODO
integerlead0 [0]+[0-9]*
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
 /* Operators */
 /* TODO: Support all operators in mC */
 +{
   updateCol();
    return OPER_ADD;
 }
 *{
   updateCol();
    return OPER_MUL;
 }
 /{
   updateCol();
    return OPER_DIV;
 }
 %{
   updateCol();
    return OPER_MOD;
 }
 <{
   updateCol();
    return OPER_LT;
 }
 >{
   updateCol();
    return OPER_GT;
 }
 <={
   updateCol();
    return OPER_LTE;
 }
 >={
   updateCol();
    return OPER_GTE;
 }
 =={
   updateCol();
    return OPER_EQ;
 }
 !={
   updateCol();
    return OPER_NEQ;
 }
 ={
   updateCol();
    return OPER_ASGN;
 }
 [{
   updateCol();
    return LSQ_BRKT;
 }
 ]{
   updateCol();
    return RSQ_BRKT;
 }
 {{
   updateCol();
    return LCRLY_BRKT;
 }
 }{
   updateCol();
    return RCRLY_BRKT;
 }
 ({
   updateCol();
    return LPAREN;
 }
 ){
   updateCol();
    return RPAREN;
 }
 ,{
   updateCol();
    return COMMA;
 }
 ;{
   updateCol();
    return SEMICLN;
 }
 @{
   updateCol();
    return OPER_AT;
 }
 ++{
   updateCol();
    return OPER_INC;
 }
 --{
   updateCol();
    return OPER_DEC;
 }
 &&{
   updateCol();
   return OPER_AND;
 }
 ||{
   updateCol();
   return OPER_OR;
 }
 !{
   updateCol();
    return OPER_NOT;
 }

 /* Identifiers */;
{identifier}    {updateCol(); return ID;} //TODO
{illidentifier} {updateCol(); yyerror="Ill Identifier"; return ERROR;}

 /* Constants */;
{integer}       {updateCol(); return INTCONST;}
{integerlead0}  {updateCol(); yyerror= "Integers may not have leading zeros"; return ERROR;}
{character}     {updateCol(); return CHARCONST;}
{string}        {updateCol(); return processString();}
{untermstring}  {updateCol(); yyerror = "Unterminated string"; return ERROR;}

 /* Comments */
{comment}       //Shouldn't do anything
{untermcomment} {updateCol(); yyerror="Unterminated Comment"; return ERROR;} //TODO
{multlncomment} //Shouldn't do anything

 /* Other */
{newline}       {countLines();}//TODO
{whitespace}    //Shouldn't do anythiing
.               {return ILLEGAL_TOK;}

%%

/* user routines */

/* TODO:
Implement this function to keep track of column numbers
*/
void updateCol(){
    scancol+=yyleng;
    yycol=scancol;
}

/* TODO:
Implement this function to keep track of line numbers
*/
void countLines(){
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
    int i = 0;
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
                    yyerror="Invalid Escape Sequence";
                    return ERROR;
                }
        }
        else{
            yytext[j]=yytext[i];
        }
        q=yytext[++i];
        j++;
    }
    yytext[j]='\0';
    return STRCONST;
}
