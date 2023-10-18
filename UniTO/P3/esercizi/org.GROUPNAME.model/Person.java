import java.util.ArrayList;

/**
 * Person
 */
public class Person {

    private String name;
    private String age;
    private ArrayList<Item> ownedItem;

    

    public Person(String name, String age, ArrayList<Item> ownedItem) {
        this.name = name;
        this.age = age;
        this.ownedItem = ownedItem;
    }

    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
    public String getAge() {
        return age;
    }
    public void setAge(String age) {
        this.age = age;
    }

    public void addItem(Item a) {
        this.ownedItem.add(a);
    }

    public void removeitem(Item a) {
        this.ownedItem.remove(a);
    }

    public int totalValue() {
        return this.ownedItem.stream().mapToInt(Item::value).sum();
    }
}