package LPP.esami;

import java.util.*;
import java.util.stream.Collectors;
 
public class Album {
    
   private String author;
   private List<String> songs;
   private int year;
   private String title;
    
   public Album(String author, String title, int year, String... songs){
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
   public ArrayList<Album> earlierThan1995(Album ... albums) {
      return Arrays.stream(albums)
         .filter(a -> a.getYear() < 1995)
         .sorted((a1, a2) -> a1.getTitle().compareTo(a2.getTitle()))
         .collect(Collectors.toCollection(ArrayList::new));
   }

   /**
    * creare la lista dei autori degli album pubblicati nel 1995 o nel 1996
    */
   public ArrayList<String> authors1995or1996(Album ... albums) {
      return Arrays.stream(albums)
         .filter(a -> a.getYear() == 1995 || a.getYear() == 1996)
         .map(Album::getAuthor)
         .distinct()
         .collect(Collectors.toCollection(ArrayList::new));
   }
}
