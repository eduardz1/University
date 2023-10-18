package LPP;

import java.util.stream.Stream;

/**
 * FastSqrt using Newton-Raphson method
 */
public class FastSqrt {
    private static final double EPS = 0.00001;

    public static void main(String[] args) {
        System.out.println(compute(4));
        System.out.println(compute(7.3));
    }

    public static double compute(double x) {
        var initVal = (x + x / x) / 2;
        return Stream.iterate(initVal, i -> (i + x / i) / 2).collect(null, null, null);

    }
    
}