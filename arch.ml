(* General-purpose registers *)
type reg = RAX | RBX | RCX | RDX | RDI | RSI | RSP | RBP
let x86_of_reg r = "%" ^
  match r with
  | RAX -> "rax"
  | RBX -> "rbx"
  | RCX -> "rcx"
  | RDX -> "rdx"
  | RDI -> "rdi"
  | RSI -> "rsi"
  | RSP -> "rsp"
  | RBP -> "rbp"

(* Jump conditions *)
type cond = EQ | NE | GT | GE | LT | LE
let x86_of_cond = function
  | EQ -> "e"
  | NE -> "ne"
  | GT -> "g"
  | GE -> "ge"
  | LT -> "l"
  | LE -> "le"
  
(* Operands *)
type operand =
  | Imm of int
  | Reg of reg
  | Mem of reg * int
let x86_of_operand = function
  | Imm n -> "$" ^ string_of_int n
  | Reg r -> x86_of_reg r
  | Mem (r,0) -> Printf.sprintf "(%s)" (x86_of_reg r)
  | Mem (r,d) -> Printf.sprintf "%d(%s)" d (x86_of_reg r)

(* Arithmetic op *)
type arith = IAdd | ISub | IMul | IDiv | IShr
let x86_of_arith = function
  | IAdd -> "addq"
  | ISub -> "subq"
  | IMul -> "imulq"
  | IDiv -> "idivq"
  | IShr -> "sarq"

type logic = IAnd | IOr
let x86_of_logic = function
  | IAnd -> "andq"
  | IOr -> "orq"

(* Instructions *)
type label = string
and  instr =
  | INot of operand
  | IArith of arith * operand * operand
  | ILogic of logic * operand * operand
  | IMov of operand * operand
  | IMovc of operand * operand
  | IMovcg of operand * operand
  | IMovcge of operand * operand
  | ISete of operand
  | IPush of operand
  | IPop of operand
  | ICmp of operand * operand
  | IJmp of cond option * label
  | IRet

let x86_of_instr i = Printf.(
  let s = sprintf in
  let x86_of_binary op_str src dst = s "%s %s, %s" op_str (x86_of_operand src) (x86_of_operand dst) in
  match i with
  | INot a -> s "not %s" (x86_of_operand a)
  | IArith (op, src, dst) -> x86_of_binary (x86_of_arith op) src dst
  | ILogic (op, src, dst) -> x86_of_binary (x86_of_logic op) src dst
  | IMov (src, dst) -> x86_of_binary "movq" src dst
  | IMovc (src, dst) -> x86_of_binary "cmove" src dst
  | IMovcg (src, dst) -> x86_of_binary "cmovg" src dst
  | IMovcge (src, dst) -> x86_of_binary "cmovge" src dst
  | ISete a -> s "setz %s" (x86_of_operand a)
  | IPush a -> s "pushq %s" (x86_of_operand a)
  | IPop a -> s "popq %s" (x86_of_operand a)
  | ICmp (src, dst) -> x86_of_binary "cmpq" src dst
  | IJmp (None, l) -> s "jmp %s" l
  | IJmp (Some c, l) -> s "j%s %s" (x86_of_cond c) l
  | IRet -> "ret")

(* A line in an assembly program *)
type asm =
  | Label of label
  | Instr of instr
let x86_of_asm = function
  | Label l -> l ^ ":"
  | Instr i -> x86_of_instr i
type prog = asm list

(* Helper functions to call constructors *)
let nott a = Instr (INot a)
let add a b = Instr (IArith (IAdd, a, b))
let sub a b = Instr (IArith (ISub, a, b))
let mul a b = Instr (IArith (IMul, a, b))
let div a b = Instr (IArith (IDiv, a, b))
let shr a = Instr (IArith (IShr, Imm 31, a))
let annd a b = Instr (ILogic (IAnd, a, b))
let orr a b = Instr (ILogic (IOr, a, b))
let mov a b = Instr (IMov (a, b))
let cmov a b = Instr (IMovc (a, b))
let cmovg a b = Instr (IMovcg (a, b))
let cmovge a b = Instr (IMovcge (a, b))
let sete a = Instr (ISete (a))
let push r = Instr (IPush r)
let pop r = Instr (IPop r)
let jmp_always l = Instr (IJmp (None, l))
let jmp c l = Instr (IJmp (Some c, l))
let cmp a b = Instr (ICmp (a, b))
let ret = Instr IRet
let rax = Reg RAX
let rbx = Reg RBX
let rcx = Reg RCX
let rdx = Reg RDX
let rdi = Reg RDI
let rsi = Reg RSI
let rsp = Reg RSP
let rbp = Reg RBP