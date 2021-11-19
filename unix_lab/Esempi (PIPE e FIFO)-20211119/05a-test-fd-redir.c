#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <fcntl.h>
#include <errno.h>
#include <string.h>

#define CMD1 "ps"
#define CMD1_ARGS "-Af"

#define CMD2 "wc"
#define CMD2_ARGS "-l"

#define OUTFILE "num_procs"

/*
 * Simulating the shell code when invoking:
 *
 * ps -Af | wc -l > num_proc
 */

#define TEST_ERROR    if (errno) {fprintf(stderr, \
					  "%s:%d: PID=%5d: Error %d (%s)\n", \
					  __FILE__,			\
					  __LINE__,			\
					  getpid(),			\
					  errno,			\
					  strerror(errno));}


int main ()
{
	int out_fd, pipe_fd[2];
	char * args1[] = {CMD1, CMD1_ARGS, NULL};	
	char * args2[] = {CMD2, CMD2_ARGS, NULL};
	int child_pid, status;

	/* 
	 * Creating the pipe needed to connect output of CMD1 to input
	 * of CMD2
	 */
	pipe(pipe_fd);
	TEST_ERROR;
	
	/* Creating CMD1 process */
	if (!fork()) {
		/* CMD1 not reading from pipe: closing read end */
		close(pipe_fd[0]);
		/* Redirecting fd 1 to write end of pipe */
		dup2(pipe_fd[1],1);
		/* Closing the original write end of the pipe: we are
		 * using fd 1 */
		close(pipe_fd[1]);

		/* Now that file descriptors are properly wired, we
		 * can switch to the process */ 
		execvp(CMD1, args1);
		TEST_ERROR;
	}

	/* Creating a file where output of CMD2 will be written */
	out_fd = open(OUTFILE, O_WRONLY | O_CREAT | O_TRUNC,
		      S_IRUSR | S_IWUSR);
	TEST_ERROR;
	
	/* Creating CMD2 process */
	if (!fork()) {
		/* CMD2 not writing to pipe: closing write end */
		close(pipe_fd[1]);
		/* Getting input from pipe (not from fd 0) */
		dup2(pipe_fd[0], 0);
		/* Closing the original read end of the pipe: we are
		 * using fd 0 */
		close(pipe_fd[0]);

		/* Now setting putput to open file */
		dup2(out_fd, 1);
		close(out_fd);
		
		/* Now that file descriptors are properly wired, we
		 * can switch to the process */ 
		execvp(CMD2, args2);
		TEST_ERROR;		
	}

	/* Parent not using the pipe, then closing both ends */
	close(pipe_fd[0]);
	close(pipe_fd[1]);

	/* Parent process just waits */
	while ((child_pid = wait(&status)) != -1) {
		printf("PARENT: PID=%d. Got info of child with PID=%d, status=0x%04X\n", getpid(), child_pid,status);
	}
	
	exit(EXIT_SUCCESS);
}
