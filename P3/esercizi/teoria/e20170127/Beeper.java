package teoria.e20170127;

import java.awt.Toolkit;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.Observable;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;

public class Beeper extends Observable {

  private JFrame frame = new JFrame();
  private JButton button = new JButton("Click Me");
  private JPanel panel = new JPanel();
  private JLabel display = new JLabel("0");
  private int i = 0;

  Beeper() {
    panel.add(display);
    panel.add(button);
    frame.add(panel);
    frame.pack();
    frame.setVisible(true);
    button.addActionListener(
      new ActionListener() {
        public void actionPerformed(ActionEvent e) {
          Toolkit.getDefaultToolkit().beep();
          i++;
          display.setText(Integer.toString(i));
          setChanged();
          notifyObservers();
        }
      }
    );
    frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
  }

  public static void main(String[] args) {
    Beeper beep = new Beeper();
  }
}
