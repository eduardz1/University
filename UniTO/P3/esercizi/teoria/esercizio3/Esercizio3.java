package teoria.esercizio3;

public class Esercizio3 {
    public static void main(String[] args) {
        A a = new A();
        B b = new B();
        a.m(a); System.out.println();
        a.m(b); System.out.println();
        b.m(b); System.out.println();
        b.m(a); System.out.println();

        I i = new A();
        i.m(b); System.out.println();

        I j = new B();
        j.m(b); System.out.println();

        I.stampa();
    }
}
