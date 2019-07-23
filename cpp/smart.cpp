#include <memory>
#include <iostream>

struct C {
    char lots_of_storage[1000];
    int m_id;
    C(int id) {
        std::cout << "making C " << id << std::endl;
        m_id = id;
    }
    ~C() {
        std::cout << "destroying C " << m_id << std::endl;
    }
};

struct S {
    C c1 = C(1);
    std::unique_ptr<C> c2;

    void makeC() {
        c2 = std::make_unique<C>(2);
    }
};


void f() {
    S s;
    std::cout << "there is an s" << std::endl;
    s.makeC();
    std::cout << "bye" << std::endl;
}

int main(int argc, char **argv) {
    f();
    std::cout << "terminating" << std::endl;
    return 0;
}

