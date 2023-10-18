#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/sysinfo.h>
#include <sys/wait.h>
#include <errno.h>
#include <time.h>
#include <string.h>


int main (void) {
	pid_t child_pid;
	int status;

    char* env_vars[] = {
		"VAR1=variabile1",
		"HOME=boh",
		NULL
	};

	char* args[] = {
    "14a-somma",
		"12",   /* */
		"14",
		NULL
	};

	printf("%s: My PID is %d and my parent's PID is %d\n",
	       __FILE__, getpid(), getppid());

	/* Creating child processes that run an external command */
    //#define COMMAND "gcc 14a-somma.c -o 14a-somma"
	//status = system(COMMAND);
	//printf("COMMAND \"%s\" terminated with exit status %d\n", COMMAND, status);


	execve("./14a-somma",args,NULL);

	/* don't need to check success. If here not success */
	fprintf(stderr, "%s: %d. Error #%03d: %s\n", __FILE__, __LINE__, errno, strerror(errno));

	exit(EXIT_FAILURE);
}
