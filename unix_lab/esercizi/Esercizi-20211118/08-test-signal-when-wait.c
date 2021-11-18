#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>
#include <sys/types.h>
#include <errno.h>
#include <string.h>
#include <signal.h>

#define NUM_KIDS 8


/* #define USE_SA_RESTART_FLAG */
/* #define RETRY_WAIT_IF_EINTR */


void handle_sig(int signum) {

	printf("PID= %5d (PARENT): Got signal %d, some child is half way\n",
	       getpid(), signum);
}

int main (int argc, char * argv[]) {
	long num_cores, n_loops;
	pid_t child_pid;
	int status, i, j;
	struct sigaction sa;
	
	/* Read n_loops from argv[1] */
	if (argc < 2) {
		fprintf(stderr, "Please specify argv[1] as n_loops\n");
		return -1;
	} else {
		n_loops = atol(argv[1]);
	}

	/* Setting the handler of SIGUSR1 for the parent */
	bzero(&sa, sizeof(sa));
	sa.sa_handler = handle_sig;
#ifdef USE_SA_RESTART_FLAG
	sa.sa_flags = SA_RESTART;
#endif
	sigaction(SIGUSR1, &sa, NULL);
	
	/* Looping to create child processes */ 
	for (i=0; i<NUM_KIDS; i++) {
		switch (child_pid = fork()) {
		case -1:
			/* Handle error */
			fprintf(stderr, "Error with the fork\n");
			exit(EXIT_FAILURE);
		case 0:
			/* Perform actions specific to child */
			printf("PID= %5d (CHILD): i=%d, running a lot\n",
			       getpid(), i);
			/* 
			 * Keeping the CPU busy. Sending SIGUSR1 to
			 * parent when half way
			 */
			for(j=0; j<n_loops; j++)
				if (j == n_loops/2)
					kill(getppid(), SIGUSR1);
			exit(i);
			printf("Hi, \
my PID is %d and you should never see this message\n", getpid());
			break;
			
		default:
			/* Perform actions specific to parent */
			printf("PID= %5d (PARENT): parent of a child with PID %d\n",
			       getpid(), child_pid);
			fflush(stdout);
			break;
		}
	}
	
	/* Now let's wait that all kids do the stuff */
#ifndef RETRY_WAIT_IF_EINTR
	while ((child_pid = wait(&status)) != -1) {
#else
	while (1) {
		child_pid = wait(&status);
		if (child_pid == -1) {
			if (errno == EINTR)
				/*
				 * A signal  was caught  while waiting
				 * on wait.  Hence we  must go back to
				 * wait
				 */
				continue;
			else
				break;
		}
#endif
		printf("PID= %5d (PARENT): \
Got info of child with PID=%d, status=0x%04X\n",
		       getpid(), child_pid, status);
	}
	if (errno == ECHILD) {
		printf("In PID=%6d, no more child processes\n",
		       getpid());
		exit(EXIT_SUCCESS);
	} else {
		fprintf(stderr, "Error #%d: %s\n", errno, strerror(errno));
		exit(EXIT_FAILURE);
	}
}

