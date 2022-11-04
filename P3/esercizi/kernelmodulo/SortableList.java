package esercizi.kernelmodulo;

public interface SortableList<T extends Comparable<T>> {
    
    public boolean add(T elem);

    public boolean remove(T elem);

    public SortableList<T> sort();

    public String print();
}
