#include <unistd.h>
#include <stdio.h>
#include <errno.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/wait.h>

#define NUM_KIDS  20


int main (int argc, char * argv[]) {
	int i;
	int status, sum;

	/*
	 * Ciclo per la creazione dei processi figlio
	 */
	for (i=0; i<NUM_KIDS; i++) {
		switch (fork()) {
		case -1:
			/* Handle error */
			fprintf(stderr, "%s, %d: Errore (%d) nella fork\n",
				__FILE__, __LINE__, errno);
			exit(EXIT_FAILURE);
		case 0:
			/* CHILD CODE */
			/*
			 * Inizializza il seed con il PID del figlio.
			 * In questo modo, la generazione di numeri
			 * casuali sara` diversa per ogni figlio.
			 */
			srand(getpid());
			/*
			 * Esci con stato uguale ad un numero casuale
			 * dal 1 a 6 come richiesto.
			 */
			exit(rand()%6+1);
			break;
		default:
			/* PARENT CODE: nothing here */
			break;
		}
	}

	sum = 0;
	while (wait(&status) != -1) {
		/* 
		 * Estrai l'exit status dei figli e somma in sum
		 */
		sum += WEXITSTATUS(status);
	}
	/*
	 * A questo punto il processo padre, avendo correttamente
	 * eseguito una wait su tutti i figli, non ha piu` figli in
	 * circolazione (terminati o in esecuzione)
	  */
	printf("Numero figli:\n%u\n", NUM_KIDS);
	printf("Somma dei valori di uscita\n%u\n", sum);
	exit(EXIT_SUCCESS);
}
