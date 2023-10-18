package teoria.e20210719;

public class Esame {
    public static void main(String[] args) {
    Point uno = new Point(4, 5);
    Point due = new Point(4, 5);
    System.out.println(uno.equals(due)); // TRUE
    Point3D tre = new Point3D(2, 5, 7);
    Point3D quattro = new Point3D(2, 5, 7);
    System.out.println(uno.equals(tre)); // FALSE
    System.out.println(tre.equals(quattro)); // TRUE 
    }
   }