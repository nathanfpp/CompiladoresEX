%{
#include <iostream>


extern int yylex();
extern void yyerror(const char* s, ...);
%}

%code requires{
    typedef struct {
       char var;
       double real;
       double img;
    } complex;   
}


%code{

complex variavel;

}


%define parse.trace

/* yylval == %union. union informs the different ways we can store data */
%union {
    complex value;
    char signal;
}

/* token defines our terminal symbols (tokens). */
%token <value>  T_VAR
%token <value>  T_REAL
%token <value>  T_IMG
%token <signal> T_PLUS T_MINUS T_TIMES T_DIV 
%token T_NL T_OPEN T_CLOSE T_EQUAL

/* type defines the type of our nonterminal symbols. Types should match the names used in the union. Example: %type<node> expr */
%type <value> program lines line expr atribuicao atribuicao_composta
%type <signal> sinal


/* Operator precedence for mathematical operators.The latest it is listed, the highest the precedence. left, right, nonassoc */

%left T_PLUS 
%left T_TIMES T_DIV
%left T_OPEN T_CLOSE

/* Starting rule */
%start program

%%

program: lines  /*$$ = $1 when nothing is said*/
       ;

lines: line        /*$$ = $1 when nothing is said*/
     | lines line
     ;

line: T_NL      
    | expr T_NL {  std::cout << "R: " << $$.real; 
                   if($$.img > 0.0){ std::cout << " + "; std::cout << $$.img << "i";} 
                   else if ($$.img <0.0) { std::cout << " - "; std::cout << $$.img << "i"; }; 
                   std::cout << "\n\nEntrada: ";                                             }
    | atribuicao
    | atribuicao_composta
    ;

expr: T_REAL T_PLUS T_IMG        {  $$.real = $1.real;  $$.img = $3.img;   std::cout << $$.real << " + " << $$.img << "i\n"; } 
    | T_REAL T_MINUS T_IMG       {  $$.real = $1.real;  $$.img = -$3.img;  std::cout << $$.real << " + " << $$.img << "i\n"; }
    | T_REAL                     {  $$.real = $1.real;  $$.img = 0.0;      std::cout << $$.real << "\n";                     }
    | T_IMG                      {  $$.real = 0.0;      $$.img = $1.img;   std::cout << $$.real << " + " << $$.img << "i\n"; }
//
// Adição
    | expr T_PLUS expr           {  $$.real = $1.real + $3.real;  $$.img = $1.img + $3.img; 
                                    std::cout << "( " << $1.real << " + " << $3.real << " )";
                                    if($$.img != 0) std::cout << " & ( " << $1.img << " + " << $3.img << " )i"; std::cout << "\n"; }
// Subtração
    | expr T_MINUS expr          { $$.real = $1.real-$3.real;  $$.img = $1.img-$3.img;
                                    std::cout << "( "<< $1.real << " - " << $3.real << " )"; 
                                    if($$.img != 0) std::cout << " & ( " << $1.img << " - " << $3.img << " )i"; std::cout << "\n"; }
// Multiplicação por Escalar
    | T_REAL T_TIMES expr        { $$.real = $1.real*$3.real;  $$.img = $1.real*$3.img; 
                                   std::cout << $1.real << " * ( " << $3.real; 
                                   if($$.img != 0) std::cout << " + " << $3.img << "i"; std::cout << " )\n"; }
    | expr T_TIMES T_REAL        { $$.real = $3.real*$1.real;  $$.img = $3.real*$1.img; 
                                   std::cout << "( " << $3.real; 
                                   if($$.img != 0) std::cout << " + " << $3.img << "i"; std::cout << " ) * " << $1.real << "\n"; }
// Multiplicação Complexa
    | expr T_TIMES expr          { $$.real = ($1.real*$3.real)-($1.img*$3.img);  $$.img = ($1.real*$3.img) + ($1.img*$3.real);
                                   std::cout << "( " << $1.real << " + " << $1.img << "i) * ( " << $3.real << " + " << $3.img << "i)\n"; }
// Divisão por Escalar
    | expr T_DIV T_REAL          { $$.real = $1.real/$3.real;  $$.img = $1.img/$3.real; 
                                   std::cout << "( "<<$1.real; 
                                   if($$.img != 0) std::cout << " + "<< $1.img << "i"; std::cout << " ) / " << $3.real << "\n"; }
// Parênteses
    | T_OPEN expr T_CLOSE        { $$.real = ($2.real);  $$.img = ($2.img); 
                                   std::cout << "( " << $2.real; if($$.img!=0) std::cout << " + " << $2.img << "i"; std::cout << " )\n"; }
// Número negativo
    | T_MINUS expr                 { $$.real = -1*($2.real);  $$.img = -1*($2.img);
                                   std::cout << "-( " << $2.real; if($$.img!=0) std::cout << " + "<< $2.img << "i"; std::cout << " )\n"; }
// (!) Adição de Reais Isolados
    | T_REAL T_PLUS T_REAL       { $$.real = $1.real + $3.real;  $$.img = 0.0; 
                                   std::cout << $$.real << " + " << $$.img << "\n"; }
// (!) Subtração de Reais Isolados
    | T_REAL T_MINUS T_REAL      { $$.real = $1.real - $3.real;  $$.img = 0.0; 
                                   std::cout << $$.real << " - " << $$.img << "\n"; }
// (!) Adição de Complexos Isolados
    | T_IMG T_PLUS T_IMG         { $$.real = 0.0;  $$.img = $1.img+$3.img;  
                                   std::cout << $$.real << " + " << $$.img << "i\n"; }
// (!) Adição de Complexos Isolados
    | T_IMG T_MINUS T_IMG        { $$.real = 0.0;  $$.img = $1.img-$3.img;  
                                   std::cout << $$.real << " - " << $$.img << "i\n"; }
// (!) Problemáticos, porém úteis
    | T_IMG T_PLUS T_REAL        { $$.real = $3.real;  $$.img = $1.img; 
                                   std::cout << $$.real << " + " << $$.img << "i\n"; }
// Fim.
    ;

sinal: T_MINUS | T_PLUS | T_TIMES | T_DIV;

atribuicao: T_VAR T_EQUAL expr    {  $$.var = $1.var;  $$.real = $3.real;  $$.img = $3.img; variavel = $$ ;std::cout << "R: "<< $$.var << " = " << $$.real << " + " << $$.img << "i\n"; }  
//Fim.
    ;
atribuicao_composta: T_VAR T_EQUAL T_VAR sinal expr  { if ($3.var != variavel.var)
                                                             std::cout<<"variavel inexistente\n";
						       else{ 
							     $$.var = $1.var; 
                                                             
                                                             switch($4)
                                                             {
                                                              case '+': 
                                                              $$.real = $5.real + variavel.real; 
                                                              $$.img = $5.img + variavel.img; 
 							      break;

							      case '-': 
                                                              $$.real = $5.real - variavel.real; 
                                                              $$.img = $5.img - variavel.img; 
 							      break;

 							      case '*': 
                                                              $$.real = $5.real*variavel.real; 
                                                              $$.img = $5.img*variavel.img; 
 							      break;

							      case '/': 
                                                              $$.real = $5.real/variavel.real; 
                                                              $$.img = $5.img/variavel.img; 
 							      break;
                                                             }

                                                             std::cout << "R: "<< $$.var << " = " << $$.real << " + " << $$.img << "i\n";
							    }
                                                        }
//Fim.
    ;

%%
