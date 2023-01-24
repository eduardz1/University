package teoria.e20220201;

public class CubbyHole {

  private String content = "";
  private boolean available = false;

  public synchronized String get(String type) {
    while (!available || !content.equals(type)) {
      try {
        wait();
      } catch (InterruptedException e) {}
    }
    available = false;
    String ris = content;
    content = "";
    notify();
    return ris;
  }

  public synchronized void put(String value) {
    while (available) {
      try {
        wait();
      } catch (InterruptedException e) {}
    }
    content = value;
    available = true;
    notify();
  }
}
