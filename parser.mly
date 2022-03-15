%{
(* Make available names in the Ast module *)
open Ast

(* Report a syntax error with the location of its orgin *)
let syntax_error () =
  let start_pos = Parsing.rhs_start_pos 1 in
  let end_pos = Parsing.rhs_end_pos 1 in
  raise (Error.SyntaxError {
    sl = start_pos.pos_lnum;
    sc = start_pos.pos_cnum - start_pos.pos_bol;
    el = end_pos.pos_lnum;
    ec = end_pos.pos_cnum - end_pos.pos_bol;
  })
%}

/* Tokens */

%token EOF 
%token UNIT
%token <int> NUMBER
%token <string> ID
%token NOT
%token ARROW
%token MULT DIV
%token PLUS MINUS
%token AND OR
%token EQUALS NOT_EQUALS GREATER_EQUALS LESS_EQUALS GREATER LESS
%token SET_EQUAL
%token O_PAREN C_PAREN
%token O_CBRAC C_CBRAC
%token O_BRAC C_BRAC
%token COMMA
%token SEMICOLON COLON
%token BOOL INT INTARR UNIT
%token LET
%token WHILE
%token FN
%token TRUE FALSE
%token IF THEN ELSE

// %nonassoc LPAREN ID UNIT NUMBER TRUE FALSE SET_EQUAL
// %left AND OR EQUALS NOT_EQUALS GREATER_EQUALS LESS_EQUALS GREATER LESS
// %left PLUS MINUS 
// %left MULT DIV
// %nonassoc NOT

%nonassoc LPAREN ID UNIT NUMBER TRUE FALSE SET_EQUAL
%left AND OR 
%nonassoc NOT
%nonassoc EQUALS NOT_EQUALS GREATER GREATER_EQUALS LESS LESS_EQUALS
%left PLUS MINUS
%left MULT DIV
%right prec_unary_minus


// TODO: Your associativity rules here
// ...

%start main
%type <Ast.prog> main
%start expr
%type <Ast.expr> expr
%%

main:
    | EOF                               { syntax_error() }
    | prog EOF                          { $1 }
    | error EOF                         { syntax_error () }
prog:
    |                                                           { [] }
    |  FN ID O_PAREN params C_PAREN ARROW type_rule expr prog   { {name = $2; param = $4; body = $8; return = $7}::$9 }


sequence:
    | O_CBRAC expr C_CBRAC                      { [$2] }
    | O_CBRAC expr SEMICOLON more_expr          { $2::$4 }

more_expr:
    | expr C_CBRAC                              { [$1] }
    | expr SEMICOLON more_expr                  { $1::$3 }

params:
    |                                      { [] }
    | ID COLON type_rule                   { [($1, $3)] }
    | ID COLON type_rule COMMA params      { ($1, $3)::$5 }


expr_list: 
    |                            { [] }
    | expr                       { [$1] }
    | expr COMMA expr_list       {$1::$3}


type_rule:
  | INT       { TInt }
  | BOOL      { TBool }
  | UNIT      { TUnit }
  | INTARR    { TArr }


expr:
    | O_PAREN C_PAREN                                   { Const(CUnit) }
    | O_PAREN expr C_PAREN                              { $2 }
    | IF expr THEN sequence ELSE sequence               { Ite($2, Seq($4), Seq($6))}
    | LET ID COLON type_rule SET_EQUAL expr             { Let($2, $4, $6)}
    | ID SET_EQUAL expr                                 { Assign($1, $3)}
    | expr DIV expr                                     { Binary(Div, $1, $3)}
    | expr MULT expr                                    { Binary(Mul, $1, $3)}
    | expr PLUS expr                                    { Binary(Add, $1, $3)}
    | expr MINUS expr                                   { Binary(Sub, $1, $3)}
    | expr AND expr                                     { Binary(And, $1, $3)}
    | expr OR expr                                      { Binary(Or, $1, $3)}
    | expr EQUALS expr                                  { Binary(Eq, $1, $3)}
    | expr NOT_EQUALS expr                              { Binary(Neq, $1, $3)}
    | expr GREATER_EQUALS expr                          { Binary(Geq, $1, $3)}
    | expr LESS expr                                    { Binary(Lt, $1, $3)}
    | expr LESS_EQUALS expr                             { Binary(Leq, $1, $3)}
    | expr GREATER expr                                 { Binary(Gt, $1, $3)}
    | sequence                                          { Seq($1)}
    | WHILE expr expr                                   { While($2, $3)}
    | ID O_PAREN expr_list C_PAREN                      { Call($1, $3)}
    | ID O_BRAC expr C_BRAC SET_EQUAL expr              { Write($1, $3, $6)}
    | ID O_BRAC expr C_BRAC                             { Read($1, $3) }
    | NOT expr                                          { Unary(Not, $2)}
    | MINUS expr %prec prec_unary_minus                 { Binary(Sub, Const(CInt(0)), $2)}
    | TRUE                {Const(CBool(true))}   
    | FALSE               {Const(CBool(false))}
    | NUMBER              {Const(CInt($1))}
    | ID                  {Id($1)}
  


binop:
    | DIV                 { Div }
    | MULT                { Mul }
    | PLUS                { Add }
    | MINUS               { Sub }
    | AND                 { And }
    | OR                  { Or }
    | EQUALS              { Eq }
    | NOT_EQUALS          { Neq}
    | GREATER_EQUALS      { Geq }
    | LESS                { Lt }
    | LESS_EQUALS         { Leq }
    | GREATER             { Gt }