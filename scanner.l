%{
#include <string>
#include "parser.h" /* Generated by Bison */

extern int yylineno;
void yyerror(const char* s, ...);
%}

%option noyywrap nodefault yylineno

integer   [0-9]+
floating  {integer}*\.{integer}
complex   ({integer}|{floating})i
letter    [a-z]|[A-Z]

%%

[ \t]               ; //ignores spaces
{letter}            { yylval.value.var = yytext[0];
		      yylval.value.real = 0.0; 
                      yylval.value.img = 0.0;
		      return T_VAR  ;  }
   
{integer}           { yylval.value.real = std::atoi(yytext); 
                      yylval.value.img = 0.0;
                      return T_REAL  ; }
{floating}          { yylval.value.real = std::atof(yytext);
                      yylval.value.img = 0.0; 
                      return T_REAL; }
{complex}           { yytext[yyleng] = '\0'; //yytext = yytext.substr(0,yyleng-1);
                      yylval.value.img  = std::atof(yytext)    ; return T_IMG; }
"+"                 {                                          return T_PLUS ; } /*special character with " "*/
"-"                 {                                          return T_MINUS;} /*special character with " "*/
\*                  {                                          return T_TIMES;} /* special character with \ */
"/"                 {                                          return T_DIV;} /*special character with " "*/
"("                 {                                          return T_OPEN;}
")"                 {                                          return T_CLOSE;}
"="                 {                                          return T_EQUAL;}
\n                  {                                          return T_NL;}
.                   { yyerror("Unknown token! %c\n", *yytext);} /*complains about every unknown character*/

%%

void yyerror(const char *s, ...){
    va_list ap;
    va_start(ap, s);
    std::fprintf(stderr, "Line %d: error: ", yylineno);
    std::vfprintf(stderr, s, ap);
}