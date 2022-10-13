package P3.esercizi.es2.summable;

public abstract class Summable<T>{
    T summable;
    
    public abstract T add(T a);

    public T getVal() {
        return summable;
    }
    public Summable(T summable) {
        this.summable = summable;
    }
    
}