#include <vector>
#include <string>
#include <iostream>

static void debug(std::string msg) {
    std::cerr << msg << std::endl;
}

template<typename Ty>
struct Mem {
    int m_len;
    std::unique_ptr<Ty[]> m_p;
    Mem(int len) : 
        m_len(len), 
        m_p(std::make_unique<Ty[]>(len))
    {
        debug("Mem(int) (create)");
    }
    Mem(const Mem<Ty>& other) : 
        m_len(other.m_len), 
        m_p(std::make_unique<Ty[]>(m_len)) 
    {
        debug("Mem(Mem&) (copy)");
        std::copy(other.m_p.get(), other.m_p.get() + m_len, m_p.get());
    }
    ~Mem() {
        // noop, unique_ptr auto-destroyed
    }
    Mem& operator=(const Mem<Ty>& other) {
        debug("Mem =Mem& (copy assign)");
        if (&other != this) {
            m_len = other.m_len;
            m_p = std::make_unique<Ty[]>(m_len);
            std::copy(other.m_p.get(), other.m_p.get() + m_len, m_p.get());
        }
        return *this;
    }
    Mem(Mem<Ty>&& other) :
        m_len(other.m_len),
        m_p(std::move(other.m_p)) 
      {
        debug("Mem(Mem&&) (move)");
        other.m_len = 0;
        other.m_p.reset();
      }
    Mem& operator=(Mem<Ty>&& other) {
        debug("Mem =Mem&& (move assign)");
        if (&other != this) {
            m_len = other.m_len;
            m_p = std::move(other.m_p);
            other.m_p.reset();
        }
        return *this;
    }
    void set(int i, const Ty& v) {
        m_p.get()[i] = v;
    }

};

template<typename T>
std::ostream& operator<<(std::ostream& str, const Mem<T>& m) {
    const T *ca = m.m_p.get();
    for (int i=0; i<m.m_len; i++) {
        str << ca[i];
    }
    return str;
}

template<typename T>
std::ostream& operator<<(std::ostream& str, const std::vector<T>& v) {
    for (const T& el: v) {
        str << el << " ";
    }
    return str;
}

Mem<std::string> getStringM(const std::string& third) {
    Mem<std::string> m(4);
    m.set(0, "one");
    m.set(1, "two");
    std::cout << "intermediate stringM: " << m << std::endl;
    m.set(2, third);

    return m;
}

Mem<char> getCharM() {
    Mem<char> m(4);
    m.set(0, 'e');
    m.set(1, 'x');
    return m;
}

auto getStringVec() {
    std::vector<std::string> v = { "eins", "zwei", "drei", "vier" };
    return v;
}

int main(int argc, char **argv) {
    std::vector<std::string> v = getStringVec();
    std::vector<std::string> v2 = std::move(v);
    v.push_back("five");
    std::cout << v << std::endl;
    std::cout << v2 << std::endl;

    debug("make one");
    Mem<char> m(10);
    m.set(0, 'a');
    m.set(1, 'b');
    std::cout << m << std::endl;
    debug("copy it");
    Mem<char> m2(m);
    m.set(1, '\0');
    std::cout << m << m2 << std::endl;

    debug("moving second to third");
    Mem<char> m3(std::move(m2));
    debug("assigning second by value from function");
    m2 = getCharM();
    debug("assigning first a copy of the third");
    m = m3;
    debug("output everything");
    std::cout << m << m2 << m3 << std::endl;

    debug("get and output a string Mem");
    Mem<std::string> stringM = getStringM(argv[0]);
    std::cout << stringM << std::endl;
}

