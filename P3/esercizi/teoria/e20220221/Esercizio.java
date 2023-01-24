package teoria.e20220221;

/*
 * Sviluppate, utilizzando il modello di sincronizzazione server-side, la classe Stampante che ha:
 *  • la variabile intera inchiostro che specifica quante unità di inchiostro sono a disposizione per 
    stampare, e che viene inizializzata a 1 alla creazione della stampante. 
    • il metodo pubblico stampa(String) per stampare una stringa di caratteri. La stampante può 
    stampare solo se inchiostro>0; ogni stampa consuma una unità di inchiostro. Se inchiostro==0, la 
    stampante mette in attesa i thread che invocano il metodo.
    • il metodo pubblico caricaInchiostro() che assegna inchiostro il valore 1 (carica una unità di 
    inchiostro nella stampante).
 */

public class Esercizio {

  public static void main(String[] args) {
    Stampante printer = new Stampante();
    Caricatore c1 = new Caricatore(printer);
    Caricatore c2 = new Caricatore(printer);
    Caricatore c3 = new Caricatore(printer);
    Stampatore p1 = new Stampatore(printer);
    Stampatore p2 = new Stampatore(printer);
    Stampatore p3 = new Stampatore(printer);
  }
}
