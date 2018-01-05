let seven n =
  let split n =
    (n / 10, n mod 10)
  in
  let rec seven_rec n step =
    if n < 100
    then
      (n, step)
    else
      let (a, b) = split n in
      seven_rec (a - 2 * b) (step + 1)
  in
  seven_rec n 0
