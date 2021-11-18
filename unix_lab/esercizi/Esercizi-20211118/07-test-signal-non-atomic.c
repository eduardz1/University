#define _GNU_SOURCE
#include <unistd.h>
#include <signal.h>
#include <stdio.h>

/* 
 * Try by defining the symbol at compile time with
 * (1) gcc ...
 * (2) gcc -DWIDE_DATA_MEM ...
 * (3) gcc -S -g ...
 */

/*#define WIDE_DATA_MEM*/

/*
 * The global variable "memory" is used to check if operations are
 * atomic or not
 */
#ifdef WIDE_DATA_MEM
struct two_words {double a, b; } memory;
#else
struct two_words {char a, b; } memory;
#endif

void handler(int signum)
{
	printf (
#ifdef WIDE_DATA_MEM
		"%f,%f %s\n",
#else
		"%d,%d %s\n",
#endif
		memory.a, memory.b, (memory.a==memory.b) ? "OK" : "!!");
	alarm (1);
}

int main (void)
{
	struct sigaction sa;
	static struct two_words zeros = { 0, 0 }, ones = { 1, 1 };
	sigset_t my_mask, old_mask;
	
	/* Setup the SIGALRM handler */
	sa.sa_handler = &handler;
	sa.sa_flags = 0;
	sigemptyset(&my_mask);
	sa.sa_mask = my_mask;
	sigaction(SIGALRM, &sa, NULL);

	/* Set a mask with SIGALRM */
	sigaddset(&my_mask, SIGALRM);

	memory = zeros;
	alarm (1);
	while (1)
	{
#if 1
		/* SIGALRM may arrive "in the middle" of each assignment */
		memory = zeros;
		memory = ones;
#else
		/* SIGALRM may NOT arrive "in the middle" of each assignment */
		sigprocmask(SIG_BLOCK, &my_mask, &old_mask);
		memory = zeros;
		sigprocmask(SIG_SETMASK, &old_mask, NULL);
		sigprocmask(SIG_BLOCK, &my_mask, &old_mask);
		memory = ones;
		sigprocmask(SIG_SETMASK, &old_mask, NULL);
#endif
	}
}

