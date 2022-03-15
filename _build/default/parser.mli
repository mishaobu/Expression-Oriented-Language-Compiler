type token =
  | EOF
  | UNIT
  | NUMBER of (int)
  | ID of (string)
  | NOT
  | ARROW
  | MULT
  | DIV
  | PLUS
  | MINUS
  | AND
  | OR
  | EQUALS
  | NOT_EQUALS
  | GREATER_EQUALS
  | LESS_EQUALS
  | GREATER
  | LESS
  | SET_EQUAL
  | O_PAREN
  | C_PAREN
  | O_CBRAC
  | C_CBRAC
  | O_BRAC
  | C_BRAC
  | COMMA
  | SEMICOLON
  | COLON
  | BOOL
  | INT
  | INTARR
  | LET
  | WHILE
  | FN
  | TRUE
  | FALSE
  | IF
  | THEN
  | ELSE

val main :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Ast.prog
val expr :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Ast.expr
