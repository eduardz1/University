import java.util.*;
import java.util.stream.Collectors;

public class PuttingIntoPractice {

  public static void main(String... args) {
    Trader raoul = new Trader("Raoul", "Cambridge");
    Trader mario = new Trader("Mario", "Milan");
    Trader alan = new Trader("Alan", "Cambridge");
    Trader brian = new Trader("Brian", "Cambridge");

    List<Transaction> transactions = Arrays.asList(
      new Transaction(brian, 2011, 300),
      new Transaction(raoul, 2012, 1000),
      new Transaction(raoul, 2011, 400),
      new Transaction(mario, 2012, 710),
      new Transaction(mario, 2012, 700),
      new Transaction(alan, 2012, 950)
    );
    // Query 1: Find all transactions from year 2011 and sort them by value (small to high).

    // Query 2: What are all the unique cities where the traders work?

    // Query 3: Find all traders from Cambridge and sort them by name.

    // Query 4: Return a string of all traders’ names sorted alphabetically.

    // Query 5: Are there any trader based in Milan?

    // Query 6: Update all transactions so that the traders from Milan are set to Cambridge.

    // Query 7: What's the highest value in all the transactions?

  }

  /**
   * Query 1
   */
  public static List<Transaction> sortedTransactionsFrom(
    int year,
    Transaction... trans
  ) {
    return Arrays
      .stream(trans)
      .filter(t -> t.getYear() == year)
      .sorted((t1, t2) -> Integer.compare(t1.getValue(), t2.getValue()))
      .toList();
  }

  /**
   * Query 2
   */
  public static Set<String> getTradersCities(Transaction... trans) {
    return Arrays
      .stream(trans)
      .map(t -> t.getTrader().getCity())
      .collect(Collectors.toSet());
  }

  /**
   * Query 3
   */
  public static Set<Trader> getTradersFrom(String city, Transaction... trans) {
    return Arrays
      .stream(trans)
      .filter(t -> t.getTrader().getCity().equals(city))
      .map(Transaction::getTrader)
      .collect(Collectors.toSet());
  }

  /**
   * Query 4
   */
  public static String allTradersSorted(Transaction... trans) {
    return Arrays
      .stream(trans)
      .sorted((t1, t2) ->
        t1.getTrader().getName().compareTo(t2.getTrader().getName())
      )
      .toString();
  }

  /**
   * Query 5
   */
  public static Boolean tradersFrom(String city, Transaction... trans) {
    return getTradersCities(trans).contains(city);
  }

  /**
   * Query 6
   */
  public static List<Trader> updateNationality(
    String oldCity,
    String newCity,
    Trader... trads
  ) {
    return Arrays
      .stream(trads)
      .map(t ->
        t.getCity().equals(oldCity) ? new Trader(t.getName(), newCity) : t
      )
      .toList();
  }

  /**
   * Query 7
   */
  public static int highestValue(Transaction... trans) {
    return Arrays
      .stream(trans)
      .max((t1, t2) -> Integer.compare(t1.getValue(), t2.getValue()))
      .get()
      .getValue();
  }
}
