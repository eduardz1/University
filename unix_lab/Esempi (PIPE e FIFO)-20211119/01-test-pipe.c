#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <limits.h>
#include <signal.h>
#include <errno.h>

void handler(int s) {
  printf("\n ricevuto segnale SIGPIPE \n");
  //signal(SIGINT, SIG_DFL);
}

int main() {
  int data_processed;
  int file_pipes[2]; // [0] --> read - [1] --> write
  const char some_data[] = "Hello pipe!";
  char buffer[BUFSIZ + 1];
  pid_t fork_result;

  memset(buffer, '\0', sizeof(buffer));

  printf("La dimensione del buffer della pipe è di %d bytes\n", PIPE_BUF);

  if (pipe(file_pipes) == 0) {
    fork_result = fork();
    switch (fork_result) {
      case -1:
        fprintf(stderr, "Fork failure");
        exit(EXIT_FAILURE);
      case 0:
        close(file_pipes[1]); //chiude il file descriptor di scrittura
        //close(file_pipes[0]);
        sleep(20);
        printf("Reading...\n");
        data_processed = read(file_pipes[0], buffer, BUFSIZ);
        printf("Read %d bytes: %s\n", data_processed, buffer);
        exit(EXIT_SUCCESS);
      default:

        if (signal(SIGPIPE, handler)==SIG_ERR) {
          printf("\nErrore della disposizione dell'handler: %s\n",strerror(errno));
          exit(EXIT_SUCCESS);
        }

        close(file_pipes[0]); //chiude il file descriptor di lettura
        //data_processed = read(file_pipes[0], buffer, BUFSIZ);
        sleep(5);
        data_processed = write(file_pipes[1], some_data, strlen(some_data));
        printf("Wrote %d bytes\n", data_processed);
        exit(EXIT_SUCCESS);
    }
  }
}
