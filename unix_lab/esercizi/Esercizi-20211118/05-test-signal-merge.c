#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <signal.h> /* sigaction(), sig*() */

/*
 * Handler of a signal is a function taking an integer as input and
 * producing no output
 */
void handle_signal(int signal);

int main()
{
	struct sigaction sa;
	sigset_t  my_mask;
	
	/* Print pid, so that we can send signals from other shells */
	printf("My pid is: %d\n", getpid());
	
	/* Setting the handler of Ctrl+C (SIGINT = 2) */
	sa.sa_handler = handle_signal;
	sa.sa_flags = 0;
	sigemptyset(&my_mask);    /* do not mask any signal during handler */
	sa.sa_mask = my_mask;
	sigaction(SIGINT, &sa, NULL);
	
	for (;;) {
		printf("Sleeping for ~3 seconds\n");
		sleep(3);
	}
}

void handle_signal(int signal) {
	static int count_invocations = 0;
	
	count_invocations++;
	printf("Handling signal #%d (%s): invocation %d (sleeping 2 seconds)\n",
	       signal, strsignal(signal), count_invocations);
	sleep(2);
	printf("Done handling: invocation %d\n", count_invocations);
}
