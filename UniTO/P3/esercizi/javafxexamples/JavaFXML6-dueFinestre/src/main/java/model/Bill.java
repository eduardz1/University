package model;

//import javafx.beans.property.SimpleDoubleProperty;
import javafx.beans.property.SimpleStringProperty;

/**
 *
 * @author liliana
 */
public class Bill {

    // Define a variable to store the property
    private SimpleStringProperty amountDue = new SimpleStringProperty();

    // Define a getter for the property's value
    public final String getAmountDue(){
        return amountDue.get();
    }

    // Define a setter for the property's value
    public final void setAmountDue(String value){
        amountDue.set(value);
    }

    // Define a getter for the property itself
    public SimpleStringProperty amountDueProperty() {
        return amountDue;
    }
}

