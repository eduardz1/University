package esercizi.es2.summable;

public class IntegerSummable extends Summable<Integer> {

    public IntegerSummable(Integer summable) {
        super(summable);
    }

    @Override
    public Integer add(Integer x) {
        return x.intValue() + this.summable.intValue();
    }
    
}
