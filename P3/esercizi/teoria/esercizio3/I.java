package teoria.esercizio3;

public interface I {
    public void m(A a);
    public static void stampa() {
        System.out.println("stampa");
    }
    class IImpl {
        public static void m(B b) {
            System.out.println("m_IB");
        }
    }
}
