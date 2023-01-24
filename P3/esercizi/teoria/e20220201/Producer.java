package teoria.e20220201;

class Producer extends Thread {

  private CubbyHole cubbyhole;
  private String type;

  public Producer(String type, CubbyHole c) {
    cubbyhole = c;
    this.type = type;
    start();
  }

  public void run() {
    cubbyhole.put(type);
  }
}
