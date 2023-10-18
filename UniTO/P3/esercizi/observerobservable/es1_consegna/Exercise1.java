package esercizi.observerobservable.es1_consegna;

public class Exercise1 {
	public static void main(String[] args) {
		Visualizer v = new Visualizer();
		Filter f = new Filter(v);
		Counter c = new Counter(f);
		c.start();
   	}
}









