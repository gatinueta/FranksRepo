#include <iostream>

struct Base {
    virtual std::ostream& format(std::ostream& str) const {
        str << "Base";
        return str;
    }
};

struct Derived : public Base {
    std::ostream& format(std::ostream& str) const override {
        Base::format(str) << " " << "Derived";
        return str;
    }
};

std::ostream& operator<<(std::ostream& str, const Base& b) {
    str << "Base";
    return str;
}

std::ostream& operator<<(std::ostream&str, const Derived& d) {
    str << static_cast<const Base&>(d) << " " << "Derived";
    return str;
}

int main() {
    Derived d;
    Base *b = &d;
    std::cout << *b << std::endl;
    std::cout << d << std::endl;
    b->format(std::cout) << std::endl;
    d.format(std::cout) << std::endl;
}

