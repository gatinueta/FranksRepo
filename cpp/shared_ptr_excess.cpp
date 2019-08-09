// Example program
#include <iostream>
#include <string>
#include <memory>
#include <vector>

struct F {
    int m_base = 1;
    virtual std::ostream& put(std::ostream& str) const {
        str << m_base;
        return str;
    }
    virtual std::string whatami() const {
        return "F";
    }
    virtual std::shared_ptr<F> getShared() const {
        return std::make_shared<F>(*this);
    }

};

struct G : F {
    char m_ext = 'a';
    virtual std::ostream& put(std::ostream& str) const {
        F::put(str) << m_ext;
        return str;
    }
    virtual std::string whatami() const {
        return "G";
    }
    virtual std::shared_ptr<F> getShared() const {
        return std::make_shared<G>(*this);
    }
};

std::ostream& operator<<(std::ostream& str, const F& f) {
    return f.put(str);
}

struct S {
    std::shared_ptr<F> m_f;
    S(const F& f) : m_f(f.getShared()) {
    }
    std::shared_ptr<S> getShared() {
        return std::make_shared<S>(*m_f->getShared());
    }
};

std::ostream& operator<<(std::ostream& str, const S& s) {
    str << *(s.m_f);
    return str;
}

int main()
{
    std::vector<S> v;
    F f;
    G g;
    
    std::shared_ptr<F> pg = std::make_shared<G>(g);
    std::cout << "g is a " << pg->whatami() << std::endl;
    std::cout << *pg << std::endl;
    std::cout << f << ", " << g << std::endl;
    
    S sf(f);
    S sg(g);
    
    v.push_back(sf);
    v.push_back(sg);
    v.push_back(sf);
    v.push_back(*sf.getShared());
    sf.m_f->m_base++;
    for (auto el: v) {
        std::cout << el << ", ";
    }
}
