// demo boost serialization on smart pointers to polymorphic type 
// 
#include <string>
#include <memory>
#include <iostream>
#include <fstream>

#include <boost/archive/text_iarchive.hpp>
#include <boost/archive/text_oarchive.hpp>
#include <boost/serialization/unique_ptr.hpp>
#include <boost/serialization/base_object.hpp>
#include <boost/serialization/export.hpp>

// Forward declaration of class boost::serialization::access
namespace boost {
namespace serialization {
class access;
}
}

struct Base {
    int b;
    template<typename Archive>
    void serialize(Archive& ar, const unsigned version) {
        ar & b;
    }
    virtual std::ostream& format(std::ostream& str) const {
        str << b;
        return str;
    }
    virtual ~Base() {
    }
};

struct Derived1 : public Base {
    int d;
    template<typename Archive>
    void serialize(Archive& ar, const unsigned version) {
        ar & boost::serialization::base_object<Base>(*this);
        ar & d;
    }
    std::ostream& format(std::ostream& str) const override {
        Base::format(str) << ", " << d;
        return str;
    }
};

std::ostream& operator<<(std::ostream& str, const Base& b) {
    return b.format(str);
}

struct S {
    std::unique_ptr<Base> bp;
       
    template<typename T> 
    void alloc(const T& b) {
        bp = std::make_unique<T>(b);
    }
    template<typename Archive>
    void serialize(Archive& ar, const unsigned version) {
        ar & bp;
    }
};

std::ostream& operator<<(std::ostream& str, const S& s) {
    if (s.bp) {
        str << *(s.bp);
    } else {
        str << "null";
    }
    return str;
}

void serialize(const S& s1, const S& s2) {
    std::string fileName("S.ser");
    // Create an output archive
    std::ofstream ofs(fileName);
    boost::archive::text_oarchive ar(ofs);

    ar & s1 & s2;
}

void deserialize(S& s1, S& s2) {
    std::string fileName("S.ser");
    std::ifstream ifs(fileName);
    boost::archive::text_iarchive ar(ifs);
    // Load data
    ar & s1 & s2;
}

int main(int argc, char **argv) {
    if (argc > 1) {
        S s1;
        S s2;
        deserialize(s1, s2);
        std::cout << s1 << "; " << s2 << std::endl;
    } else {
        Base b;
        b.b = 2;
        S sb;
        sb.alloc(b);
        S sd1;
        Derived1 d1;
        d1.b = 1;
        d1.d = 99;

        sd1.alloc(d1);
        serialize(sb, sd1);
    }
}


BOOST_CLASS_EXPORT_GUID(Derived1, "derived1")

