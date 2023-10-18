package teoria.e20170127;

import java.util.Observable;
import java.util.Observer;

import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;

public class ObserveBeeper implements Observer {
    private JFrame frame = new JFrame();
    private JPanel panel = new JPanel();
    private JLabel display = new JLabel("0");
    private int i = 0;

    ObserveBeeper() {
        panel.add(display);
        frame.add(panel);
        frame.pack();
        frame.setVisible(true);
        display.addPropertyChangeListener(null);
    }

    @Override
    public void update(Observable arg0, Object arg1) {
        // TODO Auto-generated method stub
        
    }
}
