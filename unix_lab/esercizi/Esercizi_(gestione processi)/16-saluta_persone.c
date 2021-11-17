#include <stdio.h>
#include <unistd.h>

int main(int argc, char *argv[]) {

  int i=1;
  for (;i<argc;i++) {
    printf("Ciao %s\n",argv[i]);
    sleep(1);
  }

}
