package P3.esercizi.es2;

import java.lang.reflect.Field;
import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        try (Scanner scanner = new Scanner(System.in)) {
            Geometries geometries = new Geometries();
            int choice = 1;
            while (choice != 0) {
                System.out.println("Input 1 for Rectangle, 2 for Parallelogram, 0 to exit");
                choice = scanner.nextInt();
                try {
                    if (choice == 1) {
                        System.out.println("Input the following parameters in order: ");
                        for (Field field : Class.forName("P3.esercizi.es2.Rectangle").getDeclaredFields()) {
                            System.out.println(field.getName());
                        }
                    } else if (choice == 2) {
                        System.out.println("Input the following parameters in order: ");
                        for (Field field : Class.forName("P3.esercizi.es2.Parallelogram").getDeclaredFields()) {
                            System.out.println(field.getName());
                        }
                    } else {
                        continue;
                    }
                } catch (SecurityException e) {
                    System.out.println("SecurityException");
                    e.printStackTrace();
                    return;
                } catch (ClassNotFoundException e) {
                    System.out.println("ClassNotFoundException");
                    e.printStackTrace();
                    return;
                }

                Polygon p = choice == 1 ? new Rectangle(scanner.nextInt(), scanner.nextInt())
                        : new Parallelogram(scanner.nextInt(), scanner.nextInt(), scanner.nextInt(), scanner.nextInt(),
                                scanner.nextInt());

                geometries.addPolygon(p);
            }
            scanner.close();
            System.out.println("Number of polygons: " + geometries.countPolygons());
            System.out.println("Polygons: " + geometries);
            System.out.println("Areas: " + geometries.printAreas());
        }
    }
}
