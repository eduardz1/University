#include <sys/types.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include <sys/sysinfo.h>
#include <sys/wait.h>

int main()
{
  pid_t pid;
  char *message;
  int n;
  printf("fork program starting\n");
  pid = fork();
  switch(pid)
  {
    case -1:
      perror("fork failed");
      exit(1);
    case 0:
      message = "This is the child";

      char *names[]={
        "16-saluta_persone","Claudio","Mario","pipo", NULL
      };

      execvp("./16-saluta_persone",names);

    	/* don't need to check success. If here not success */
    	fprintf(stderr, "%s: %d. Error #%03d: %s\n", __FILE__, __LINE__, errno, strerror(errno));

    	exit(EXIT_FAILURE);

      break;
    default:
      message = "This is the parent";

      pid_t childPid;
      int status=0;

      if ((childPid = waitpid(-1, &status, 0))== -1) {
        if (errno == ECHILD) {
          printf("In PID = %d, no more child processes\n",
                 getpid());
          exit(EXIT_SUCCESS);
        } else {
          fprintf(stderr, "Error #%d: %s\n", errno, strerror(errno));
          exit(EXIT_FAILURE);
        }
      }

      if (WIFEXITED(status)) {
        printf("WIFEXITED(status) is true\n");
        printf("WEXITSTATUS(status): %d\n",WEXITSTATUS(status));
      } else {
        printf("Unexpected status\n");
      }

      exit(EXIT_SUCCESS);

      break;
  }


}
