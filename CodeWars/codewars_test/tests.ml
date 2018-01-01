
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

Alcotest.run "My Codewars Tests" [
    "simple test", suite_hello;
  ]
