package teoria.e20220201;

/*
 * {[lista di lock], [lista di wait], content, available}
 *
 */
public class EsercizioSenzaPrint {

  public static void main(String[] args) {
    CubbyHole c = new CubbyHole();
    Consumer c1v = new Consumer("vegano", c);
    Producer p1v = new Producer("vegano", c);
    Consumer c2p = new Consumer("pescetariano", c);
    Producer p3g = new Producer("generico", c);
    Producer p2p = new Producer("pescetariano", c);
    Consumer c3g = new Consumer("generico", c);
  }
}

/*
 * {[ c1v, p1v, c2p, p3g, p2p, c3g ], [ ], “”, false}
 * {[ p1v, c2p, p3g, p2p, c3g ], [ c1v ], “”, false}
 * {[ c2p, p3g, p2p, c3g, c1v ], [ ], “vegano”, true}
 * {[ p3g, p2p, c3g, c1v ], [ c2p ], "vegano", true}
 * {[ p2p, c3g, c1v ], [ c2p, p3g ], "vegano", true}
 * {[ c3g, c1v ], [ c2p, p2g, p2p ], "vegano", true}
 * {[ c1v ], [ c2p, p2g, p2p, c3g ], "vegano", true}
 * {[ c2p ], [ p2g, p2p, c3g ], "", false}
 * {[], [ p2g, p2p, c3g, c2p ], "", false}
 */