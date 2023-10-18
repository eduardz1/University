package esercizi.observerobservable.nondeprecata;

import java.beans.PropertyChangeListener;
import java.beans.PropertyChangeSupport;
import java.util.ArrayList;
import java.util.List;

public class Filter {

  private List<Integer> list;

  private PropertyChangeSupport support;

  public Filter() {
    list = new ArrayList<Integer>();
    support = new PropertyChangeSupport(this);
  }

  public void addPropertyChangeListener(PropertyChangeListener listener) {
    support.addPropertyChangeListener(listener);
  }

  public void removePropertyChangeListener(PropertyChangeListener listener) {
    support.removePropertyChangeListener(listener);
  }

  public void filter(int c) {
    List<Integer> oldList = new ArrayList<>(list);
    list.add(c);
    if (list.size() % 2 == 0) {
      System.out.println("lista size: " + list.size());
      support.firePropertyChange("list", oldList, list);
    }
  }
}
