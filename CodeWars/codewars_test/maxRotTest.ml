
let test () =
  Alcotest.(check int) "just equal" 1 1

let testHello () =
  let hello = MaxRot.getHello () in
  Alcotest.(check string) "should not pass" "Hello world!!!" hello

let suite = [
    "case 1", `Quick, test;
    "case hello", `Quick, testHello;
  ];;

Alcotest.run "" ["", suite]
