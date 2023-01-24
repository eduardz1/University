package teoria.e20220618;

// Si simuli un’esecuzione del programma riportato sotto supponendo che le liste di lock e di wait
// siano gestite con una politica First In First Out. Per la simulazione si riportino tutti i cambiamenti di
// stato del programma, e le stampe che vengono fatte, assumendo che lo stato sia descritto come segue:
// {[lista di lock], [lista di wait], [inchiostroNero, inchiostroColor]}. Si assuma che lo stato iniziale del
// programma sia: {[ s1, s2, s3, c1, c2, c3 ], [ ], [1, 1]}, dove s1 è il primo elemento della lista e c3 l’ultimo.
public class Esercizio {

  public static void main(String[] args) {
    Stampante printer = new Stampante();
    Stampatore s1 = new Stampatore(printer, "nero");
    Stampatore s2 = new Stampatore(printer, "nero");
    Stampatore s3 = new Stampatore(printer, "color");
    Caricatore c1 = new Caricatore(printer, "nero");
    Caricatore c2 = new Caricatore(printer, "color");
    Caricatore c3 = new Caricatore(printer, "nero");
  }
}

/*
 * {[ s1, s2, s3, c1, c2, c3 ], [ ], [1, 1]}
 * {[ s2, s3, c1, c2, c3 ], [ ], [0, 1]}
 * {[ s3, c1, c2, c3 ], [ s2 ], [0, 1]}
 * {[ c1, c2, c3 ], [ s2 ], [0, 0]}
 * {[ c2, c3, s2 ], [ ], [1, 0]}
 * {[ c2, c3 ], [ ], [1, 0]}
 * {[ c3 ], [ ], [2, 0]}
 * {[ s2 ], [ ], [2, 1]}
 * {[ ], [ ], [1, 1]}
 */
