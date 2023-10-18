package teoria.e20220618;

class Stampatore extends Thread {

  private Stampante stampante;
  private String colore;

  public Stampatore(Stampante stamp, String colore) {
    stampante = stamp;
    this.colore = colore;
    start();
  }

  public void run() {
    if (colore.equals("nero")) stampante.stampa("nero"); else stampante.stampa(
      "color"
    );
  }
}