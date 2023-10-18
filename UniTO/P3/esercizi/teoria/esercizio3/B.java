package teoria.esercizio3;

public class B extends A {
    public void m(A a) {
        super.m(a);
        System.out.println("m_BA");
    }
    public static void m(B b) {
        System.out.println("m_BB");
    }
}
