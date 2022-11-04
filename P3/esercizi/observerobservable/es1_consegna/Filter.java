package esercizi.observerobservable.es1_consegna;

import java.util.ArrayList;
import java.util.List;

class Filter {
    private List<Integer> list;
    Visualizer visualizer;

    public Filter(Visualizer v) {
        visualizer = v;
        list = new ArrayList<>();
    }

    public void filter(int c) {
        list.add(c);
        if (list.size()%2==0) {
            System.out.println("list size: " + list.size());
            visualizer.visualize(list);
        }
    }
}