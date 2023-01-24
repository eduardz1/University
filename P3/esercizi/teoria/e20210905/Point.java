package teoria.e20210905;

public class Point {
    private int x;
    private int y;

    public Point(int x, int y) {
        this.x = x;
        this.y = y;
    }

    public int getX() { return x; }
    public int getY() { return y; }

    // esercizio 1: 
    // scrivere il metodo clone facendo l'override di quello in Object
    @Override
    protected Object clone() throws CloneNotSupportedException {
        return new Point(x, y); // what? che razza di esame è?
    }
}
