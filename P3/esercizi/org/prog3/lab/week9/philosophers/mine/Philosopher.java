package org.prog3.lab.week9.philosophers.mine;

public class Philosopher implements Runnable {

  private final long ALTERNATE_TIME = 2;
  private State state;

  private ChopStick leftChopStick;
  private ChopStick rightChopStick;

  public Philosopher(ChopStick rightChopStick, ChopStick leftChopStick) {
    this.rightChopStick = rightChopStick;
    this.leftChopStick = leftChopStick;
  }

  public Philosopher() {}

  @Override
  public void run() {
    while (true) {
      this.state = new Thinking();
      try {
        Thread.sleep(ALTERNATE_TIME);
        this.state = new Eating();
      } catch (InterruptedException e) {
        e.printStackTrace();
      }
    }
  }

  public ChopStick getLeftChopStick() {
    return leftChopStick;
  }

  public void setLeftChopStick(ChopStick leftChopStick) {
    this.leftChopStick = leftChopStick;
  }

  public ChopStick getRightChopStick() {
    return rightChopStick;
  }

  public void setRightChopStick(ChopStick rightChopStick) {
    this.rightChopStick = rightChopStick;
  }
}
