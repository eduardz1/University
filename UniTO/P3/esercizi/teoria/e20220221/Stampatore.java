package teoria.e20220221;

class Stampatore extends Thread {

  private Stampante stampante;

  public Stampatore(Stampante stamp) {
    stampante = stamp;
    start();
  }

  public void run() {
    stampante.stampa("ciao");
  }
}