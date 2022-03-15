open Front_end
open Ast

let impossible () = failwith "Impossible"
let hole () = failwith "TODO"

(* Environment *)
type env = (string * bottom) list
and  bottom = (typ * expr)

let lookup k env = List.assoc_opt k env
let insert k v env = (k,v) :: env

(* Constant folding and propagation *)
let rec fold_constant (e: expr) (env: env) : env * expr = 
  let recur e = fold_constant e env |> snd in
  let return e = (env, e) in
  match e with
  | Const _ -> return e
  | Id x -> let opt_result = lookup x env in 
            (match opt_result with 
            | Some (a, b) -> let t, v = a, b in
                              return v
            | None -> failwith "shouldnt happen")
  | Let (x, t, rhs) -> let v = recur rhs in (insert x (t, v) env), Let (x, t, v)
  | Seq es -> let _, e_list = compile_seq env es in
              return (Seq e_list)
  | Unary (op, e') -> let _, e_out = fold_constant e' env in return (Unary (op, e_out ))
  | Binary (op, e1, e2) -> return (compile_binary env recur op e1 e2 e)
  | Ite (ec, et, ef) -> return (Ite (recur ec, recur et, recur ef))
  | Call (f, args) -> return (Call (f, (List.map recur args)))
  | _ -> return e

  (* this should return env * expr_list; which is then converted to Seq *)
  and compile_seq env = function
  | [] -> failwith "impossible"
  | [e] -> let env_out, e_out = fold_constant e env in (env_out, [e_out])
  | e::es -> let env_out, e_out = fold_constant e env in 
             let env_out2, e_out2 = compile_seq env_out es in
             env_out2, e_out::e_out2 

and compile_binary env recur op e1 e2 e: expr =
let e_red1 = recur e1 in let e_red2 = recur e2 in
  match op with
  | Add ->  (match (e_red1, e_red2) with
            | (Const(CInt(v1)), Const(CInt(v2))) -> Const(CInt(v1 + v2))
            | _ -> e)
  | Sub -> (match (e_red1, e_red2) with
            | (Const(CInt(v1)), Const(CInt(v2))) -> Const(CInt(v1 - v2))
            | _ -> e)
  | Mul -> (match (e_red1, e_red2) with
            | (Const(CInt(v1)), Const(CInt(v2))) -> Const(CInt(v1 * v2))
            | _ -> e)
  | Div -> (match (e_red1, e_red2) with
            | (Const(CInt(v1)), Const(CInt(v2))) -> Const(CInt(v1 / v2))
            | _ -> e)
  | And -> (match (e_red1, e_red2) with
            | (Const(CBool(v1)), Const(CBool(v2))) -> Const(CBool(v1 && v2))
            | _ -> e)
  | Or -> (match (e_red1, e_red2) with
            | (Const(CBool(v1)), Const(CBool(v2))) -> Const(CBool(v1 || v2))
            | _ -> e)
  | Eq -> (match (e_red1, e_red2) with
            | (Const(CBool(v1)), Const(CBool(v2))) -> Const(CBool(v1 == v2))
            | _ -> e)
  | Neq -> (match (e_red1, e_red2) with
            | (Const(CBool(v1)), Const(CBool(v2))) -> Const(CBool(v1 != v2))
            | _ -> e)
  | Gt -> (match (e_red1, e_red2) with
            | (Const(CBool(v1)), Const(CBool(v2))) -> Const(CBool(v1 > v2))
            | _ -> e)
  | Geq -> (match (e_red1, e_red2) with
            | (Const(CBool(v1)), Const(CBool(v2))) -> Const(CBool(v1 >= v2))
            | _ -> e)
  | Lt -> (match (e_red1, e_red2) with
            | (Const(CBool(v1)), Const(CBool(v2))) -> Const(CBool(v1 < v2))
            | _ -> e)
  | Leq -> (match (e_red1, e_red2) with
            | (Const(CBool(v1)), Const(CBool(v2))) -> Const(CBool(v1 <= v2))
            | _ -> e)


and optimize_expr (e: expr) (env: env) : expr =
  (* fix f computes the fixpoint of function f *)
  let rec fix (f: 'a -> 'a) (x: 'a) (i: int): 'a =
    Printf.printf "Iteration %d\n%!" i;
    let x' = f x in
    if x = x' then x' else fix f x' (i+1) in
  (* feel free to add more optimization phases, e.g. dead code elimination *)
  let fold_once e = fold_constant e env |> snd in
  fix fold_once e 0

let optimize_fn (f: fn) : fn =
  let {name; param; body; return} = f in
  (* hole () below; replacing with temp *)
  let env = [] in
  let body' = optimize_expr body env in
  {name = name; param = param; body = body'; return = return}

let optimize_prog (p: prog) : prog =
  List.map optimize_fn p


(*
Folding: Constants in a binary expression are computed at compile time;
Compute LHS, compute RHS. If two consts, simply return const. Recursively repeat and return a const

Copy Propogation: "replace references to constant variables with their actual values."
With each variable we save "const value" along with it. When we use ID, we check if this corresponds to a const value.
Const flag is set when variable is first assigned. If it is assigned to const; const flag is set. 
Suppose then that we change this value; the overwrite of this variable will cause the const value to be changed 

fold: expr -> expr
*)