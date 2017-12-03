#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>

int enable_sock_reuseport(int fd) {
  int enable = 1;
  setsockopt(fd, SOL_SOCKET, SO_REUSEPORT, &enable, 1);
  return 0;
}


#include <caml/mlvalues.h>

CAMLprim value caml_enable_reuseport(value fd_val) {
  int fd = Int_val(fd_val);
  int enable = 1;
  printf("Hello world!!!\n");
  setsockopt(fd, SOL_SOCKET, SO_REUSEPORT, &enable, 1);
  return Val_int(0);
}
