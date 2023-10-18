package teoria.e20220201;

public class Consumer extends Thread {

  private CubbyHole cubbyHole;
  private String type;

  public Consumer(String type, CubbyHole c) {
    cubbyHole = c;
    this.type = type;
    start();
  }

  public void run() {
    cubbyHole.get(type);
  }
}
