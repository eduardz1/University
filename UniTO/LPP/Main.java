package LPP;

import java.util.Arrays;
import java.util.List;

public class Main {

  public static void main(String[] args) {
    var b1 = new Book("Java 9", "Herbert Schildt", 49.99f);
    var b2 = new Book("A Song of Ice and Fire", "George R.R. Martin", 30.0f);
    var b3 = new Book("Harry Potter", "J.K. Rowling", 15.0f);
    var b4 = new Book("The Theory of Everything", "Stephen Hawking", 25.0f);
    var b5 = new Book("The Lord of the Rings", "J.R.R. Tolkien", 20.0f);

    System.out.println("Lowest cost book: " + getLowerCost(b1, b2, b3, b4, b5));
    System.out.println("All books lower than 20$: " + getLowerThan(20, b1, b2, b3, b4, b5));
    System.out.println("Books ordered by price: " + orderBooks(b1, b2, b3, b4, b5));
  }

  public static Book getLowerCost(Book... books) {
    return Arrays
      .stream(books)
      .min((b1, b2) -> Float.compare(b1.price(), b2.price()))
      .get();
  }

  public static List<Book> getLowerThan(float val, Book ... books) {
    return Arrays
        .stream(books)
        .filter(b -> b.price() < val)
        .toList();
  }

  public static List<Book> orderBooks(Book ... books) {
    return Arrays
        .stream(books)
        .sorted((b1, b2) -> Float.compare(b1.price(), b2.price()))
        .toList();
  }
}
