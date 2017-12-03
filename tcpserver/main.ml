open Core
open Async
open Sock_helper

let configure_socket socket =
  socket
  |> Async.Socket.fd
  |> Async.Fd.file_descr_exn
  |> Core.Unix.File_descr.to_int
  |> enable_reuseport
  |> ignore

let () =
  let port = 8080 in
  let addr = Socket.Address.Inet.create Unix.Inet_addr.bind_any port in
  Socket.create 
  |> configure_socket
