package org.prog3.lab.week9.philosophers.mine;

import java.util.ArrayList;
import java.util.Scanner;

public class Main {

  private static ArrayList<Philosopher> generatePhilosophers(int num) {
    ArrayList<Philosopher> res = new ArrayList<>(num);
    while (num > 0) {
      res.add(new Philosopher());
      num--;
    }
    return res;
  }

  private static ArrayList<ChopStick> generateChopSticks(int num) {
    ArrayList<ChopStick> res = new ArrayList<>(num);
    while (num > 0) {
      res.add(new ChopStick());
      num--;
    }
    return res;
  }

  public static void main(String[] args) {
    Scanner input = new Scanner(System.in);
    var num = input.nextInt();
    input.close();

    var philosophers = generatePhilosophers(num);
    var chopSticks = generateChopSticks(num);

    philosophers.get(0).setRightChopStick(chopSticks.get(0));

    for (int i = 1; i < num; i++) {
      philosophers.get(i).setLeftChopStick(chopSticks.get(i));
    }

    philosophers.forEach(Philosopher::run);
  }
}
