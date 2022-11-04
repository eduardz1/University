package esercizi.es2.summable;

public class DoubleSummable extends Summable<Double> {

    public DoubleSummable(Double summable) {
        super(summable);
    }

    @Override
    public Double add(Double x) {
        return x.doubleValue() + this.summable.doubleValue();
    }
    
}
