package esercizi.mvc;

/**
 * Relazioni tra le componenti dell'app:
 *  - il Controller ha un riferimento al Model
 *  - il Controller è un listener degli eventi della View
 *  - la View è un osservatore del Model
 *  Tutti i "collegamenti" tra le varie componenti sono effettuati dal
 *  costruttore del controller.
 */
public class ProverbsApp {
    public static void main(String[] args) {
		Model model = new Model();
        View view = new View("Proverbi:");
        Controller controller = new Controller(model, view);
    }
}











