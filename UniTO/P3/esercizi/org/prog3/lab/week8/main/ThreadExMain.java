package org.prog3.lab.week8.main;

import java.util.ArrayList;

/**
 * Classe che contiene il main che andrà a creare i vari thread
 */


public class ThreadExMain {
    public static void main(String[] args) {
        ActivityCounter activityCounter = new ActivityCounter();

        ArrayList<Thread> threadList = new ArrayList<>();
        Thread a0 = new Thread(new Activity(0, 3, new ArrayList<>(), activityCounter));
        ArrayList<Thread> constraintsFor123 = new ArrayList<>();
        constraintsFor123.add(a0);

        threadList.add(a0);

        Thread a1 = new Thread(new Activity(1, 15, constraintsFor123, activityCounter));
        Thread a2 = new Thread(new Activity(2, 5, constraintsFor123, activityCounter));
        Thread a3 = new Thread(new Activity(3, 10, constraintsFor123, activityCounter));

        threadList.add(a1);
        threadList.add(a2);
        threadList.add(a3);

        ArrayList<Thread> constraintsFor4 = new ArrayList<>();
        constraintsFor4.add(a1);
        constraintsFor4.add(a2);
        constraintsFor4.add(a3);

        Thread a4 = new Thread(new Activity(4, 4, constraintsFor4, activityCounter));
        threadList.add(a4);

        Thread prevThreadFor5 = a4;

        for(int i=0; i<5; ++i) {
            ArrayList<Thread> constraintsFor5 = new ArrayList<>();
            constraintsFor5.add(prevThreadFor5);
            Thread a5 = new Thread(new Activity(5,3, constraintsFor5, activityCounter));
            prevThreadFor5 = a5;

            threadList.add(a5);
        }

        for(Thread thread: threadList) {
            thread.start();
        }
    }


}
