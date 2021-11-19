#include <stdio.h>
#include <errno.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>

#define MY_OUT "mio.txt"
/*
#define REDIRECT_STDOUT
*/

int main ()
{
	int out_fd, new_fd;
	
	/* open a file in write mode */
	if ((out_fd = open(MY_OUT,
			   O_WRONLY | O_CREAT | O_TRUNC,
			   S_IRUSR | S_IWUSR)) == -1) {
		fprintf(stderr, "Error %d (%s) when opening file \"%s\"\n",
			errno,
			strerror(errno),
			MY_OUT);
		exit(EXIT_FAILURE);
	}

#ifdef REDIRECT_STDOUT
	new_fd = dup2(out_fd, 1);
	fprintf(stderr, "Writing data to fd=%d, will actually write to fd=%d\n",
		new_fd, out_fd);
#endif	
	/* if dup2 happened, it prints on the file */
	dprintf(1, "Printing to stdout\n");     
	
	/* this prints to the file anyway */
	dprintf(out_fd, "Printing to out_fd\n");
	close(out_fd);
}
