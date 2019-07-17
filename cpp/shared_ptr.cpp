#include <memory>
#include <array>
#include <iostream>

struct Object {
    static int s_no;
    int m_no;
    Object() {
        s_no++;
        std::cout << "constructing object " << s_no << std::endl;
        m_no = s_no;
    }
    int no() const {
        return m_no;
    }
    ~Object() {
        std::cout << "destroying object " << m_no << std::endl; 
    }
};

int Object::s_no = 0;

template<size_t size>
static std::shared_ptr<std::array<Object, size>> make_objects() {
    auto objs = std::make_shared<std::array<Object, size>>();
    std::cout << "no of first " << (*objs)[0].no() << std::endl;
    return objs;
}

int main(int argc, char **argv) {
    {
        auto objects = make_objects<4>();
        std::cout << "within scope" << std::endl;
        std::cout << "no of fourth is " << (*objects)[3].no() << std::endl;
    }
    std::cout << "out of scope" << std::endl;
    {
        make_objects<2>();
        std::cout << "within scope" << std::endl;
    }
    std::cout << "out of scope" << std::endl;
    return 0;
}

