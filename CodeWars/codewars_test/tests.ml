
(*-- Just a simple testcase --*)
let test () =
  Alcotest.(check int) "just equal" 1 1;;

module TestTarget = struct
  let getHello () = "Hello world!!!"
end

let testHello () =
  let hello = TestTarget.getHello () in
  Alcotest.(check string) "should not pass" "Hello world!!!" hello

let suite_hello = [
    "case 1", `Quick, test;
    "case hello", `Quick, testHello;
  ];;

(* MaxRot *)

let test_56789 () =
  let result = MaxRot.max_rot 56789 in
  Alcotest.(check int) "The max rot" 68957 result;;

let suite_max_rot = [
    "official", `Quick, test_56789;
  ];;

(* seven *)

let test_seven () =
  let test = Alcotest.(check (pair int int)) "official case" in
  test (35, 1) (Seven.seven 371);
  test (7, 2) (Seven.seven 1603);
  test (28, 7) (Seven.seven 477557101);
;;

let suite_seven = [
    "official", `Quick, test_seven;
  ];;

Alcotest.run "My Codewars Tests" [
    (* "simple test", suite_hello; *)
    (* "max_rot", suite_max_rot; *)
    "seven", suite_seven;
  ]
