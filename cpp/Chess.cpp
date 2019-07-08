#include <iostream>

class Piece {
public:
    static const char sym = 0;
};

class Pawn : public Piece {
public:
    static const char sym = 'P';
};

class Field {
    Piece *m_content;
public:
    Field() {
        m_content = NULL;
    }
    const Piece *put(Piece& p) {
        Piece *old = m_content;
        m_content = &p;
        return old;
    }
    const Piece *remove() {
        Piece *old = m_content;
        m_content = NULL;
        return old;
    }
    const Piece* get() const {
        return m_content;
    }
};
const static int DIM = 8;

const static std::string ROWNAMES = "ABCDEFGH";
const static std::string COLNAMES = "12345678";

struct Point {
    int x, y;
    Point(int ax, int ay) : x(ax), y(ay) {
    }
    static Point convert(std::string pos) {
        size_t x = ROWNAMES.find(pos[0]);
        size_t y = COLNAMES.find(pos[1]);
        if (x == std::string::npos || y == std::string::npos) {
            throw std::runtime_error("can't parse " + pos);
        }
        return Point(x, y);
    }
};  

class Board {
    Field m_b[DIM * DIM];
public:
    Field& get(Point p) {
        return m_b[p.x + DIM*p.y];
    }
    const Field& at(Point p) const {
        return m_b[p.x + DIM*p.y];
    }
    Field& get(const std::string& pos) {
        return this->get(Point::convert(pos));
    }
};

std::ostream& operator<<(std::ostream &strm, const Field &f) {
    const Piece *p = f.get();
    strm << (p == NULL ? '.' : p->sym);
    return strm;
}

std::ostream& operator<<(std::ostream &strm, const Board &b) {
    strm << "  1 2 3 4 5 6 7 8" << std::endl;
    Point p(0, 0);
    for (int y=0; y<DIM; y++) {
        p.y = y;
        strm << ROWNAMES[y] << ' ';
        for (int x=0; x<DIM; x++) {
            p.x = x;
            strm << b.at(p) << ' ';
        }
        strm << std::endl;
    }
    strm << std::endl;
    return strm;
}

int main(int argc, char **argv) {
    Pawn p;
    Board b;
    b.get("C3").put(p);
    std::cout << b << std::endl;

    return 0;
}


