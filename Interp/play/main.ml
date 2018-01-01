open Core
open Async

let connect ~maximum_delay host_and_port =
  let host = Host_and_port.host host_and_port in
  let port = Host_and_port.port host_and_port in
  let connect () =
    Tcp.connect @@ Tcp.to_host_and_port host port
  in
  let rec retry ~delay =
    Monitor.try_with connect
    >>= function
    | Error _exn ->
       let delay = Time.Span.min maximum_delay delay in
       Clock.after delay
       >>= fun () -> retry ~delay:(Time.Span.scale delay 2.)
    | Ok (_, reader, writer) ->
       Writer.write writer "hello\n";
       Writer.close writer
       >>= fun () -> Reader.contents reader
  in
  retry ~delay:(Time.Span.of_sec 1.);;

let myConnect host_and_port =
  Tcp.connect host_and_port
  >>= fun (_, reader, writer) ->
  Writer.write writer "hello\n";
  Writer.flushed writer
  >>= fun () ->
  Reader.contents reader
  >>= fun text ->
  Writer.close writer
  >>= fun () ->
  Reader.close reader
  >>= fun () ->
  return text;;

let myListen host_and_port =
  let handler _addr reader writer =
    Reader.contents reader
    >>= fun _ ->
    Writer.write writer "greeting";
    Writer.close writer
  in
  Tcp.Server.create host_and_port handler;;

(*-- Main method --*)
let () =
  (* connect ~maximum_delay:(Time.Span.of_sec 64.) (Host_and_port.create "localhost" 6666) |> ignore; *)
  (
    myConnect (Tcp.to_host_and_port "localhost" 6666)
    >>| fun text ->
    print_endline text;
    shutdown 0
  ) |> ignore;
  (* let host = "localhost" in
   * let port = 6666 in
   * let listen_addr = Tcp.on_port port in
   * let connect_addr = Tcp.to_host_and_port host port in
   * myListen listen_addr |> ignore;
   * (\* >>= fun () -> *\)
   * myConnect connect_addr |> ignore; *)
  print_endline "About to go...";
  Scheduler.go () |> ignore;
  print_endline "Finished.";
