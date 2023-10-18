package teoria.e20220221;

class Caricatore extends Thread {
  int[] buffer;

  private Stampante stampante;

  public Caricatore(Stampante stamp) {
    stampante = stamp;
    start();
  }

  public void run() {
    stampante.caricaInchiostro();
  }
}