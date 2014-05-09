class A {

  public A() {
    System.out.println("void constructor called");
  }

  public A(int v) {
    this.v = v;
  }

  public A(A a) {
    v = a.v+1;
  }

  public void inc() {
    v++;
  }

  public void clone(A a) {
    v = a.v;
  }

  public void print() {
    System.out.println(v);
  }

  int v;
}

public class ref {
  static void swap(A a1, A a2) {
    A a3 = new A(1000);
    
    a3.clone(a1);
    a1.clone(a2);
    a2.clone(a3);
  }

  public static void main(String[] args) {
    A a = new A(100);
    A b = new A(10);

    A c = a;

    a.inc();

    a.print();
    b.print();
    c.print();

    A a1 = new A(15);
    A a2 = new A(35);

    a1.print();
    a2.print();

    swap(a1, a2);

    a1.print();
    a2.print();

  }
}

