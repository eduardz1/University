#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include <sys/sysinfo.h>
#include <sys/wait.h>

void print_wait_status(char * msg, int status) {

}

int main() {
  pid_t my_pid, my_ppid, value, childPid;
  int status;

  switch (value = fork()) {
  case -1:
    /* Handle error */
    fprintf(stderr,"Error #%03d: %s\n", errno, strerror(errno));
    break;

  case 0:
    /* Perform actions specific to child */
    my_pid = getpid();
    my_ppid = getppid();
    printf("CHILD:  PID=%d, PPID=%d, fork_value=%d\n", my_pid, my_ppid, value);

    sleep(10);

    printf("CHILD:  PID=%d terminated\n", my_pid);

    exit(EXIT_SUCCESS);

  default:
    /* Perform actions specific to parent */
    my_pid = getpid();
    my_ppid = getppid();
    printf("PARENT: PID=%d, PPID=%d, fork_value=%d\n", my_pid, my_ppid, value);

    while ((childPid = waitpid(value, &status, WNOHANG))!= -1) {
      if (childPid==0) {
        printf("No child terminated\n");
      } else {
        printf("PARENT:  PID=%d terminated (the child) with status %d\n", childPid, WEXITSTATUS(status));
      }

      sleep(1);
    }

    if (errno == ECHILD) {
      printf("In PID = %d, no more child processes\n",
             getpid());
      exit(EXIT_SUCCESS);
    } else {
      fprintf(stderr, "Error #%d: %s\n", errno, strerror(errno));
      exit(EXIT_FAILURE);
    }

    break;
  }


}
