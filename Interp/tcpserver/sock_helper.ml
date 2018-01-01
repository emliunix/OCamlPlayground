(* open Ctypes
 * open Foreign
 * 
 * let enable_reuseport =
 *   foreign "enable_sock_reuseport" (int @-> returning int) *)

external enable_reuseport : int -> int
  = "caml_enable_reuseport"
