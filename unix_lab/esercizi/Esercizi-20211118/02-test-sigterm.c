#include <unistd.h>
#include <stdio.h>
#include <signal.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>

void handler_int(int s) {
	printf("\n ricevuto segnale SIGINT \n");
	//signal(SIGINT, SIG_DFL);
}

int main(int argc, char *argv[]) {
	int i;

  printf("Id processo: %d\n",getpid());

	// associazione segnale-handler
	if (signal(SIGINT, handler_int)==SIG_ERR) {
    	printf("\nErrore della disposizione dell'handler: %s\n",strerror(errno));
    	exit(EXIT_SUCCESS);
  	}
  	


	while(1) {
	    printf("tic\n");
	    sleep(1);
  	}
	exit(EXIT_SUCCESS);
}