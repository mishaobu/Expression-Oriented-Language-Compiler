open Front_end
open Ast
open Error
exception Failure of string


let hole () = failwith "TODO"

(* A function type is a pair where
 * the first element is the argument types
 * the second element is the return type *)
type ftyp = typ list * typ
[@@deriving show]

(* Function environment, aka Delta *)
type fenv = (string * ftyp) list
[@@deriving show]

(* Type environment, aka Gamma *)
type tenv = (string * typ) list
[@@deriving show]

(* Look up variable x in gamma, and raises an exception if x is not found *)
let lookup (x: string) (gamma: tenv) : typ =
  match List.assoc_opt x gamma with
  | Some v -> v
  | None -> unbound_var x
let insert x t gamma = (x,t) :: gamma
let print_tenv gamma = gamma |> show_tenv |> print_endline

(* Look up function f in delta, and raises an exception if f is not found *)
let lookup_f (f: string) (delta: fenv) : ftyp = 
  match List.assoc_opt f delta with
  | Some ftyp -> ftyp
  | None -> unbound_fn f
let print_fenv delta = delta |> show_fenv |> print_endline

(* Type check an expression *)
type result = tenv * typ
let rec check (e: expr) (delta: fenv) (gamma: tenv) : result =
  (* print_tenv gamma;  *)

  (* Helper function: return type t without changing the type environment *)
  let return (t: typ) : result = (gamma, t) in
  (* Helper function: type check e, but discard the new environment *)
  let type_of (e: expr) : typ = check e delta gamma |> snd in
  (* Helper function: type check a list of expressions *)
  let rec check_list (es: expr list) (gamma: tenv) : typ =
    match es with
    | [] -> Error.empty_seq ()
    | [e] -> let _, typ = check e delta gamma in typ
    | e::es' -> let gamma', typ = check e delta gamma in 
                expect e TUnit typ; check_list es' gamma' in 

  (* body of check starts here *)
  match e with
  (* constant *)
  | Const c -> 
    (* Printf.printf("we here1\n"); *)
    let t = match c with
    | CUnit -> TUnit
    | CBool x -> TBool
    | CInt x -> TInt in
    return t

  (* variable reference *)
  | Id x -> return (lookup x gamma)

  (* unary expression *)
  | Unary (Not, e) ->
    let te = type_of e in
    expect e TBool te;
    return TBool

  (* binary expression *)
  | Binary (op, e1, e2) ->
    (* Printf.printf("we here3\n"); *)
    let te1 = type_of e1 in
    let te2 = type_of e2 in
    (* please refer to ast.ml for the definition of kind_of_binop *)
    let t = match kind_of_binop op with
    | Arith -> expect e1 TInt te1; expect e2 TInt te2; TInt
    | Logic -> expect e1 TBool te1; expect e2 TBool te2; TBool
    | EqNeq -> assert_eq te1 te2 "eqneq" "ahh"; TBool
    | Comp -> expect e1 TInt te1; expect e2 TInt te2; TBool in
    return t

  (* if-then-else expression *)
  | Ite (ec, et, ef) -> 
    (* printf "stuck here" *)
    (* Printf.printf("we here4\n"); *)
    let tec = type_of ec in
    let tet = type_of et in
    let tef = type_of ef in
    expect ec TBool tec; assert_eq tet tef "'true' ite body" "'false' ite body";
    return tet
    
  (* while expression *)
  | While (ec, ebody) -> 
    (* Printf.printf("we here5\n"); *)
    let tec = type_of ec in
    let tebody = type_of ebody in
    expect ec TBool tec; expect ebody TUnit tebody;
    return TUnit

  (* variable binding *)
  | Let (x, t, e) ->
    (* Printf.printf("we here6\n"); *)
    let te = type_of e in
    expect e t te; 
    ((insert x t gamma), TUnit)

  (* variable assignment *)
  | Assign (x, e) ->
    (* Printf.printf("we here7\n"); *)
    let t = lookup x gamma in
    let t' = type_of e in
    assert_eq t t' (msg_of_var x) (msg_of_expr e);
    return TUnit

  (* array indexing *)
  | Read (a, i) ->
    (* Printf.printf("we here8\n"); *)
    let ta = lookup a gamma in
    let ti = type_of i in
    expect_var a TArr ta; expect i TInt ti;
    return TInt

  (* array overwrite *)
  | Write (a, i, e) -> 
    (* Printf.printf("we here9\n"); *)
    let ta = lookup a gamma in
    let ti = type_of i in
    let te = type_of e in
    expect_var a TArr ta; expect i TInt ti; expect e TInt te;
    return TUnit

  (* sequence expression *)
  | Seq es -> return (check_list es gamma)

  (* function call *)
  | Call (f, args) -> 
    let filter = fun a -> type_of a in 
    let tfargs, tf = lookup_f f delta in
    let targs = List.map type_of args in
    if (f = "main") then
      main_called ()
    else if (List.compare_lengths tfargs args) == 0 then
      if tfargs = targs then
        return tf
      else 
        semantic_error "Wrong arg type"
    else 
      arg_length_mismatch f


(* Type check a function *)
let check_fn (delta: fenv) ({name; param; body; return} : fn) : unit =
  let gamma = param in
  let _, tbody = check body delta gamma in
  (* Functions to help check for duplicated param*)
  let duped_param = ("N/A", TUnit) in
  let rec exist elem lst =
    match lst with
    | [] -> false
    | hd::tl -> elem = hd || exist elem tl in 
  let rec dupExist lst =
    match lst with
    | [] -> false
    | hd::tl -> (exist hd tl) || dupExist tl in
  let param_names = List.map (fun (a, b) -> a) param in 
  let fxn_names = List.map (fun (a, b) -> a) delta in
  (*Check for duplicated function*)
  if (dupExist param_names) then
    let param_name, _ = duped_param in
    duplicated_param name param_name
  else if (name = "main" && List.length param != 0) then
    main_param ()
  else if (name = "main" && return != TUnit) then
    main_return ()
  else ()

(* Patina's built-in functions *)
(*print_bool print_int print_arr print_ln alloc->[int]*)
let built_in : fenv =
  [("print_bool", ([TBool], TUnit));
   ("print_int", ([TInt], TUnit));
   ("print_arr", ([TArr; TInt], TUnit));
   ("print_ln", ([], TUnit));
   ("alloc", ([TInt], TArr))]

  
(* Type check a program; need to add all functions to delta before check_fn *)

(* need dulplicated function check*)
let check_prog (fns: prog) : unit =
  let helper_fn = fun x -> (x.name, (List.map snd x.param, x.return)) in
  let delta = built_in @ (List.map helper_fn fns) in
  (* print_fenv delta; *)
  let fxn_names = List.map (fun (a, b) -> a) delta in
  let rec exist elem lst =
    match lst with
    | [] -> false
    | hd::tl -> elem = hd || exist elem tl in
  let rec getDupExistLst lst =
    match lst with
    | [] -> []
    | hd::tl -> (exist hd tl)::getDupExistLst tl in
  let rec find x lst =
    match lst with
    | [] -> raise (Failure "Not Found")
    | h :: t -> if x = h then 0 else 1 + find x t in
  let dupExistsLst = getDupExistLst fxn_names in
  (* let () = List.iter (Printf.printf "%b ") dupExistsLst in *)

  if List.mem true dupExistsLst then
    let index_dup = find true dupExistsLst in
    let duped_name = List.nth fxn_names index_dup in
    duplicated_fn duped_name
  else if List.mem "main" fxn_names then
    List.iter (check_fn delta) fns 
  else
    no_main ()