{ 
  open Parser 
  
  (* Increment line number.
   * Note: incrementing column number is handled automatically
   *)
  let incr_linenum lexbuf =
    let pos = lexbuf.Lexing.lex_curr_p in
    lexbuf.Lexing.lex_curr_p <- { pos with
      Lexing.pos_lnum = pos.Lexing.pos_lnum + 1;
      Lexing.pos_bol = pos.Lexing.pos_cnum;
    }
}

rule token = parse
 | [' ' '\r' '\t'] { token lexbuf }
 | '\n'            { incr_linenum lexbuf; token lexbuf}
 | "->" { ARROW }
 | '/' { DIV }
 | '+' { PLUS }
 | '-' { MINUS }
 | '*' { MULT }
 | "||" { OR }
 | "&&" { AND }
 | "==" { EQUALS }
 | "!=" { NOT_EQUALS }
 | '!' { NOT }
 | ">=" { GREATER_EQUALS }
 | "<=" { LESS_EQUALS }
 | '>' { GREATER }
 | '<' { LESS }
 | '=' { SET_EQUAL }
 | '(' { O_PAREN }
 | ')' { C_PAREN }
 | '}' { C_CBRAC }
 | '{' { O_CBRAC }
 | '[' { O_BRAC }
 | ']' { C_BRAC }
 | ',' { COMMA }
 | ';' { SEMICOLON }
 | ':' { COLON }
 | "while" { WHILE }
 | "let" { LET } 
 | "bool" { BOOL }
 | "int" { INT }
 | "[int]" { INTARR }
 | "unit" { UNIT }
 | "fn" { FN }
 | "true" { TRUE }
 | "false" { FALSE }
 | "if" { IF } 
 | "then" { THEN } 
 | "else" { ELSE }
 | ['0'-'9'] ['0'-'9'] * as lxm   { NUMBER(int_of_string lxm) }
 | ['A'-'Z' 'a'-'z' '_'] ['A'-'Z' 'a'-'z' '0'-'9' '_'] * as idlxm {ID(idlxm)}

 
 | "//"            { comment lexbuf }
 | eof             { EOF }

and comment = parse
 | '\n'            { incr_linenum lexbuf; token lexbuf }
 | _               { comment lexbuf }
