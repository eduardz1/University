package LPP.esami;

import java.util.*;
import java.util.stream.Collectors;

public class Album {

  private String author;
  private List<String> songs;
  private int year;
  private String title;

  public Album(String author, String title, int year, String... songs) {
    this.author = author;
    this.year = year;
    this.title = title;
    this.songs = new ArrayList<>(Arrays.asList(songs));
  }

  public String getAuthor() {
    return author;
  }

  public List<String> getSongs() {
    return songs;
  }

  public int getYear() {
    return year;
  }

  public String getTitle() {
    return title;
  }

  /**
   * lista dei titoli dei dischi pubblicati prima del 1995,
   * con titoli in ordine alfabetico
   */
  public ArrayList<Album> earlierThan1995(Album... albums) {
    return Arrays
      .stream(albums)
      .filter(a -> a.getYear() < 1995)
      .sorted((a1, a2) -> a1.getTitle().compareTo(a2.getTitle()))
      .collect(Collectors.toCollection(ArrayList::new));
  }

  /**
   * creare la lista dei autori degli album pubblicati nel 1995 o nel 1996
   */
  public ArrayList<String> authors1995or1996(Album... albums) {
    return Arrays
      .stream(albums)
      .filter(a -> a.getYear() == 1995 || a.getYear() == 1996)
      .map(Album::getAuthor)
      .distinct()
      .collect(Collectors.toCollection(ArrayList::new));
  }

  /**
   * returns the author of the album with the given title
   */
  public static String authorOf(String albumTitle, Album... albums) {
    return Arrays
      .stream(albums)
      .filter(a -> a.getTitle().equals(albumTitle))
      .map(Album::getAuthor)
      .findFirst()
      .orElse(null);
  }

  public static void main(String[] args) {
    List<Album> albums = new ArrayList<>();

    albums.add(
      new Album(
        "Pink Floyd",
        "The Division Bell",
        1994,
        "Cluster One",
        "What Do You Want from Me",
        "Poles Apart",
        "Marooned",
        "A Great Day for Freedom",
        "Wearing the Inside Out",
        "Take It Back",
        "Coming Back to Life",
        "Keep Talking",
        "Lost for Words",
        "High Hopes"
      )
    );

    albums.add(
      new Album(
        "Daft Punk",
        "Discovery",
        2001,
        "One More Time",
        "Aerodynamic",
        "Digital Love",
        "Harder, Better, Faster, Stronger",
        "Crescendolls",
        "Nightvision",
        "Superheroes",
        "High Life",
        "Something About Us",
        "Voyager",
        "Veridis Quo",
        "Short Circuit",
        "Face to Face",
        "Too Long",
        "Burning",
        "Contact"
      )
    );

    albums.add(
      new Album(
        "Gorillaz",
        "Demon Days",
        2005,
        "Intro",
        "Last Living Souls",
        "Kids with Guns",
        "O Green World",
        "Dirty Harry",
        "Feel Good Inc.",
        "El Mañana",
        "Every Planet We Reach Is Dead",
        "November Has Come",
        "All Alone",
        "White Light",
        "DARE",
        "Fire Coming Out of the Monkey's Head",
        "Doncamatic",
        "Demon Days"
      )
    );

    System.out.println("author of Discovery: " + authorOf("Discovery", albums.toArray(new Album[0])));
  }
}
