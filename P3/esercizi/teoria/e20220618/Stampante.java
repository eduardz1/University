package teoria.e20220618;

class Stampante {

  private int inchiostroNero = 1, inchiostroColor = 1;

  public synchronized void stampa(String colore) {
    if (colore.equals("nero")) {
      while (inchiostroNero <= 0) {
        try {
          wait();
        } catch (InterruptedException e) {}
      }
      System.out.println(colore);
      inchiostroNero--;
    } else {
      while (inchiostroColor <= 0) {
        try {
          wait();
        } catch (InterruptedException e) {}
      }
      System.out.println(colore);
      inchiostroColor--;
    }
  }

  public synchronized void caricaInchiostro(String colore) {
    if (colore.equals("nero")) inchiostroNero++; else inchiostroColor++;
    System.out.println("caricato " + colore);
    notify();
  }
}
