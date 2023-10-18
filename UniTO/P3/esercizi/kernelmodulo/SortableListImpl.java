package esercizi.kernelmodulo;

import java.util.ArrayList;

public class SortableListImpl<T extends Comparable<T>> implements SortableList<T> {

    private ArrayList<T> list;

    
    protected SortableListImpl() {
        this.list = new ArrayList<T>();
    }

    public SortableListImpl(ArrayList<T> list) {
        this.list = list;
    }

    @Override
    public boolean add(T elem) {
        return this.list.add(elem);
    }

    @Override
    public boolean remove(T elem) {
        return this.list.remove(elem);
    }

    @Override
    public SortableList<T> sort() {
        this.list.sort(T::compareTo);

        return this;
    }

    @Override
    public String print() {
        return this.list.toString();
    }

    @Override
    public String toString() {
        return "SortableListImpl [list=" + list + "]";
    }
    
    
}
