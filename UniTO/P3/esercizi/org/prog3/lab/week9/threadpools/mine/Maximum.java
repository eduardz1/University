package org.prog3.lab.week9.threadpools.mine;

import java.util.List;

public class Maximum {

  public static int calculateMaximum(List<List<Integer>> matrix) {
    return matrix
      .parallelStream()
      .map(s -> s.stream().max(Integer::compare).get())
      .max(Integer::compare)
      .get();
  }

  public static void main(String[] args) {
    List<List<Integer>> a = List.of(
        List.of(2, 3, 4, 5, 7, 1),
        List.of(1, 5, 8, 9, 2, 5),
        List.of(77, 1, 2, 3, 4, 1)
    );

    System.out.println(calculateMaximum(a));
  }
}
