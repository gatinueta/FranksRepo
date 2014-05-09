#include <iostream>
using namespace std;

class A {
  static int ord;
public:
  A() {
    v = ++ord;
    cout << "void constructor called with " << v << "\n";
  }

  A(const A& a) {
    cout << "copy constructor called with " << a.v << "\n";
    v = a.v;
  }

  A& operator=(const A& a) {
    cout << "assignment operator called with " << a.v << "\n";
    v = a.v;
    return *this;
  }

  int v;
};

int A::ord = 0;

void f(A& a) {
  A* ap = new A();
  cout << " now assigning...\n";
  a = *ap; 
   cout << " assigning done...\n";

}

void fp(A *ap) {
  A *ap2 = new A();
  cout << "now assigning...\n";
  *ap = *ap2;
  cout << "assigning done.\n";
}

void swap(A& a1, A& a2) {
  A t = a1;

  a1 = a2;
  a2 = t;
}


int main()
{
  A* ap = new A();
  A a = *ap;

  cout << a.v << "\n";

  f(a);

  cout << a.v << "\n";

  fp(&a);

  cout << a.v << "\n";

  cout << "swap test\n";

  A a1, a2;

  swap(a1, a2);


}

