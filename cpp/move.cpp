#include <vector>
#include <string>
#include <iostream>

static void debug(std::string msg) {
    std::cerr << msg << std::endl;
}

struct M {
    int m_len;
    std::unique_ptr<char[]> m_p;
    M(int len) : 
        m_len(len), 
        m_p(std::make_unique<char[]>(len))
    {
        debug("M(int) (create)");
    }
    M(const M& other) : 
        m_len(other.m_len), 
        m_p(std::make_unique<char[]>(m_len)) 
    {
        debug("M(M&) (copy)");
        std::copy(other.m_p.get(), other.m_p.get() + m_len, m_p.get());
    }
    ~M() {
        // noop, unique_ptr auto-destroyed
    }
    M& operator=(const M& other) {
        debug("M =M& (copy assign)");
        if (&other != this) {
            m_len = other.m_len;
            m_p = std::make_unique<char[]>(m_len);
            std::copy(other.m_p.get(), other.m_p.get() + m_len, m_p.get());
        }
        return *this;
    }
    M(M&& other) :
        m_len(other.m_len),
        m_p(std::move(other.m_p)) 
      {
        debug("M(M&&) (move)");
        other.m_len = 0;
        other.m_p.reset();
      }
    M& operator=(M&& other) {
        debug("M =M&& (move assign)");
        if (&other != this) {
            m_len = other.m_len;
            m_p = std::move(other.m_p);
            other.m_p.reset();
        }
        return *this;
    }
    void set(int i, char v) {
        m_p.get()[i] = v;
    }

};

std::ostream& operator<<(std::ostream& str, const M& m) {
    const char *ca = m.m_p.get();
    str << (ca == nullptr ? "nullptr" : ca);
    return str;
}

template<typename T>
std::ostream& operator<<(std::ostream& str, const std::vector<T>& v) {
    for (const T& el: v) {
        str << el << " ";
    }
    return str;
}

M getM() {
    M m(100);
    m.set(0, 'e');
    m.set(1, 'x');

    return m;
}

int main() {
    std::vector<std::string> v = { "eins", "zwei", "drei", "vier" };
    std::vector<std::string> v2 = std::move(v);
    v.push_back("five");
    std::cout << v << std::endl;
    std::cout << v2 << std::endl;

    debug("make one");
    M m(10);
    m.set(0, 'a');
    m.set(1, 'b');
    std::cout << m << std::endl;
    debug("copy it");
    M m2(m);
    m.set(1, '\0');
    std::cout << m << m2 << std::endl;

    debug("moving second to third");
    M m3(std::move(m2));
    debug("assigning second by value from function");
    m2 = getM();
    debug("assigning first a copy of the third");
    m = m3;
    debug("output everything");
    std::cout << m << m2 << m3 << std::endl;

}

