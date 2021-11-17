#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include <sys/sysinfo.h>
#include <sys/wait.h>

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

    sleep(60);
    exit(72);

  default:
    /* Perform actions specific to parent */
    my_pid = getpid();
    my_ppid = getppid();
    printf("PARENT: PID=%d, PPID=%d, fork_value=%d\n", my_pid, my_ppid, value);

    while ((childPid = waitpid(-1, &status, WUNTRACED | WCONTINUED))!= -1) {
      printf("waitpid returned %d\n",childPid);
      if (WIFSIGNALED(status)) {
        printf("WIFSIGNALED(status) is true\n");
        printf("WTERMSIG(status): %d\n",WTERMSIG(status));
      } else if (WIFSTOPPED(status)) {
        printf("WIFSTOPPED(status) is true\n");
      } else if (WIFCONTINUED(status)) {
        printf("WIFCONTINUED(status) is true\n");
      } else if (WIFEXITED(status)) {
        printf("WIFEXITED(status) is true\n");
        printf("WEXITSTATUS(status): %d\n",WEXITSTATUS(status));
      } else {
        printf("Unexpected status\n");
      }
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
