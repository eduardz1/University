#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>

#define BUF_SIZE    100

/*
  (1) gcc test-fifo-client.c -o test-fifo-client
  (2) ./test-fifo-client fifo_file mio_messaggio  &
 */

/* Creates a client that writes to a FIFO named argv[1] the message
   argv[2] plus other client info */
int main(int argc, char * argv[])
{
  int fifo_fd, str_len;
  char my_msg[BUF_SIZE];
  ssize_t num_bytes;

  int data_processed;

  // Open FIFO in write mode
  fifo_fd = open(argv[1], O_WRONLY);

  // Assemble the message
  str_len = sprintf(my_msg,"%s:PID=%d: \"%s\"\n", __FILE__, getpid(), argv[2]);

  // Write message to FIFO
  data_processed=write(fifo_fd, my_msg, str_len);

  printf("Wrote %d bytes\n",data_processed);

  close(fifo_fd);

  return(0);
}
