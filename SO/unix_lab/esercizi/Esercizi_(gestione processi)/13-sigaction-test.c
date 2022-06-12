#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include <signal.h>
#include <sys/sysinfo.h>
#include <sys/wait.h>

void sigchldtest(int sig) {
  printf("SIGCHLD signal received! %d\n", sig);
}

int main() {
  struct sigaction act;
  pid_t my_pid, my_ppid, value;
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

    sleep(5);
    exit(EXIT_SUCCESS);

  default:
    act.sa_handler = sigchldtest;
    sigemptyset(&act.sa_mask);
    act.sa_flags = 0;

    sigaction(SIGCHLD, &act, 0);

    /* Perform actions specific to parent */
    my_pid = getpid();
    my_ppid = getppid();
    printf("PARENT: PID=%d, PPID=%d, fork_value=%d\n", my_pid, my_ppid, value);

    printf("Waiting for child process %d termination...\n",value);

    pid_t terminatedPid;
    while ((terminatedPid = wait(&status)) != -1) {
      printf("Child terminated with status %d\n",status);
    }

    if (errno == ECHILD) {
      printf("In PID = %d, no more child processes\n",
             getpid());
      exit(EXIT_SUCCESS);
    } else {
      fprintf(stderr, "Error #%d: %s\n", errno, strerror(errno));
      exit(EXIT_FAILURE);
    }
  }


}
