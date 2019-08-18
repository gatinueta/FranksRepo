#include <vector>
#include <string>
#include <iostream>

struct M {
    int m_len;
    std::unique_ptr<char[]> m_p;
    M(int len) : 
        m_len(len), 
        m_p(std::make_unique<char[]>(len))
    {
    }
    M(const M& other) : 
        m_len(other.m_len), 
        m_p(std::make_unique<char[]>(m_len)) 
    {
        memcpy(m_p.get(), other.m_p.get(), m_len);
    }
    ~M() {
        // noop, unique_ptr auto-destroyed
    }
    M& operator=(const M& other) {
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
        other.m_len = 0;
        other.m_p.reset();
      }
    M& operator=(M&& other) {
        if (&other != this) {
            m_len = other.m_len;
            m_p = std::move(other.m_p);
            std::copy(other.m_p.get(), other.m_p.get() + m_len, m_p.get());
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
        
int main() {
    std::vector<std::string> v = { "eins", "zwei", "drei", "vier" };
    std::vector<std::string> v2 = std::move(v);
    v.push_back("five");
    std::cout << v << std::endl;
    std::cout << v2 << std::endl;

    M m(10);
    m.set(0, 'a');
    m.set(1, 'b');
    std::cout << m << std::endl;
    M m2(m);
    m.set(1, '\0');
    std::cout << m << m2 << std::endl;

    M m3(std::move(m2));
    std::cout << m << m2 << m3 << std::endl;

}

