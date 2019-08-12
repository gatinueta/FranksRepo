// Example program
#include <iostream>
#include <string>
#include <memory>
#include <vector>

int nof_objs = 0;

struct F {
static int s_id;
int m_id;
    F() {
        s_id++;
        m_id = s_id;
        std::cout << "constructing F(" << m_id << ")\n";
        nof_objs++;
    }
    F(const F& f) {
        std::cout << "copy constructing F(" << f.m_id << ")\n";
        m_id = f.m_id;
        m_base = f.m_base;
        nof_objs++;
    }
    int m_base = 1;
    virtual std::ostream& format(std::ostream& str) const {
        str << m_base;
        return str;
    }
    virtual std::string whatami() const {
        return "F";
    }
    virtual std::shared_ptr<F> clone() const {
        return std::make_shared<F>(*this);
    }
    virtual ~F() {
        std::cout << "deconstructing F(" << m_id << ")\n";
        nof_objs--;
    }

};

int F::s_id = 0;

struct G : F {
    char m_ext = 'a';
    char m_data[100];
    G() {
        s_id++;
        m_id = s_id;
        std::cout << "constructing G(" << m_id << ")\n";
        nof_objs++;
    }
    G(const G& g) {
        std::cout << "copy constructing G(" << g.m_id << ")\n";
        m_id = g.m_id;
        m_base = g.m_base;
        m_ext = g.m_ext;
        memcpy(m_data, g.m_data, 100);
        nof_objs++;
    }
    std::ostream& format(std::ostream& str) const override {
        F::format(str) << m_ext;
        return str;
    }
    std::string whatami() const override {
        return "G";
    }
    std::shared_ptr<F> clone() const override {
        return std::make_shared<G>(*this);
    }
    ~G() override {
        std::cout << "deconstructing G(" << m_id << ")\n";
        nof_objs--;
    }
};

std::ostream& operator<<(std::ostream& str, const F& f) {
    return f.format(str);
}

struct S {
    std::shared_ptr<F> m_f;
    S(const F& f) : m_f(f.clone()) {
    }
    std::shared_ptr<S> clone() {
        return std::make_shared<S>(*m_f->clone());
    }
};

struct SC {
    F& m_f;
    SC(F& f) : m_f(f) {
    }
    std::shared_ptr<SC> clone() {
        return std::make_shared<SC>(*(m_f.clone()));
    }
};

std::ostream& operator<<(std::ostream& str, const S& s) {
    str << *(s.m_f);
    return str;
}

std::ostream& operator<<(std::ostream& str, const SC& sc) {
    str << sc.m_f;
    return str;
}

template<class C>
std::ostream& operator<<(std::ostream& str, const std::vector<C>& v) {
    for (auto el: v) {
        str << el << ",";
    }
    return str;
}

void test()
{
    // instances of base and derived classes on the stack
    F f;
    G g;
    
    // make_shared takes the actual pointer type to construct the object
    std::shared_ptr<F> pg = std::make_shared<G>(g);
    std::cout << "g is a " << pg->whatami() << std::endl;
    // operator<< will invoke G::put()
    std::cout << *pg << std::endl;
    std::cout << f << ", " << g << std::endl;
    
    // wrap up the instances into containers, the values will be copied
    S sf(f);
    S sg(g);
    S sf2(f);

    // first and third element of the vector point to the same instance of F
    std::vector<S> v;
    v.reserve(5);
    v.push_back(sf);
    v.push_back(sg);
    v.push_back(sf);

    // deep copy 
    v.push_back(*sf.clone());
    v.push_back(sf2);
 
    // will modify the first and third element of the vector, but not the deep copies
    sf.m_f->m_base+=3;
    
    // will modify only the second deep copy
    v[4].m_f->m_base++;

    std::cout << v << std::endl;

    // alternatively, just store references in wrapper objects. The values will not be copied
    SC scf(f);
    SC scg(g);
    SC scf2(f);

    // also store three elements. They will reference the objects on the stack directly
    std::vector<SC> vc;
    vc.reserve(5);
    vc.push_back(scf);
    vc.push_back(scg);
    vc.push_back(scf);
    vc.push_back(*scf.clone());
    vc.push_back(scf2);
    scf.m_f.m_base+=3; // modifies f, but won't affect the cloned (fourth) element
    vc[4].m_f.m_base++;
    std::cout << vc << std::endl;
    std::cout << sizeof(SC) << ", " << sizeof(F&) << ", " << sizeof(G&) << std::endl;
 
    // SC will just contain a pointer to C
    void *ptr;
    memcpy(&ptr, &scf, sizeof(ptr));
    std::cout << ptr << ", " << &f << std::endl;
    std::cout << "nof_objs=" << nof_objs << std::endl;
}

int main() {
    test();
    std::cout << "nof_objs=" << nof_objs << std::endl;
}
