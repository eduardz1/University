#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/sysinfo.h>
#include <sys/wait.h>
#include <errno.h>
#include <time.h>
#include <string.h>

int main(int argc, char *argv[]) {

	printf("%s: My PID is %d and my parent's PID is %d\n",
	       __FILE__, getpid(), getppid());

	if (argc==3) {
		int i=atoi(argv[1]);
		int j=atoi(argv[2]);

		printf("i+j = %d\n", i+j);
	} else {
		printf("Sono richiesti due argomenti. Ne sono stati inseriti %d\n",argc-1);
	}
}
