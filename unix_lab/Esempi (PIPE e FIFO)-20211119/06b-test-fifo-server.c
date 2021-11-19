#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>


#define BUF_SIZE    100

/*
  (1) gcc test-fifo-server.c -o test-fifo-server
  (2) ./test-fifo-server fifo_file server.log  &
 */

/* Creates a server that reads from a FIFO named argv[1] and writes
   over argv[2] */
int main(int argc, char * argv[])
{
  int fifo_fd;
  FILE *out_fd=NULL;
  char readbuf[BUF_SIZE];
  ssize_t num_bytes;

  /* Create the FIFO if it does not exist */
  //  umask(0);
  //mknod(FIFO_FILE, S_IFIFO|0666, 0);
  mkfifo(argv[1], S_IRUSR | S_IWUSR);

  // Open the log file
  out_fd = fopen(argv[2], "w");

  // Next code will keep reading forever (server needs to be kill/term
  // by signal or else
  while(1) {
    //  for (;;) {
    fifo_fd = open(argv[1], O_RDONLY);
    while (num_bytes = read(fifo_fd, readbuf, BUF_SIZE)) {
      printf("Received %ld bytes.\n",num_bytes);
      fprintf(out_fd,"%s",readbuf);
      fflush(out_fd);
    }
    close(fifo_fd);
  }


  /*
  // Next code will exit as soon as a client closes its write file descriptor
  fifo_fd = open(argv[1], O_RDONLY);
  while (num_bytes = read(fifo_fd, readbuf, BUF_SIZE)) {
    write(out_fd, readbuf, num_bytes);
  }
  */

  return(0);
}
