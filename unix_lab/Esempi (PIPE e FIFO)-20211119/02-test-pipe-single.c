#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/sysinfo.h>
#include <sys/wait.h>
#include <errno.h>
#include <time.h>
#include <string.h>
#include <limits.h>

#define NUM_PROC      8
#define NUM_ITER      5
#define READ_BUF_SIZE 60        // try varying this
#define TEST_ERROR    if (errno) {fprintf(stderr, \
					   "%s:%d: PID=%5d: Error %d (%s)\n",\
					   __FILE__,\
					   __LINE__,\
					   getpid(),\
					   errno,\
					   strerror(errno));}


int main (void) {
  pid_t child_pid;
  int my_pipe[2];
  int i, j, status;
  char * buf;
  ssize_t num_bytes;


  // PIPE_BUF is declared in limits.h
  printf("Pipe capacity on this machine is %d bytes. Good.\n", PIPE_BUF);

  // Create a pipe
  pipe(my_pipe);    // data written to my_pipe[1] is read from mypipe[0]
  TEST_ERROR;
  switch (fork()) {
  case -1:
    /* Handle error */
    TEST_ERROR;
    exit(EXIT_FAILURE);
  case 0:
    /* Perform actions specific to child */
    // Child process will only write, the read end must be closed
    close(my_pipe[0]);
    TEST_ERROR;

    for(j=0; j<NUM_ITER; j++) {
      // write data to the pipe
      dprintf(my_pipe[1], "CHILD PID %5d: j=%2d\n", getpid(), j);
      sleep(2);
      TEST_ERROR;
    }

		sleep(10);

    // Now the write end can be closed as well
    close(my_pipe[1]);

    sleep(5);

    TEST_ERROR;
    exit(EXIT_SUCCESS);
    break;

  default:
    /* Perform actions specific to parent */
    // Parent process will only read, the write end must be closed
    close(my_pipe[1]);
    TEST_ERROR;

    // Allocated read buffer
    buf = malloc(READ_BUF_SIZE);
    TEST_ERROR;

    while (num_bytes = read(my_pipe[0], buf, READ_BUF_SIZE)) {
      //      write(STDOUT_FILENO, "X", 1);
      write(STDOUT_FILENO, buf, num_bytes);
      //sleep(1);
			printf("waiting for data...\n");
      TEST_ERROR;
    }
    break;
  }

  printf("waiting for child termination...\n");
  /* Now let's wait for the termination of all kids */
  while ((child_pid = wait(&status)) != -1) {
    printf("PARENT: PID=%d. Got info of child with PID=%d, status=0x%04X\n", getpid(), child_pid,status);
  }

	TEST_ERROR;

  exit(EXIT_SUCCESS);
}