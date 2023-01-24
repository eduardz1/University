package teoria.e20210607;

// Si consideri il seguente codice. Si dica se l’applicazione gestisce la stampante
// in modo corretto (cioè se è garantito che ciascun array venga stampato senza
// interruzioni). In caso negativo si corregga il codice in modo da sincronizzare
// i thread secondo il modello client side.
class Stampante {

  public void stampa(String el) {
    try {
      Thread.sleep((long) (Math.random() * 100));
    } catch (InterruptedException e) {
      System.out.println(e.getMessage());
    }
    System.out.println(el);
  }
}
