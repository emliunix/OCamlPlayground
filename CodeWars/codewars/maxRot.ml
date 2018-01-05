let max_rot n =
  let rec els_of_n n =
    if n > 0 then
      (els_of_n (n / 10)) @ [(n mod 10)]
    else
      []
  in
  let n_of_els els = 
    let rec n_of_els_rec els a = match els with
      | [] -> a;
      | (x::xs) -> n_of_els_rec xs (a * 10 + x);
    in
    n_of_els_rec els 0
  in
  let rotate = function
    | (a::xs) -> xs @ [a];
    | [] -> [];
  in
  let rec search left right curr_max =
    match right with
    | [] -> curr_max;
    | xs ->
       let right_tmp = rotate xs in
       let curr_val = left @ right_tmp |> n_of_els in
       let new_max = max curr_val curr_max in
       let x = List.hd right_tmp in
       let xs = List.tl right_tmp in
       let new_left = left @ [x] in
       let new_right = xs in
       Printf.printf "%d\n" curr_val;
       search new_left new_right new_max
  in
  let els = els_of_n n in
  search [] els n;;
