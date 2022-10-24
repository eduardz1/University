package P3.esercizi.kernelmodulo;

public class SortableArray<T extends Comparable<T>> {

    private SortableList<T> sortableList;

    public SortableArray(SortableList<T> sortableList) {
        this.sortableList = sortableList;
    }

    public void addModule(SortableList<T> sortableList) {
        this.sortableList = sortableList;
    }

    public boolean add(T elem) {
        return this.sortableList.add(elem);
    }

    public boolean remove(T elem) {
        return this.sortableList.remove(elem);
    }

    public SortableList<T> sort() {
        return this.sortableList.sort();
    }

    public String print() {
        return this.toString();
    }

    @Override
    public String toString() {
        return "SortableArray [sortableList=" + sortableList + "]";
    }

}