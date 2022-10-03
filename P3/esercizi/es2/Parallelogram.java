package P3.esercizi.es2;

public class Parallelogram implements Polygon {
    private int base;
    private int height;
    private int diagonal1;
    private int diagonal2;
    private int side;

    public Parallelogram(int base, int height, int diagonal1, int diagonal2, int side) {
        this.base = base;
        this.height = height;
        this.diagonal1 = diagonal1;
        this.diagonal2 = diagonal2;
        this.side = side;
    }

    @Override
    public int getArea() {
        return base * height;
    }

    @Override
    public int getPerimeter() {
        return 2 * (base + side);
    }

    @Override
    public int getNumVertices() {
        return 4;
    }

    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + base;
        result = prime * result + diagonal1;
        result = prime * result + diagonal2;
        result = prime * result + height;
        result = prime * result + side;
        return result;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj)
            return true;
        if (obj == null)
            return false;
        if (getClass() != obj.getClass())
            return false;
        Parallelogram other = (Parallelogram) obj;
        if (base != other.base)
            return false;
        if (diagonal1 != other.diagonal1)
            return false;
        if (diagonal2 != other.diagonal2)
            return false;
        if (height != other.height)
            return false;
        if (side != other.side)
            return false;
        return true;
    }

    @Override
    public String toString() {
        return "Parallelogram [base=" + base + ", diagonal1=" + diagonal1 + ", diagonal2=" + diagonal2 + ", height="
                + height + ", side=" + side + "]";
    }

    
}
