package teoria.e20220618;

class Caricatore extends Thread {

  private Stampante stampante;
  private String colore;

  public Caricatore(Stampante stamp, String colore) {
    stampante = stamp;
    this.colore = colore;
    start();
  }

  public void run() {
    stampante.caricaInchiostro(colore);
  }
}