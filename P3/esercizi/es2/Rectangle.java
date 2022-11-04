package esercizi.es2;

public class Rectangle implements Polygon {
    private int base;
    private int height;

    public Rectangle(int base, int height) {
        this.base = base;
        this.height = height;
    }

    @Override
    public int getArea() {
        return base * height;
    }

    @Override
    public int getPerimeter() {
        return 2 * (base + height);
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
        result = prime * result + height;
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
        Rectangle other = (Rectangle) obj;
        if (base != other.base)
            return false;
        if (height != other.height)
            return false;
        return true;
    }

    @Override
    public String toString() {
        return "Rectangle [base=" + base + ", height=" + height + "]";
    }

}
