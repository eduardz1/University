package P3.esercizi.kernelmodulo;

public class Main {
    public static void main(String[] args) {
        SortableList<Integer> sortableList = new SortableListImpl<>();
        SortableArray<Integer> sortableArray = new SortableArray<>(sortableList);

        sortableArray.add(3);
        sortableArray.add(2);
        sortableArray.add(7);
        sortableArray.add(10);
        sortableArray.add(4);
        sortableArray.add(1);
        sortableArray.add(8);
        sortableArray.add(5);
        sortableArray.add(6);
        sortableArray.add(9);

        System.out.println(sortableArray.print());

        sortableArray.sort();

        System.out.println(sortableArray.print());
    }
}
