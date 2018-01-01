open Llvm
open Llvm_bitwriter

exception Error of string

type expr =
  | Number of float
  | BinOp of char * expr * expr

let context = Llvm.global_context ()
let the_module = Llvm.create_module context "test module"
let builder = Llvm.builder context
let double_type = Llvm.double_type context

let rec codegen_expr = function
  | Number n -> Llvm.const_float double_type n
  | BinOp (op, lhs, rhs) ->
     let lhs_val = codegen_expr lhs in
     let rhs_val = codegen_expr rhs in
     let pair =
       match op with
       | '+' -> (Llvm.build_add, "addtmp")
       | _ -> Error "unknown op" |> raise
     in
     begin
       match pair with
       | (f, op) -> f lhs_val rhs_val op builder
     end

let () =
  BinOp ('+', (Number 1.), (Number 2.))
  |> codegen_expr
  |> Llvm.dump_value

let () =
  Llvm.dump_module the_module

let () =
  Llvm.dump_type double_type

let () =
  let result =
    Llvm_bitwriter.write_bitcode_file the_module "/tmp/output.bit"
  in
  Printf.printf "Write success?: %B\n" result
