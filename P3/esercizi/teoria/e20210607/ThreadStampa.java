package teoria.e20210607;

class ThreadStampa extends Thread {

  String[] arr;
  Stampante st;

  public ThreadStampa(String[] a, Stampante s) {
    arr = a;
    st = s;
  }

  public void run() {
    for (int j = 0; j < 2; j++) {
      synchronized (st) {
        for (int i = 0; i < arr.length; i++) st.stampa(arr[i]);
      }
    }
  }
}
