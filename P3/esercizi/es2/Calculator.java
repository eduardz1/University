package esercizi.es2;

import java.util.Comparator;
import java.util.List;

import esercizi.es2.summable.Summable;

public class Calculator {
    public static <T> String print(List<T> list) {
        return list.toString();
    }

    public static <T> T max(List<T> list, Comparator<? super T> comp) {
        return list.stream().max(comp).get();
    }

    public static <E, T extends Summable<E>> T sum(List<T> list) {
        T res = list.get(0);
        for(int i = 1; i < list.size(); i++) {
            res.add(list.get(i).getVal());
        }
        return res;
    }
}
