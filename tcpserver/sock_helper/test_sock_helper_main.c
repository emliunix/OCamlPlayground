#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>

extern int enable_sock_reuseport(int fd);

int main(int argc, char **argv) {
  // test code
  struct sockaddr_in addr = {
    .sin_family = AF_INET,
    .sin_port = htobe16(8080),
    .sin_addr = {
      .s_addr = htobe32(INADDR_ANY)
    }
  };
  int sock_fd = socket(AF_INET, SOCK_STREAM, 0);
  enable_sock_reuseport(sock_fd);
  puts("enable_sock_reuseport(sock_fd);");
  bind(sock_fd, (const struct sockaddr *)&addr, sizeof(struct sockaddr_in));
  listen(sock_fd, 10);
  puts("listen(sock_fd, 10);");
  char buf[1024];
  int len;
  while (1) {
    struct sockaddr peer_addr;
    int peer_addr_len = sizeof(struct sockaddr);
    int c_sock_fd = accept(sock_fd, &peer_addr, &peer_addr_len);
    puts("int c_sock_fd = accept(sock_fd, &peer_addr, &peer_addr_len);");
    while((len = read(c_sock_fd, buf, 1023)) != 0) {
      buf[len] = 0;
      puts(buf);
      write(c_sock_fd, buf, len);
    }
  }
  return 0;
}
