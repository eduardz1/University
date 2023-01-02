#include <stdio.h>
#include <signal.h>
#include <sys/types.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <unistd.h>
#include <time.h>

int var = 0;
pid_t * children;
int argv2;

void interation()
{
    var += 1;
    var %= argv2;
}

int spawnChild()
{
    pid_t self = fork();
    switch(self)
    {
    case -1: // error case
        exit(1);
        break;
    case 0: // child case
        sigaction(SIGUSR1, NULL, NULL);
        while (1)
        {
            interation();
            if (var == 0)
                kill(SIGUSR1, getppid());
        }
        break;
    default:
        return self;
    }
}

void handleSIGUSR1(int signal)
{
    if (var == 0)
        kill(SIGINT, rand() % argv2);

    if (wait(NULL) == -1)
        exit(0);
}

int main(int argc, char const *argv[])
{
    if (argc < 3)
        printf("Errore troppi pochi parametri\n");

    argv2 = atoi(argv[2]);
    srand(time(NULL));

    children = calloc(argv2, sizeof(pid_t));

    struct sigaction sa;
    sa.sa_handler = handleSIGUSR1;
    sigaction(SIGUSR1, &sa, NULL);

    for (int i = 0; i < atoi(argv[1]); i++)
    {
        children[i] = spawnChild();
    }

    while (1) interation();
}