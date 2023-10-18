package teoria.e20210719;

// Si consideri il seguente codice. La classe Point rappresenta punti bidimensionali, con le loro
// coordinate.
// • Si sviluppi il metodo equals() della classe Point in modo che, se due punti hanno uguali
// coordinate, la loro comparazione restituisca il valore true (come in uno.equals(due)).
// Diversamente, se due punti hanno coordinate differenti, deve restituire false.
// • Inoltre, utilizzando l’ereditarietà, si sviluppi la classe Point3D, che rappresenta punti
// tridimensionali ed estende Point. Anche nella classe Point3D, fare in modo
// che la comparazione di due punti con uguali coordinate sia true
// (come in tre.equals(quattro)), mentre la comparazione di punti con coordinate
// differenti, o di punti di tipo diverso, sia false (come in uno.equals(tre)).
class Point {

  private int x;
  private int y;

  public Point(int x, int y) {
    this.x = x;
    this.y = y;
  }

  public int getX() {
    return x;
  }

  public int getY() {
    return y;
  }

  @Override
  public boolean equals(Object obj) {
    if (this == obj) return true;
    if (obj == null) return false;
    if (getClass() != obj.getClass()) return false;
    
    Point other = (Point) obj;
    if (x != other.x) return false;
    if (y != other.y) return false;
    return true;
  }
}
