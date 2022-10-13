package P3.esercizi.es2;

import java.util.List;

public class Queue<T> {
    List<T> q;

    public Queue(List<T> q) {
        this.q = q;
    }

    public boolean enqueue(T elem) {
        return q.add(elem);
    }
    
    public T dequeue(T elem) {
        return q.remove(0);
    }

    public boolean empty() {
        return q.isEmpty();
    }

    @Override
    public String toString() {
        return "Queue [q=" + q + "]";
    }
}
