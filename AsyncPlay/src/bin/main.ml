open Async

module ColorText = struct

  type color =
    | Black
    | Red
    | Green
    | Yellow
    | Blue
    | Magenta
    | Cyan
    | White

  type styleAttribute =
    | Reset
    | Bright
    | Dim
    | Underscore	
    | Blink
    | Reverse
    | Hidden

  type style = {
      attribute: styleAttribute;
      background: color;
      foreground: color;
    }

  let create ?(attribute=Reset) ?(background=Black) ?(foreground=White) () =
    {
      attribute = attribute;
      background = background;
      foreground = foreground;
    }

  let colorNumber isBack color =
    (if isBack then 40 else 30) +
      match color with
      | Black -> 0
      | Red -> 1
      | Green -> 2 
      | Yellow -> 3
      | Blue -> 4
      | Magenta -> 5
      | Cyan -> 6
      | White -> 7

  let styleString style =
    let attributeString = match style.attribute with
      | Reset -> "0;"
      | Bright -> "1;"
      | Dim -> "2;"
      | Underscore -> "4;"
      | Blink -> "5;"
      | Reverse -> "7;"
      | Hidden -> "8;"
    in
    let backgroundString = Printf.sprintf "%d;" (colorNumber true style.background) in
    let foregroundString = Printf.sprintf "%dm" (colorNumber false style.foreground) in
    "\x1b[" ^ attributeString ^ backgroundString ^ foregroundString

  let plainStyle = create ()

  let render style text =
    (styleString style) ^ text ^ (styleString plainStyle)

end

let boldRedStyle = ColorText.(create ~attribute:Bright ~foreground:Red ())
let boldGreenStyle = ColorText.(create ~attribute:Bright ~foreground:Green ())

let () =
  let handle s r w =
    print_endline "Started...";
    let rec echo () =
      Reader.read_line r
      >>= (
        function
        | `Ok s when s = "end" ->
           Writer.write_line  w (ColorText.render boldRedStyle "END");
           print_endline @@ (ColorText.render boldRedStyle "CMD") ^ " end";
           return ()
        | `Ok s ->
           printf "Received %s\n" s;
           Writer.write_line  w ((ColorText.render boldGreenStyle "ECHO") ^ " " ^ s);
           echo ()
        | `Eof ->
           print_endline "EOF";
           return ()
      )
    in
    echo ()
    >>| fun () ->
    print_endline "Finished...";
    shutdown 0
  in
  Tcp.with_connection
    (Tcp.to_host_and_port "localhost" 8899)
    handle
  |> ignore;
  Scheduler.go ()
  |> ignore
