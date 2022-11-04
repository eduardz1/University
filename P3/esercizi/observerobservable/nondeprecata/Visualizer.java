package esercizi.observerobservable.nondeprecata;

import java.beans.PropertyChangeEvent;
import java.beans.PropertyChangeListener;
import java.util.EventListener;
import java.util.List;

public class Visualizer implements PropertyChangeListener {

  public void visualize(List<Integer> list) {
    list.stream().forEach(i -> System.out.println(i));
    System.out.println();
  }

  @Override
  public void propertyChange(PropertyChangeEvent arg0) {
    if (arg0.getPropertyName().equals("list")) {
      visualize((List<Integer>) arg0.getNewValue());
    }
  }
}
