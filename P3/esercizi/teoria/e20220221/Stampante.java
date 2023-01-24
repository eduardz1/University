package teoria.e20220221;

class Stampante {

  private int inchiostro = 1;

  public synchronized void stampa(String s) {
    while (inchiostro <= 0) {
      try {
        wait();
      } catch (InterruptedException e) {}
    }
    System.out.println(s);
    inchiostro--;
    //notify();
  }

  public synchronized void caricaInchiostro() {
    System.out.println("sto ricaricando");
    inchiostro++;
    notify();
  }
}